define(["jQuery", "kendo", "utils", "text!./login.html"], function ($, kendo, utils, loginHtml) {
    var viewModel = kendo.observable({
        username: "",
        password: "",
        rememberMe: true,

        onLogin: function () {
            var that = this,
                username = that.get("username").trim();

            if (username === "") {
                return;
            }

            that.performLogin();
        },

        performLogin: function () {
            var that = this,
                username = that.get("username").trim(),
                password = that.get("password").trim(),
                rememberMe = that.get("rememberMe");
            
            if (password === "") {
                password = " ";
            }

            utils.ajax({
                url: utils.urlPrefix + "/api/login",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader("Authorization", utils.getAuthHeader(username, password));
                    utils.showLoading();
                    return utils.hasConnection();
                }
            }).done(function () {
                utils.set("username", username);
                utils.set("remember", rememberMe);
                that.retrieveToken();
            }).fail(function (jqXHR) {
                if (jqXHR.status === 409) {
                    utils.set("username", username);
                    utils.set("remember", rememberMe);
                    utils.hideLoading();
                    utils.navigate("#password-view");
                } else if (jqXHR.status === 401) {
                    utils.hideLoading();
                    utils.alert("Incorrect username or password");
                } else {
                    that.handleError(jqXHR);
                }
            });
        },

        retrieveToken: function () {
            var that = this;
            utils.ajax({
                url: utils.urlPrefix + "/api/token"
            }).done(that.retrieveUser)
                .fail(that.handleError);
        },

        retrieveUser: function () {
            var that = this;
            utils.ajax({
                url: utils.urlPrefix + "/api/user"
            }).done(function (data) {
                utils.set("user", data);
                utils.loadExceptions();
                utils.loadData().done(function () {
                    utils.hideLoading();
                    if (utils.getValue('user', 'DeliveryLocationId') === null) {
                        var office = utils.find('offices', 'OfficeId', utils.getValue('user', 'OfficeId'));
                        if (office === null) {
                            utils.navigate("#office-view?allowBack=false");
                        } else if (office.DeliveryLocationId === null) {
                            utils.showLoading();
                            utils.set('OfficeId', office.OfficeId);
                            utils.ajax({
                                url: utils.urlPrefix + "/api/office/" + office.OfficeId
                            }).done(function (data) {
                                utils.set("office", data);
                                utils.hideLoading();
                                utils.clearNotifications();
                                utils.navigate("#invite-view", "slide:left reverse");
                            }).fail(that.handleError);
                        } else {
                            utils.set('DeliveryLocationId', office.DeliveryLocationId);
                            utils.setValue('user', 'DeliveryLocationId', office.DeliveryLocationId);
                            utils.navigate("#dashboard-view");
                        }
                    } else {
                        utils.set('DeliveryLocationId', utils.getValue('user', 'DeliveryLocationId'));
                        utils.set('OfficeId', utils.getValue('user', 'OfficeId'));
                        utils.navigate("#dashboard-view");
                    }
                }).fail(that.handleError);
            }).fail(that.handleError);
        },

        handleError: function (jqXHR, textStatus, errorThrown) {
            utils.hideLoading();
            utils.alert(jqXHR.statusText === "canceled" ?
                  "An internet connection is required to proceed. Please try again when a connection is present." : 
                  'We were unable to log you in. Please try again.');
        },

        clearForm: function () {
            var that = this;
            that.set("username", "");
            that.set("password", "");
        },

        checkEnter: function (e) {
            var that = this;
            if (e.keyCode == 13) {
                $(e.target).blur();
                that.onLogin();
            }
        }
    });

    return {
        init: function (initEvt) {
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
            viewModel.clearForm();
            if (showEvt.view.params.hasOwnProperty('logout') && showEvt.view.params.logout == 'true') {
                utils.clear();
                utils.clearNotifications();
            } else {
                if (utils.get('username') && utils.get('remember')) {
                    utils.showLoading();
                    viewModel.retrieveToken();
                }
            }
        },

        html: loginHtml,

        viewModel: viewModel
    }
});