define(["jQuery", "kendo", "utils", "text!./profile.html"], function ($, kendo, utils, profileHtml) {
    var viewModel = kendo.observable({
        sms: false,
        email: "",
        first: "",
        last: "",
        phone: "",
        birthday: "",
        currentPassword: "",
        newPassword1: "",
        newPassword2: "",
        onSaveContact: function () {
            $('#modalview-contact').kendoMobileModalView('close');

            utils.ajax({
                method: 'post',
                url: utils.urlPrefix + "/api/user",
                data: {
                    FirstName: this.get('first'),
                    LastName: this.get('last'),
                    Phone: this.get('phone'),
                    SMSNotify: this.get('sms')
                }
            }).done(function (data) {
                utils.set('user', data);
            });
        }, onCancelPassword: function () {
            $('#modalview-password').kendoMobileModalView('close');
            this.set('currentPassword', '');
            this.set('newPassword1', '');
            this.set('newPassword2', '');
        }, onSavePassword: function () {
            var p1 = this.get('currentPassword'),
                p2 = this.get('newPassword1'),
                p3 = this.get('newPassword2')
            that = this;

            $('#modalview-password .error-text').remove();
            var error = $('<div class="error-text"></div>');

            if (p1 === '' || p2 === '' || p3 === '') {
                error.clone().text('All fields are required').appendTo('#modalview-password .m-password thead th');
            }
            else if (p2 !== p3) {
                error.clone().text('Your passwords must match').appendTo('#modalview-password .m-password thead th');
            }

            if ($('#modalview-password .error-text').length === 0) {
                utils.showLoading();
                utils.ajax({
                    method: 'post',
                    url: utils.urlPrefix + "/api/user/changepassword",
                    data: {
                        OldPassword: p1,
                        NewPassword: p2
                    }
                }).done(function (data) {
                    utils.hideLoading();
                    if (data.Success) {
                        $('#modalview-password').kendoMobileModalView('close');
                        that.set('currentPassword', '');
                        that.set('newPassword1', '');
                        that.set('newPassword2', '');
                    }
                    else {
                        error.clone().text('Your password was incorrect').appendTo('#modalview-password .m-password thead th');
                        that.set('currentPassword', '');
                    }
                }).fail(utils.standardError);
            }
        },
        onEditCard: function () {
            var list = $("#profile-card").data('kendoDropDownList');
            if (list !== null) {
                list.open();
            }
        },
        onEnableSMS: function() {
			utils.ajax({
                method: 'post',
                url: utils.urlPrefix + "/api/user",
                data: {
                    FirstName: this.get('first'),
                    LastName: this.get('last'),
                    Phone: this.get('phone'),
                    SMSNotify: this.get('sms')
                }
            }).done(function (data) {
                utils.set('user', data);
            });
        }
    });

    return {
        init: function (initEvt) {
            $("#profile-card").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "id",
                change: function () {
                    console.info(this.value() + ' selected as card');
                    utils.set('preferredCard', this.value());
                }
            });
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
            var user = utils.get('user');
            viewModel.set('email', user.Email);
            viewModel.set('first', user.FirstName);
            viewModel.set('last', user.LastName);
            viewModel.set('phone', user.Phone);
            viewModel.set('birthday', user.Birthday);
            viewModel.set('sms', user.SMSNotify);

            var list = $('#profile-card').data('kendoDropDownList'),
                cards = utils.get('cards'),
                source = [];

            if (cards.length > 1) {
                $.each(cards, function (i, card) {
                    var card = {
                        id: card.CCProfileId,
                        text: "Card ending in ..." + card.LastFour
                    };
                    source.push(card);
                });

                list.setDataSource(source);
                list.value(utils.get('preferredCard'));
                $('#profile-default-card').show();
            }
            else {
                $('#profile-default-card').hide();
            }
        },

        html: profileHtml,

        viewModel: viewModel
    }
});