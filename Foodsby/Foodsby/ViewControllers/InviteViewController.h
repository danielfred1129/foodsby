//
//  InviteViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/13/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfficeApi.h"
#import "SlideNavigationController.h"

@interface InviteViewController : UIViewController <UITextFieldDelegate, OfficeApiDelegate>


@property (weak, nonatomic) IBOutlet UILabel *labelOfficeName;
@property (weak, nonatomic) IBOutlet UILabel *labelOfficeCount;
@property (weak, nonatomic) IBOutlet UILabel *labelOfficeAddress;

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailAddress1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailAddress2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailAddress3;

@property (weak, nonatomic) IBOutlet UIButton *buttonFindContracts;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;


@end
