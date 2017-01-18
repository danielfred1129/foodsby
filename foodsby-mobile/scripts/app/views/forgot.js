define(["jQuery", "kendo", "utils", "text!./forgot.html"], function ($, kendo, utils, forgotHtml) {
    var viewModel = kendo.observable({
        username: "",

        onReset: function () {
            var that = this,
                username = that.get("username").trim();

            if (username !== "") {
                that.sendReset();
            }
        },

        sendReset: function () {
            var that = this,
                username = that.get("username").trim();

            utils.ajax({
                url: utils.urlPrefix + "/api/user/resetpassword",
                method: 'POST',
                data: {email: username},
                beforeSend: function (xhr) {
                    utils.showLoading();
                    return utils.hasConnection();
                }
            }).done(function () {
                utils.alert("Please check your email for password reset instructions.");
                utils.navigate('#login-view');
            }).fail(that.handleError)
                .always(function () {
                    utils.hideLoading();
                    that.clearForm();
                });
        },

        handleError: function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.statusText === "canceled")
                  utils.alert("An internet connection is required to proceed. Please try again when a connection is present.");
            else
                utils.alert("Invalid email address");
        },

        clearForm: function () {
            var that = this;
            that.set("username", "");
        },

        checkEnter: function (e) {
            var that = this;
            if (e.keyCode == 13) {
                $(e.target).blur();
                that.onReset();
            }
        }
    });

    return {
        init: function (initEvt) {
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
        },

        html: forgotHtml,

        viewModel: viewModel
    }
});