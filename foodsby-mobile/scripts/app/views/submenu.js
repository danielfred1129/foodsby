define(["kendo", "utils", "text!./submenu.html"], function (kendo, utils, submenuHtml) {
    var viewModel = kendo.observable({
        submenuName: null,
        submenuText: null
    });

    return {
        init: function (initEvt) {
            $("#submenu-list").on('click', 'a', function (e) {
                var itemId = $(this).attr('rel');
                utils.showLoading();
                utils.ajax({
                    url: utils.urlPrefix + "/api/menu/item/" + itemId
                }).done(function (data) {
                    if (data != null) {
                        utils.set("qa", data);
                        utils.set("menuItemId", itemId);
                        utils.navigate("#item-view");
                    }
                    utils.hideLoading();
                }).fail(utils.standardError);
            });
        },

        beforeShow: function (beforeShowEvt) {
            $('.location-bar-image').css('background-image', 'url("' + utils.urlPrefix + encodeURI(utils.getValue('menu', 'LogoLink').substr(1)) + '")');
            var submenu = utils.get('submenu');
            viewModel.set('submenuName', submenu.SubMenuName);
            viewModel.set('submenuText', submenu.Description);
            var menu = utils.get('menu');
            $('#submenu-view [data-icon="cart"]').data('kendoMobileButton').badge(menu.OrderItemsCount > 0 ? menu.OrderItemsCount : false);
        },

        show: function (showEvt) {
            showEvt.view.element.find("#submenu-list").kendoMobileListView({
                template: showEvt.view.element.find("#submenu-list-tmp").html(),
                dataSource: kendo.data.DataSource.create(utils.get('items'))
            });
        },

        html: submenuHtml,

        viewModel: viewModel,
    }
});