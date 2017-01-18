//
//  OrderApiParser.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderApiParser.h"
#import "Utils.h"

@implementation OrderApiParser

static OrderApiParser * sharedOrderApiParser = nil;

+ (OrderApiParser *) sharedOrderApiParser {
    
    if (sharedOrderApiParser == nil) {
        
        sharedOrderApiParser = [[OrderApiParser alloc] init];
    }
    
    return sharedOrderApiParser;
}


#pragma mark - OrderApiParserDelegate methods parsing

- (void) error:(NSDictionary *)errorInfo {
    
    
}

- (Order *) didGetOrder:(NSDictionary *) info {
    
    if (info == nil)
        return nil;
    
    Order * order = [[Order alloc] init];
    
    order.orderId = [[info objectForKey:@"OrderId"] integerValue];
    order.storeId = [[info objectForKey:@"StoreId"] integerValue];
    order.userId = [[info objectForKey:@"UserId"] integerValue];
    order.deliveryTimeId = [[info objectForKey:@"DeliveryTimeId"] integerValue];
    order.orderDate = [info objectForKey:@"OrderDate"];
    order.orderStatus = [[info objectForKey:@"OrderStatus"] integerValue];
    order.orderDate = [info objectForKey:@"AdditionalInstructions"];
    
    NSArray * arrayOrderItems = [info objectForKey:@"OrderItems"];
    
    for (int i = 0 ; i < arrayOrderItems.count ; i ++) {
        
        OrderItem * orderItem = [[OrderItem alloc] init];
        NSDictionary * dictOrderItemInfo = [arrayOrderItems objectAtIndex: i];
        
        orderItem.itemName = [dictOrderItemInfo objectForKey:@"ItemName"];
        orderItem.price = [[dictOrderItemInfo objectForKey:@"Price"] doubleValue];
        orderItem.orderItemId = [[dictOrderItemInfo objectForKey:@"OrderItemId"] integerValue];
        orderItem.specialInstructions = [dictOrderItemInfo objectForKey:@"SpecialInstructions"];
        
        NSArray * arrayModifier = [dictOrderItemInfo objectForKey:@"Modifiers"];
        
        for (int j = 0 ; j < arrayModifier.count ; j ++) {
            
            OrderItemModifier * modifier = [[OrderItemModifier alloc] init];
            NSDictionary * dictModifier = [arrayModifier objectAtIndex: j];
            
            modifier.depth = [[dictModifier objectForKey:@"Depth"] integerValue];
            modifier.orderItemModifierId = [[dictModifier objectForKey:@"OrderItemModifierId"] integerValue];

            NSArray * arrayAnswers = [dictModifier objectForKey:@"Answers"];
            
            for (int k = 0 ; k < arrayAnswers.count ; k ++) {
                
                OrderItemModifierAnswer * answer = [[OrderItemModifierAnswer alloc] init];
                NSDictionary * dictAnswer = [arrayAnswers objectAtIndex: k];
                
                answer.answerId = [[dictAnswer objectForKey:@"AnswerId"] integerValue];
                answer.itemName = [dictAnswer objectForKey:@"ItemName"];
                answer.price = [[dictAnswer objectForKey:@"Price"] doubleValue];
                
                [modifier.answers addObject:answer];
            }
            
            [orderItem.modifiers addObject:modifier];
        }
        
        [order.orderItems addObject:orderItem];
    }
    
    order.created = [info objectForKey:@"Created"];
    order.itemSubTotal = [[info objectForKey:@"ItemSubTotal"] doubleValue];
    order.couponSubTotal = [[info objectForKey:@"CouponSubTotal"] doubleValue];
    order.taxSubTotal = [[info objectForKey:@"TaxSubTotal"] doubleValue];
    order.orderTotal = [[info objectForKey:@"OrderTotal"] doubleValue];
    order.transactionId = [info objectForKey:@"TransactionId"];
    order.deliveryLocationId = [[info objectForKey:@"DeliveryLocationId"] integerValue];
    order.foodsbyFee = [[info objectForKey:@"FoodsbyFee"] doubleValue];
    
    return order;
}

- (void) didReorder:(NSDictionary *) info {
    
    
}

- (void) didGetOrderHistory:(NSArray *) info {

    if ([Utils sharedUtils].arrayReorder.count > 0)
        [[Utils sharedUtils].arrayReorder removeAllObjects];
    
    for (int i = 0 ; i < info.count ; i ++) {
        
        OrderHistory * orderHistory = [[OrderHistory alloc] init];
        NSDictionary * dictOrderHistory = [info objectAtIndex:i];
        
        orderHistory.orderHistoryId = [[dictOrderHistory objectForKey:@"OrderHistoryId"] integerValue];
        orderHistory.additionalInstructions = [dictOrderHistory objectForKey:@"AdditionalInstructions"];
        
        NSArray * arrayOrderItems = [dictOrderHistory objectForKey:@"OrderItems"];

        for (int j = 0 ; j < arrayOrderItems.count ; j ++) {
            
            OrderHistoryItem * orderItem = [[OrderHistoryItem alloc] init];
            NSDictionary * dictOrderItemInfo = [arrayOrderItems objectAtIndex: j];
            
            orderItem.itemName = [dictOrderItemInfo objectForKey:@"ItemName"];
            orderItem.specialInstructions = [dictOrderItemInfo objectForKey:@"SpecialInstructions"];
            
            NSArray * arrayModifier = [dictOrderItemInfo objectForKey:@"Modifiers"];
            
            for (int k = 0 ; k < arrayModifier.count ; k ++) {
                
                OrderHistoryItemModifier * modifier = [[OrderHistoryItemModifier alloc] init];
                NSDictionary * dictModifier = [arrayOrderItems objectAtIndex: k];
                
                modifier.depth = [[dictModifier objectForKey:@"Depth"] integerValue];
                modifier.questionName = [dictModifier objectForKey:@"QuestionName"];
                
                NSArray * arrayAnswers = [dictModifier objectForKey:@"Answers"];
                
                for (int m = 0 ; m < arrayAnswers.count ; m ++) {
                    
                    NSDictionary * dictAnswer = [arrayAnswers objectAtIndex: m];
                    [modifier.answers addObject:[dictAnswer objectForKey:@"ItemName"]];
                }
                
                [orderItem.modifiers addObject:modifier];
            }
            
            [orderHistory.orderItems addObject:orderItem];
        }
        
        [[Utils sharedUtils].arrayReorder addObject:orderHistory];
    }
    
    return;
}

- (void) didAddOrderItem:(NSDictionary *) info {
    
    
}

- (void) didRemoveOrderItem:(NSDictionary *) info {
    
    
}

- (OrderApplyCoupon *) didApplyCouponToOrder:(NSDictionary *) info {
    
    OrderApplyCoupon * orderApplyCoupon = [[OrderApplyCoupon alloc] init];

    orderApplyCoupon.success = [[info objectForKey:@"Success"] boolValue];
    orderApplyCoupon.message = [info objectForKey:@"Message"];
    
    if (orderApplyCoupon.success == NO)
        return orderApplyCoupon;
    
    NSDictionary * dictOrder = [info objectForKey:@"Order"];
    
    orderApplyCoupon.order.orderId = [[dictOrder objectForKey:@"OrderId"] integerValue];
    orderApplyCoupon.order.storeId = [[dictOrder objectForKey:@"StoreId"] integerValue];
    orderApplyCoupon.order.userId = [[dictOrder objectForKey:@"UserId"] integerValue];
    orderApplyCoupon.order.deliveryTimeId = [[dictOrder objectForKey:@"DeliveryTimeId"] integerValue];
    orderApplyCoupon.order.orderDate = [dictOrder objectForKey:@"OrderDate"];
    orderApplyCoupon.order.orderStatus = [[dictOrder objectForKey:@"OrderStatus"] integerValue];
    orderApplyCoupon.order.orderDate = [dictOrder objectForKey:@"AdditionalInstructions"];
    
    NSArray * arrayOrderItems = [dictOrder objectForKey:@"OrderItems"];
    
    for (int i = 0 ; i < arrayOrderItems.count ; i ++) {
        
        OrderItem * orderItem = [[OrderItem alloc] init];
        NSDictionary * dictOrderItemInfo = [arrayOrderItems objectAtIndex: i];
        
        orderItem.itemName = [dictOrderItemInfo objectForKey:@"ItemName"];
        orderItem.price = [[dictOrderItemInfo objectForKey:@"Price"] doubleValue];
        orderItem.orderItemId = [[dictOrderItemInfo objectForKey:@"OrderItemId"] integerValue];
        orderItem.specialInstructions = [dictOrderItemInfo objectForKey:@"SpecialInstructions"];
        
        NSArray * arrayModifier = [dictOrderItemInfo objectForKey:@"Modifiers"];
        
        for (int j = 0 ; j < arrayModifier.count ; j ++) {
            
            OrderItemModifier * modifier = [[OrderItemModifier alloc] init];
            NSDictionary * dictModifier = [arrayOrderItems objectAtIndex: j];
            
            modifier.depth = [[dictModifier objectForKey:@"Depth"] integerValue];
            modifier.orderItemModifierId = [[dictModifier objectForKey:@"OrderItemModifierId"] integerValue];
            
            NSArray * arrayAnswers = [dictModifier objectForKey:@"Answers"];
            
            for (int k = 0 ; k < arrayAnswers.count ; k ++) {
                
                OrderItemModifierAnswer * answer = [[OrderItemModifierAnswer alloc] init];
                NSDictionary * dictAnswer = [arrayAnswers objectAtIndex: k];
                
                answer.answerId = [[dictAnswer objectForKey:@"AnswerId"] integerValue];
                answer.itemName = [dictAnswer objectForKey:@"ItemName"];
                answer.price = [[dictAnswer objectForKey:@"Price"] doubleValue];
                
                [modifier.answers addObject:answer];
            }
            
            [orderItem.modifiers addObject:modifier];
        }
        
        [orderApplyCoupon.order.orderItems addObject:orderItem];
    }
    
    orderApplyCoupon.order.created = [dictOrder objectForKey:@"Created"];
    orderApplyCoupon.order.itemSubTotal = [[dictOrder objectForKey:@"ItemSubTotal"] doubleValue];
    orderApplyCoupon.order.couponSubTotal = [[dictOrder objectForKey:@"CouponSubTotal"] doubleValue];
    orderApplyCoupon.order.taxSubTotal = [[dictOrder objectForKey:@"TaxSubTotal"] doubleValue];
    orderApplyCoupon.order.orderTotal = [[dictOrder objectForKey:@"OrderTotal"] doubleValue];
    orderApplyCoupon.order.transactionId = [dictOrder objectForKey:@"TransactionId"];
    orderApplyCoupon.order.deliveryLocationId = [[dictOrder objectForKey:@"DeliveryLocationId"] integerValue];
    orderApplyCoupon.order.foodsbyFee = [[dictOrder objectForKey:@"FoodsbyFee"] doubleValue];
    
    return orderApplyCoupon;
}

@end
