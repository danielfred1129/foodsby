//
//  SignupViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/11/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "SignupViewController.h"
#import "TermsViewController.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#import "OfficeViewController.h"
#import "DashboardViewController.h"

#import "UserApiParser.h"
#import "LocationApiParser.h"
#import "OfficeApiParser.h"
#import "ExceptionApiParser.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    _textFieldEmailAddress.delegate = self;
    _textFieldPassword.delegate = self;
    _textFieldConfirmPassword.delegate = self;
    
    bCheckboxTerms = NO;
 
    [self setCustomNavBar];
    [self createLinkFromWord];
    
    _buttonSignup.layer.cornerRadius = 5;
    _buttonSignup.clipsToBounds = YES;
    
    
    UIView * viewPadding1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldEmailAddress.leftView = viewPadding1;
    _textFieldEmailAddress.leftViewMode = UITextFieldViewModeAlways;

    UIView * viewPadding2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldPassword.leftView = viewPadding2;
    _textFieldPassword.leftViewMode = UITextFieldViewModeAlways;

    UIView * viewPadding3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldConfirmPassword.leftView = viewPadding3;
    _textFieldConfirmPassword.leftViewMode = UITextFieldViewModeAlways;
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
    
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    
    self.navigationItem.title = @"Register";
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}

- (void) showDashboard {
    
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    if ([Utils sharedUtils].user.deliveryLocationId == -1) {
        
        OfficeViewController * viewController  = (OfficeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_OfficeViewController"];
        
        viewController.bShowBackButton = NO;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        
        DashboardViewController * viewController  = (DashboardViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_DashboardViewController"];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    return;
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _textFieldEmailAddress)
        [_textFieldPassword becomeFirstResponder];
    
    else if (textField == _textFieldPassword)
        [_textFieldConfirmPassword becomeFirstResponder];

    else {
    
        [_textFieldConfirmPassword resignFirstResponder];
        
        [self onSignup:nil];
    }
    
    return YES;
}


#pragma mark - TTTAttributedLabelDelegate

- (void) attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    TermsViewController * viewController  = (TermsViewController *)[sb instantiateViewControllerWithIdentifier:@"ID_TermsViewController"];
    
    viewController.urlTerms = url;
    
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Foodsby terms and conditions

- (void) createLinkFromWord{
    
    self.labelTermsAndConditions.delegate = self;

    self.labelTermsAndConditions.text = @"I have read and agree to Foodsby terms and conditions";
    
    NSRange range = [self.labelTermsAndConditions.text rangeOfString:@"Foodsby terms and conditions"];
    
    NSString * strURL = urlPrefix;
    
    NSURL * url = [NSURL URLWithString:[strURL stringByAppendingString:@"Home/Legal"]];

    NSArray * keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName, (id)kCTUnderlineStyleAttributeName, nil];
    NSArray * objects = [[NSArray alloc] initWithObjects:MainBackgroundColor,[NSNumber numberWithInt:kCTUnderlineStyleSingle], nil];
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    self.labelTermsAndConditions.linkAttributes = linkAttributes;
    
    [self.labelTermsAndConditions addLinkToURL:url withRange:range];
}


#pragma mark - UI Action methods

- (IBAction) onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) onCheckTerms:(id)sender {
    
    bCheckboxTerms = !bCheckboxTerms;
    
    if (bCheckboxTerms == YES) {
        
        [_buttonCheckbox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    } else {
        
        [_buttonCheckbox setImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }
}

- (IBAction) onSignup:(id)sender {
    
    if (self.textFieldEmailAddress.text.length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Email address is required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }

    if ([Utils validateEmail:self.textFieldEmailAddress.text] == NO) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Email adderess must be validated" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }

    if (self.textFieldPassword.text.length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Password is required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    if ([self.textFieldPassword.text isEqualToString:self.textFieldConfirmPassword.text] == NO) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Your password must match" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    if (bCheckboxTerms == NO) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"You must agree to the terms" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[UserApi sharedUserApi] setDelegate:self];
    [[UserApi sharedUserApi] createUser:self.textFieldEmailAddress.text password:self.textFieldPassword.text];
}


#pragma mark - UserApiDelegate

- (void) error:(NSDictionary *)errorInfo {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString * errorDescription = [errorInfo objectForKey:@"NSLocalizedDescription"];
    
    if ([errorDescription rangeOfString:@"409"].location != NSNotFound) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"A user with that email address has already registered with Foodsby." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
    } else
        [[Utils sharedUtils] standardError:errorInfo];

    [[Utils sharedUtils] clearNotifications];
    
    [self onBack:nil];
}

- (void) didCreateUser:(NSDictionary *)info {
    
    [[UserApiParser sharedUserApiParser] didCreateUser:info];
}

- (void) didGetUserToken:(NSDictionary *)info {

    [[UserApiParser sharedUserApiParser] didGetUserToken:info];
}

- (void) didGetUser:(NSDictionary *) info {
    
    [[UserApiParser sharedUserApiParser] didGetUser:info];
    
//    [[ExceptionApi sharedExceptionApi] setDelegate:self];
//    [[ExceptionApi sharedExceptionApi] getAllGlobalException];

    NSInteger locationId = [Utils sharedUtils].user.deliveryLocationId;
    
    if (locationId != -1) {
        
        [[LocationApi sharedLocationApi]setDelegate:self];
        [[LocationApi sharedLocationApi] getLocationSchedule:locationId];
        
    } else {
        
        [[UserApi sharedUserApi] getUserCards];
    }
}

- (void) didGetUserCards:(NSArray *) info {
    
    [[UserApiParser sharedUserApiParser] didGetUserCards:info];
    
    [[LocationApi sharedLocationApi]setDelegate:self];
    [[LocationApi sharedLocationApi] getDeliveryLocations];
}

#pragma mark - ExceptionApiDelegate

- (void) didGetAllGlobalException:(NSArray *) info {
    
    [[ExceptionApiParser sharedExceptionApiParser] didGetAllGlobalException:info];
    
//    NSInteger locationId = [Utils sharedUtils].user.deliveryLocationId;
//    
//    if (locationId != -1) {
//        
//        [[LocationApi sharedLocationApi]setDelegate:self];
//        [[LocationApi sharedLocationApi] getLocationSchedule:locationId];
//        
//    } else {
//        
//        [[UserApi sharedUserApi] getUserCards];
//    }
}

#pragma mark - LocationApiDelegate

- (void) didGetLocationSchedule:(NSDictionary *) info {
    
    [[LocationApiParser sharedLocationApiParser] didGetLocationSchedule:info];
    
    [[Utils sharedUtils] setupNotifications:[Utils sharedUtils].deliveryLocationSchedule];

    [[UserApi sharedUserApi] getUserCards];
}

- (void) didGetDeliveryLocations:(NSArray *) info {
    
    [[LocationApiParser sharedLocationApiParser] didGetDeliveryLocations:info];
    
    [[OfficeApi sharedOfficeApi] setDelegate:self];
    [[OfficeApi sharedOfficeApi] getAllOffices];
}

#pragma mark - OfficeApiDelegate

- (void) didGetAllOffices:(NSArray *) info {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [[OfficeApiParser sharedOfficeApiParser] didGetAllOffices:info];
    
    [self showDashboard];
    
    return;
}


@end
