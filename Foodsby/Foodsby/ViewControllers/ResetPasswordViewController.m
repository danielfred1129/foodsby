//
//  ResetPasswordViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/12/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "UserApiParser.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _textFieldEmailAddress.delegate = self;
    
    _buttonSendPasswordLink.layer.cornerRadius = 5;
    _buttonSendPasswordLink.clipsToBounds = YES;
    
    [self setCustomNavBar];
    
    UIView * viewPadding1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldEmailAddress.leftView = viewPadding1;
    _textFieldEmailAddress.leftViewMode = UITextFieldViewModeAlways;

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
    
    self.navigationItem.title = @"Reset Password";
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [self onSendPasswordLink:nil];
    
    return YES;
}

#pragma mark - UI Action methods

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSendPasswordLink:(id)sender {
    
    [self.textFieldEmailAddress resignFirstResponder];

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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[UserApi sharedUserApi] setDelegate:self];
    [[UserApi sharedUserApi] resetPassword:self.textFieldEmailAddress.text];
}

#pragma mark - UserApiDelegate

- (void) error:(NSDictionary *) errorInfo {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString * errorDescription = [errorInfo objectForKey:@"NSLocalizedDescription"];
    
    if ([errorDescription rangeOfString:@"canceled"].location != NSNotFound) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"An internet connection is required to proceed. Please try again when a connection is present." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Invalid email address" message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void) didResetPassword:(NSDictionary *)info {

    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [[UserApiParser sharedUserApiParser] didResetPassword:info];
    
    [self onBack:nil];
}

@end
