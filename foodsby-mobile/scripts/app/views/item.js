define(["kendo", "utils", "text!./item.html", "jQuery"], function (kendo, utils, itemHtml, $) {
    var viewModel = kendo.observable({
    });

    return {
        init: function (initEvt) {
            $("#item-list").on('change', 'input.answer[type=radio]', function () {
                $(this).parents('li.answer').siblings('.question').hide();
                $('.q-for-' + $(this).val().trim()).show();
            });
            $("#item-list").on('change', 'input.answer[type=checkbox]', function () {
                if (this.checked) {
                    $('.q-for-' + $(this).val().trim()).show();
                } else {
                    $('.q-for-' + $(this).val().trim()).hide();
                }
            });
            $("#item-view").on('click', '.add-item,.checkout', function () {
                var error = 0;
                var response = {
                    OrderId: utils.get('orderId'),
                    MenuItemId: utils.get('menuItemId'),
                    SpecialInstructions: $('#item-view textarea[name=special]').val(),
                    SelectedAnswers: []
                };
                $.each($('.question-text:visible'), function () {
                    var list = $(this).next().find('ul:first');
                    var checked = list.find('> li.answer :checked');
                    var min = parseInt(list.attr('data-min').trim());
                    var max = parseInt(list.attr('data-max').trim());
                    if (!(min == 0 && max == 0)) {
                        if (min > checked.length) {
                            if (error === 0) {
                                error = $(this).offset().top - $(this).outerHeight();
                            }
                            $(this).find('.error-text').text('You must select at least ' + min + ' option' + (min > 1 ? 's' : '') + '.');
                        }
                        else if (max !== 0 && max < checked.length) {
                            if (error === 0) {
                                error = $(this).offset().top - $(this).outerHeight();
                            }
                            $(this).find('.error-text').text('You can only select up to ' + max + ' option' + (max > 1 ? 's' : '') + '.');
                        }
                    }
                    $.each(checked, function () {
                        response.SelectedAnswers.push({
                            AnswerId: $(this).val().trim(),
                            Selected: true,
                            Depth: $(this).attr('data-depth').trim()
                        });
                    });
                });
                if (error !== 0) {
                    utils.getKendoApp().scroller().scrollTo(0, -(utils.getKendoApp().scroller().scrollTop + error - 20));
                    error = 0;
                }
                else {
                    var that = $(this);
                    utils.showLoading();
                    utils.ajax({
                        method: 'post',
                        url: utils.urlPrefix + "/api/order/additem",
                        data: JSON.stringify(response),
                        dataType: 'text',
                        contentType: 'application/json; charset=utf-8'
                    }).done(function () {
                        utils.setValue('menu', 'OrderItemsCount', utils.getValue('menu', 'OrderItemsCount') + 1);
                        utils.hideLoading();
                        if (that.hasClass('add-item')) {
                            utils.navigate("#menu-view");
                        } else {
                            utils.navigate("#confirm-view");
                        }
                    })
                        .fail(function (jqXHR) {
                            utils.hideLoading();
                            utils.alert(jqXHR.statusText === "canceled" ?
                                  "An internet connection is required to proceed. Please try again when a connection is present." : 
                                  'There was a problem processing your item. Please try again.');
                        });
                }
            });
        },

        beforeShow: function (beforeShowEvt) {
            utils.getKendoApp().scroller().reset();
            var menu = utils.get('menu');
            $('#item-view [data-icon="cart"]').data('kendoMobileButton').badge(menu.OrderItemsCount > 0 ? menu.OrderItemsCount : false);
        },

        show: function (showEvt) {
            showEvt.view.element.find("#item-list").kendoMobileListView({
                template: showEvt.view.element.find("#item-list-tmp").html(),
                dataSource: kendo.data.DataSource.create(utils.getValue('qa', 'QuestionItems'))
            });
            $('#item-view textarea[name=special]').val('');
            showEvt.view.scroller.reset();
        },

        html: itemHtml,

        viewModel: viewModel,
    }
});