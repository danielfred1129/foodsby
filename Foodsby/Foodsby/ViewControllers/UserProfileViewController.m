//
//  UserProfileViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Utils.h"
#import "UserCard.h"
#import "UserApiParser.h"


@interface UserProfileViewController () {
    
    ComboBox *          comboBoxCreditCards;
    
    NSMutableArray *    arrayCreditCard;
    NSMutableArray *    arrayCCProfileId;

    NSArray *           arrayTextFields;
}

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setCustomNavBar];
    [self initDropDownList];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setCustomNavBar {
    
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    
    self.navigationItem.title = @"User Profile";
}


- (void) initDropDownList {
    
    arrayCreditCard = [[NSMutableArray alloc] init];
    arrayCCProfileId = [[NSMutableArray alloc] init];
    
    if ([Utils sharedUtils].arrayCards.count == 0) {
     
        _viewCreditCard.hidden = YES;
        
        return;
    }
    
    NSInteger nSelectedCreditCard = [Utils sharedUtils].preferredCard;
    NSInteger nFirstIndex = -1;
    
    for (int i = 0 ; i < [Utils sharedUtils].arrayCards.count ; i ++) {
        
        UserCard * card = [[Utils sharedUtils].arrayCards objectAtIndex:i];
        
        [arrayCCProfileId addObject:[NSNumber numberWithInteger:card.cCProfileId]];
        [arrayCreditCard addObject: [NSString stringWithFormat:@"Card ending in ...%@", card.lastFour]];
        
        if (nSelectedCreditCard == card.cCProfileId)
            nFirstIndex = i;
    }
    
    _textFieldCreditCard.hidden = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = _textFieldCreditCard.frame;
    rect.origin.x = screenRect.size.width - rect.size.width - 20;
    
    comboBoxCreditCards = [[ComboBox alloc]initWithFrame:rect];
    comboBoxCreditCards.delegate = self;
    [comboBoxCreditCards setComboBoxSize:CGSizeMake(_textFieldCreditCard.frame.size.width, _textFieldCreditCard.frame.size.height * 5)];
    [self.view addSubview:comboBoxCreditCards];
    [comboBoxCreditCards setComboBoxDataArray:arrayCreditCard];
    
    if (nFirstIndex != -1)
        [comboBoxCreditCards setComboBoxTitle:[arrayCreditCard objectAtIndex:nFirstIndex]];
    
}

- (void) initViews {
    
    _buttonContactSave.layer.cornerRadius = 5;
    _buttonContactSave.clipsToBounds = YES;
    
    _buttonPasswordSave.layer.cornerRadius = 5;
    _buttonPasswordSave.clipsToBounds = YES;
    
    arrayTextFields = @[_textFieldEmail, _textFieldFirstName, _textFieldLastName, _textFieldPhoneNumber, _textFieldCurrentPassword, _textFieldNewPassword, _textFieldConfirmPassword];
    
    for (int i = 0 ; i < arrayTextFields.count ; i ++) {
        
        UIView * viewPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        UITextField * text = [arrayTextFields objectAtIndex:i];
        text.leftView = viewPadding;
        text.leftViewMode = UITextFieldViewModeAlways;
        text.delegate = self;
    }
    
    _textFieldEmail.text = [Utils sharedUtils].user.email;
    _textFieldFirstName.text = [Utils sharedUtils].user.firstName;
    _textFieldLastName.text = [Utils sharedUtils].user.lastName;
    _textFieldPhoneNumber.text = [Utils sharedUtils].user.phone;
    _switchNotification.on = [Utils sharedUtils].user.smsNotify;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _textFieldEmail)
        [_textFieldFirstName becomeFirstResponder];
    else if (textField == _textFieldFirstName)
        [_textFieldLastName becomeFirstResponder];
    else if (textField == _textFieldLastName)
        [_textFieldPhoneNumber becomeFirstResponder];
    else if (textField == _textFieldPhoneNumber)
        [_textFieldPhoneNumber resignFirstResponder];
    else if (textField == _textFieldCurrentPassword)
        [_textFieldNewPassword becomeFirstResponder];
    else if (textField == _textFieldNewPassword)
        [_textFieldConfirmPassword becomeFirstResponder];
    else if (textField == _textFieldConfirmPassword)
        [_textFieldConfirmPassword resignFirstResponder];
    
    return YES;
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    for (int i = 0 ; i < arrayTextFields.count ; i ++) {
        
        UITextField * textField = [arrayTextFields objectAtIndex:i];
        [textField resignFirstResponder];
    }
    
}

#pragma mark - ComBoxDelegate

-(void)comboBox:(ComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [Utils sharedUtils].preferredCard = [[arrayCCProfileId objectAtIndex:indexPath.row] integerValue];
}

#pragma mark - UI Actions

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSaveContactInfo:(id)sender {
    
    for (int i = 0 ; i < arrayTextFields.count ; i ++) {
        
        UITextField * textField = [arrayTextFields objectAtIndex:i];
        [textField resignFirstResponder];
    }
    
    CustomerInfo * info = [[CustomerInfo alloc] init];
    
    info.fistName = _textFieldFirstName.text;
    info.lastName = _textFieldLastName.text;
    info.phone = _textFieldPhoneNumber.text;
    info.smsNotify = _switchNotification.on;
    
    [[UserApi sharedUserApi] setDelegate:self];
    [[UserApi sharedUserApi] setContactUserInfo:info];
}

- (IBAction)onChangePassword:(id)sender {
    
    for (int i = 0 ; i < arrayTextFields.count ; i ++) {
        
        UITextField * textField = [arrayTextFields objectAtIndex:i];
        [textField resignFirstResponder];
    }
    
    if (([_textFieldCurrentPassword.text isEqualToString:@""] == YES) || ([_textFieldNewPassword.text isEqualToString:@""] == YES) || ([_textFieldCurrentPassword.text isEqualToString:@""] == YES)) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"All fields are required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
        
    } else if ([_textFieldNewPassword.text isEqualToString:_textFieldConfirmPassword.text] == NO) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Your passwords must match" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    [[UserApi sharedUserApi] setDelegate:self];
    [[UserApi sharedUserApi] changePassword:_textFieldCurrentPassword.text newPassword:_textFieldNewPassword.text];
}

- (IBAction)onSwitchNotifications:(id)sender {
    
    CustomerInfo * info = [[CustomerInfo alloc] init];
    
    info.fistName = _textFieldFirstName.text;
    info.lastName = _textFieldLastName.text;
    info.phone = _textFieldPhoneNumber.text;
    info.smsNotify = _switchNotification.on;
    
    [[UserApi sharedUserApi] setDelegate:self];
    [[UserApi sharedUserApi] setContactUserInfo:info];
}


#pragma mark - UserApiDelegate


- (void) error:(NSDictionary *)errorInfo {
    
    [[Utils sharedUtils] standardError:errorInfo];
}

- (void) didSetContactUserInfo:(NSDictionary *)info {
    
    [[UserApiParser sharedUserApiParser] didSetContactUserInfo:info];
}

- (void) didChangePassword:(NSDictionary *)info {
    
    BOOL success = [[UserApiParser sharedUserApiParser] didChangePassword:info];
    
    if (success == NO) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Your password was incorrect" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    _textFieldCurrentPassword.text = @"";
    _textFieldNewPassword.text = @"";
    _textFieldConfirmPassword.text = @"";
    
}

@end
