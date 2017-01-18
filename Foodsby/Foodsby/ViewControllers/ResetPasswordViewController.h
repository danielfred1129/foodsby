//
//  ResetPasswordViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/12/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserApi.h"

@interface ResetPasswordViewController : UIViewController <UITextFieldDelegate, UserApiDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailAddress;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendPasswordLink;

@end
