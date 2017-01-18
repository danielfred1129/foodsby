define(["jQuery", "kendo", "utils", "text!./checkout.html"], function ($, kendo, utils, checkoutHtml) {
    var viewModel = kendo.observable({
            name: "",
            cc: "",
            cvv: "",
            address1: "",
            address2: "",
            city: "",
            zip: "",

            onRegister: function () {
                console.info('Checking out with card');
                var name = this.get('name').trim(),
                    cc = this.get('cc'),
                    cvv = this.get('cvv'),
                    address1 = this.get('address1'),
                    address2 = this.get('address2'),
                    city = this.get('city'),
                    zip = this.get('zip');

                var state_select = $('#c-state').data('kendoDropDownList'),
                    state = state_select.value();

                var month_select = $('#c-exp-month').data('kendoDropDownList'),
                    month = month_select.value();

                var year_select = $('#c-exp-year').data('kendoDropDownList'),
                    year = year_select.value();

                var save_switch = $('#c-save').data('kendoMobileSwitch'),
                    save = save_switch.check();

                $('#checkout-view .error-text').remove();
                var error = $('<div class="error-text"></div>');

                if (cc === '' || cvv === '' || month === 'Expiration Month' || year === 'Expiration Year') {
                    error.clone().text('Credit card fields are required').appendTo('#checkout-view .card thead th');
                }
                if (name === '' || name.indexOf(' ') < 0) {
                    error.clone().text('First and last names are required').appendTo('#checkout-view .card thead th');
                }
                if (address1 === '' || city === '' || zip === '' || state === '') {
                    error.clone().text('Credit card fields are required').appendTo('#checkout-view .address thead th');
                }

                if ($('#checkout-view .error-text').length === 0) {
                    utils.showLoading();
                    utils.ajax({
                        method: 'POST',
                        url: utils.urlPrefix + "/api/checkout/",
                        data: {
                            OrderId: utils.get('orderId'),
                            Street: address1 + ' ' + address2,
                            City: city,
                            State: state,
                            Zip: zip,
                            Payment: {
                                FirstName: name.split(' ')[0],
                                LastName: name.split(' ')[1],
                                CardNbr: cc,
                                ExpMonth: month,
                                ExpYear: year,
                                CVV2: cvv,
                                Amount: utils.get('order').OrderTotal
                            },
                            SaveCard: save,
                            IsProduction: utils.isProduction
                        }
                    }).done(function (data) {
                        utils.hideLoading();
                        if (data.Success) {
                            utils.set('order', data.OrderDetails);
                            utils.set('receipt', data.ReceiptDetails);
                            console.info('Order placed');
                            utils.navigate('#receipt-view');

                            if (save) {
                                utils.ajax({
                                    url: utils.urlPrefix + "/api/user/cards"
                                }).done(function (data) {
                                    utils.set("cards", data);
                                    if (utils.get('preferredCard') === false && data.length > 0) {
                                        utils.set("preferredCard", data[0].CCProfileId);
                                    }
                                });
                            }

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
                        CouponCode: $('#checkout-view .code-entry').val().trim()
                    }
                }).done(function (data) {
                    utils.hideLoading();
                    if (data.Success) {
                        utils.set('order', data.Order);
                        $('#checkout-view .code-entry').val('');
                        $('#checkout-view .code-apply').hide();
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
                $('#checkout-view .code-caption').text('').hide();
            }
            $('footer .foodsby .delivery').text('$' + data.FoodsbyFee.toFixed(2));
            $('footer .foodsby .tax').text('$' + data.TaxSubTotal.toFixed(2));
            $('footer .foodsby .total').text('$' + data.OrderTotal.toFixed(2));
        },
        clearForm = function () {
            viewModel.set('name', '');
            viewModel.set('cc', '');
            viewModel.set('cvv', '');
            viewModel.set('address1', '');
            viewModel.set('address2', '');
            viewModel.set('city', '');
            viewModel.set('zip', '');

            var state_select = $('#c-state').data('kendoDropDownList');
            state_select.select(0);
            var month_select = $('#c-exp-month').data('kendoDropDownList');
            month_select.select(0);
            var year_select = $('#c-exp-year').data('kendoDropDownList');
            year_select.select(0);
            var save_switch = $('#c-save').data('kendoMobileSwitch');
            save_switch.check(true);
        };

    return {
        init: function (initEvt) {
            $("#c-exp-month").kendoDropDownList({
                optionLabel: "Expiration Month",
                dataSource: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
            });
            $("#c-exp-year").kendoDropDownList({
                optionLabel: "Expiration Year",
                dataSource: ["2014", "2015", "2016", "2017", "2018", "2019", "2020" ]
            });
            $("#c-state").kendoDropDownList({
                    dataTextField: "name",
                    dataValueField: "abbreviation",
                    optionLabel: {
                        name: "State",
                        abbreviation: ""
                    },
                    dataSource: [
                        {
                            "name": "Alabama",
                            "abbreviation": "AL"
                        },
                        {
                            "name": "Alaska",
                            "abbreviation": "AK"
                        },
                        {
                            "name": "American Samoa",
                            "abbreviation": "AS"
                        },
                        {
                            "name": "Arizona",
                            "abbreviation": "AZ"
                        },
                        {
                            "name": "Arkansas",
                            "abbreviation": "AR"
                        },
                        {
                            "name": "California",
                            "abbreviation": "CA"
                        },
                        {
                            "name": "Colorado",
                            "abbreviation": "CO"
                        },
                        {
                            "name": "Connecticut",
                            "abbreviation": "CT"
                        },
                        {
                            "name": "Delaware",
                            "abbreviation": "DE"
                        },
                        {
                            "name": "District Of Columbia",
                            "abbreviation": "DC"
                        },
                        {
                            "name": "Federated States Of Micronesia",
                            "abbreviation": "FM"
                        },
                        {
                            "name": "Florida",
                            "abbreviation": "FL"
                        },
                        {
                            "name": "Georgia",
                            "abbreviation": "GA"
                        },
                        {
                            "name": "Guam",
                            "abbreviation": "GU"
                        },
                        {
                            "name": "Hawaii",
                            "abbreviation": "HI"
                        },
                        {
                            "name": "Idaho",
                            "abbreviation": "ID"
                        },
                        {
                            "name": "Illinois",
                            "abbreviation": "IL"
                        },
                        {
                            "name": "Indiana",
                            "abbreviation": "IN"
                        },
                        {
                            "name": "Iowa",
                            "abbreviation": "IA"
                        },
                        {
                            "name": "Kansas",
                            "abbreviation": "KS"
                        },
                        {
                            "name": "Kentucky",
                            "abbreviation": "KY"
                        },
                        {
                            "name": "Louisiana",
                            "abbreviation": "LA"
                        },
                        {
                            "name": "Maine",
                            "abbreviation": "ME"
                        },
                        {
                            "name": "Marshall Islands",
                            "abbreviation": "MH"
                        },
                        {
                            "name": "Maryland",
                            "abbreviation": "MD"
                        },
                        {
                            "name": "Massachusetts",
                            "abbreviation": "MA"
                        },
                        {
                            "name": "Michigan",
                            "abbreviation": "MI"
                        },
                        {
                            "name": "Minnesota",
                            "abbreviation": "MN"
                        },
                        {
                            "name": "Mississippi",
                            "abbreviation": "MS"
                        },
                        {
                            "name": "Missouri",
                            "abbreviation": "MO"
                        },
                        {
                            "name": "Montana",
                            "abbreviation": "MT"
                        },
                        {
                            "name": "Nebraska",
                            "abbreviation": "NE"
                        },
                        {
                            "name": "Nevada",
                            "abbreviation": "NV"
                        },
                        {
                            "name": "New Hampshire",
                            "abbreviation": "NH"
                        },
                        {
                            "name": "New Jersey",
                            "abbreviation": "NJ"
                        },
                        {
                            "name": "New Mexico",
                            "abbreviation": "NM"
                        },
                        {
                            "name": "New York",
                            "abbreviation": "NY"
                        },
                        {
                            "name": "North Carolina",
                            "abbreviation": "NC"
                        },
                        {
                            "name": "North Dakota",
                            "abbreviation": "ND"
                        },
                        {
                            "name": "Northern Mariana Islands",
                            "abbreviation": "MP"
                        },
                        {
                            "name": "Ohio",
                            "abbreviation": "OH"
                        },
                        {
                            "name": "Oklahoma",
                            "abbreviation": "OK"
                        },
                        {
                            "name": "Oregon",
                            "abbreviation": "OR"
                        },
                        {
                            "name": "Palau",
                            "abbreviation": "PW"
                        },
                        {
                            "name": "Pennsylvania",
                            "abbreviation": "PA"
                        },
                        {
                            "name": "Puerto Rico",
                            "abbreviation": "PR"
                        },
                        {
                            "name": "Rhode Island",
                            "abbreviation": "RI"
                        },
                        {
                            "name": "South Carolina",
                            "abbreviation": "SC"
                        },
                        {
                            "name": "South Dakota",
                            "abbreviation": "SD"
                        },
                        {
                            "name": "Tennessee",
                            "abbreviation": "TN"
                        },
                        {
                            "name": "Texas",
                            "abbreviation": "TX"
                        },
                        {
                            "name": "Utah",
                            "abbreviation": "UT"
                        },
                        {
                            "name": "Vermont",
                            "abbreviation": "VT"
                        },
                        {
                            "name": "Virgin Islands",
                            "abbreviation": "VI"
                        },
                        {
                            "name": "Virginia",
                            "abbreviation": "VA"
                        },
                        {
                            "name": "Washington",
                            "abbreviation": "WA"
                        },
                        {
                            "name": "West Virginia",
                            "abbreviation": "WV"
                        },
                        {
                            "name": "Wisconsin",
                            "abbreviation": "WI"
                        },
                        {
                            "name": "Wyoming",
                            "abbreviation": "WY"
                        }
                    ]
                }
            );
            $("#c-save").kendoMobileSwitch({
                checked: true,
                onLabel: "YES",
                offLabel: "NO"
            });

            $('#checkout-view').on('keyup', '.code-entry', function () {
                if ($(this).val() !== '') {
                    $('#checkout-view .code-apply').show();
                }
                else {
                    $('#checkout-view .code-apply').hide();
                }
            });
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
            showEvt.view.scroller.reset();
            clearForm();
            $('#checkout-view .code-apply').hide();

            var order = utils.get('order');
            handleOrder(order);
        },

        html: checkoutHtml,

        viewModel: viewModel
    }
});