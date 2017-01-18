//
//  CheckoutViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutApi.h"
#import "UserApi.h"
#import "ComboBox.h"

@interface CheckoutViewController : UIViewController <UITextFieldDelegate, CheckoutApiDelegate, UserApiDelegate, ComBoxDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldFullName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCreditCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldExpirationMonth;
@property (weak, nonatomic) IBOutlet UITextField *textFieldExpirationYear;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCvv;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCity;
@property (weak, nonatomic) IBOutlet UITextField *textFieldState;
@property (weak, nonatomic) IBOutlet UITextField *textFieldZip;
@property (weak, nonatomic) IBOutlet UISwitch *swithSave;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlaceOrder;

@property (weak, nonatomic) IBOutlet UILabel *labelSubtotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscount;

@end
