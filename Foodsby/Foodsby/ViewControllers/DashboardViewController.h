//
//  DashboardViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/12/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "OrderApi.h"
#import "MenuApi.h"
#import "StoreForLocation.h"


@interface DashboardViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, OrderApiDelegate, MenuApiDelegate> {
    
    NSMutableArray *    arrayWeekButtons;
    NSMutableArray *    arrayDayOfWeek;

    NSMutableArray *    arrayStores;
    UIButton *          buttonPrevSelect;
    NSInteger           nSelectedDay;
    StoreForLocation *  selectedStore;
}

@property (weak, nonatomic) IBOutlet UIView *       viewWeekButtons;
@property (weak, nonatomic) IBOutlet UITableView *  tableViewDeliveryTime;

@end
