//
//  CustomizeDetailViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/27/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomizeDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic)       NSArray *           arrayQuestionItems;

@property (weak, nonatomic) IBOutlet UITableView *tableViewQuestion;

@end
