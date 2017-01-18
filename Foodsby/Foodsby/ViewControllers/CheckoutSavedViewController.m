//
//  CheckoutSavedViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CheckoutSavedViewController.h"
#import "CheckoutViewController.h"
#import "ReceiptViewController.h"
#import "UserApiParser.h"

#import "MBProgressHUD.h"

#import "Utils.h"
#import "UserCard.h"
#import "CheckoutApiParser.h"

@interface CheckoutSavedViewController () {
    
    ComboBox *          comboBoxCreditCards;
    
    NSMutableArray *    arrayCreditCard;
    NSMutableArray *    arrayCCProfileId;
}

@end

@implementation CheckoutSavedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _buttonPlaceOrder.layer.cornerRadius = 5;
    _buttonPlaceOrder.clipsToBounds = YES;
    
    [self setCustomNavBar];
    [self initDropDownList];
    [self handleOrder:[Utils sharedUtils].order];
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
    
    self.navigationItem.title = @"Checkout";
}


- (void) initDropDownList {
    
    arrayCreditCard = [[NSMutableArray alloc] init];
    arrayCCProfileId = [[NSMutableArray alloc] init];

    NSInteger nSelectedCreditCard = [Utils sharedUtils].preferredCard;
    NSInteger nFirstIndex = -1;

    [arrayCCProfileId addObject:[NSNumber numberWithInteger:-1]];
    [arrayCreditCard addObject:@"Add New Card"];
    
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
    [comboBoxCreditCards setComboBoxSize:CGSizeMake(_textFieldCreditCard.frame.size.width, _textFieldCreditCard.frame.size.height * 10)];
    [self.view addSubview:comboBoxCreditCards];
    [comboBoxCreditCards setComboBoxDataArray:arrayCreditCard];
    
    if (nFirstIndex != -1)
        [comboBoxCreditCards setComboBoxTitle:[arrayCreditCard objectAtIndex:nFirstIndex]];
    
}

- (void) handleOrder:(Order *) order {
    
    _labelSubtotalPrice.text = [NSString stringWithFormat:@"$%.2lf", order.itemSubTotal];
    
    if (order.couponSubTotal > 0) {
        
        _labelDiscountPrice.hidden = NO;
        _labelDiscount.hidden = NO;
        _labelDiscountPrice.text = [NSString stringWithFormat:@"($%.2lf)", order.couponSubTotal];
    } else {
        
        _labelDiscountPrice.hidden = YES;
        _labelDiscount.hidden = YES;
        _labelDiscountPrice.text = @"($0.00)";
    }
    
    _labelDeliveryPrice.text = [NSString stringWithFormat:@"$%.2lf", order.foodsbyFee];
    _labelTaxPrice.text = [NSString stringWithFormat:@"$%.2lf", order.taxSubTotal];
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%.2lf", order.orderTotal];
}


#pragma mark - ComBoxDelegate

-(void)comboBox:(ComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger nSelectedCreditCard = [[arrayCCProfileId objectAtIndex:indexPath.row] integerValue];
    
    if (nSelectedCreditCard == -1) {
        
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

        CheckoutViewController * viewController  = (CheckoutViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_CheckoutViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
        return;
    }
    
    [Utils sharedUtils].preferredCard = nSelectedCreditCard;
}



#pragma mark - CheckoutApiDelegate

- (void) error:(NSDictionary *)errorInfo {
    
    [[Utils sharedUtils] standardError:errorInfo];
}

- (void) didCheckoutSavedCard:(NSDictionary *)info {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    CheckoutCard * checkout = [[CheckoutApiParser sharedCheckoutApiParser] didCheckoutSavedCard:info];
    
    if (checkout.success == YES) {
        
        [Utils sharedUtils].orderDetails = checkout.orderDetails;//order
        [Utils sharedUtils].receiptDetails = checkout.receiptDetails;
        
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        ReceiptViewController * viewController  = (ReceiptViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_ReceiptViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
        [self updateUser];
        
    } else {
        
        //utils.alert (checkout.message);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:checkout.message  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
    
}


- (void) updateUser {
    
    if (([Utils sharedUtils].deliveryLocationId != [Utils sharedUtils].user.deliveryLocationId)
        || ([Utils sharedUtils].officeId != [Utils sharedUtils].user.officeId)) {
        
        User * user = [[User alloc] init];
        
        user.firstName = [Utils sharedUtils].user.firstName;
        user.lastName = [Utils sharedUtils].user.lastName;
        user.phone = [Utils sharedUtils].user.phone;
        user.smsNotify = [Utils sharedUtils].user.smsNotify;
        user.birthday = [Utils sharedUtils].user.birthday;
        user.deliveryLocationId = [Utils sharedUtils].deliveryLocationId;
        user.officeId = [Utils sharedUtils].officeId;
        
        [[UserApi sharedUserApi] setDelegate:self];
        [[UserApi sharedUserApi] updateUser:user];
    }
}


#pragma mark - UserApiDelegate

- (void) didUpdateUser:(NSDictionary *)info {
    
    [[UserApiParser sharedUserApiParser] didUpdateUser:info];
}

#pragma mark - UI Action methods

- (IBAction)onBack:(id)sender {
    
    [[Utils sharedUtils] setMenuType:[Utils sharedUtils].orderSummaryViewController.navigationController type:1];
    [self.navigationController popToViewController:[Utils sharedUtils].orderSummaryViewController animated:YES];

}

- (IBAction)onPlaceOrder:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CheckoutApi sharedCheckoutApi] setDelegate:self];
    [[CheckoutApi sharedCheckoutApi] checkoutSavedCard:[Utils sharedUtils].orderId cCProfileId:[Utils sharedUtils].preferredCard isProduction:[Utils sharedUtils].isProduction];
    
}

@end
