//
//  LoginViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/11/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "LoginViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "SignupViewController.h"
#import "DashboardViewController.h"
#import "OfficeViewController.h"
#import "BuildLocationTabBarController.h"
#import "UserApiParser.h"
#import "LocationApiParser.h"
#import "OfficeApiParser.h"
#import "ExceptionApiParser.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _textFieldEmailAddress.delegate = self;
    _textFieldPassword.delegate = self;
    
    _buttonLogin.layer.cornerRadius = 5;
    _buttonLogin.clipsToBounds = YES;
    
    _textFieldEmailAddress.text = @"test17@gmail.com";
    _textFieldPassword.text = @"123";
    
    UIView * viewPadding1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldEmailAddress.leftView = viewPadding1;
    _textFieldEmailAddress.leftViewMode = UITextFieldViewModeAlways;

    UIView * viewPadding2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldPassword.leftView = viewPadding2;
    _textFieldPassword.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
 
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _textFieldEmailAddress.text = @"";
    _textFieldPassword.text = @"";

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) showDashboard {

    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    NSUInteger deliveryId = [Utils sharedUtils].user.deliveryLocationId;
    
    if ([Utils sharedUtils].user.deliveryLocationId == -1) {
        
        CompanyDetail * office = nil;
        
        for (int i = 0 ; i < [Utils sharedUtils].arrayAllOffices.count ; i ++) {
            
            office = [[Utils sharedUtils].arrayAllOffices objectAtIndex:i];
            
            if (office.officeId == [Utils sharedUtils].user.officeId)
                break;
            
        }
        
        if (office == nil) {
            
            OfficeViewController * viewController  = (OfficeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_OfficeViewController"];
            
            viewController.bShowBackButton = NO;
            
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if (office.deliveryLocationId == -1) {
            
            [[OfficeApi sharedOfficeApi] setDelegate:self];
            [[OfficeApi sharedOfficeApi] getOffice:office.officeId];
            
            return;
            
        } else {
            
            [Utils sharedUtils].deliveryLocationId = office.deliveryLocationId;

            [Utils sharedUtils].user.deliveryLocationId = office.deliveryLocationId;
            
            DashboardViewController * viewController  = (DashboardViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_DashboardViewController"];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }

    } else {
    
        [Utils sharedUtils].deliveryLocationId = deliveryId;
        
        DashboardViewController * viewController  = (DashboardViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_DashboardViewController"];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }

    [MBProgressHUD hideHUDForView:self.view animated:YES];

    return;
}

#pragma mark - UI Action methods

- (IBAction)onForgotPassword:(id)sender {
    
    
}

- (IBAction)onLogin:(id)sender {
    
    if (self.textFieldEmailAddress.text.length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Email address is required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    if (self.textFieldPassword.text.length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Password is required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    if ([Utils validateEmail:self.textFieldEmailAddress.text] == NO) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Email adderess must be validated" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    for (UIView* view in self.view.subviews) {
        
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[UserApi sharedUserApi] setDelegate:self];
    [[UserApi sharedUserApi] logIn:self.textFieldEmailAddress.text password:self.textFieldPassword.text];

}

- (IBAction)onSignup:(id)sender {

    
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _textFieldEmailAddress)
        [_textFieldPassword becomeFirstResponder];
    
    else {
        
        [textField resignFirstResponder];
        
        [self onLogin:nil];
    }
    
    return YES;
}


#pragma mark - UserApiDelegate

- (void) error:(NSDictionary *) errorInfo {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString * errorDescription = [errorInfo objectForKey:@"NSLocalizedDescription"];
    
    if ([errorDescription rangeOfString:@"401"].location != NSNotFound) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Incorrect username or password" message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
    } else if ([errorDescription rangeOfString:@"canceled"].location != NSNotFound) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"An internet connection is required to proceed. Please try again when a connection is present." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"We were unable to log you in. Please try again." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
    }
}

- (void) didLogIn:(NSDictionary *) info {
    
    [[UserApiParser sharedUserApiParser] didLogIn:info];
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
    
    [[OfficeApiParser sharedOfficeApiParser] didGetAllOffices:info];

    [self showDashboard];
    
    return;
}

- (void) didGetOffice:(NSDictionary *)info {

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils sharedUtils].office = [[OfficeApiParser sharedOfficeApiParser] didGetOffice:info];
    
    [[Utils sharedUtils] clearNotifications];

    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BuildLocationTabBarController * viewController  = (BuildLocationTabBarController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_BuildLocationTabBarController"];

    [self.navigationController pushViewController:viewController animated:YES];
}

@end
