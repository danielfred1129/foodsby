//
//  Utils.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/11/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Global.h"

#import "DeliveryLocationSchedule.h"
#import "User.h"
#import "CompanyDetail.h"
#import "MenuInfo.h"
#import "ReorderInfo.h"
#import "MenuList.h"
#import "PromoCode.h"
#import "Order.h"
#import "CheckoutOrderDetails.h"
#import "CheckoutReceiptDetails.h"


@interface Utils : NSObject

+ (BOOL) validateEmail:(NSString *)email;
+ (Utils *) sharedUtils;
+ (NSObject *) utilsObject:(NSObject *) object;


@property (nonatomic) NSInteger                         officeId;
@property (nonatomic) NSInteger                         deliveryLocationId;
@property (nonatomic) NSInteger                         orderId;
@property (nonatomic) NSInteger                         menuItemId;
@property (nonatomic) NSInteger                         orderItemsCount;
@property (nonatomic) NSInteger                         preferredCard;
@property (nonatomic) BOOL                              isProduction;

@property (nonatomic) User *                            user;
@property (nonatomic) NSMutableArray *                  arrayCards;//cards
@property (nonatomic) NSMutableArray *                  arrayDeliveryLocations;//locations
@property (nonatomic) CompanyDetail *                   office;
@property (nonatomic) NSMutableArray *                  arrayAllOffices;
@property (nonatomic) DeliveryLocationSchedule *        deliveryLocationSchedule;//schedule
@property (nonatomic) MenuInfo *                        identifiers;
@property (nonatomic) NSMutableArray *                  arrayExceptions;
@property (nonatomic) NSMutableArray *                  arrayReorder;
@property (nonatomic) MenuList *                        menu;
@property (nonatomic) NSMutableArray *                  arraySubMenus;
@property (nonatomic) SubMenu *                         subMenu;
@property (nonatomic) NSMutableArray *                  arrayItems;
@property (nonatomic) MenuItem *                        qa;
@property (nonatomic) PromoCode *                       promo;
@property (nonatomic) Order *                           order;
@property (nonatomic) CheckoutOrderDetails *            orderDetails;//order
@property (nonatomic) CheckoutReceiptDetails *          receiptDetails;//receipt




@property (nonatomic) UIViewController *            dashboardViewController;
@property (nonatomic) UIViewController *            selectMenuViewController;
@property (nonatomic) UIViewController *            orderSummaryViewController;


- (void) setMenuType:(UINavigationController *)nav type:(NSInteger)nType;
- (NSString *) convertCurrentTimeZone:(NSString *) time;
- (void) setupNotifications:(DeliveryLocationSchedule *) schedule;
- (void) clearNotifications;
- (BOOL) hasMissingInfo;
- (BOOL) hasSavedCards;
- (void) standardError:(NSDictionary *) error;
- (void) resetUtils;//clear

@end
