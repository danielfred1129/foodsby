require.config({
    paths: {
        jQuery: "libs/jquery.min",
        kendo: "libs/kendo.mobile.min",
        base64: "libs/jquery.base64.min",
        format: "libs/jquery.dateFormat.min",
        utils: "utils",
        text: "libs/text"
    },
    shim: {
        jQuery: {
            exports: "jQuery"
        },
        kendo: {
            deps: ["jQuery"],
            exports: "kendo"
        },
        base64: {
            deps: ["jQuery"],
            exports: "base64"
        },
        format: {
            deps: ["jQuery"],
            exports: "format"
        }
    }
});

var app;

require(["jQuery", "app/app"], function ($, application) {
    app = application;

    $(document).ready(function () {
        function onDeviceReady() {
            document.addEventListener('backbutton', function () {
            }, true);
            app.init();
            $(document.body).height(window.innerHeight);
        }

        if (!window.device || window.tinyHippos) {
            onDeviceReady();
        }
        else {
            document.addEventListener('deviceready', onDeviceReady);
        }
    });
});