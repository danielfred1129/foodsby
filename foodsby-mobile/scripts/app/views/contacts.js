define(["kendo", "utils", "text!./contacts.html"], function (kendo, utils, contactsHtml) {
    var viewModel = kendo.observable({
        onInvite: function () {
            var emails = "";
            var checked = $('#contacts-list li input:checked');
            if (checked.length > 0) {
                checked.each(function (i, item) {
                    emails += $(item).siblings('p').text() + ", ";
                });
                emails = emails.substr(0, emails.length - 2);

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
                    utils.navigate('#invite-view');
                });
            }
        },
        canInvite: true
    });

    return {
        init: function (initEvt) {
            $("#contacts-list").kendoMobileListView({
                template: $("#contacts-list-tmp").html(),
                endlessScroll: true,
                virtualViewSize: 60,
                filterable: {
                    field: "name",
                    operator: "contains",
                    ignoreCase: true
                }
            });
        },

        beforeShow: function (beforeShowEvt) {
            var options = new ContactFindOptions();
            options.filter = "";
            options.multiple = true;
            var fields = ['displayName', 'emails'];
            var suffix = utils.getValue('user', 'Email').split('@')[1];
            navigator.contacts.find(fields, function (contacts) {
                console.log('loading contacts', contacts.length);
                utils.showLoading();
                contactsArray = [];
                if (contacts.length > 0) {
                    $.each(contacts, function (i, contact) {
                        if (contact.displayName !== null && contact.emails !== null) {
                            $.each(contact.emails, function (j, email) {
                                if (email.value !== null && $.grep(contactsArray,function (c) {
                                    return c.email === email.value
                                }).length === 0) {
                                    var entry = {
                                        name: contact.displayName,
                                        email: email.value
                                    };
                                    if (email.value.indexOf(suffix) > 0) {
                                        contactsArray.unshift(entry);
                                    } else {
                                        contactsArray.push(entry);
                                    }
                                }
                            });
                        }
                        if (i === contacts.length - 1) {
                            utils.hideLoading();
                            $('#contacts-list').data('kendoMobileListView').setDataSource(kendo.data.DataSource.create(contactsArray));
                        }
                    });
                } else {
                    $('#contacts-list').data('kendoMobileListView').setDataSource(kendo.data.DataSource.create([]));
                }
            }, function (error) {
                console.log('could not load contacts', error);
            }, options);
        },

        show: function (showEvt) {
        },

        html: contactsHtml,

        viewModel: viewModel,
    }
});