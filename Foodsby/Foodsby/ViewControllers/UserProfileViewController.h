//
//  UserProfileViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComboBox.h"
#import "UserApi.h"


@interface UserProfileViewController : UIViewController <UITextFieldDelegate, ComBoxDelegate, UserApiDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewCreditCard;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;

@property (weak, nonatomic) IBOutlet UIView *viewNotifications;

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *textFieldCreditCard;

@property (weak, nonatomic) IBOutlet UITextField *textFieldCurrentPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *buttonContactSave;
@property (weak, nonatomic) IBOutlet UIButton *buttonPasswordSave;
@property (weak, nonatomic) IBOutlet UISwitch *switchNotification;

@end
