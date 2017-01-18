//
//  NotificationsViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComboBox.h"

@interface NotificationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ComBoxDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldTime;

@property (weak, nonatomic) IBOutlet UITableView *tableViewNotifications;

@end
