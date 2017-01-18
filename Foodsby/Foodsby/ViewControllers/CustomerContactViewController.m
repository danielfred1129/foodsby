//
//  CustomerContactViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CustomerContactViewController.h"
#import "CheckoutSavedViewController.h"
#import "CheckoutViewController.h"
#import "ReceiptViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "CustomerInfo.h"
#import "UserApiParser.h"
#import "CheckoutApiParser.h"


@interface CustomerContactViewController ()

@end

@implementation CustomerContactViewController

@synthesize bFree;

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setCustomNavBar];
    [self initViews];

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

- (void) initViews {
    
    _buttonDo.layer.cornerRadius = 5;
    _buttonDo.clipsToBounds = YES;
    
    UIView * viewPadding1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldEmail.leftView = viewPadding1;
    _textFieldEmail.leftViewMode = UITextFieldViewModeAlways;
    _textFieldEmail.delegate = self;
    
    UIView * viewPadding2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldFirstName.leftView = viewPadding2;
    _textFieldFirstName.leftViewMode = UITextFieldViewModeAlways;
    _textFieldFirstName.delegate = self;

    UIView * viewPadding3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldLastName.leftView = viewPadding3;
    _textFieldLastName.leftViewMode = UITextFieldViewModeAlways;
    _textFieldLastName.delegate = self;

    
    UIView * viewPadding4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldPhoneNumber.leftView = viewPadding4;
    _textFieldPhoneNumber.leftViewMode = UITextFieldViewModeAlways;
    _textFieldPhoneNumber.delegate = self;
    
    if (bFree == YES) {

        //Process
        [_buttonDo setTitle:@"Process" forState:UIControlStateNormal];
        
    } else {
        
        //Continue
        [_buttonDo setTitle:@"Continue" forState:UIControlStateNormal];
    }
    
    if ([Utils sharedUtils].user != nil) {
        
        _textFieldEmail.text = [Utils sharedUtils].user.email;
        _textFieldFirstName.text = [Utils sharedUtils].user.firstName;
        _textFieldLastName.text = [Utils sharedUtils].user.lastName;
        _textFieldPhoneNumber.text = [Utils sharedUtils].user.phone;
    }
}

- (void) setCustomNavBar {
    
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    
    self.navigationItem.title = @"Customer Info";
}


#pragma mark - UserApiDelegate

- (void) error:(NSDictionary *)errorInfo {
 
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [[Utils sharedUtils] standardError:errorInfo];
}

- (void) didSetContactUserInfo:(NSDictionary *)info {
    
    [[UserApiParser sharedUserApiParser] didSetContactUserInfo:info];
    
    if (bFree == YES) {
        
        //freeCheckout
        
        [[CheckoutApi sharedCheckoutApi] setDelegate:self];
        [[CheckoutApi sharedCheckoutApi] checkoutFreeMeal:[Utils sharedUtils].orderId];
        
    } else {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        if ([[Utils sharedUtils] hasSavedCards] == YES) {
            
            CheckoutSavedViewController * viewController  = (CheckoutSavedViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_CheckoutSavedViewController"];
            [self.navigationController pushViewController:viewController animated:YES];

        } else {
            
            CheckoutViewController * viewController  = (CheckoutViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_CheckoutViewController"];
            [self.navigationController pushViewController:viewController animated:YES];

        }
    }
}

- (void) didUpdateUser:(NSDictionary *)info {
    
    [[UserApiParser sharedUserApiParser] didUpdateUser:info];
}

#pragma mark - CheckoutApiDelegate

- (void) didCheckoutFreeMeal:(NSDictionary *) info {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    CheckoutCard * checkout = [[CheckoutApiParser sharedCheckoutApiParser] didCheckoutFreeMeal:info];
    
    if (checkout.success == YES) {
        
        [Utils sharedUtils].orderDetails = checkout.orderDetails;//order
        [Utils sharedUtils].receiptDetails = checkout.receiptDetails;
        
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        ReceiptViewController * viewController  = (ReceiptViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_ReceiptViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
        if (([Utils sharedUtils].deliveryLocationId != [Utils sharedUtils].user.deliveryLocationId)
            || ([Utils sharedUtils].officeId != [Utils sharedUtils].user.officeId)) {
            
            User * user = [[User alloc] init];
            
            user.firstName = [Utils sharedUtils].user.firstName;
            user.lastName = [Utils sharedUtils].user.lastName;
            user.phone = [Utils sharedUtils].user.phone;
            user.smsNotify = [Utils sharedUtils].user.smsNotify;
            user.birthday = [Utils sharedUtils].user.birthday;
            user.deliveryLocationId = [Utils sharedUtils].deliveryLocationId;
            user.officeId = [Utils sharedUtils].officeId;
            
            [[UserApi sharedUserApi] setDelegate:self];
            [[UserApi sharedUserApi] updateUser:user];
        }
        
        
    } else {
        
        //utils.alert (checkout.message);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:checkout.message  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
}

#pragma mark - UI Action Mehthods

- (IBAction)onDo:(id)sender {
    
    if ( ([_textFieldEmail.text isEqualToString:@""] == YES) || ([_textFieldFirstName.text isEqualToString:@""] == YES) || ([_textFieldLastName.text isEqualToString:@""] == YES) || ([_textFieldPhoneNumber.text isEqualToString:@""] == YES)) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"All fields are required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CustomerInfo * customerInfo = [[CustomerInfo alloc] init];
    
    customerInfo.fistName = _textFieldFirstName.text;
    customerInfo.lastName = _textFieldLastName.text;
    customerInfo.smsNotify = [Utils sharedUtils].user.smsNotify;
    customerInfo.phone = _textFieldPhoneNumber.text;
    
    [[UserApi sharedUserApi] setDelegate:self];
    [[UserApi sharedUserApi] setContactUserInfo:customerInfo];
}

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _textFieldEmail)
        [_textFieldFirstName becomeFirstResponder];

    else if (textField == _textFieldFirstName)
        [_textFieldLastName becomeFirstResponder];

    else if (textField == _textFieldLastName)
        [_textFieldPhoneNumber becomeFirstResponder];

    else {
        
        [textField resignFirstResponder];
        
        [self onDo:nil];
        
    }
    
    return YES;
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}

@end
