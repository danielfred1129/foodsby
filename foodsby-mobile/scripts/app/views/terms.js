define(["jQuery", "kendo", "utils", "text!./terms.html"], function ($, kendo, utils, termsHtml) {
    var viewModel = kendo.observable({});

    return {
        init: function (initEvt) {},

        beforeShow: function (beforeShowEvt) {},

        show: function (showEvt) {
            showEvt.view.scroller.reset();
        },

        html: termsHtml,

        viewModel: viewModel
    }
});