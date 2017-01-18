define(["jQuery", "kendo", "utils", "text!./contact.html"], function ($, kendo, utils, contactHtml) {
    var viewModel = kendo.observable({
            email: "",
            first: "",
            last: "",
            phone: "",
            isFree: false,
            isNotFree: true,
            onRegister: function () {
                var first = this.get('first').trim(),
                    last = this.get('last').trim(),
                    phone = this.get('phone').trim(),
                    isFree = this.get('isFree');

                $('#contact-view .error-text').remove();
                var error = $('<div class="error-text"></div>');

                if (phone === '' || first === '' || last === '') {
                    error.clone().text('All fields are required').appendTo('#contact-view .account thead th');
                }

                if ($('#contact-view .error-text').length === 0) {
                    utils.showLoading();
                    utils.ajax({
                        url: utils.urlPrefix + "/api/user",
                        data: {
                            FirstName: first,
                            LastName: last,
                            SMSNotify: utils.getValue('user', 'SMSNotify'),
                            Phone: phone
                        },
                        method: 'POST'
                    }).done(function (data) {
                        utils.set('user', data);
                        console.info('User saved. Proceeding to checkout.');
                        if (isFree) {
                            freeCheckout();
                        } else {
                            if (utils.hasSavedCards()) {
                                console.info('Proceeding to saved checkout.');
                                utils.navigate('#checkout_saved-view');
                            }
                            else {
                                console.info('Proceeding to checkout.');
                                utils.navigate('#checkout-view');
                            }
                        }
                    }).fail(utils.standardError)
                    .always(function () {
                        utils.hideLoading();
                    });
                }
            }
        }),
        freeCheckout = function () {
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
        };

    return {
        init: function (initEvt) {
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
            var user = utils.get('user');
            viewModel.set('email', user.Email !== null ? user.Email : "");
            viewModel.set('first', user.FirstName !== null ? user.FirstName : "");
            viewModel.set('last', user.LastName !== null ? user.LastName : "");
            viewModel.set('phone', user.Phone !== null ? user.Phone : "");
            if (showEvt.view.params.hasOwnProperty('free') && showEvt.view.params.free == '1') {
                viewModel.set('isNotFree', false);
                viewModel.set('isFree', true);
            } else {
                viewModel.set('isNotFree', true);
                viewModel.set('isFree', false);
            }
        },

        html: contactHtml,

        viewModel: viewModel
    }
});