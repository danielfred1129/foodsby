define(["kendo", "utils", "text!./office.html"], function (kendo, utils, officeHtml) {
    var viewModel = kendo.observable({
        }),
        sortOffices = function (offices, position) {
            var lat = position.coords.latitude,
                lon = position.coords.longitude;
            offices.sort(function (o1, o2) {
                d1 = Math.sqrt(Math.pow(o1.Latitude - lat, 2) + Math.pow(o1.Longitude - lon, 2));
                d2 = Math.sqrt(Math.pow(o2.Latitude - lat, 2) + Math.pow(o2.Longitude - lon, 2));
                return d1 - d2;
            });
            utils.set('offices', offices);
            initList(offices);
        },
        initList = function (offices) {
            utils.hideLoading();
            $('#office-list').data('kendoMobileListView').setDataSource(offices);
        };

    return {
        init: function (initEvt) {
            $("#office-list").kendoMobileListView({
                template: $("#office-list-tmp").html(),
                endlessScroll: true,
                virtualViewSize: 40,
                dataSource: kendo.data.DataSource.create([]),
                filterable: {
                    field: "OfficeName",
                    operator: "contains",
                    ignoreCase: true
                }
            });
            $("#office-list").on('click', 'a', function (e) {
                var locId = parseInt($(this).attr('rel'));
                var officeId = parseInt($(this).attr('data-office'));
                if (utils.getValue('user', 'OfficeId') == null || utils.getValue('user', 'DeliveryLocationId') == null) {
                    utils.ajax({
                        method: 'post',
                        url: utils.urlPrefix + "/api/user",
                        data: {
                            FirstName: utils.getValue('user', 'FirstName'),
                            LastName: utils.getValue('user', 'LastName'),
                            Phone: utils.getValue('user', 'Phone'),
                            SMSNotify: utils.getValue('user', 'SMSNotify'),
                            Birthday: utils.getValue('user', 'Birthday'),
                            DeliveryLocationId: locId,
                            OfficeId: officeId
                        }
                    }).done(function (data) {
                        utils.set('user', data);
                    });
                }
                if (isNaN(locId)) {
                    utils.showLoading();
                    utils.set('OfficeId', officeId);
                    utils.ajax({
                        url: utils.urlPrefix + "/api/office/" + officeId
                    }).done(function (data) {
                        utils.set("office", data);
                        utils.hideLoading();
                        utils.clearNotifications();
                        utils.navigate("#invite-view", "slide:left reverse");
                    });
                } else {
                    utils.showLoading();
                    utils.set('DeliveryLocationId', locId);
                    utils.set('OfficeId', officeId);
                    utils.ajax({
                        url: utils.urlPrefix + "/api/location/" + locId + "/schedule"
                    }).done(function (data) {
                        if (data == null) {
                            utils.set("schedule", {"DeliveryDaysThisWeek": []});
                            utils.clearNotifications();
                        } else {
                            utils.set("schedule", data);
                            utils.setupNotifications(data);
                        }
                        utils.navigate("#dashboard-view", "slide:left reverse");
                    }).fail(function (jqXHR) {
                        if (jqXHR.status === 404) {
                            utils.alert('The delivery location for this office is not active.');
                        } else {
                            utils.alert(jqXHR.statusText === "canceled" ?
                              "An internet connection is required to proceed. Please try again when a connection is present." : 
                              'Unable to load office information. Please select a different office.');
                        }
                    }).always(utils.hideLoading);
                }
            });
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
            if (showEvt.view.params.allowBack === 'false') {
                showEvt.view.element.find('.km-navbar .km-leftitem').hide();
            } else {
                showEvt.view.element.find('.km-navbar .km-leftitem').show();
            }
            showEvt.view.scroller.reset();
            $('.no-location').hide();
            var offices = utils.get('offices');
            utils.showLoading();
            $('#office-list').data('kendoMobileListView').setDataSource([]);
            navigator.geolocation.getCurrentPosition(
                function (position) {
                    sortOffices(offices, position);
                },
                function (error) {
                    $('.no-location').show();
                    initList(offices);
                },
                {
                    timeout: 20000,
                    enableHighAccuracy: true
                }
            );
        },

        html: officeHtml,

        viewModel: viewModel,
    }
});