//
//  DashboardViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/12/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "DashboardViewController.h"
#import "Utils.h"
#import "NavTitleView.h"
#import "DeliveryLocation.h"
#import "DeliveryDaysThisWeek.h"
#import "DeliveryTimes.h"
#import "MBProgressHUD.h"

#import "OrderApiParser.h"
#import "MenuApiParser.h"

#import "SelectMenuViewController.h"
#import "SDwebImage/UIImageView+WebCache.h"


@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [[Utils sharedUtils] setMenuType:self.navigationController type:1];
    
    [Utils sharedUtils].dashboardViewController = self;

    arrayStores = nil;
    nSelectedDay = 0;
    
    [self setCustomNavBar];
    
    self.tableViewDeliveryTime.delegate = self;
    self.tableViewDeliveryTime.dataSource = self;
    
    [self initWeekButtons:[self getWeekFromDeliveryDate]];
    
    
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

#pragma mark - Init

- (void) initWeekButtons:(NSArray *) arrayWeek {
    
    arrayWeekButtons = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < 7 ; i ++) {
        
        UIButton * button = (UIButton *)[self.viewWeekButtons viewWithTag:i + 1];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        
        [button addTarget:self action:@selector(onSelectDay:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor colorWithRed:240.0 / 255.0 green:240.0 / 255.0 blue:240.0 / 255.0 alpha:1.0]];
        [button setTitleColor:TextColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [button setTitle:[arrayWeek objectAtIndex:i] forState:UIControlStateNormal];

        [arrayWeekButtons addObject:button];
    }
    
    buttonPrevSelect = [arrayWeekButtons objectAtIndex:0];
    
    [self onSelectDay:buttonPrevSelect];
}

- (void) setCustomNavBar {
    
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    self.navigationItem.hidesBackButton = YES;
    
    //title
    NSInteger locationId = [Utils sharedUtils].deliveryLocationId;
    
    if (locationId == -1) {
        
        locationId = [Utils sharedUtils].user.deliveryLocationId;
        [Utils sharedUtils].deliveryLocationId = locationId;
    }
    
    DeliveryLocation * location;
    
    for (int i = 0 ; i < [Utils sharedUtils].arrayDeliveryLocations.count ; i ++) {
        
        location =[[Utils sharedUtils].arrayDeliveryLocations objectAtIndex:i];
        
        if (locationId == location.deliveryLocationId) {
            
            NavTitleView * viewTitle = [[NavTitleView alloc] initWithFrame:self.navigationItem.titleView.frame nibName:@"NavTitleView"];
            
            viewTitle.labelTitle.text = location.locationName;
            viewTitle.labelSubTitle.text = [NSString stringWithFormat:@"%@, %@", location.deliveryLine1, location.lastLine];
            
            self.navigationItem.titleView = viewTitle;
            break;
        }
    }
}

- (NSArray *) getWeekFromDeliveryDate {
    
    DeliveryLocationSchedule * schedule = [Utils sharedUtils].deliveryLocationSchedule;
    NSArray * arrayDays = schedule.deliveryDaysThisWeek;
    
    NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
    
    NSMutableArray * arrayWeek = [[NSMutableArray alloc] init];
    arrayDayOfWeek = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < arrayDays.count ; i ++) {
        
        DeliveryDaysThisWeek * deliveryDay = [arrayDays objectAtIndex:i];
        
        [dateFormate setDateFormat:@"YYYY-MM-dd"];
        
        NSString * today = [dateFormate stringFromDate:[NSDate date]];
        
        NSString * day = [deliveryDay.dateOfDayForWeek substringToIndex:10];
        
        if ([day isEqualToString:today] == YES)
            [arrayWeek addObject:@"Today"];
        
        else {
            
            NSDate * date = [dateFormate dateFromString:day];
            [dateFormate setDateFormat:@"EEE"];
            [arrayWeek addObject:[dateFormate stringFromDate:date]];
        }
        
        [arrayDayOfWeek addObject:[NSNumber numberWithInteger:deliveryDay.dayOfWeek]];
    }
    
    return arrayWeek;
}

#pragma mark - SlideNavigationController Methods -

- (BOOL) slideNavigationControllerShouldDisplayLeftMenu{
    
    return NO;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
    
    return YES;
}

#pragma mark - UITableView Delegate & Datasrouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (arrayStores != nil)
        return arrayStores.count;
    
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    StoreForLocation * store = [arrayStores objectAtIndex:indexPath.row];
    DeliveryTimes * deliveryTime = [store.deliveryTimes objectAtIndex:0];
    
    NSDate * currentTime = [NSDate date];
    NSDate * cutOffTime = [self getDate:store.cutOffDateTime];
    
    UITableViewCell * cell;
    
    if ([currentTime compare:cutOffTime] == NSOrderedAscending)
        cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryCell"];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:@"BummerCell"];
    
    UIImageView * imageViewMark = (UIImageView *) [cell viewWithTag:1];
    UILabel * labelDeliveryTime = (UILabel *)[cell viewWithTag:2];
    UILabel * labelOrderTime = (UILabel *)[cell viewWithTag:3];

    if ([currentTime compare:cutOffTime] == NSOrderedAscending) {

        labelDeliveryTime.text = [[Utils sharedUtils] convertCurrentTimeZone:deliveryTime.dropoffDateTime];
        labelOrderTime.text = [[Utils sharedUtils] convertCurrentTimeZone:store.cutOffDateTime];
    } else {
        
        labelDeliveryTime.text = @"Bummer! You're late.";
        labelOrderTime.text = [@"Orders need to be placed by " stringByAppendingString:[[Utils sharedUtils] convertCurrentTimeZone:store.cutOffDateTime]];
    }
    
    NSString * url = [urlPrefix stringByAppendingString:[store.logoLink substringFromIndex:1]];
    [imageViewMark sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    selectedStore = [arrayStores objectAtIndex:indexPath.row];
    DeliveryTimes * deliveryTime = [selectedStore.deliveryTimes objectAtIndex:0];

    [Utils sharedUtils].identifiers.deliveryTimeId = deliveryTime.deliveryTimeId;
    [Utils sharedUtils].identifiers.deliveryLocationId = deliveryTime.deliveryLocationId;
    [Utils sharedUtils].identifiers.storeId = selectedStore.storeId;
    [Utils sharedUtils].identifiers.deliveryId = deliveryTime.deliveryId;
    [Utils sharedUtils].identifiers.dayOfWeek = nSelectedDay;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[OrderApi sharedOrderApi] setDelegate:self];
    [[OrderApi sharedOrderApi] getOrderHistory:selectedStore.storeId];
    
    return;
}

- (NSDate *) getDate:(NSString *)time {
    
    NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZ"];
    NSDate * date = [dateFormate dateFromString:time];
    
    return date;
}

#pragma mark - UI Actions

- (void) onSelectDay:(UIButton *)sender {
    
    [buttonPrevSelect setBackgroundColor:[UIColor lightGrayColor]];
    [buttonPrevSelect setBackgroundColor:[UIColor colorWithRed:240.0 / 255.0 green:240.0 / 255.0 blue:240.0 / 255.0 alpha:1.0]];
    [buttonPrevSelect setTitleColor:TextColor forState:UIControlStateNormal];

    [sender setBackgroundColor: MainBackgroundColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    buttonPrevSelect = sender;
    nSelectedDay = [[arrayDayOfWeek objectAtIndex: sender.tag - 1] integerValue];
    
    DeliveryLocationSchedule * schedule = [Utils sharedUtils].deliveryLocationSchedule;
    NSArray * arrayDays = schedule.deliveryDaysThisWeek;
    
    DeliveryDaysThisWeek * deliveryDay = nil;
    
    for (int i = 0 ; i < arrayDays.count ; i ++) {
        
        deliveryDay = [arrayDays objectAtIndex:i];
        
        if (deliveryDay.dayOfWeek == nSelectedDay)
            break;
        else
            deliveryDay = nil;
    }
    
    if ( deliveryDay != nil)
        arrayStores = deliveryDay.stores;
    else
        arrayStores = nil;
    
    [_tableViewDeliveryTime reloadData];
}


#pragma mark - OrderApiDelegate

- (void) didGetOrderHistory:(NSArray *)info {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [[OrderApiParser sharedOrderApiParser] didGetOrderHistory:info];
    
    [[MenuApi sharedMenuApi] setDelegate:self];
    [[MenuApi sharedMenuApi] getMenu:[Utils sharedUtils].identifiers];
}


#pragma mark - MenuApiDelegate

- (void) error:(NSDictionary *)errorInfo {
    
    NSString * errorDescription = [errorInfo objectForKey:@"NSLocalizedDescription"];
    
    if ([errorDescription rangeOfString:@"404"].location != NSNotFound) {
        
        [[Utils sharedUtils].arrayReorder removeAllObjects];
        
        [[MenuApi sharedMenuApi] setDelegate:self];
        [[MenuApi sharedMenuApi] getMenu:[Utils sharedUtils].identifiers];
        
        return;
        
    } else if ([errorDescription rangeOfString:@"canceled"].location != NSNotFound) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"An internet connection is required to proceed. Please try again when a connection is present." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Sorry, this restaurant's menu could not be loaded." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    return;
}

- (void) didGetMenu:(NSDictionary *)info {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [Utils sharedUtils].menu = [[MenuApiParser sharedMenuApiParser] didGetMenu:info];
    
    if ( [Utils sharedUtils].menu == nil ) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Sorry, this restaurant's menu could not be loaded." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
        return;

    } else if ( [Utils sharedUtils].menu.soldOut == YES) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Sorry, this restaurant has reached the maximum level of orders it can accept for this delivery." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
        return;
        
    } else {
        
        DeliveryTimes * deliveryTime = [selectedStore.deliveryTimes objectAtIndex:0];

        [Utils sharedUtils].menu.cutOffTime = selectedStore.cutOffDateTime;
        [Utils sharedUtils].menu.dropoffTime = deliveryTime.dropoffDateTime;
        [Utils sharedUtils].arraySubMenus = [Utils sharedUtils].menu.subMenus;
        [Utils sharedUtils].orderId = [Utils sharedUtils].menu.orderId;
     
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SelectMenuViewController * viewController  = (SelectMenuViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_SelectMenuViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }        
}

@end
