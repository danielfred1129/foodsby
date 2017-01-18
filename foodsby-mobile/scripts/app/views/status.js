define(["jQuery", "kendo", "utils", "text!./status.html"], function ($, kendo, utils, statusHtml) {
    var viewModel = kendo.observable({
        officeName: "",
        officeCount: "",
        officeAddress: "",
    });

    return {
        init: function (initEvt) {
        },

        beforeShow: function (beforeShowEvt) {
            var office = utils.get('office');
            viewModel.set('officeName', office.OfficeName);
            viewModel.set('officeCount', office.Count == 1 ? "1 person" : office.Count + " people");
            viewModel.set('officeCountText', office.Count == 1 ? "1 person has" : office.Count + " people have");
            viewModel.set('officeAddress', office.DeliveryLine1 + ", " + office.LastLine);
        },

        show: function (showEvt) {
        },

        html: statusHtml,

        viewModel: viewModel
    }
});