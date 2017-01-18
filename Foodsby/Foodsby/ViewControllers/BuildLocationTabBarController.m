//
//  BuildLocationTabBarController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/18/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "BuildLocationTabBarController.h"
#import "Utils.h"

@interface BuildLocationTabBarController ()

@end

@implementation BuildLocationTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[Utils sharedUtils] setMenuType:self.navigationController type:3];

    [self setCustomNavBar];
    [self setCustomTabBar];
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
    
    self.navigationItem.title = @"Build Location";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void) setCustomTabBar {

    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    UIImage * image = [[UIImage imageNamed:@"TabBarSelectBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [self.tabBar setSelectionIndicatorImage:image];
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    
    return NO;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
    
    return YES;
}

@end
