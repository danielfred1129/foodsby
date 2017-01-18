define(["jQuery", "kendo", "utils", "text!./invite.html"], function ($, kendo, utils, inviteHtml) {
    var viewModel = kendo.observable({
            email1: "",
            email2: "",
            email3: "",
            officeName: "",
            officeCount: "",
            officeAddress: "",

            onInvite: function () {
                var validator = $("#invite-view table.coworkers").data("kendoValidator");

                $('#invite-view .error-text').remove();
                var error = $('<div class="error-text"></div>');

                if (!validator.validate()) {
                    error.clone().text(validator.errors()[0]).appendTo('#invite-view .coworkers thead th');
                    validator.hideMessages();
                } else {
                    var emails = this.get('email1');
                    if (this.get('email2') !== "") {
                        emails += ', ' + this.get('email2');
                    }
                    if (this.get('email3') !== "") {
                        emails += ', ' + this.get('email3');
                    }
                    clearForm();
                    utils.showLoading();
                    utils.ajax({
                        url: utils.urlPrefix + "/api/office/invite",
                        method: "POST",
                        data: {
                            InviteEmails: emails,
                            OfficeId: utils.get('OfficeId')
                        }
                    }).always(function () {
                        utils.hideLoading();
                        utils.alert('Your invites have been sent!')
                    });
                }
            }
        }),

        clearForm = function () {
            viewModel.set('email1', '');
            viewModel.set('email2', '');
            viewModel.set('email3', '');
        };

    return {
        init: function (initEvt) {
            $("#invite-view table.coworkers").kendoValidator({validateOnBlur: false});
        },

        beforeShow: function (beforeShowEvt) {
            var office = utils.get('office');
            viewModel.set('officeName', office.OfficeName);
            viewModel.set('officeCount', office.Count == 1 ? "1 person" : office.Count + " people");
            viewModel.set('officeAddress', office.DeliveryLine1 + ", " + office.LastLine);
            $('#settings-dashboard, #settings-notifications').hide();
        },

        show: function (showEvt) {
            clearForm();
        },

        html: inviteHtml,

        viewModel: viewModel
    }
});