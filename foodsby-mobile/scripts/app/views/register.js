define(["jQuery", "kendo", "utils", "text!./register.html"], function ($, kendo, utils, registerHtml) {
    var viewModel = kendo.observable({
        email: "",
        password: "",
        confirm: "",
        terms: false,
        readingTerms: false,
        onTerms: function() {
          this.set('readingTerms', true);
        },
        onRegister: function () {
            var email = this.get('email').trim(),
                password = this.get('password'),
                confirm = this.get('confirm'),
                terms = this.get('terms'),
                that = this;

            $('#register-view .error-text').remove();
            var error = $('<div class="error-text"></div>');

            if (email === '') {
                error.clone().text('Email address is required').appendTo('#register-view .account thead th');
            } else if (password === '') {
                error.clone().text('A password is required').appendTo('#register-view .account thead th');
            } else if (password !== confirm) {
                error.clone().text('Your passwords must match').appendTo('#register-view .account thead th');
            }

            if (!terms) {
                error.clone().text('You must agree to the terms').appendTo('#register-view .terms thead th');
            }

            if ($('#register-view .error-text').length === 0) {
                utils.showLoading();
                utils.ajax({
                    url: utils.urlPrefix + "/api/user/createuser",
                    xhrFields: {
                        withCredentials: false
                    },
                    beforeSend: utils.hasConnection,
                    data: {
                        Email: email,
                        Password: password,
                        SMSNotify: false
                    },
                    method: 'POST'
                }).done(function () {
                    utils.loadExceptions();
                    utils.set('username', email);
                    that.retrieveToken();
                }).fail(function (jqXHR) {
                    utils.hideLoading();
                    if (jqXHR.status === 409) {
                        utils.alert('A user with that email address has already registered with Foodsby.');
                    } else {
                        utils.alert(jqXHR.statusText === "canceled" ?
                          "An internet connection is required to proceed. Please try again when a connection is present." : 
                          "Sorry, but we've run into an error on our end. Please try again later.");
                    }
                });
            }
        },

        retrieveToken: function () {
            var email = this.get('email').trim(),
                password = this.get('password'),
                that = this;

            utils.ajax({
                url: utils.urlPrefix + "/api/token",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader("Authorization", utils.getAuthHeader(email, password));
                    return utils.hasConnection();
                }
            }).done(function () {
                that.retrieveUser();
            }).fail(that.unableToProceed);
        },

        retrieveUser: function () {
            var that = this;
            utils.ajax({
                url: utils.urlPrefix + "/api/user"
            }).done(function (data) {
                utils.set("user", data);
                utils.loadExceptions();
                utils.loadData().done(function () {
                    utils.hideLoading();
                    if (utils.getValue('user', 'DeliveryLocationId') === null) {
                        utils.navigate("#office-view?allowBack=false");
                    }
                    else {
                        utils.navigate("#dashboard-view");
                    }
                }).fail(that.unableToProceed);
            }).fail(that.unableToProceed);
        },

        unableToProceed: function (jqXHR) {
            utils.hideLoading();
            utils.alert(jqXHR.statusText === "canceled" ?
                  "An internet connection is required to proceed. Please try again when a connection is present." : 
                  "Sorry, but we've run into an error on our end. Please try again later.");
            utils.navigate('#login-view?logout=true');
        }
    });

    return {
        init: function (initEvt) {
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
            if (viewModel.get('readingTerms')) {
                viewModel.set('readingTerms', false);
            } else {
                viewModel.set('email', '');
                viewModel.set('password', '');
                viewModel.set('confirm', '');
                viewModel.set('terms', false);
            }
        },

        html: registerHtml,

        viewModel: viewModel
    }
});