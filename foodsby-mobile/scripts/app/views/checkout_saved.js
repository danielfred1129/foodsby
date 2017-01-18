define(["jQuery", "kendo", "utils", "text!./checkout_saved.html"], function ($, kendo, utils, checkout_savedHtml) {
    var viewModel = kendo.observable({
            card: "",
            onRegister: function () {
                console.info('Checking out with saved card');
                utils.showLoading();
                utils.ajax({
                    method: 'POST',
                    url: utils.urlPrefix + "/api/checkout/savedcard",
                    data: {
                        OrderId: utils.get('orderId'),
                        CCProfileId: utils.get('preferredCard'),
                        IsProduction: utils.isProduction
                    }
                }).done(function (data) {
                    utils.hideLoading();
                    if (data.Success) {
                        utils.set('order', data.OrderDetails);
                        utils.set('receipt', data.ReceiptDetails);
                        console.info('Order placed');
                        utils.navigate('#receipt-view');

                        if (utils.get('DeliveryLocationId') != utils.getValue('user', 'DeliveryLocationId') ||
                            utils.get('OfficeId') != utils.getValue('user', 'OfficeId')) {
                            utils.ajax({
                                method: 'POST',
                                url: utils.urlPrefix + "/api/user",
                                data: {
                                    FirstName: utils.getValue('user', 'FirstName'),
                                    LastName: utils.getValue('user', 'LastName'),
                                    Phone: utils.getValue('user', 'Phone'),
                                    SMSNotify: utils.getValue('user', 'SMSNotify'),
                                    Birthday: utils.getValue('user', 'Birthday'),
                                    DeliveryLocationId: utils.get('DeliveryLocationId'),
                                    OfficeId: utils.get('OfficeId')
                                }
                            }).done(function (data) {
                                utils.set('user', data);
                            });
                        }
                    }
                    else {
                        utils.alert(data.Message);
                    }
                }).fail(utils.standardError);
            },
            onPromoCode: function () {
                console.info('Applying code');
                utils.showLoading();
                utils.ajax({
                    method: 'POST',
                    url: utils.urlPrefix + "/api/order/applycoupon",
                    data: {
                        OrderId: utils.get('orderId'),
                        CouponCode: $('#checkout_saved-view .code-entry').val().trim()
                    }
                }).done(function (data) {
                    utils.hideLoading();
                    if (data.Success) {
                        utils.set('order', data.Order);
                        $('#checkout_saved-view .code-entry').val('');
                        $('#checkout_saved-view .code-apply').hide();
                        handleOrder(data.Order);
                    }
                    else {
                        utils.alert(data.Message);
                    }
                }).fail(utils.standardError);
            }
        }),
        handleOrder = function (data) {
            $('footer .foodsby .subtotal').text('$' + data.ItemSubTotal.toFixed(2));
            if (data.CouponSubTotal > 0) {
                $('footer .foodsby .discount').text('($' + data.CouponSubTotal.toFixed(2) + ')');
                $('footer .foodsby .discount-row').show();
            }
            else {
                $('footer .foodsby .discount-row').hide();
                $('footer .foodsby .discount').text('($0.00)');
                $('#checkout_saved-view .code-caption').text('').hide();
            }
            $('footer .foodsby .delivery').text('$' + data.FoodsbyFee.toFixed(2));
            $('footer .foodsby .tax').text('$' + data.TaxSubTotal.toFixed(2));
            $('footer .foodsby .total').text('$' + data.OrderTotal.toFixed(2));
        },
        clearForm = function () {
            $('#checkout_saved-view .code-entry').val('');
        };

    return {
        init: function (initEvt) {
            $("#cs-select-card").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "id",
                change: function () {
                    if (this.value() === 'new') {
                        console.info('Creating new card');
                        utils.navigate('#checkout-view');
                    }
                    else {
                        console.info(this.value() + ' selected as card');
                        utils.set('preferredCard', this.value());
                    }
                }
            });
            $('#checkout_saved-view').on('keyup', '.code-entry', function () {
                if ($(this).val() !== '') {
                    $('#checkout_saved-view .code-apply').show();
                }
                else {
                    $('#checkout_saved-view .code-apply').hide();
                }
            });
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
            clearForm();
            $('#checkout_saved-view .code-apply').hide();
            var list = $('#cs-select-card').data('kendoDropDownList'),
                cards = utils.get('cards'),
                source = [];

            $.each(cards, function (i, card) {
                var card = {
                    id: card.CCProfileId,
                    text: "Card ending in ..." + card.LastFour
                };
                source.push(card);
            });

            source.push({
                id: "new",
                text: "Add New Card"
            });

            list.setDataSource(source);
            list.value(utils.get('preferredCard'));
            var order = utils.get('order');
            handleOrder(order);
        },

        html: checkout_savedHtml,

        viewModel: viewModel
    }
});