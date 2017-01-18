define(["jQuery", "kendo", "utils", "text!./company.html"], function ($, kendo, utils, companyHtml) {
    var viewModel = kendo.observable({
            name: "",
            address: "",
            suite: "",
            city: "",
            state: "",
            zip: "",
            onCloseModal: function () {
                $("#modalview-address").data("kendoMobileModalView").close();
            },
            onRegister: function () {
                var name = this.get('name').trim(),
                    state = this.get('state').trim(),
                    address = this.get('address').trim(),
                    city = this.get('city').trim(),
                    zip = this.get('zip').trim(),
                    that = this;

                $('#company-view .error-text').remove();
                var error = $('<div class="error-text"></div>');

                if (name === '') {
                    error.clone().text('A name is required').appendTo('#company-view .account thead th');
                } else if (address === '') {
                    error.clone().text('Street address is required').appendTo('#company-view .account thead th');
                } else if (city === '') {
                    error.clone().text('City is required').appendTo('#company-view .account thead th');
                } else if (state === '') {
                    error.clone().text('State is required').appendTo('#company-view .account thead th');
                } else if (zip === '') {
                    error.clone().text('Zip is required').appendTo('#company-view .account thead th');
                }

                if ($('#company-view .error-text').length === 0) {
                    utils.showLoading();
                    utils.ajax({
                        url: utils.urlPrefix + "/api/address/validate",
                        data: {
                            Street: address,
                            City: city,
                            State: state,
                            Zip: zip
                        },
                        method: 'POST'
                    }).done(function (data) {
                        utils.hideLoading();
                        if (data.Success) {
                            if (data.ValidatedAddressId !== null) {
                                postOffice(data.ValidatedAddressId, false);
                            } else {
                                $("#modalview-address").data("kendoMobileModalView").open();
                                $("#company-address").kendoMobileListView({
                                    template: $("#address-tmp").html(),
                                    dataSource: kendo.data.DataSource.create(data.Candidates)
                                });
                            }
                        } else {
                            utils.alert("Your address could not be validated");
                        }
                    }).fail(utils.standardError);
                }
            }
        }),
        postOffice = function (id, isCandidate) {
            utils.showLoading();
            utils.ajax({
                url: utils.urlPrefix + "/api/office",
                data: {
                    CompanyName: viewModel.get('name').trim(),
                    IsCandidateAddress: isCandidate,
                    SelectedAddressId: id
                },
                method: "POST"
            }).done(function (data) {
                utils.hideLoading();
                utils.set('office', data);
                utils.set('OfficeId', data.OfficeId);
                utils.hideLoading();
                utils.clearNotifications();
                utils.navigate("#invite-view", "slide:left reverse");
            }).fail(utils.standardError);
        };

    return {
        init: function (initEvt) {
            $("#company-address").on('click', 'a', function (e) {
                $("#modalview-address").data("kendoMobileModalView").close();
                postOffice(parseInt($(this).attr('data-address')), true);
            });
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
            viewModel.set('name', '');
            viewModel.set('address', '');
            viewModel.set('suite', '');
            viewModel.set('city', '');
            viewModel.set('state', '');
            viewModel.set('zip', '');
        },

        html: companyHtml,

        viewModel: viewModel
    }
});