//
//  StatusViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/18/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "StatusViewController.h"
#import "InviteContactsViewController.h"
#import "CompanyDetail.h"
#import "Utils.h"

@interface StatusViewController ()

@end

@implementation StatusViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self showOfficeInfo];
    
    _viewCommentContainer.layer.borderWidth = 1;
    _viewCommentContainer.layer.borderColor = [[UIColor blackColor] CGColor];
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

- (void) showOfficeInfo {
    
    CompanyDetail * office = [Utils sharedUtils].office;
    
    _labelOfficeName.text = office.officeName;
    
    
    NSString * peoples;
    
    if (office.count == 1) {
        
        _labelOfficeCount.text = @"1 person";
        peoples = @"1 person has";
        
    } else {
        
        _labelOfficeCount.text = [NSString stringWithFormat:@"%ld people", office.count];
        peoples = [NSString stringWithFormat:@"%ld people have", office.count];
    }
    
    _labelLocationComment.text = [peoples stringByAppendingString:@"joined this location"];
    
    _labelOfficeAddress.text = [NSString stringWithFormat:@"%@, %@", office.deliveryLine1, office.lastLine];
}

@end
