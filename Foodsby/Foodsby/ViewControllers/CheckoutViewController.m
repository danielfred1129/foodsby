//
//  CheckoutViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CheckoutViewController.h"
#import "ReceiptViewController.h"
#import "Utils.h"
#import "CheckoutApiParser.h"
#import "UserApiParser.h"
#import "MBProgressHUD.h"

@interface CheckoutViewController () {

    NSArray *   arrayTextFields;
    
    NSArray *   arrayMonth;
    NSArray *   arrayYear;
    NSArray *   arrayState;

    ComboBox * comboBoxMonth;
    ComboBox * comboBoxYear;
    ComboBox * comboBoxState;
}

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    [self initViews];
    [self setCustomNavBar];
    [self initDropDownList];
    
    [self handleOrder:[Utils sharedUtils].order];
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
    
    _buttonPlaceOrder.layer.cornerRadius = 5;
    _buttonPlaceOrder.clipsToBounds = YES;
    
    
    arrayTextFields = @[_textFieldFullName, _textFieldCreditCardNumber, _textFieldExpirationYear, _textFieldCvv, _textFieldAddress1, _textFieldAddress2, _textFieldCity, _textFieldState, _textFieldZip];
    
    for (int i = 0 ; i < arrayTextFields.count ; i ++) {
        
        UIView * viewPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        UITextField * text = [arrayTextFields objectAtIndex:i];
        text.leftView = viewPadding;
        text.leftViewMode = UITextFieldViewModeAlways;
        text.delegate = self;
    }
}

- (void) setCustomNavBar {
    
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    
    self.navigationItem.title = @"Checkout";
}

- (void) initDropDownList {
    
    //Month
    _textFieldExpirationMonth.hidden = YES;
    arrayMonth = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", nil];
    comboBoxMonth = [[ComboBox alloc]initWithFrame:_textFieldExpirationMonth.frame];
    comboBoxMonth.delegate = self;
    [comboBoxMonth setComboBoxSize:CGSizeMake(_textFieldExpirationMonth.frame.size.width, _textFieldExpirationMonth.frame.size.height * 5)];
    [self.view addSubview:comboBoxMonth];
    [comboBoxMonth setComboBoxHintTitle:@"Exp.Month"];
    [comboBoxMonth setComboBoxDataArray:arrayMonth];
    
    //Year
    _textFieldExpirationYear.hidden = YES;
    arrayYear = [NSArray arrayWithObjects:@"2015", @"2016", @"2017", @"2018", @"2019", @"2020", nil];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = _textFieldExpirationYear.frame;
    rect.origin.x = screenRect.size.width - rect.size.width - 20;
    
    comboBoxYear = [[ComboBox alloc]initWithFrame:rect];
    comboBoxYear.delegate = self;
    [comboBoxYear setComboBoxSize:CGSizeMake(_textFieldExpirationYear.frame.size.width, _textFieldExpirationYear.frame.size.height * 5)];
    [self.view addSubview:comboBoxYear];
    [comboBoxYear setComboBoxHintTitle:@"Exp.Year"];
    [comboBoxYear setComboBoxDataArray:arrayYear];

    //State
    _textFieldState.hidden = YES;
    arrayState = [NSArray arrayWithObjects:@"Alabama", @"Alaska", @"American Samoa", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"District Of Columbia", @"Federated States Of Micronesia", @"Florida", @"Georgia", @"Guam", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Marshall Islands", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Northern Mariana Islands", @"Ohio", @"Oklahoma", @"Oregon", @"Palau", @"Pennsylvania", @"Puerto Rico", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virgin Islands", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
    comboBoxState = [[ComboBox alloc]initWithFrame:_textFieldState.frame];
    comboBoxState.delegate = self;
    [comboBoxState setComboBoxSize:CGSizeMake(_textFieldState.frame.size.width, _textFieldState.frame.size.height * 5)];
    [self.view addSubview:comboBoxState];
    [comboBoxState setComboBoxHintTitle:@"State"];
    [comboBoxState setComboBoxDataArray:arrayState];
    
}


#pragma mark - UI Action methods

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPlaceOrder:(id)sender {
    
    for (int i = 0 ; i < arrayTextFields.count ; i ++) {
        
        UITextField * text = [arrayTextFields objectAtIndex:i];
        
        [text resignFirstResponder];
    }

    if (([_textFieldCreditCardNumber.text isEqualToString:@""] == YES) || ([_textFieldCvv.text isEqualToString:@""] == YES)
        || ([_textFieldExpirationMonth.text isEqualToString:@""] == YES) || ([_textFieldExpirationYear.text isEqualToString:@""] == YES)) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Credit card fields are required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    if (([_textFieldFullName.text isEqualToString:@""] == YES) || ([_textFieldFullName.text containsString:@" "] == NO)) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"First and last names are required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    if (([_textFieldAddress1.text isEqualToString:@""] == YES) || ([_textFieldCity.text isEqualToString:@""] == YES)
        || ([_textFieldZip.text isEqualToString:@""] == YES) || ([_textFieldState.text isEqualToString:@""] == YES)) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Credit card fields are required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    CheckoutInfo * info = [[CheckoutInfo alloc] init];
    
    info.orderId = [Utils sharedUtils].orderId;
    info.street = [NSString stringWithFormat:@"%@ %@", _textFieldAddress1.text, _textFieldAddress2.text];
    info.city = _textFieldCity.text;
    info.state = _textFieldState.text;
    info.zip = _textFieldZip.text;
    
    NSArray * arrayName = [_textFieldFullName.text componentsSeparatedByString:@" "];
    info.payment.fistName = [arrayName objectAtIndex:0];
    info.payment.lastName = [arrayName objectAtIndex:1];
    info.payment.cardNbr = _textFieldCreditCardNumber.text;
    info.payment.expMonth = [_textFieldExpirationMonth.text integerValue];
    info.payment.expYear = [_textFieldExpirationYear.text integerValue];
    info.payment.cVV2 = _textFieldCvv.text;
    info.payment.amount = [Utils sharedUtils].order.orderTotal;
    
    info.saveCard = _swithSave.on;
    info.isProduction = [Utils sharedUtils].isProduction;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CheckoutApi sharedCheckoutApi] setDelegate:self];
    [[CheckoutApi sharedCheckoutApi] checkoutCard:info];
}


#pragma mark - CheckoutApiDelegate

- (void) error:(NSDictionary *)errorInfo {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [[Utils sharedUtils] standardError:errorInfo];
}

- (void) didCheckoutCard:(NSDictionary *)info {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    CheckoutCard * checkout = [[CheckoutApiParser sharedCheckoutApiParser] didCheckoutCard:info];
    
    if (checkout.success == YES) {
        
        [Utils sharedUtils].orderDetails = checkout.orderDetails;
        [Utils sharedUtils].receiptDetails = checkout.receiptDetails;
        
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        ReceiptViewController * viewController  = (ReceiptViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_ReceiptViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
        if (_swithSave.on == YES) {
            
            [[UserApi sharedUserApi] setDelegate:self];
            [[UserApi sharedUserApi] getUserCards];
            
        } else
            [self updateUser];
        
    } else {
        
        //utils.alert (checkout.message);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:checkout.message  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
}

- (void) updateUser {
    
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
}


#pragma mark - UserApiDelegate

- (void) didUpdateUser:(NSDictionary *)info {
    
    [[UserApiParser sharedUserApiParser] didUpdateUser:info];
}

- (void) didGetUserCards:(NSArray *)info {
    
    [[UserApiParser sharedUserApiParser] didGetUserCards:info];
    
    [self updateUser];
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


#pragma mark - ComBoxDelegate

-(void)comboBox:(ComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (comboBox == comboBoxMonth) {
        
        _textFieldExpirationMonth.text = arrayMonth[indexPath.row];
        
    } else if (comboBox == comboBoxYear) {
        
        _textFieldExpirationYear.text = arrayYear[indexPath.row];
        
    } else if (comboBox == comboBoxState) {
        
        _textFieldState.text = arrayState[indexPath.row];
    }
}


#pragma mark -

- (void) handleOrder:(Order *) order {
    
    _labelSubtotalPrice.text = [NSString stringWithFormat:@"$%.2lf", order.itemSubTotal];
    
    if (order.couponSubTotal > 0) {
        
        _labelDiscountPrice.hidden = NO;
        _labelDiscount.hidden = NO;
        _labelDiscountPrice.text = [NSString stringWithFormat:@"($%.2lf)", order.couponSubTotal];
    } else {
        
        _labelDiscountPrice.hidden = YES;
        _labelDiscount.hidden = YES;
        _labelDiscountPrice.text = @"($0.00)";
    }
    
    _labelDeliveryPrice.text = [NSString stringWithFormat:@"$%.2lf", order.foodsbyFee];
    _labelTaxPrice.text = [NSString stringWithFormat:@"$%.2lf", order.taxSubTotal];
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%.2lf", order.orderTotal];
}

@end
