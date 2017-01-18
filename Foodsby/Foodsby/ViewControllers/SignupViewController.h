//
//  SignupViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/11/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserApi.h"
#import "LocationApi.h"
#import "OfficeApi.h"
#import "TTTAttributedLabel.h"
#import "ExceptionApi.h"

@interface SignupViewController : UIViewController <UITextFieldDelegate, TTTAttributedLabelDelegate, UserApiDelegate, LocationApiDelegate, OfficeApiDelegate, ExceptionApiDelegate> {
    
    BOOL        bCheckboxTerms;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignup;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheckbox;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *labelTermsAndConditions;

@end
