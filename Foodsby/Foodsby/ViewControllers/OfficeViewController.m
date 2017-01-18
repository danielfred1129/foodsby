//
//  OfficeViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/13/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OfficeViewController.h"
#import "Utils.h"
#import "OfficeTableViewCell.h"
#import "AddCompanyViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "UserApiParser.h"
#import "OfficeApiParser.h"
#import "LocationApiParser.h"
#import "BuildLocationTabBarController.h"
#import "DashboardViewController.h"

@interface OfficeViewController ()

@end

//OfficeName
//DeliveryLine1, LastLine

@implementation OfficeViewController

@synthesize bShowBackButton;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setCustomNavBar];
    
    arrayFilteredOffices = [NSMutableArray arrayWithCapacity:[Utils sharedUtils].arrayAllOffices.count];
    
    _buttonAddYourOffice.layer.cornerRadius = 5;
    _buttonAddYourOffice.clipsToBounds = YES;

    self.searchBarOffice.delegate = self;
    self.tableViewOffices.delegate = self;
    self.tableViewOffices.dataSource = self;
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    
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
    
    NSDictionary * navBarTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    if (bShowBackButton == NO)
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    else
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];

    self.navigationItem.title = @"Select Office";
}


#pragma mark - Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {

    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [arrayFilteredOffices removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.officeName contains[c] %@",searchText];
    
    arrayFilteredOffices = [NSMutableArray arrayWithArray:[[Utils sharedUtils].arrayAllOffices filteredArrayUsingPredicate:predicate]];
}


#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {

    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope: [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark - UITableView Delegate & Datasrouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return [arrayFilteredOffices count];
    }

    return [Utils sharedUtils].arrayAllOffices.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellIndentifier = @"OfficeTableViewCell";
    
    OfficeTableViewCell * cell = [self.tableViewOffices dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil)
        cell = [[OfficeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {

        office = [arrayFilteredOffices objectAtIndex:indexPath.row];
    } else {
        
        office = [[Utils sharedUtils].arrayAllOffices objectAtIndex:indexPath.row];
    }

    cell.labelOfficeName.text = office.officeName;
    cell.labelDeliveryLine.text = [office.deliveryLine1 stringByAppendingFormat:@" %@", office.lastLine];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        office = [arrayFilteredOffices objectAtIndex:indexPath.row];
    } else {
        
        office = [[Utils sharedUtils].arrayAllOffices objectAtIndex:indexPath.row];
    }
    
    if (([[Utils sharedUtils] user].officeId == -1) || ([[Utils sharedUtils] user].deliveryLocationId == -1)) {
        
        User * user = [[User alloc] init];
        user.firstName = [Utils sharedUtils].user.firstName;
        user.lastName = [Utils sharedUtils].user.lastName;
        user.phone = [Utils sharedUtils].user.phone;
        user.smsNotify = [Utils sharedUtils].user.smsNotify;
        user.birthday = [Utils sharedUtils].user.birthday;
        user.deliveryLocationId = office.deliveryLocationId;
        user.officeId = office.officeId;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[UserApi sharedUserApi] setDelegate:self];
        [[UserApi sharedUserApi] updateUser:user];
    
    } else {
        
        if (office.deliveryLocationId ==  -1) {
            
            [Utils sharedUtils].officeId = office.officeId;
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [[OfficeApi sharedOfficeApi] setDelegate:self];
            [[OfficeApi sharedOfficeApi] getOffice:office.officeId];
            
            
        } else {
            
            [Utils sharedUtils].deliveryLocationId = office.deliveryLocationId;
            [Utils sharedUtils].officeId = office.officeId;
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [[LocationApi sharedLocationApi] setDelegate:self];
            [[LocationApi sharedLocationApi] getLocationSchedule:office.deliveryLocationId];
        }
    }

    return;
}

#pragma mark - UI Action methods

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddYourOffice:(id)sender {
    
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    AddCompanyViewController * viewController  = (AddCompanyViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_AddCompanyViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UserApiDelegate methods

- (void) error:(NSDictionary *)errorInfo {
 
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSString * errorDescription = [errorInfo objectForKey:@"NSLocalizedDescription"];
    
    if ([errorDescription rangeOfString:@"404"].location != NSNotFound) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"The delivery location for this office is not activate." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
    } else if ([errorDescription rangeOfString:@"canceled"].location != NSNotFound) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"An internet connection is required to proceed. Please try again when a connection is present." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Unable to load office information. Please select a different office." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
    }

}

- (void) didUpdateUser:(NSDictionary *)info {
    
    [[UserApiParser sharedUserApiParser] didUpdateUser:info];
    
    if (office.deliveryLocationId ==  -1) {
        
        [Utils sharedUtils].officeId = office.officeId;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[OfficeApi sharedOfficeApi] setDelegate:self];
        [[OfficeApi sharedOfficeApi] getOffice:office.officeId];
        
        
    } else {
        
        [Utils sharedUtils].deliveryLocationId = office.deliveryLocationId;
        [Utils sharedUtils].officeId = office.officeId;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[LocationApi sharedLocationApi] setDelegate:self];
        [[LocationApi sharedLocationApi] getLocationSchedule:office.deliveryLocationId];
    }
}

- (void) didGetOffice:(NSDictionary *)info {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [Utils sharedUtils].office = [[OfficeApiParser sharedOfficeApiParser] didGetOffice:info];
    
    [[Utils sharedUtils] clearNotifications];
    
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BuildLocationTabBarController * viewController  = (BuildLocationTabBarController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_BuildLocationTabBarController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) didGetLocationSchedule:(NSDictionary *)info {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [[LocationApiParser sharedLocationApiParser] didGetLocationSchedule:info];
    
    if ([Utils sharedUtils].deliveryLocationSchedule.deliveryDaysThisWeek.count > 0)
        [[Utils sharedUtils] setupNotifications:[Utils sharedUtils].deliveryLocationSchedule];
    else
        [[Utils sharedUtils] clearNotifications];
    
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    DashboardViewController * viewController  = (DashboardViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_DashboardViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];

}

@end
