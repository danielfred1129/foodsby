define(["kendo", "utils", "text!./settings.html"], function (kendo, utils, settingsHtml) {
    var viewModel = kendo.observable({});

    return {
        init: function (initEvt) {
        },

        beforeShow: function (beforeShowEvt) {
        },

        show: function (showEvt) {
        },

        html: settingsHtml,

        viewModel: viewModel,
    }
});