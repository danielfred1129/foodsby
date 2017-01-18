//
//  ReceiptViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "ReceiptViewController.h"
#import "Utils.h"
#import "SDwebImage/UIImageView+WebCache.h"
#import "CheckoutReceiptDetails.h"
#import "OrderItem.h"

@interface ReceiptViewController () {
    
    NSArray * arrayOrderItems;
}

@end

@implementation ReceiptViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setCustomNavBar];
    [self showLocationInfo];
    [self showPrices];

    arrayOrderItems = [Utils sharedUtils].order.orderItems;
    
    _tableViewOrderSummary.delegate = self;
    _tableViewOrderSummary.dataSource = self;
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

- (void) showPrices {
    
    Order * order = [Utils sharedUtils].order;
    
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

- (void) showLocationInfo {
    
    CheckoutReceiptDetails * receipt = [Utils sharedUtils].receiptDetails;
    MenuList * menu = [Utils sharedUtils].menu;
    
    NSString * url = [urlPrefix stringByAppendingString:[menu.logoLink substringFromIndex:1]];
    [_imageViewLogo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    _labelDeliveryInfo.text = [NSString stringWithFormat:@"Delivered at  %@ at %@", [[Utils sharedUtils] convertCurrentTimeZone:menu.dropoffTime], receipt.locationName];
    _labelDeliveryInstructions.text = receipt.pickupInstruction;
}

- (void) setCustomNavBar {
    
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WhiteHomeIcon"] style:UIBarButtonItemStyleBordered target:self action:@selector(onHome:)];
    
    self.navigationItem.title = @"Order Summary";
}


#pragma mark - SlideNavigationController Methods

- (BOOL) slideNavigationControllerShouldDisplayLeftMenu {
    
    return NO;
}

- (BOOL) slideNavigationControllerShouldDisplayRightMenu {
    
    return YES;
}


#pragma mark - UI Action methods

- (IBAction)onHome:(id)sender {
    
    [[Utils sharedUtils] setMenuType:[Utils sharedUtils].dashboardViewController.navigationController type:1];
    [self.navigationController popToViewController:[Utils sharedUtils].dashboardViewController animated:YES];
}


#pragma mark - UITableView Delegate & Datasrouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrayOrderItems.count;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    OrderItem * item = [arrayOrderItems objectAtIndex:indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"OrderSummaryOrderCell"];
    
    UILabel * labelPrice = (UILabel *)[cell viewWithTag:1];
    UILabel * labelItemName = (UILabel *)[cell viewWithTag:2];
    UILabel * labelSpecialInstruction = (UILabel *)[cell viewWithTag:3];
    
    if (item.price > 0)
        labelPrice.text = [NSString stringWithFormat:@"$%.2lf", item.price];
    
    labelItemName.text = item.itemName;

    labelSpecialInstruction.text = item.specialInstructions;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
