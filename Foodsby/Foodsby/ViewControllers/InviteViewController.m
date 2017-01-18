//
//  InviteViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/13/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "InviteViewController.h"
#import "Utils.h"
#import "InviteContactsViewController.h"
#import "MBProgressHUD.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {

    [super viewDidLoad];

//    self.navigationController.navigationBar.hidden = YES;
    
    _buttonFindContracts.layer.cornerRadius = 5;
    _buttonFindContracts.clipsToBounds = YES;

    _buttonSend.layer.cornerRadius = 5;
    _buttonSend.clipsToBounds = YES;
    
    _textFieldEmailAddress1.delegate = self;
    _textFieldEmailAddress2.delegate = self;
    _textFieldEmailAddress3.delegate = self;
    
    
    UIView * viewPadding1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldEmailAddress1.leftView = viewPadding1;
    _textFieldEmailAddress1.leftViewMode = UITextFieldViewModeAlways;
    
    UIView * viewPadding2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldEmailAddress2.leftView = viewPadding2;
    _textFieldEmailAddress2.leftViewMode = UITextFieldViewModeAlways;

    UIView * viewPadding3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldEmailAddress3.leftView = viewPadding3;
    _textFieldEmailAddress3.leftViewMode = UITextFieldViewModeAlways;

    [self showOfficeInfo];
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

- (void) showOfficeInfo {

    CompanyDetail * office = [Utils sharedUtils].office;
    
    _labelOfficeName.text = office.officeName;
    
    if (office.count == 1)
        _labelOfficeCount.text = @"1 person";
    else
        _labelOfficeCount.text = [NSString stringWithFormat:@"%ld people", office.count];
    
    _labelOfficeAddress.text = [NSString stringWithFormat:@"%@, %@", office.deliveryLine1, office.lastLine];
}


#pragma mark - UI Action methods

- (IBAction)onFindContacts:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;

    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    InviteContactsViewController * viewController  = (InviteContactsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_InviteContactsViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onSend:(id)sender {
    
    if ((_textFieldEmailAddress1.text.length == 0) || (_textFieldEmailAddress2.text.length == 0) || (_textFieldEmailAddress2.text.length == 0)) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Email address is required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    if ((_textFieldEmailAddress1.text.length != 0) && ([Utils validateEmail:_textFieldEmailAddress1.text] == NO)) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"The first email adderess must be validated" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }

    if ((_textFieldEmailAddress2.text.length != 0) && ([Utils validateEmail:_textFieldEmailAddress2.text] == NO)) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"The second email adderess must be validated" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }

    if ((_textFieldEmailAddress3.text.length != 0) && ([Utils validateEmail:_textFieldEmailAddress3.text] == NO)) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"The third email adderess must be validated" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }

    NSString * emails = @"";
    
    if (_textFieldEmailAddress1.text.length != 0)
        emails = _textFieldEmailAddress1.text;
    
    if (_textFieldEmailAddress2.text.length != 0) {
        
        if (emails.length == 0)
            emails = _textFieldEmailAddress2.text;
        else
            emails = [emails stringByAppendingString:[NSString stringWithFormat:@", %@", _textFieldEmailAddress2.text]];
    }
    
    if (_textFieldEmailAddress3.text.length != 0) {
        
        if (emails.length == 0)
            emails = _textFieldEmailAddress3.text;
        else
            emails = [emails stringByAppendingString:[NSString stringWithFormat:@", %@", _textFieldEmailAddress3.text]];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSInteger officeId = [Utils sharedUtils].officeId;

    [[OfficeApi sharedOfficeApi] setDelegate:self];
    [[OfficeApi sharedOfficeApi] inviteOffice:emails officeId:officeId];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];

    
    return YES;
}


- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}

@end
