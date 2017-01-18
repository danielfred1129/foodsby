//
//  MenuViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/12/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"


@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *      tableViewMenu;
@property (nonatomic) NSInteger                           nMenuType;
@property (weak, nonatomic) UINavigationController *      menuNavigationController;

@end
