define(["kendo", "utils", "format", "text!./dashboard.html"], function (kendo, utils, format, dashboardHtml) {
    var viewModel = kendo.observable({
        location: null,
    });

    var day;

    var today;

    var setDay = function c(newDay) {
        if (newDay !== undefined) {
            day = newDay;
        }
        var deliveryDay = utils.getDeliveryDay(day);
        if (deliveryDay.Stores.length == 0) {
            $("#list").hide();
            $("#dashboard-no-deliveries").show();
        }
        else {
            $("#list").kendoMobileListView({
                template: $("#tmp").html(),
                dataSource: kendo.data.DataSource.create(deliveryDay.Stores)
            }).show();
            $("#dashboard-no-deliveries").hide();
        }
    }

    return {
        init: function (initEvt) {
            $("#day-list").on('click', 'div', function (e) {
                $('.day-list-item').removeClass('km-state-active');
                $(this).addClass('km-state-active');
                setDay($(this).attr('rel'));
            });
            $("#list").on('click', '.list-delivery-item', function (e) {
                var data = JSON.parse($(this).attr('rel')),
                    cutoff = $(this).data('cutoff'),
                    dropoff = $(this).data('dropoff');
                data.DayOfWeek = day;
                utils.set('identifiers', data);
                utils.showLoading();

                // Runs two ajax requests in parallel to retrieve menu
                // and past orders. Modifies return status of reorder call
                // to return a resolved deferred object on 404 responses
                $.when(utils.ajax({
                        url: utils.urlPrefix + "/api/order/history/" + data.StoreId
                    }).then(function (data, textStatus, jqXHR) {
                        return [data, textStatus, jqXHR];
                    }, function (jqXHR, textStatus, errorThrown) {
                        if (jqXHR.status === 404) {
                            return $.Deferred().resolve([
                                [],
                                textStatus,
                                jqXHR
                            ]);
                        }
                        return $.Deferred().reject(jqXHR, textStatus, errorThrown);
                    }), utils.ajax({
                        method: 'POST',
                        url: utils.urlPrefix + "/api/menu",
                        data: data
                    })).done(function (reorderData, menuData) {
                    utils.set('reorder', reorderData[0]);
                    if (menuData[0] === null) {
                        utils.set("menu", {});
                        utils.alert("Sorry, this restaurant's menu could not be loaded.");
                    } else {
                        if (menuData[0].SoldOut) {
                            utils.alert('Sorry, this restaurant has reached the maximum level of orders it can accept for this delivery.')
                        } else {
                            menuData[0].CutOffTime = cutoff;
                            menuData[0].DropoffTime = dropoff;
                            utils.set("menu", menuData[0]);
                            utils.set("submenus", menuData[0].SubMenus);
                            utils.set("orderId", menuData[0].OrderId);
                            utils.navigate("#menu-view");
                        }
                    }
                }).fail(function (jqXHR) {
                    utils.alert(jqXHR.statusText === "canceled" ?
                      "An internet connection is required to proceed. Please try again when a connection is present." : 
                      "Sorry, this restaurant's menu could not be loaded.");
                }).always(function () {
                    utils.hideLoading();
                });
            });
        },

        beforeShow: function (beforeShowEvt) {
            today = new Date();
            day = today.getDay();
            var locId = utils.get('DeliveryLocationId');
            if (locId === false) {
                locId = utils.getValue('user', 'DeliveryLocationId');
                utils.set('DeliveryLocationId', locId);
            }
            var location = utils.find('locations', 'DeliveryLocationId', locId);
            location.LastLine = location.LastLine.slice(0, -5);
            viewModel.set('location', location);
            $('#settings-dashboard, #settings-notifications').show();
        },

        show: function (showEvt) {
            setDay();
            var days = utils.getValue('schedule', 'DeliveryDaysThisWeek');
            $.each(days, function (i, value) {
                var date = new Date(value.DateOfDayForWeek.substr(0, 10));
                date.setMinutes(date.getMinutes() + date.getTimezoneOffset());
                days[i].DateOfDayForWeek = today.getDate() === date.getDate() ? "Today" : $.format.date(date, "ddd").substr(0, 3);
            });
            $("#day-list").kendoMobileListView({
                template: "<div data-role='button' class='day-list-item' rel='#: DayOfWeek #'>#: DateOfDayForWeek #</div>",
                dataSource: days
            });
            $('.day-list-item[rel=' + day + ']').addClass('km-state-active');
            if (showEvt.view.params.StoreId !== undefined) {
                $('.day-list-item').removeClass('km-state-active');
                $('.day-list-item[rel=' + today.getDay() + ']').addClass('km-state-active');
                setDay(today.getDay());
                $('#dashboard-view a[data-store="' + showEvt.view.params.StoreId + '"]').trigger('click');
            }
            if (utils.getIsClosed()) {
                utils.alert('Foodsby is closed at this time.');
                navigator.app.exitApp();
            }
        },

        html: dashboardHtml,

        viewModel: viewModel
    }
});