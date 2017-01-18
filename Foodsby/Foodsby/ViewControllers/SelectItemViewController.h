//
//  SelectItemViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/24/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "MenuApi.h"

@interface SelectItemViewController : UIViewController<SlideNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, MenuApiDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *  imageViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *      labelSubMenuName;
@property (weak, nonatomic) IBOutlet UILabel *      labelSubMenuText;
@property (weak, nonatomic) IBOutlet UITableView *  tableViewSubMenu;
@property (weak, nonatomic) IBOutlet UILabel *      labelSubMenuNameOne;

@end
