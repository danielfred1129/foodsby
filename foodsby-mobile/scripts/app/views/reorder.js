define(["kendo", "utils", "text!./reorder.html"], function (kendo, utils, reorderHtml) {
    var viewModel = kendo.observable({
        reorderName: "Your Past Orders",
        reorderText: "Fly through the menu pages by re-ordering one of your past orders."
    }),
        incompatible;

    return {
        init: function (initEvt) {
            var os = kendo.support.mobileOS;
            incompatible = os.ios && os.flatVersion < 710;
            
            $('#reorder-view').on('click', 'a.reorder-item-toggle', function (e) {
                e.preventDefault();
                if (!incompatible) {
                    $(this).parent('li').toggleClass('opened');
                    $(this).find('ul.confirm-sublist').toggle();
                }
            });
            
            $("#reorder-list").on('click', 'a.reorder-item-add', function (e) {
                var reorderId = $(this).attr('rel'),
                    data = utils.get('identifiers');
                data.OrderHistoryId = reorderId;
                delete data.DeliveryId;
                utils.showLoading();
                utils.ajax({
                    url: utils.urlPrefix + "/api/order/reorder",
                    method: 'POST',
                    data: data
                }).done(function (data) {
                    if (data != null) {
                        utils.set("orderId", data);
                        utils.setValue("menu", "OrderId", data);
                        utils.navigate("#confirm-view");
                    }
                    utils.hideLoading();
                }).fail(utils.standardError);
            });
        },

        beforeShow: function (beforeShowEvt) {
            $('.location-bar-image').css('background-image', 'url("' + utils.urlPrefix + encodeURI(utils.getValue('menu', 'LogoLink').substr(1)) + '")');
            var menu = utils.get('menu');
            $('#reorder-view [data-icon="cart"]').data('kendoMobileButton').badge(menu.OrderItemsCount > 0 ? menu.OrderItemsCount : false);
        },

        show: function (showEvt) {
            showEvt.view.element.find("#reorder-list").kendoMobileListView({
                template: showEvt.view.element.find("#reorder-list-tmp").html(),
                dataSource: kendo.data.DataSource.create(utils.get('reorder'))
            });
            if (incompatible) {
                $('#reorder-list').addClass('incompatible');
            }
        },

        html: reorderHtml,

        viewModel: viewModel,
    }
});