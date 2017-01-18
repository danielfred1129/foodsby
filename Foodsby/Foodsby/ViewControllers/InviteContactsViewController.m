//
//  InviteContactsViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/20/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "InviteContactsViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "ContactInAddressBook.h"
#import <AddressBook/AddressBook.h>

@interface InviteContactsViewController ()

@end

@implementation InviteContactsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _buttonSendInvitation.layer.cornerRadius = 5;
    _buttonSendInvitation.clipsToBounds = YES;
    
    arrayContacts = [[NSMutableArray alloc] init];
    
    [self setCustomNavBar];
    
    [self allowContactsAccess];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setCustomNavBar {
    
//    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
//    [self.navigationController.navigationBar setTranslucent:NO];
//    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    
//    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
//    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
  
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    
    self.navigationItem.title = @"Invite Contacts";
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    
    return NO;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
    
    return YES;
}

#pragma mark - UI Action methods

- (IBAction)onSendInvitations:(id)sender {

    NSString * emails = nil;
    
    for ( int i = 0 ; i < arrayContacts.count ; i ++) {
        
        ContactInAddressBook * contact = [arrayContacts objectAtIndex:i];
        
        if (contact.selected == YES) {
            
            if (emails == nil)
                emails = contact.email;
            else
                emails = [emails stringByAppendingString:[NSString stringWithFormat:@", %@", contact.email]];
        }
    }
    
    if (emails != nil) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSInteger officeId = [Utils sharedUtils].officeId;
        
        [[OfficeApi sharedOfficeApi] setDelegate:self];
        [[OfficeApi sharedOfficeApi] inviteOffice:emails officeId:officeId];
    }
        
}

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AddressBook

- (void) allowContactsAccess {
    
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            
            if (granted) {
                
                // First time access has been granted, add the contact
                [self getContactsInAddressBook];
                
            } else {
                
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
        
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        // The user has previously given access, add the contact
        [self getContactsInAddressBook];
        
    } else {
        
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
}

- (void) getContactsInAddressBook {
    
    CFErrorRef * error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
    
    CFIndex nPeople = CFArrayGetCount(allPeople);
    
    for ( int i = 0; i < nPeople; i++ ) {
        
        ContactInAddressBook * contact = [[ContactInAddressBook alloc] init];
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        if (ABMultiValueGetCount(emails) > 0) {
            
            contact.firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            contact.lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            contact.companyName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonOrganizationProperty));
            
            NSLog(@"%@ %@", contact.lastName, contact.firstName);
            
            for (CFIndex j = 0 ; j < ABMultiValueGetCount(emails) ; j++) {
                
                NSString * email = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(emails, j);
                
                if (email != nil) {
                    
                    contact.email = email;
                    break;
                }
            }
            
            BOOL bSameEmail = NO;
            
            for (int k = 0 ; k < arrayContacts.count ; k ++) {
                
                ContactInAddressBook * object = [arrayContacts objectAtIndex:k];
                
                if ([contact.email isEqualToString:object.email] == YES) {
                    
                    bSameEmail = YES;
                    break;
                }
            }
            
            if (bSameEmail == NO)
                [arrayContacts addObject:contact];
            
        }
    }
    
    if (arrayContacts.count > 0) {
        
        _tableViewCotacts.delegate = self;
        _tableViewCotacts.dataSource = self;
        
        [_tableViewCotacts reloadData];
    }

}

#pragma mark - UITableView Delegate & Datasrouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrayContacts.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0    ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    
    ContactInAddressBook * contact = [arrayContacts objectAtIndex:indexPath.row];
    
    UILabel * labelName = (UILabel *)[cell viewWithTag:1];
    UILabel * labelEmail = (UILabel *)[cell viewWithTag:2];

    if (contact.firstName != nil)
        labelName.text = contact.firstName;
    
    if (contact.lastName != nil)
        [labelName.text stringByAppendingString:contact.lastName];
    
    if ((contact.firstName == nil) && (contact.lastName == nil))
        labelName.text = contact.companyName;
    
    labelEmail.text = contact.email;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactInAddressBook * contact = [arrayContacts objectAtIndex:indexPath.row];
    
    contact.selected = !contact.selected;
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];

    if (contact.selected == YES)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return;
}

#pragma mark - OfficeApiDelegate methods

- (void) error:(NSDictionary *)errorInfo {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

- (void) didInviteOffice:(NSDictionary *)info {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Your invites have been sent!" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert show];
}

@end
