define(["kendo", "utils", "format", "text!./confirm.html"], function (kendo, utils, format, confirmHtml) {
    var viewModel = kendo.observable({
            deliveryTime: null,
            deliveryInstructions: null,
            isExpress: false,
            canCheckout: false,
            isFree: false,
            isNotFree: true,
            onCheckout: function () {
                if (utils.hasMissingInfo()) {
                    console.info('Missing contact info.');
                    utils.navigate('#contact-view');
                }
                else {
                    if (utils.hasSavedCards()) {
                        console.info('Proceeding to saved checkout.');
                        utils.navigate('#checkout_saved-view');
                    } else {
                        console.info('Proceeding to checkout.');
                        utils.navigate('#checkout-view');
                    }
                }
            },
            onFreeCheckout: function () {
                if (utils.hasMissingInfo()) {
                    console.info('Missing contact info.');
                    utils.navigate('#contact-view?free=1');
                }
                else {
                    utils.showLoading();
                    utils.ajax({
                        method: 'POST',
                        url: utils.urlPrefix + "/api/checkout/freemeal",
                        data: {
                            OrderId: utils.get('orderId')
                        }
                    }).done(function (data) {
                        utils.hideLoading();
                        if (data.Success) {
                            utils.set('order', data.OrderDetails);
                            utils.set('receipt', data.ReceiptDetails);
                            console.info('Order placed');
                            utils.navigate('#receipt-view');
                        } else {
                            utils.alert(data.Message);
                        }
                    }).fail(utils.standardError);
                }
            },
            onPromoCode: function () {
                console.info('Applying code');
                utils.showLoading();
                utils.ajax({
                    method: 'POST',
                    url: utils.urlPrefix + "/api/order/applycoupon",
                    data: {
                        OrderId: utils.get('orderId'),
                        CouponCode: $('#confirm-view .code-entry').val().trim()
                    }
                }).done(function (data) {
                    utils.hideLoading();
                    if (data.Success) {
                        utils.set('order', data.Order);
                        utils.set('promo', {
                            id: data.Order.OrderId,
                            code: $('#confirm-view .code-entry').val().trim()
                        });
                        $('#confirm-view .code-entry').val('');
                        handleOrder(data.Order);
                    } else {
                        utils.alert(data.Message);
                    }
                }).fail(utils.standardError);
            },
            onExpress: function () {
                $('#modalview-express').data("kendoMobileModalView").open();
            },
            onCloseModal: function () {
                $('#modalview-express').data("kendoMobileModalView").close();
            },
            onPerformExpress: function () {
                console.info('Express checkout commencing.');
                $('#modalview-express').data("kendoMobileModalView").close();
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
                    }
                    else {
                        utils.alert(data.Message);
                    }
                }).fail(utils.standardError);
            }
        }),
        handleOrder = function (data) {
            if (data === null) {
                utils.set("order", {});
                viewModel.set('canCheckout', false);
            }
            else {
                utils.set("order", data);
                viewModel.set('canCheckout', data.OrderItems.length > 0);
                $("#confirm-list").kendoMobileListView({
                    template: $("#confirm-list-tmp").html(),
                    dataSource: kendo.data.DataSource.create(data.OrderItems)
                });
                $('footer .foodsby .subtotal').text('$' + data.ItemSubTotal.toFixed(2));
                if (data.CouponSubTotal > 0) {
                    $('footer .foodsby .discount').text('($' + data.CouponSubTotal.toFixed(2) + ')');
                    $('footer .foodsby .discount-row').show();
                    $('#confirm-view .code-caption').text('Coupon for $' + data.CouponSubTotal.toFixed(2) + ' off has been applied.').show();
                }
                else {
                    $('footer .foodsby .discount-row').hide();
                    $('footer .foodsby .discount').text('($0.00)');
                    $('#confirm-view .code-caption').text('').hide();
                }
                $('footer .foodsby .delivery').text('$' + data.FoodsbyFee.toFixed(2));
                $('footer .foodsby .tax').text('$' + data.TaxSubTotal.toFixed(2));
                $('footer .foodsby .total').text('$' + data.OrderTotal.toFixed(2));

                if (data.OrderItems.length > 0 && data.OrderTotal == 0.0) {
                    viewModel.set('isNotFree', false);
                    viewModel.set('isFree', true);
                } else {
                    viewModel.set('isNotFree', true);
                    viewModel.set('isFree', false);
                }

                if (viewModel.get('canCheckout') && !utils.hasMissingInfo() && utils.hasSavedCards()) {
                    viewModel.set('isExpress', true);
                } else {
                    viewModel.set('isExpress', false);
                }
            }
        };

    return {
        init: function (initEvt) {
            $('#confirm-view').on('click', 'a.confirm-item-toggle', function (e) {
                e.preventDefault();
                $(this).parent('li').toggleClass('opened');
                $(this).find('ul.confirm-sublist').toggle();
            });
            $('#confirm-view').on('click', 'a.confirm-delete', function (e) {
                e.preventDefault();
                var id = $(this).data('id');
                var listItem = $(this).parent('li');
                listItem.hide('blind');
                utils.ajax({
                    method: 'POST',
                    url: utils.urlPrefix + "/api/order/removeitem",
                    data: {
                        OrderId: utils.get('orderId'),
                        OrderItemId: id
                    }
                }).done(function () {
                    utils.setValue('menu', 'OrderItemsCount', utils.getValue('menu', 'OrderItemsCount') - 1);
                    utils.ajax({
                        method: 'GET',
                        url: utils.urlPrefix + "/api/order/" + utils.get('orderId')
                    }).done(handleOrder);
                }).fail(utils.standardError, function () {
                    listItem.show();
                });
            });
            $('#confirm-view').on('click', '.confirm-insert-code', function (e) {
                e.preventDefault();
                $('#confirm-view .confirm-code-entry').show();
                $('#confirm-view .confirm-insert-code').hide();
            })
        },

        beforeShow: function (beforeShowEvt) {
            var menu = utils.get('menu');
            $('.location-bar-image').css('background-image', 'url("' + utils.urlPrefix + encodeURI(menu.LogoLink.substr(1)) + '")');
            var dropoffDate = new Date(menu.DropoffTime);
            viewModel.set('deliveryTime', 'Delivered at ' + $.format.date(dropoffDate, "h:mm a") + ' at ' + menu.LocationName);
            viewModel.set('deliveryInstructions', menu.PickupInstruction);
            utils.showLoading();
            var promo = utils.get('promo');
            if (promo && promo.id == utils.get('orderId')) {
                console.info('Applying code');
                $('#confirm-view .confirm-code-entry').show();
                $('#confirm-view .confirm-insert-code').hide();
                utils.ajax({
                    method: 'POST',
                    url: utils.urlPrefix + "/api/order/applycoupon",
                    data: {
                        OrderId: utils.get('orderId'),
                        CouponCode: promo.code
                    }
                }).done(function (data) {
                    if (data.Success) {
                        utils.hideLoading();
                        utils.set('order', data.Order);
                        handleOrder(data.Order);
                    }
                    else {
                        utils.showLoading();
                        utils.ajax({
                            method: 'GET',
                            url: utils.urlPrefix + "/api/order/" + utils.get('orderId'),
                            success: handleOrder,
                            complete: function () {
                                utils.hideLoading();
                            }
                        }).done(function (data) {
                            utils.hideLoading();
                            handleOrder(data);
                        }).fail(utils.standardError);
                        utils.alert(data.Message);
                    }
                }).fail(utils.standardError);
            } else {
                $('#confirm-view .confirm-insert-code').show();
                $('#confirm-view .confirm-code-entry').hide();
                utils.ajax({
                    method: 'GET',
                    url: utils.urlPrefix + "/api/order/" + utils.get('orderId')
                }).done(handleOrder).always(function () {
                    utils.set('promo', false);
                    utils.hideLoading();
                });
            }
        },

        show: function (showEvt) {
            $('#confirm-view .code-entry').val('');
            showEvt.view.scroller.reset();
        },

        html: confirmHtml,

        viewModel: viewModel,
    }
});