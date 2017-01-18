define(["kendo", "utils", "format", "text!./receipt.html"], function (kendo, utils, format, receiptHtml) {
    var viewModel = kendo.observable({
        deliveryTime: null,
        deliveryLocation: null,
        deliveryInstructions: null,
        orderNumber: null
    });

    return {
        init: function (initEvt) {
        },

        beforeShow: function (beforeShowEvt) {
            var receipt = utils.get('receipt');
            viewModel.set('deliveryLocation', receipt.LocationName);
            viewModel.set('deliveryInstructions', receipt.PickupInstruction);
            viewModel.set('orderNumber', receipt.OrderId);
            viewModel.set('deliveryTime', $.format.date(new Date(utils.getValue('menu','DropoffTime')), "h:mm a"));

            var menu = utils.get('menu');
            $('#receipt-view .item-photo').css('background-image', 'url("' + utils.urlPrefix + encodeURI(menu.LogoLink).substr(1) + '")');

            var order = utils.get('order');
            $('#receipt-view .order .subtotal').text('$' + order.ItemSubTotal.toFixed(2));
            if (order.CouponSubTotal > 0) {
                $('#receipt-view .order .discount').text('($' + order.CouponSubTotal.toFixed(2) + ')');
                $('#receipt-view .order.discount-row').show();
            }
            else {
                $('#receipt-view .order.discount-row').hide();
                $('#receipt-view .order .discount').text('($0.00)');
            }
            $('#receipt-view .order .delivery').text('$' + order.FoodsbyFee.toFixed(2));
            $('#receipt-view .order .tax').text('$' + order.TaxSubTotal.toFixed(2));
            $('#receipt-view .order .total').text('$' + order.OrderTotal.toFixed(2));
        },

        show: function (showEvt) {
            showEvt.view.element.find("#receipt-list").kendoMobileListView({
                template: showEvt.view.element.find("#receipt-list-tmp").html(),
                dataSource: kendo.data.DataSource.create(utils.get('order').OrderItems)
            });
        },

        html: receiptHtml,

        viewModel: viewModel,
    }
});