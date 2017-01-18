//
//  OrderSummaryViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/28/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "OrderApi.h"
#import "CheckoutApi.h"

@interface OrderSummaryViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, OrderApiDelegate, CheckoutApiDelegate>

//Main View
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryTime;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryInstructions;
@property (weak, nonatomic) IBOutlet UITableView *tableViewComplex;
@property (weak, nonatomic) IBOutlet UILabel *labelSubtotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscount;
@property (weak, nonatomic) IBOutlet UIButton *buttonExperessCheckout;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheckout;
@property (weak, nonatomic) IBOutlet UIButton *buttonProcess;

//Order Item  details
@property (weak, nonatomic) IBOutlet UIView *viewOrderItem;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOrderItem;
@property (weak, nonatomic) IBOutlet UIButton *buttonCloseOrderItem;


//Apply Promotion Code
@property (weak, nonatomic) IBOutlet UIView *viewApplyPromitionCode;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCouponCode;
@property (weak, nonatomic) IBOutlet UILabel *labelCodeCaption;
@property (weak, nonatomic) IBOutlet UIButton *buttonClosePromotion;
@property (weak, nonatomic) IBOutlet UIButton *buttonApplyCode;


@end
