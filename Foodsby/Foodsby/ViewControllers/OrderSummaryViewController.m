//
//  OrderSummaryViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/28/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderSummaryViewController.h"
#import "SDwebImage/UIImageView+WebCache.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "OrderApiParser.h"
#import "CheckoutApiParser.h"
#import "SelectMenuViewController.h"
#import "CustomerContactViewController.h"
#import "CheckoutViewController.h"
#import "CheckoutSavedViewController.h"
#import "ReceiptViewController.h"

#define AnimationTime           0.5f

@interface OrderSummaryViewController () {
    
    OrderItem *     selectedItem;
    BOOL            bFirstApplyCoupon;
    BOOL            bFirstGetOrder;
}

@end

@implementation OrderSummaryViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    selectedItem = nil;

    [self setCustomNavBar];
    [self showLocationInfo];
    [self initViews];
    
    [self getOrders];
    
    [Utils sharedUtils].orderSummaryViewController = self;
    
    [[Utils sharedUtils] setMenuType:self.navigationController type:1];
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

- (void) initViews {
    
    _buttonCheckout.layer.cornerRadius = 5;
    _buttonCheckout.clipsToBounds = YES;
    
    _buttonExperessCheckout.layer.cornerRadius = 5;
    _buttonExperessCheckout.clipsToBounds = YES;
    
    _buttonProcess.layer.cornerRadius = 5;
    _buttonProcess.clipsToBounds = YES;
    
    _buttonCloseOrderItem.layer.cornerRadius = 5;
    _buttonCloseOrderItem.clipsToBounds = YES;

    _buttonClosePromotion.layer.cornerRadius = 5;
    _buttonClosePromotion.clipsToBounds = YES;

    _buttonApplyCode.layer.cornerRadius = 5;
    _buttonApplyCode.clipsToBounds = YES;

    UIView * viewPadding1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textFieldCouponCode.leftView = viewPadding1;
    _textFieldCouponCode.leftViewMode = UITextFieldViewModeAlways;
    _textFieldCouponCode.delegate = self;

    _buttonCheckout.enabled = NO;
    _buttonProcess.enabled = NO;
    _buttonExperessCheckout.enabled = NO;
    
    _viewMain.frame = self.view.frame;
    _viewOrderItem.frame = self.view.frame;
    _viewApplyPromitionCode.frame = self.view.frame;
    
    _viewMain.hidden = NO;
    _viewOrderItem.hidden = YES;
    _viewApplyPromitionCode.hidden = YES;
    
}

- (void) setCustomNavBar {
    
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    
    self.navigationItem.title = @"Order Summary";
}

- (void) showLocationInfo {
    
    MenuList * menu = [Utils sharedUtils].menu;
    NSString * url = [urlPrefix stringByAppendingString:[menu.logoLink substringFromIndex:1]];
    [_imageViewLogo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    _labelDeliveryTime.text = [NSString stringWithFormat:@"Delivered at  %@ at %@", [[Utils sharedUtils] convertCurrentTimeZone:menu.dropoffTime], menu.locationName];
    _labelDeliveryInstructions.text = menu.pickupInstruction;
    
    //badge
}

- (void) getOrders {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if (([Utils sharedUtils].promo != nil) && ([Utils sharedUtils].promo.Id == [Utils sharedUtils].orderId)) {
        
        _viewMain.hidden = YES;
        _viewOrderItem.hidden = YES;
        _viewApplyPromitionCode.hidden = NO;

        bFirstApplyCoupon = YES;
        
        [[OrderApi sharedOrderApi] setDelegate:self];
        [[OrderApi sharedOrderApi] applyCouponToOrder:[Utils sharedUtils].orderId couponCode:[Utils sharedUtils].promo.code];
        
    } else {
        
        bFirstGetOrder = YES;
        
        [[OrderApi sharedOrderApi] setDelegate:self];
        [[OrderApi sharedOrderApi] getOrder:[Utils sharedUtils].orderId];
    }
}


#pragma mark - SlideNavigationController Methods

- (BOOL) slideNavigationControllerShouldDisplayLeftMenu {
    
    return NO;
}

- (BOOL) slideNavigationControllerShouldDisplayRightMenu {
    
    return YES;
}


#pragma mark - UITableView Delegate & Datasrouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tableViewComplex)
        return [Utils sharedUtils].order.orderItems.count + 2;
    
    return selectedItem.modifiers.count;
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    return nil;
//}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView == _tableViewComplex)
        return nil;
    
    return selectedItem.itemName;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == _tableViewComplex)
        return 0;
    
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableViewComplex)
        return 44;
    
    return 30;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    if (tableView == _tableViewOrderItem) {
        
        NSString * CellIdentifier = @"ModifiersCell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
        }

        OrderItemModifier * modifier = [selectedItem.modifiers objectAtIndex:indexPath.row];
        
        OrderItemModifierAnswer * answer = [modifier.answers objectAtIndex:0];
        
        NSString * text = answer.itemName;
        
        if (answer.price > 0)
            text = [NSString stringWithFormat:@"%@ $%.2lf", text, answer.price];
        
        NSString * space = @"";
        for (int j = 0 ; j < modifier.depth ; j ++)
            space = [space stringByAppendingString:@"     "];
        
        cell.textLabel.text = [space stringByAppendingString:text];
        
        return cell;
    }
    
    if (indexPath.row == [Utils sharedUtils].order.orderItems.count) {
        //add item
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"OrderSummaryAddCell"];
        UILabel * labelAddItem = (UILabel *)[cell viewWithTag:1];
        labelAddItem.text = @"Add Item";
        
    } else if (indexPath.row == ([Utils sharedUtils].order.orderItems.count + 1)) {
        //apply promotion code
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"OrderSummaryAddCell"];
        UILabel * labelPromotion = (UILabel *)[cell viewWithTag:1];
        labelPromotion.text = @"Apply Promotion Code";
        
    } else {
        
        OrderItem * item = [[Utils sharedUtils].order.orderItems objectAtIndex:indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"OrderSummaryOrderCell"];
        
        UILabel * labelPrice = (UILabel *)[cell viewWithTag:1];
        UILabel * labelItemName = (UILabel *)[cell viewWithTag:2];
        UIButton * buttonRemove = (UIButton *)[cell viewWithTag:3];
        
        buttonRemove.tag = indexPath.row + 1;
        
        if (item.price > 0)
            labelPrice.text = [NSString stringWithFormat:@"$%.2lf", item.price];
        
        labelItemName.text = item.itemName;
        
        [buttonRemove addTarget:self action:@selector(onRemoveOrderItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [Utils sharedUtils].order.orderItems.count) {
    
        //add item
        
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SelectMenuViewController * viewController  = (SelectMenuViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_SelectMenuViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if (indexPath.row == ([Utils sharedUtils].order.orderItems.count + 1)) {
    
        //apply promotion code
        
        [self openPromotionCode];
        
    } else {
        
        selectedItem = [[Utils sharedUtils].order.orderItems objectAtIndex:indexPath.row];
        
        [self openOrderItemDetails];
    }
    
    return;
}


#pragma mark - OrderApiDelegate

- (void)error:(NSDictionary *)errorInfo {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [[Utils sharedUtils] standardError:errorInfo];
}

- (void) didGetOrder:(NSDictionary *)info {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    Order * order = [[OrderApiParser sharedOrderApiParser] didGetOrder:info];
    [self handleOrder:order];
    
    if (bFirstGetOrder == YES)
        [Utils sharedUtils].promo = nil;
    
}

- (void) didApplyCouponToOrder:(NSDictionary *)info {
    
    OrderApplyCoupon * orderApplyCoupon = [[OrderApiParser sharedOrderApiParser] didApplyCouponToOrder:info];
    
    if (bFirstApplyCoupon == YES) {
        
        if (orderApplyCoupon.success == YES) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self handleOrder:orderApplyCoupon.order];
            
        } else {
            
            bFirstGetOrder = NO;
            
            [[OrderApi sharedOrderApi] setDelegate:self];
            [[OrderApi sharedOrderApi] getOrder:[Utils sharedUtils].orderId];
            
            //utils.alert (orderApplyCoupon.message);
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:orderApplyCoupon.message  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [alert show];
        }
        
        [self closePromotionCode];

    } else {

       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if (orderApplyCoupon.success == YES) {
            
            [Utils sharedUtils].promo.Id = orderApplyCoupon.order.orderId;
            [Utils sharedUtils].promo.code = _textFieldCouponCode.text;
            
            _textFieldCouponCode.text = @"";
            
            [self handleOrder:orderApplyCoupon.order];
            
            [self closePromotionCode];
            
        } else {
            
            //utils.alert (orderApplyCoupon.message);
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:orderApplyCoupon.message  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [alert show];
        }
    }
}

- (void) didRemoveOrderItem:(NSDictionary *)info {
    
//    [[OrderApiParser sharedOrderApiParser] didRemoveOrderItem:info];
    
    [Utils sharedUtils].menu.orderItemsCount --;
    
    bFirstGetOrder = NO;

    [[OrderApi sharedOrderApi] setDelegate:self];
    [[OrderApi sharedOrderApi] getOrder:[Utils sharedUtils].orderId];
}


#pragma mark - CheckoutApiDelegate

- (void) didCheckoutFreeMeal:(NSDictionary *) info {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    CheckoutCard * checkout = [[CheckoutApiParser sharedCheckoutApiParser] didCheckoutFreeMeal:info];
    
    if (checkout.success == YES) {
        
        [Utils sharedUtils].orderDetails = checkout.orderDetails;//order
        [Utils sharedUtils].receiptDetails = checkout.receiptDetails;
        
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        ReceiptViewController * viewController  = (ReceiptViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_ReceiptViewController"];
        [self.navigationController pushViewController:viewController animated:YES];

    } else {
        
        //utils.alert (checkout.message);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:checkout.message  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
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
        
    } else {
        
        //utils.alert (checkout.message);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:checkout.message  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }

}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        //onPerformExpress
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[CheckoutApi sharedCheckoutApi] setDelegate:self];
        [[CheckoutApi sharedCheckoutApi] checkoutSavedCard:[Utils sharedUtils].orderId cCProfileId:[Utils sharedUtils].preferredCard isProduction:[Utils sharedUtils].isProduction];
    }
    
    return;
}


#pragma mark - UITextFieldDelegate

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    for (UIView* view in _viewApplyPromitionCode.subviews) {
        
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - UI Action methods

- (IBAction)onBack:(id)sender {
    
    [[Utils sharedUtils] setMenuType:[Utils sharedUtils].selectMenuViewController.navigationController type:2];
    [self.navigationController popToViewController:[Utils sharedUtils].selectMenuViewController animated:YES];
}

- (IBAction)onExpressCheckout:(id)sender {
    
    //onExpress
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Checkout" message:@"Are you sure you want to check out?"  delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Place Order",nil];
    
    [alert show];
}

- (IBAction)onCheckout:(id)sender {
    
    //onCheckout

    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    if ([[Utils sharedUtils] hasMissingInfo] == YES) {
        
        CustomerContactViewController * viewController  = (CustomerContactViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_CustomerContactViewController"];
        viewController.bFree = NO;
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([[Utils sharedUtils] hasSavedCards] == YES) {
        
        CheckoutSavedViewController * viewController  = (CheckoutSavedViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_CheckoutSavedViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        
        CheckoutViewController * viewController  = (CheckoutViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_CheckoutViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

- (IBAction)onFreeCheckout:(id)sender {
    
    //onFreeCheckout
    
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    if ([[Utils sharedUtils] hasMissingInfo] == YES) {
        
        CustomerContactViewController * viewController  = (CustomerContactViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_CustomerContactViewController"];
        viewController.bFree = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[CheckoutApi sharedCheckoutApi] setDelegate:self];
        [[CheckoutApi sharedCheckoutApi] checkoutFreeMeal:[Utils sharedUtils].orderId];
    }
}

- (IBAction)onCloseOrderItem:(id)sender {
    
    [self closeOrderItemDetails];

}

- (void) onRemoveOrderItem:(id)sender {
    
    UIButton * button = (UIButton *) sender;
    
    NSLog(@"%ld", button.tag);
    
    OrderItem * item = [[Utils sharedUtils].order.orderItems objectAtIndex:button.tag];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[OrderApi sharedOrderApi] setDelegate:self];
    [[OrderApi sharedOrderApi] removeOrderItem:[Utils sharedUtils].orderId orderItemId:item.orderItemId];
    
    return;
}

- (IBAction)onClosePromotionCode:(id)sender {
    
    [_textFieldCouponCode resignFirstResponder];

    [self closePromotionCode];
}

- (IBAction)onApplyCode:(id)sender {
    
    //onPromoCode
    
    [_textFieldCouponCode resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    bFirstApplyCoupon = NO;
    
    [[OrderApi sharedOrderApi] applyCouponToOrder:[Utils sharedUtils].orderId couponCode:_textFieldCouponCode.text];
    
}


#pragma mark - View Moving...

- (void) openOrderItemDetails {
    
    _tableViewOrderItem.delegate = self;
    _tableViewOrderItem.dataSource = self;
    [_tableViewOrderItem reloadData];
    
    _viewMain.hidden = NO;
    _viewOrderItem.hidden = NO;
    _viewApplyPromitionCode.hidden = YES;
    
    _viewMain.frame = CGRectMake(_viewMain.frame.origin.x, _viewMain.frame.origin.y, _viewMain.frame.size.width, _viewMain.frame.size.height);
    _viewOrderItem.frame = CGRectMake(_viewOrderItem.frame.size.width, _viewOrderItem.frame.origin.y, _viewOrderItem.frame.size.width, _viewOrderItem.frame.size.height);
    
    [UIView animateWithDuration:AnimationTime
                     animations:^{
                         
                         _viewOrderItem.frame = CGRectMake(0, _viewOrderItem.frame.origin.y, _viewOrderItem.frame.size.width, _viewOrderItem.frame.size.height);
                         _viewMain.frame = CGRectMake(-_viewMain.frame.size.width, _viewMain.frame.origin.y, _viewMain.frame.size.width, _viewMain.frame.size.height);
                         
                     } completion:^(BOOL finished){
                         
                     }];
    
}

- (void) closeOrderItemDetails {
    
    _viewMain.hidden = NO;
    _viewOrderItem.hidden = NO;
    _viewApplyPromitionCode.hidden = YES;
    
    _viewMain.frame = CGRectMake(-_viewMain.frame.size.width, _viewMain.frame.origin.y, _viewMain.frame.size.width, _viewMain.frame.size.height);
    _viewOrderItem.frame = CGRectMake(0, _viewOrderItem.frame.origin.y, _viewOrderItem.frame.size.width, _viewOrderItem.frame.size.height);
    
    [UIView animateWithDuration:AnimationTime
                     animations:^{
                         
                         _viewMain.frame = CGRectMake(0, _viewMain.frame.origin.y, _viewMain.frame.size.width, _viewMain.frame.size.height);
                         
                         _viewOrderItem.frame = CGRectMake(_viewOrderItem.frame.size.width, _viewOrderItem.frame.origin.y, _viewOrderItem.frame.size.width, _viewOrderItem.frame.size.height);
                         
                         
                     } completion:^(BOOL finished){
                         
                     }];
    
}

- (void) openPromotionCode {
    
    _viewMain.hidden = NO;
    _viewOrderItem.hidden = YES;
    _viewApplyPromitionCode.hidden = NO;
    
    _viewMain.frame = CGRectMake(_viewMain.frame.origin.x, _viewMain.frame.origin.y, _viewMain.frame.size.width, _viewMain.frame.size.height);
    _viewApplyPromitionCode.frame = CGRectMake(_viewApplyPromitionCode.frame.size.width, _viewApplyPromitionCode.frame.origin.y, _viewApplyPromitionCode.frame.size.width, _viewApplyPromitionCode.frame.size.height);
    
    [UIView animateWithDuration:AnimationTime
                     animations:^{
                         
                         _viewApplyPromitionCode.frame = CGRectMake(0, _viewApplyPromitionCode.frame.origin.y, _viewApplyPromitionCode.frame.size.width, _viewApplyPromitionCode.frame.size.height);
                         _viewMain.frame = CGRectMake(-_viewMain.frame.size.width, _viewMain.frame.origin.y, _viewMain.frame.size.width, _viewMain.frame.size.height);
                         
                     } completion:^(BOOL finished){
                         
                     }];

}

- (void) closePromotionCode {
    
    _viewMain.hidden = NO;
    _viewOrderItem.hidden = YES;
    _viewApplyPromitionCode.hidden = NO;
    
    _viewMain.frame = CGRectMake(-_viewMain.frame.size.width, _viewMain.frame.origin.y, _viewMain.frame.size.width, _viewMain.frame.size.height);
    _viewApplyPromitionCode.frame = CGRectMake(0, _viewApplyPromitionCode.frame.origin.y, _viewApplyPromitionCode.frame.size.width, _viewApplyPromitionCode.frame.size.height);
    
    [UIView animateWithDuration:AnimationTime
                     animations:^{
                         
                         _viewMain.frame = CGRectMake(0, _viewMain.frame.origin.y, _viewMain.frame.size.width, _viewMain.frame.size.height);
                         
                         _viewApplyPromitionCode.frame = CGRectMake(_viewApplyPromitionCode.frame.size.width, _viewApplyPromitionCode.frame.origin.y, _viewApplyPromitionCode.frame.size.width, _viewApplyPromitionCode.frame.size.height);
                         
                         
                     } completion:^(BOOL finished){
                         
                     }];

}


#pragma mark - General methods...

- (void) handleOrder:(Order * ) order {

    if (order == nil) {
    
        [Utils sharedUtils].order = nil;
        _buttonCheckout.enabled = NO;
        
    } else {
        
        [Utils sharedUtils].order = order;
        
        if (order.orderItems > 0) {
            
            _buttonCheckout.enabled = YES;
            _buttonProcess.enabled = YES;
        } else {
            
            _buttonCheckout.enabled = NO;
            _buttonProcess.enabled = NO;
        }
        
        _labelSubtotalPrice.text = [NSString stringWithFormat:@"$%.2lf", order.itemSubTotal];
        
        if (order.couponSubTotal > 0) {
            
            _labelDiscountPrice.text = [NSString stringWithFormat:@"($%.2lf)", order.couponSubTotal];
            _labelDiscountPrice.hidden = NO;
            _labelDiscount.hidden = NO;
            _labelCodeCaption.text = [NSString stringWithFormat:@"Coupon for $%.2lf off has been applied.", order.couponSubTotal];
            
            
        } else {
            
            _labelDiscountPrice.text = @"($0.00)";
            _labelDiscountPrice.hidden = YES;
            _labelDiscount.hidden = YES;
            _labelCodeCaption.text = @"";
        }
        
       _labelDeliveryPrice.text = [NSString stringWithFormat:@"$%.2lf", order.foodsbyFee];
       _labelTaxPrice.text = [NSString stringWithFormat:@"$%.2lf", order.taxSubTotal];
       _labelTotalPrice.text = [NSString stringWithFormat:@"$%.2lf", order.orderTotal];
        
        if ((order.orderItems.count > 0) && (order.orderTotal == 0.0)) {
            
            _buttonCheckout.hidden = YES;
            _buttonExperessCheckout.hidden = YES;
            _buttonProcess.hidden = NO;
            
        } else {

            _buttonCheckout.hidden = NO;
            _buttonExperessCheckout.hidden = NO;
            _buttonProcess.hidden = YES;
        }
        
        
        if ((_buttonCheckout.enabled == YES) && ([[Utils sharedUtils] hasMissingInfo] == NO) && ([[Utils sharedUtils] hasSavedCards] == YES))
            _buttonExperessCheckout.enabled = YES;
        else
            _buttonExperessCheckout.enabled = NO;
        
        _tableViewComplex.delegate = self;
        _tableViewComplex.dataSource = self;
        [_tableViewComplex reloadData];
    }
}

@end
