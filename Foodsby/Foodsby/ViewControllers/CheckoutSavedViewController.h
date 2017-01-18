//
//  CheckoutSavedViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComboBox.h"
#import "CheckoutApi.h"
#import "UserApi.h"

@interface CheckoutSavedViewController : UIViewController <ComBoxDelegate, CheckoutApiDelegate, UserApiDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelSubtotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscount;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlaceOrder;

@property (weak, nonatomic) IBOutlet UITextField *textFieldCreditCard;

@end
