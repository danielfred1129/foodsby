//
//  LoginViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/11/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserApi.h"
#import "LocationApi.h"
#import "OfficeApi.h"
#import "ExceptionApi.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, UserApiDelegate, LocationApiDelegate, OfficeApiDelegate, ExceptionApiDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

@end

