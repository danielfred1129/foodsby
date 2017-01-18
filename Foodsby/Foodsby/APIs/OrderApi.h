//
//  OrderApi.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "OrderAddItem.h"
#import "ReorderInfo.h"
#import "SelectedAnswerInfo.h"

@class OrderApi;

@protocol OrderApiDelegate

@required

- (void) error:(NSDictionary *) errorInfo;

@optional

- (void) didApplyCouponToOrder:(NSDictionary *) info;
- (void) didRemoveOrderItem:(NSDictionary *) info;
- (void) didGetOrder:(NSDictionary *) info;
- (void) didGetOrderHistory:(NSArray *) info;
- (void) didAddItemToOrder:(NSDictionary *) info;
- (void) didReorder:(NSDictionary *) info;

@end

@interface OrderApi : NSObject {
    
    NSObject <OrderApiDelegate> *       delegate;
    enum API_CALL_TYPE                  currentCallType;
}

+ (OrderApi *) sharedOrderApi;
- (void)setDelegate:(NSObject <OrderApiDelegate> *) apiDelegate;

- (void) applyCouponToOrder:(NSInteger) orderId couponCode:(NSString *) couponCode;
- (void) removeOrderItem:(NSInteger) orderId orderItemId:(NSInteger) orderItemId;
- (void) getOrder:(NSInteger) orderId;
- (void) getOrderHistory:(NSInteger) storeId;
- (void) addItemToOrder:(OrderAddItem *) info;
- (void) reorder:(ReorderInfo *) info;

@end
