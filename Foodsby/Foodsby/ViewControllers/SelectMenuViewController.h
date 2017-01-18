//
//  SelectMenuViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/24/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface SelectMenuViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *  imageViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *      labelDeliveryTime;
@property (weak, nonatomic) IBOutlet UILabel *      labelDeliveryInstructions;
@property (weak, nonatomic) IBOutlet UITableView *  tableViewMenu;

@end
