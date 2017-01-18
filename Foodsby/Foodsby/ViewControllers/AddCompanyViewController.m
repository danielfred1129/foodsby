//
//  AddCompanyViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/16/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "AddCompanyViewController.h"
#import "BuildLocationTabBarController.h"
#import "MBProgressHUD.h"
#import "OfficeApiParser.h"
#import "Utils.h"

@interface AddCompanyViewController ()

@end

@implementation AddCompanyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setCustomNavBar];
    
    validateAddress = nil;
    
    _buttonAdd.layer.cornerRadius = 5;
    _buttonAdd.clipsToBounds = YES;
    
    _textFieldCompanyName.delegate = self;
    _textFieldStreetAddress.delegate = self;
    _textFieldSuite.delegate = self;
    _textFieldCity.delegate = self;
    _textFieldState.delegate = self;
    _textFieldZip.delegate = self;
    
    _viewVerifyAddress.hidden = YES;
    
    UIView * viewPadding1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldCompanyName.leftView = viewPadding1;
    _textFieldCompanyName.leftViewMode = UITextFieldViewModeAlways;

    UIView * viewPadding2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldStreetAddress.leftView = viewPadding2;
    _textFieldStreetAddress.leftViewMode = UITextFieldViewModeAlways;
    
    UIView * viewPadding3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldSuite.leftView = viewPadding3;
    _textFieldSuite.leftViewMode = UITextFieldViewModeAlways;
    
    UIView * viewPadding4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldCity.leftView = viewPadding4;
    _textFieldCity.leftViewMode = UITextFieldViewModeAlways;
    
    UIView * viewPadding5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldState.leftView = viewPadding5;
    _textFieldState.leftViewMode = UITextFieldViewModeAlways;
    
    UIView * viewPadding6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldZip.leftView = viewPadding6;
    _textFieldZip.leftViewMode = UITextFieldViewModeAlways;
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
    
    self.navigationItem.title = @"Add Company";
}


#pragma mark - UI Actions

- (IBAction)onAdd:(id)sender {

    if (self.textFieldCompanyName.text.length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"A name is required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }

    if (self.textFieldStreetAddress.text.length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Street address is required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }

    if (self.textFieldCity.text.length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"City is required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }

    if (self.textFieldState.text.length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"State is required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }

    if (self.textFieldZip.text.length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Zip is required" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AddressApi sharedAddressApi] setDelegate:self];
    [[AddressApi sharedAddressApi] validateAddress:self.textFieldStreetAddress.text city:self.textFieldCity.text state:self.textFieldState.text zip:self.textFieldZip.text];
}

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)onCancelVerifyAddress:(id)sender {
    
    validateAddress = nil;
    _viewAddCompany.hidden = NO;
    _viewVerifyAddress.hidden = YES;
}

#pragma mark - UITableView Delegate & Datasrouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (validateAddress != nil)
        return validateAddress.candidates.count;
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0    ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VerifyAddressCell"];
    
    CandidateAddress * candicateAddress = [validateAddress.candidates objectAtIndex:indexPath.row];
    
    UILabel * labelDeliveryLine = (UILabel *)[cell viewWithTag:1];
    UILabel * labelLastLine = (UILabel *)[cell viewWithTag:2];
    
    labelDeliveryLine.text = candicateAddress.deliveryLine1;
    labelLastLine.text = candicateAddress.lastLine;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     
    CandidateAddress * candicateAddress = [validateAddress.candidates objectAtIndex:indexPath.row];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[OfficeApi sharedOfficeApi] setDelegate:self];
    [[OfficeApi sharedOfficeApi] createOffice:_textFieldCompanyName.text isCandidateAddress:YES selectedAddressId:candicateAddress.candidateAddressId];

    return;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _textFieldCompanyName)
        [_textFieldStreetAddress becomeFirstResponder];

    else if (textField == _textFieldStreetAddress)
        [_textFieldSuite becomeFirstResponder];

    else if (textField == _textFieldCity)
        [_textFieldState becomeFirstResponder];

    else if (textField == _textFieldState)
        [_textFieldZip becomeFirstResponder];

    else {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}


#pragma mark - AddressApiDelegate

- (void) error:(NSDictionary *)errorInfo {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [[Utils sharedUtils] standardError:errorInfo];
}

- (void) didValidateAddress:(NSDictionary *)info {
    
    validateAddress = [[AddressApiParser sharedAddressApiParser] didValidateAddress:info];
    
    if (validateAddress.success == YES) {
        
        if (validateAddress.validatedAddressId != -1) {
            
            [[OfficeApi sharedOfficeApi] setDelegate:self];
            [[OfficeApi sharedOfficeApi] createOffice:_textFieldCompanyName.text isCandidateAddress:NO selectedAddressId:validateAddress.validatedAddressId];
        } else {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            _tableViewVerifyAddress.delegate = self;
            _tableViewVerifyAddress.dataSource = self;
            
            _viewAddCompany.hidden = YES;
            _viewVerifyAddress.hidden = NO;
            
            [_tableViewVerifyAddress reloadData];
        }
        
    } else {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Your address could not be validated" message:nil  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
}

#pragma mark - OfficeApiDelegate

- (void) didCreateOffice:(NSDictionary *)info {

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
 
    
    [Utils sharedUtils].office = [[OfficeApiParser sharedOfficeApiParser] didCreateOffice:info];

    [Utils sharedUtils].officeId = [Utils sharedUtils].office.officeId;
    
    [[Utils sharedUtils] clearNotifications];

    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BuildLocationTabBarController * viewController  = (BuildLocationTabBarController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_BuildLocationTabBarController"];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
