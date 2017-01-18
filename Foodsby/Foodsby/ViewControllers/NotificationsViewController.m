//
//  NotificationsViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "NotificationsViewController.h"
#import "Utils.h"
#import "StoreForLocation.h"

@interface NotificationsViewController () {
    
    ComboBox *          comboBoxTime;
    NSArray *           arrayTimeName;
    NSArray *           arrayStores;
}

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setCustomNavBar];
    [self initDropDownList];
    
    arrayStores = [Utils sharedUtils].deliveryLocationSchedule.storesForLocation;
    
    _tableViewNotifications.delegate = self;
    _tableViewNotifications.dataSource = self;
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
    
    self.navigationItem.title = @"Notifications";
}


- (void) initDropDownList {

    arrayTimeName = @[@"30 minutes", @"45 minutes", @"1 hour", @"2 hours"];
    
    _textFieldTime.hidden = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = _textFieldTime.frame;
    rect.origin.x = screenRect.size.width - rect.size.width - 20;
    
    comboBoxTime = [[ComboBox alloc]initWithFrame:rect];
    comboBoxTime.delegate = self;
    [comboBoxTime setComboBoxSize:CGSizeMake(_textFieldTime.frame.size.width, _textFieldTime.frame.size.height * 4)];
    [self.view addSubview:comboBoxTime];
    [comboBoxTime setComboBoxDataArray:arrayTimeName];
    
    NSInteger notificationTime =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationTime"] integerValue];

    int index = 0;
    
    if (notificationTime == 0) {
        
        notificationTime = 30;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:notificationTime] forKey:@"NotificationTime"];
    }
    
    switch (notificationTime) {
            
        case 30:
            
            index = 0;
            break;
            
        case 45:
            
            index = 1;
            break;
            
        case 60:
            
            index = 2;
            break;
            
        case 120:
            
            index = 3;
            break;
            
        default:
            break;
    }
    
    [comboBoxTime setComboBoxTitle:[arrayTimeName objectAtIndex:index]];
}


#pragma mark - ComBoxDelegate

-(void)comboBox:(ComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger time = 0;
    
    switch (indexPath.row) {

        case 0:
            time = 30;
            break;
            
        case 1:
            time = 45;
            break;
            
        case 2:
            time = 60;
            break;
            
        case 3:
            time = 120;
            break;
            
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:time] forKey:@"NotificationTime"];
    
    [[Utils sharedUtils] setupNotifications:[Utils sharedUtils].deliveryLocationSchedule];

}


#pragma mark - UITableView Delegate & Datasrouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrayStores.count;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"NotificationCell";
    
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    StoreForLocation * storeLocation = [arrayStores objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = storeLocation.store.restaurantName;

    BOOL bState =  [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"LocalNotification%ld", storeLocation.storeId]] boolValue];

    if (bState == NO)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    StoreForLocation * storeLocation = [arrayStores objectAtIndex:indexPath.row];

    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];

    BOOL bState =  [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"LocalNotification%ld", storeLocation.storeId]] boolValue];
    
    if (bState == YES) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"LocalNotification%ld", storeLocation.storeId]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {

        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"LocalNotification%ld", storeLocation.storeId]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    [[Utils sharedUtils] setupNotifications:[Utils sharedUtils].deliveryLocationSchedule];
    
    return;
}


#pragma mark - UI Actions

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
