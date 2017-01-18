//
//  MenuViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/12/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "MenuViewController.h"
#import "Utils.h"
#import "OfficeViewController.h"
#import "DashboardViewController.h"
#import "OrderSummaryViewController.h"
#import "UserProfileViewController.h"
#import "NotificationsViewController.h"

@interface MenuViewController ()


@end

@implementation MenuViewController

@synthesize nMenuType;
@synthesize menuNavigationController;
@synthesize tableViewMenu;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableViewMenu.delegate = self;
    self.tableViewMenu.dataSource = self;
    
    self.tableViewMenu.separatorColor = [UIColor lightGrayColor];
    
    self.view.layer.borderWidth = .6;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;

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

#pragma mark - UITableView Delegate & Datasrouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (nMenuType == 1)
        return 5;
    else if (nMenuType == 2)
        return 6;
    
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.tableViewMenu.frame.size.width, 40)];
//    
//    label.text = @"More Options";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor clearColor];
//    
//    return label;
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    UIImageView * imageViewMark = (UIImageView *) [cell viewWithTag:1];
    UILabel * labelTitle = (UILabel *)[cell viewWithTag:2];

    if (nMenuType == 1) {
    
        switch (indexPath.row) {
                
            case 0:
                
                labelTitle.text = @"Home";
                imageViewMark.image = [UIImage imageNamed:@"HomeIcon.png"];
                
                break;
                
            case 1:

                labelTitle.text = @"User Profile";
                imageViewMark.image = [UIImage imageNamed:@"ProfileIcon.png"];

                break;
                
            case 2:
                
                labelTitle.text = @"Notifications";
                imageViewMark.image = [UIImage imageNamed:@"NotificationIcon.png"];

                break;
                
            case 3:
                
                labelTitle.text = @"Change Office";
                imageViewMark.image = [UIImage imageNamed:@"ChangeLocationIcon.png"];

                break;

            case 4:
                
                labelTitle.text = @"Logout";
                imageViewMark.image = [UIImage imageNamed:@"LogOutIcon.png"];

                break;
        }
        
    } else if (nMenuType == 2) {
        
        switch (indexPath.row) {
                
            case 0:
                
                labelTitle.text = @"Home";
                imageViewMark.image = [UIImage imageNamed:@"HomeIcon.png"];
                
                break;
                
            case 1:
                
                labelTitle.text = @"Order Summary";
                imageViewMark.image = [UIImage imageNamed:@"CartIcon.png"];
                
                break;

            case 2:
                
                labelTitle.text = @"User Profile";
                imageViewMark.image = [UIImage imageNamed:@"ProfileIcon.png"];
                
                break;
                
            case 3:
                
                labelTitle.text = @"Notifications";
                imageViewMark.image = [UIImage imageNamed:@"NotificationIcon.png"];
                
                break;
                
            case 4:
                
                labelTitle.text = @"Change Office";
                imageViewMark.image = [UIImage imageNamed:@"ChangeLocationIcon.png"];
                
                break;
                
            case 5:
                
                labelTitle.text = @"Logout";
                imageViewMark.image = [UIImage imageNamed:@"LogOutIcon.png"];
                
                break;
        }
        
    } else if (nMenuType == 3) {
        
        switch (indexPath.row) {
                
            case 0:
                
                labelTitle.text = @"User Profile";
                imageViewMark.image = [UIImage imageNamed:@"ProfileIcon.png"];
                
                break;
                
            case 1:
                
                labelTitle.text = @"Change Office";
                imageViewMark.image = [UIImage imageNamed:@"ChangeLocationIcon.png"];
                
                break;
                
            case 2:
                
                labelTitle.text = @"Logout";
                imageViewMark.image = [UIImage imageNamed:@"LogOutIcon.png"];
                
                break;
        }

    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    if (nMenuType == 1) {
        
        switch (indexPath.row) {
                
            case 0:
            {
                //Home;
                
                DashboardViewController * viewController  = (DashboardViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_DashboardViewController"];
                
                [menuNavigationController pushViewController:viewController animated:YES];
                
                break;
            }
                
            case 1: {
                
                //User Profile
                
                UserProfileViewController * viewController  = (UserProfileViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_UserProfileViewController"];
                
                [menuNavigationController pushViewController:viewController animated:YES];

                break;
            }
                
            case 2:
            {
                //Notifications

                NotificationsViewController * viewController  = (NotificationsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_NotificationsViewController"];
                
                [menuNavigationController pushViewController:viewController animated:YES];
   
                break;
            }
                
            case 3:
            {
                
                //Change Office
                OfficeViewController * viewController  = (OfficeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_OfficeViewController"];
                
                viewController.bShowBackButton = YES;
                
                [menuNavigationController pushViewController:viewController animated:NO];
                
                
                break;
            }
                
            case 4:
            {
                //Logout

                [menuNavigationController popToRootViewControllerAnimated:YES];
                
                [[Utils sharedUtils] resetUtils];
                [[Utils sharedUtils] clearNotifications];

                return;

            }
                break;
        }

    }else if (nMenuType == 2) {
        
        switch (indexPath.row) {
                
            case 0:
            {
                //Home;
                
                UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                
                DashboardViewController * viewController  = (DashboardViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_DashboardViewController"];
                
                [menuNavigationController pushViewController:viewController animated:YES];
                
                break;
            }
            case 1:
            {
                
                //Order Summary
                
                UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                OrderSummaryViewController * viewController  = (OrderSummaryViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_OrderSummaryViewController"];
                [menuNavigationController pushViewController:viewController animated:YES];

                
                break;
            }

            case 2:
            {
                //User Profile
                
                UserProfileViewController * viewController  = (UserProfileViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_UserProfileViewController"];
                
                [menuNavigationController pushViewController:viewController animated:YES];

                break;
            }
                
            case 3:
            {
                //Notifications
                
                NotificationsViewController * viewController  = (NotificationsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_NotificationsViewController"];
                
                [menuNavigationController pushViewController:viewController animated:YES];

                break;
            }
                
            case 4:
            {
                
                //Change Office
                OfficeViewController * viewController  = (OfficeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_OfficeViewController"];
                
                viewController.bShowBackButton = YES;
                
                [menuNavigationController pushViewController:viewController animated:NO];
                
                
                break;
            }
                
            case 5:
            {
                //Logout
                
                [menuNavigationController popToRootViewControllerAnimated:YES];
                
                [[Utils sharedUtils] resetUtils];
                [[Utils sharedUtils] clearNotifications];
                
                return;
                
            }
                break;
        }
        
    } else if (nMenuType == 3) {
        
        switch (indexPath.row) {
                
            case 0:
            {
                
                //User Profile

                UserProfileViewController * viewController  = (UserProfileViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_UserProfileViewController"];
                
                [menuNavigationController pushViewController:viewController animated:YES];
   
                break;
            }
                
            case 1:
            {
                //Change Office
                OfficeViewController * viewController  = (OfficeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_OfficeViewController"];
                
                viewController.bShowBackButton = YES;
                
                [menuNavigationController pushViewController:viewController animated:NO];

                break;
            }
                
            case 2:
            {
                //Logout

                [menuNavigationController popToRootViewControllerAnimated:YES];
                
                [[Utils sharedUtils] resetUtils];
                [[Utils sharedUtils] clearNotifications];
                
                break;
            }
        }

    }

    return;
}


@end
