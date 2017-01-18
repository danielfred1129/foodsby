//
//  CustomerContactViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserApi.h"
#import "CheckoutApi.h"

@interface CustomerContactViewController : UIViewController <UITextFieldDelegate, UserApiDelegate, CheckoutApiDelegate>

@property (nonatomic)       BOOL            bFree;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonDo;

@end
