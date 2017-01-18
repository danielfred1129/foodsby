define(["kendo", "utils", "format", "text!./menu.html"], function (kendo, utils, format, menuHtml) {
    var viewModel = kendo.observable({
        deliveryTime: null,
        deliveryInstructions: null
    });

    return {
        init: function (initEvt) {
            $("#menu-list").on('click', 'a', function (e) {
                var subMenuId = $(this).attr('rel');
                utils.set('submenu', utils.find('submenus', 'SubMenuId', subMenuId));
                utils.set('items', utils.getValue('submenu', 'Items'));
                utils.navigate('#submenu-view');
            });
        },

        beforeShow: function (beforeShowEvt) {
            var menu = utils.get('menu');
            $('.location-bar-image').css('background-image', 'url("' + utils.urlPrefix + encodeURI(menu.LogoLink).substr(1) + '")');
            var dropoffDate = new Date(menu.DropoffTime);
            viewModel.set('deliveryTime', 'Delivered at ' + $.format.date(dropoffDate, "h:mm a") + ' at ' + menu.LocationName);
            viewModel.set('deliveryInstructions', menu.PickupInstruction);
            $('#menu-view [data-icon="cart"]').data('kendoMobileButton').badge(menu.OrderItemsCount > 0 ? menu.OrderItemsCount : false);
        },

        show: function (showEvt) {
            showEvt.view.element.find("#menu-list").kendoMobileListView({
                template: showEvt.view.element.find("#menu-list-tmp").html(),
                dataSource: kendo.data.DataSource.create(utils.get('submenus'))
            });
            var reorder = utils.get('reorder');
            if (reorder !== false && reorder.length > 0) {
                $("#menu-reorder-list").show();
            } else {
                $("#menu-reorder-list").hide();
            }
        },

        html: menuHtml,

        viewModel: viewModel,
    }
});