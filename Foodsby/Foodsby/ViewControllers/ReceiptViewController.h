//
//  ReceiptViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface ReceiptViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryInstructions;

@property (weak, nonatomic) IBOutlet UITableView *tableViewOrderSummary;

@property (weak, nonatomic) IBOutlet UILabel *labelSubtotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscount;

@end
