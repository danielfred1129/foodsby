define(["jQuery", "kendo", "utils", "base64", "app/views/login", "app/views/register", "app/views/dashboard", "app/views/office", "app/views/settings",
    "app/views/menu", "app/views/submenu", "app/views/item", "app/views/confirm", "app/views/forgot", "app/views/notifications", "app/views/password",
    "app/views/contact", "app/views/checkout_saved", "app/views/checkout", "app/views/receipt", "app/views/profile", "app/views/company", "app/views/invite",
    "app/views/status", "app/views/contacts", "app/views/reorder", "app/views/terms"],

    function ($, kendo, utils, base64, login, register, dashboard, office, settings, menu, submenu, item, confirm, forgot, notifications, password, contact, checkout_saved, checkout, receipt, profile, company, invite, status, contacts, reorder, terms) {

        var _kendoApplication, _kendoViews = {
            login: login,
            register: register,
            dashboard: dashboard,
            office: office,
            settings: settings,
            menu: menu,
            submenu: submenu,
            item: item,
            confirm: confirm,
            forgot: forgot,
            notifications: notifications,
            password: password,
            contact: contact,
            checkout: checkout,
            checkout_saved: checkout_saved,
            receipt: receipt,
            profile: profile,
            company: company,
            invite: invite,
            status: status,
            contacts: contacts,
            reorder: reorder,
            terms: terms
        };

        function onBeforeInit() {
            var i, item, htmlBuffer = [];
            for (item in _kendoViews) {
                if (_kendoViews.hasOwnProperty(item) && _kendoViews[item].hasOwnProperty('html')) {
                    htmlBuffer.push(_kendoViews[item].html);
                }
            }
            $(document.body).prepend(htmlBuffer.join(''));
        }

        return {
            init: function () {
                onBeforeInit();

                var os = kendo.support.mobileOS;
                var statusBarStyle = os.ios && os.flatVersion >= 700 ? "black-translucent" : "black";
                _kendoApplication = new kendo.mobile.Application(document.body, {
                    initial: 'login-view',
                    transition: 'slide',
                    skin: 'flat',
                    statusBarStyle: statusBarStyle
                });

                utils.setKendoApp(_kendoApplication);
                if (window.plugin !== undefined) {
                    window.plugin.notification.local.setDefaults({ autoCancel: true });
                }
                $(document.body).show();
            },
            views: _kendoViews,
        }
    });