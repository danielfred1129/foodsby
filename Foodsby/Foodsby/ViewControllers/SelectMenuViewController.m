//
//  SelectMenuViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/24/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "SelectMenuViewController.h"
#import "Utils.h"
#import "SelectItemViewController.h"
#import "SDwebImage/UIImageView+WebCache.h"


@interface SelectMenuViewController ()

@end

@implementation SelectMenuViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setCustomNavBar];
    [self showLocationInfo];
    
    _tableViewMenu.delegate = self;
    _tableViewMenu.dataSource = self;
    
    [Utils sharedUtils].selectMenuViewController = self;
    
    [[Utils sharedUtils] setMenuType:self.navigationController type:2];
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
    
    self.navigationItem.title = @"Select Menu";
}

- (void) showLocationInfo {
    
    MenuList * menu = [Utils sharedUtils].menu;
    NSString * url = [urlPrefix stringByAppendingString:[menu.logoLink substringFromIndex:1]];
    [_imageViewLogo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    _labelDeliveryTime.text = [NSString stringWithFormat:@"Delivered at  %@ at %@", [[Utils sharedUtils] convertCurrentTimeZone:menu.dropoffTime], menu.locationName];
    _labelDeliveryInstructions.text = menu.pickupInstruction;

    //badge
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
    
    return [Utils sharedUtils].arraySubMenus.count;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubMenu * subMenu = [[Utils sharedUtils].arraySubMenus objectAtIndex:indexPath.row];

    if (subMenu.subMenuDescription != nil)
        return 64;

    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubMenu * subMenu = [[Utils sharedUtils].arraySubMenus objectAtIndex:indexPath.row];
    
    UITableViewCell * cell;
    
    if (subMenu.subMenuDescription != nil) {
     
        cell = [tableView dequeueReusableCellWithIdentifier:@"SelectMenuFullCell"];
        
        UILabel * labelSubMenuName = (UILabel *)[cell viewWithTag:1];
        UILabel * labelDescription = (UILabel *)[cell viewWithTag:2];
        
        labelSubMenuName.text = subMenu.subMenuName;
        labelDescription.text = subMenu.subMenuDescription;
        
    } else {

        cell = [tableView dequeueReusableCellWithIdentifier:@"SelectMenuSimpleCell"];
        
        UILabel * labelSubMenuName = (UILabel *)[cell viewWithTag:1];
        
        labelSubMenuName.text = subMenu.subMenuName;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SubMenu * subMenu = [[Utils sharedUtils].arraySubMenus objectAtIndex:indexPath.row];
    [Utils sharedUtils].subMenu = subMenu;
    [Utils sharedUtils].arrayItems = subMenu.menuItems;
    
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SelectItemViewController * viewController  = (SelectItemViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_SelectItemViewController"];
    [self.navigationController pushViewController:viewController animated:YES];

    return;
}


#pragma mark - UI Action methods

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popToViewController:[Utils sharedUtils].dashboardViewController animated:YES];
}

@end
