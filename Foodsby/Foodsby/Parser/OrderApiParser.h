//
//  OrderApiParser.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Order.h"
#import "OrderApplyCoupon.h"
#import "OrderItem.h"
#import "OrderItemModifier.h"
#import "OrderItemModifierAnswer.h"
#import "OrderHistory.h"
#import "OrderHistoryItem.h"
#import "OrderHistoryItemModifier.h"

@interface OrderApiParser : NSObject

- (void) error:(NSDictionary *)errorInfo;
- (Order *) didGetOrder:(NSDictionary *) info;
- (void) didReorder:(NSDictionary *) info;
- (void) didGetOrderHistory:(NSArray *) info;
- (void) didAddOrderItem:(NSDictionary *) info;
- (void) didRemoveOrderItem:(NSDictionary *) info;
- (OrderApplyCoupon *) didApplyCouponToOrder:(NSDictionary *) info;


+ (OrderApiParser *)sharedOrderApiParser;

@end
