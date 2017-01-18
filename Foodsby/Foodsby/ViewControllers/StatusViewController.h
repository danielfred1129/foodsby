//
//  StatusViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/18/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface StatusViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelOfficeName;
@property (weak, nonatomic) IBOutlet UILabel *labelOfficeCount;
@property (weak, nonatomic) IBOutlet UILabel *labelOfficeAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelLocationComment;
@property (weak, nonatomic) IBOutlet UIView *viewCommentContainer;

@end
