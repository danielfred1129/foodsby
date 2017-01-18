define(['jQuery', 'base64'], function ($, base64) {
    var _kendoApp;

    return {
        /**
         * Provides a reusable ajax method which handles authorization. Standard ajax options may be
         * passed in to override.
         * @param {object} options - jQuery.ajax options
         */
        ajax: function (options) {
            var that = this;
            var defaults = {
                type: "GET",
                xhrFields: {
                    withCredentials: true
                },
                beforeSend: function (xhr) {
                    xhr.setRequestHeader("Authorization", that.getAuthHeader(that.get('username'), ""));
                    
                    return that.hasConnection();
                }
            };
            return $.ajax($.extend(defaults, options));
        },
        
        /**
         * Checks for an internet connection
         */
        hasConnection: function() {
            if (navigator != undefined && navigator.hasOwnProperty('connection') && navigator.connection.type == Connection.NONE) {
                return false;
            } else {
                return true;
            }
        },

        /**
         * Set the kendo application reference
         * @param {object} kendoApplication
         */
        setKendoApp: function (kendoApplication) {
            _kendoApp = kendoApplication;
        },

        /**
         * Get the kendo application reference
         * @return {object} kendoApplication
         */
        getKendoApp: function () {
            return _kendoApp;
        },

        /**
         * Shortcut method for navigation through the kendo application
         * @param {string} location - page to navigate to
         * @param {string} transition - transition to use. defaults to 'slide'
         */
        navigate: function (location, transition) {
            _kendoApp.navigate(location, transition ? transition : 'slide');
        },

        /**
         * Shortcut method to show the loading animation through the kendo application
         */
        showLoading: function () {
            _kendoApp.pane.loader.transition();
            _kendoApp.showLoading();
        },

        /**
         * Shortcut method to hide the loading animation through the kendo application
         */
        hideLoading: function () {
            _kendoApp.hideLoading();
            _kendoApp.pane.loader.transitionDone();
        },

        /**
         * Generates the authorization header based on username and password parameters.
         * If a password isn't supplied, Cookie based auth is used.
         * @param {string} username
         * @param {string} password
         */
        getAuthHeader: function (username, password) {
            var authType;
            if (password == "") {
                authType = "Cookie " + $.base64.encode(username);
            }
            else {
                var up = $.base64.encode(username + ":" + password);
                authType = "Basic " + up;
            }
            return authType;
        },

        /**
         * Retrieves a value or object from localStorage with provided key
         * @param {string} key
         * @return {mixed}
         */
        get: function (key) {
            var value = window.localStorage.getItem(key);
            if (value == null) {
                return false;
            }
            var first = value.substr(0, 1);
            if (first == '{' || first == '[') {
                return JSON.parse(value);
            }
            else {
                return value;
            }
        },
`
        /**
         * Retrieves a value or object from an object within localStorage
         * @param {string} key - key value for object
         * @param {string} field - field from object to return
         * @return {mixed}
         */
        getValue: function (key, field) {
            return this.get(key)[field];
        },

        /**
         * Sets a value within localStorage with specified key
         * @param {string} key
         * @param {mixed} value
         */
        set: function (key, value) {
            if (value instanceof Object) {
                window.localStorage.setItem(key, JSON.stringify(value));
            }
            else {
                window.localStorage.setItem(key, value);
            }
            return this;
        },

        /**
         * Sets a value within an object within localStorage
         * @param {string} key - key value for object
         * @param {string} field - field within object to modify or set
         * @param {mixed} value
         */
        setValue: function (key, field, value) {
            var object = this.get(key);
            object[field] = value;
            this.set(key, object);
            return this;
        },

        /**
         * Searches an array within localStorage for an object with a matching field/value pair.
         * Returns the last one found.
         * @param {string} key - key referencing array of objects
         * @param {string} field - field within object to match
         * @param {mixed} value
         * @return {object}
         */
        find: function (key, field, value) {
            var object = this.get(key);
            var found = null;

            $.each(object, function (i, item) {
                if (item[field] == value) {
                    found = item;
                }
            });

            return found;
        },

        /**
         * Clears data from localStorage
         */
        clear: function () {
            window.localStorage.clear();
            if (this.hasCookiePlugin()) {
                window.cookies.clear();
            }
        },

        /**
         * Loads exceptions from Foodsby into localStorage. Will not perform work
         * if exceptions have been loaded in the past 24 hours.
         * @return {Promise}
         */
        loadExceptions: function () {
            if (!this.get('exceptionExpiry') || new Date() > new Date(this.get('exceptionExpiry'))) {
                var that = this;
                return this.ajax({
                    url: that.urlPrefix + "/api/exception"
                }).done(function (data) {
                    that.set("exceptions", data);
                }).fail(function () {
                    that.set("exceptions", []);
                }).always(function () {
                    var d = new Date();
                    d.setHours(d.getHours() + 24);
                    that.set("exceptionExpiry", d.toString());
                }).promise();
            } else {
                return $.Deferred().resolve().promise();
            }
        },

        /**
         * Loads important information from Foodsby. Loads schedule if delivery location is set.
         * Additionally, loads locations, offices, and saved cards.
         * @return {Promise}
         */
        loadData: function () {
            console.info('Loading fresh data');
            var locId = this.getValue('user', 'DeliveryLocationId'),
                that = this,
                scheduleCall,
                locationCall,
                officeCall,
                cardsCall;

            if (locId !== null) {
                scheduleCall = this.ajax({
                    url: that.urlPrefix + "/api/location/" + locId + "/schedule"
                }).done(function (data) {
                    if (data == null) {
                        that.set("schedule", {"DeliveryDaysThisWeek": []});
                    }
                    else {
                        that.set("schedule", data);
                        that.setupNotifications(data);
                    }
                });
            } else {
                scheduleCall = $.Deferred().resolve();
            }

            locationCall = this.ajax({
                url: that.urlPrefix + "/api/location"
            }).done(function (data) {
                that.set("locations", data);
                var d = new Date();
                d.setHours(d.getHours() + 12);
                that.set("dataExpiry", d.toString());
            });

            officeCall = this.ajax({
                url: that.urlPrefix + "/api/office"
            }).done(function (data) {
                that.set("offices", data);
            });

            cardsCall = this.ajax({
                url: that.urlPrefix + "/api/user/cards"
            }).done(function (data) {
                that.set("cards", data);
                if (data.length > 0) {
                    that.set("preferredCard", data[0].CCProfileId);
                }
            });

            return $.when(scheduleCall, locationCall, officeCall, cardsCall);
        },

        /**
         * Retrieve the delivery schedule for a specific day of the week. Logo url's
         * are automatically reformatted.
         * @param {number} nDay - Day of the week (0-6)
         * @param {object} schedule
         */
        getDeliveryDay: function (nDay) {
            var days = this.getValue('schedule', 'DeliveryDaysThisWeek');
            var that = this;
            if (nDay == undefined) {
                nDay = new Date;
                nDay = nDay.getDay();
            }
            var today = null;
            $.each(days, function (i, value) {
                if (value.DayOfWeek == nDay) {
                    today = value;
                }
            });
            if (today == null) {
                return {Stores: []};
            }
            else {
                $.each(today.Stores, function (i, value) {
                    today.Stores[i].LogoLink = that.urlPrefix + encodeURI(value.LogoLink.substr(1)).replace(/'/g, "\\'");
                });
                return today;
            }
        },

        /**
         * Clears all stored notifications
         */
        clearNotifications: function (callback) {
            if (this.hasNotificationPlugin()) {
                console.info('Clearing notifications');
                window.plugin.notification.local.cancelAll(callback);
            }
        },

        /**
         * Sets up notifications for the schedule that is currently downloaded. Will clear
         * notifications before scheduling new ones. Also schedules generic reminders
         * for the following week.
         * @param {object} data - Delivery schedule as retrieved from API
         */
        setupNotifications: function (data) {
            var that = this;
            if (that.hasNotificationPlugin()) {
                that.clearNotifications(function() {
                    console.info('Setting notifications');
                    // Schedule notifications for each day from the schedule
                    $.each(data.DeliveryDaysThisWeek, function (i, day) {
                        var dow = day.DayOfWeek;
                        // Schedule notifications for each store within a day
                        $.each(day.Stores, function (i, store) {
                            // Only schedule the notification if the user 
                            // hasn't disabled notifications for this store
                            if (that.get('notification' + store.StoreId) !== 'false') {
                                var cutoffDate = new Date(store.CutOffDateTime);
                                var cutoffString = $.format.date(cutoffDate, 'h:mm a');
                                
                                // Schedule it 30 minutes before the cutoff time
                                // or using the user defined time
                                var time = parseInt(that.get('notificationTime'));
                                if (isNaN(time)) {
                                    that.set('notificationTime', "30");
                                    time = 30;
                                }
                                
                                var notifDate = new Date(cutoffDate.getTime() - time * 60 * 1000);
                                // Only schedule it if it's in the future
                                if (notifDate > new Date()) {
                                    window.plugin.notification.local.add({
                                        id: (dow * 100000 + store.DeliveryTimes[0].DeliveryTimeId).toString(),
                                        date: notifDate,
                                        message: "The cutoff time is almost up! Place your order by " + cutoffString,
                                        title: store.Store.Restaurant.RestaurantName.trim(),
                                        json: JSON.stringify({StoreId: store.StoreId}),
                                        icon: 'icon'
                                    });
                                }
                            }
                        });
                    });
                    
                    // Schedule a reminder notification a week from now
                    // on a weekday to reload the schedule
                    var reminderDate = new Date(), additionalDays = 0;
                    if (reminderDate.getDay() === 6) {
                        additionalDays = 2
                    } else if (reminderDate.getDay() === 0) {
                        additionalDays = 1;
                    }
                    reminderDate.setDate(reminderDate.getDate() + 7 + additionalDays);
                    reminderDate.setHours(9);
                    reminderDate.setMinutes(0);
                    reminderDate.setSeconds(0);
                    reminderDate.setMilliseconds(0);
                    
                    window.plugin.notification.local.add({
                        id: "1",
                        repeat: "daily",
                        date: reminderDate,
                        message: "Click to see which restaurants are available for lunch today",
                        title: "Lunch Options",
                        icon: 'icon'
                    });
                    
                    window.plugin.notification.local.onclick = function (id, state, json) {
                        if (json !== undefined && json !== null) {
                            var data = JSON.parse(json);
                            that.navigate('#dashboard-view?StoreId=' + data.StoreId, 'none');
                        }
                    };
                });
            }
        },

        /**
         * Helper function to determine whether local-notification plugin is supported
         * @returns {boolean}
         */
        hasNotificationPlugin: function () {
            return window.hasOwnProperty('plugin') && window.plugin.hasOwnProperty('notification') && window.plugin.notification.hasOwnProperty('local');
        },

        /**
         * Helper function to determine whether cookie plugin is supported
         * @returns {boolean}
         */
        hasCookiePlugin: function () {
            return window.hasOwnProperty('cookies');
        },

        /**
         * Helper function to determine whether the user has saved cards
         * @return {boolean}
         */
        hasSavedCards: function () {
            return this.get('cards').length > 0;
        },

        /**
         * Helper function to determine whether the user has missing
         * contact information
         * @return {boolean}
         */
        hasMissingInfo: function () {
            var user = this.get('user');
            if (user.Email === null || user.Email === "")
                return true;
            if (user.FirstName === null || user.FirstName === "")
                return true;
            if (user.LastName === null || user.LastName === "")
                return true;
            return user.Phone === null || user.Phone === "";

        },

        /**
         * Helper function to determine whether Foodsby is closed
         * @return {boolean}
         */
        getIsClosed: function () {
            var exceptions = this.get('exceptions');
            var now = new Date().getTime();
            var isClosed = false;
            $.each(exceptions, function (i, exception) {
                var start = new Date(exception.ExceptionDate).getTime();
                var diffHours = (now - start) / (3600 * 1000);
                if (diffHours >= 0 && diffHours < exception.Duration) {
                    isClosed = true;
                }
            });

            return isClosed;
        },

        /**
         * Boilerplate fail handler for ajax calls
         * @param {object} jqXHR
         */
        standardError: function (jqXHR) {
            _kendoApp.hideLoading();
            this.alert(jqXHR.statusText === "canceled" || jqXHR.status === 0 ?
                  "An internet connection is required to proceed. Please try again when a connection is present." : 
                  "Sorry, but we've run into an error on our end. Please try again later.");
        },

        /**
         * Convenience shortcut for Cordova Alert method with
         * no callback and title of 'Foodsby'
         * @param message
         */
        alert: function (message) {
            navigator.notification.alert(message, null, 'Foodsby');
        },

        /**
         * Prefix used for web requests
         */
        urlPrefix: 'https://www.foodsby.com',

        /**
         * Flag for production
         */
        isProduction: true
    };
});