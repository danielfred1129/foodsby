define(["kendo", "utils", "text!./notifications.html"], function (kendo, utils, notificationsHtml) {
    var viewModel = kendo.observable({
    });

    return {
        init: function (initEvt) {
            $("#notif-time").kendoDropDownList();

            $('#notification-list').on('change', 'input[type="checkbox"]', function () {
                utils.set('notification' + $(this).attr('rel').trim(), this.checked);
                utils.setupNotifications(utils.get('schedule'));
            });

            $('#notifications-view').on('change', 'select', function () {
                utils.set('notificationTime', $(this).val());
                utils.setupNotifications(utils.get('schedule'));
            });

            var dropdownlist = $("#notif-time").data("kendoDropDownList");
            var time = utils.get('notificationTime');
            if (time === null) {
                utils.set('notificationTime', 30);
                time = "30";
            }
            dropdownlist.select(function (dataItem) {
                return dataItem.value === time;
            });
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
            $("#notification-list").kendoMobileListView({
                template: $("#notif-template").html(),
                dataSource: kendo.data.DataSource.create(utils.getValue('schedule', 'StoresForLocation'))
            });
        },

        html: notificationsHtml,

        viewModel: viewModel
    }
});