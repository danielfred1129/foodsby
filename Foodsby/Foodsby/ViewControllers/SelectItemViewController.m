//
//  SelectItemViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/24/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "SelectItemViewController.h"
#import "Utils.h"
#import "SDwebImage/UIImageView+WebCache.h"
#import "CustomizeViewController.h"
#import "MenuApiParser.h"
#import "MBProgressHUD.h"

@interface SelectItemViewController ()

@end

@implementation SelectItemViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setCustomNavBar];
    [self showMenuInfo];

    _tableViewSubMenu.delegate = self;
    _tableViewSubMenu.dataSource = self;
    
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
    
    self.navigationItem.title = @"Select Item";
}

- (void) showMenuInfo {
    
    MenuList * menu = [Utils sharedUtils].menu;
    NSString * url = [urlPrefix stringByAppendingString:[menu.logoLink substringFromIndex:1]];
    [_imageViewLogo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    if ([Utils sharedUtils].subMenu.subMenuDescription != nil) {
        
        _labelSubMenuName.text = [Utils sharedUtils].subMenu.subMenuName;
        _labelSubMenuText.text = [Utils sharedUtils].subMenu.subMenuDescription;
    } else {
        
        _labelSubMenuNameOne.hidden = NO;
        _labelSubMenuName.hidden = YES;
        _labelSubMenuText.hidden = YES;
        
        _labelSubMenuNameOne.text = [Utils sharedUtils].subMenu.subMenuName;
    }

    //badge
}


#pragma mark - SlideNavigationController Methods -

- (BOOL) slideNavigationControllerShouldDisplayLeftMenu {
    
    return NO;
}

- (BOOL) slideNavigationControllerShouldDisplayRightMenu {
    
    return YES;
}


#pragma mark - UITableView Delegate & Datasrouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [Utils sharedUtils].arrayItems.count;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuItem * item = [[Utils sharedUtils].arrayItems objectAtIndex:indexPath.row];
    
    if (item.menuItemDescription != nil)
        return 74;

    return 64;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuItem * item = [[Utils sharedUtils].arrayItems objectAtIndex:indexPath.row];
    
    UITableViewCell * cell;
    
    if (item.menuItemDescription != nil) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"SelectItemFullCell"];
        
        UILabel * labelPrice = (UILabel *)[cell viewWithTag:1];
        UILabel * labelDisplayText = (UILabel *)[cell viewWithTag:2];
        UILabel * labelDescription = (UILabel *)[cell viewWithTag:3];
        
        labelPrice.text = [NSString stringWithFormat:@"$ %.2lf", item.price];
        labelDisplayText.text = item.displayText;
        labelDescription.text = item.menuItemDescription;
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"SelectItemSimpleCell"];

        UILabel * labelPrice = (UILabel *)[cell viewWithTag:1];
        UILabel * labelDisplayText = (UILabel *)[cell viewWithTag:2];
        
        labelPrice.text = [NSString stringWithFormat:@"$ %.2lf", item.price];
        labelDisplayText.text = item.displayText;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MenuItem * item = [[Utils sharedUtils].arrayItems objectAtIndex:indexPath.row];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [Utils sharedUtils].menuItemId = item.menuItemId;

    [[MenuApi sharedMenuApi] setDelegate:self];
    [[MenuApi sharedMenuApi] getMenuItem:item.menuItemId];
    
    return;
}

#pragma mark - MenuApiDelegate methods

- (void) error:(NSDictionary *)errorInfo {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [Utils sharedUtils].menuItemId = -1;
    
    [[Utils sharedUtils] standardError:errorInfo];

}

- (void) didGetMenuItem:(NSDictionary *)info {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [Utils sharedUtils].qa = [[MenuApiParser sharedMenuApiParser] didGetMenuItem:info];
    
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CustomizeViewController * viewController  = (CustomizeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_CustomizeViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UI Action methods

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
