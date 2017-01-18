//
//  CheckoutApiParser.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CheckoutApiParser.h"

@implementation CheckoutApiParser

static CheckoutApiParser * sharedCheckoutApiParser = nil;

+ (CheckoutApiParser *) sharedCheckoutApiParser {
    
    if (sharedCheckoutApiParser == nil) {
        
        sharedCheckoutApiParser = [[CheckoutApiParser alloc] init];
    }
    
    return sharedCheckoutApiParser;
}


#pragma mark - CheckoutApiParserDelegate methods parsing

- (void) error:(NSDictionary *) errorInfo {
    

}

- (CheckoutCard *) checkout:(NSDictionary *)info {
    
    CheckoutCard * checkoutCard = [[CheckoutCard alloc] init];
    
    checkoutCard.success = [[info objectForKey:@"Success"] boolValue];
    checkoutCard.message = [info objectForKey:@"Message"];
    
    if (checkoutCard.success == NO)
        return checkoutCard;        
    
    NSDictionary * dictOrderDetailes = [info objectForKey:@"OrderDetails"];
    
    checkoutCard.orderDetails.orderHistoryId = [[dictOrderDetailes objectForKey:@"OrderHistoryId"] integerValue];
    checkoutCard.orderDetails.orderId = [[dictOrderDetailes objectForKey:@"OrderId"] integerValue];
    checkoutCard.orderDetails.storeId = [[dictOrderDetailes objectForKey:@"StoreId"] integerValue];
    checkoutCard.orderDetails.storeName = [dictOrderDetailes objectForKey:@"StoreName"];
    checkoutCard.orderDetails.userId = [[dictOrderDetailes objectForKey:@"UserId"] integerValue];
    checkoutCard.orderDetails.userName = [dictOrderDetailes objectForKey:@"UserName"];
    checkoutCard.orderDetails.deliveryTimeId = [[dictOrderDetailes objectForKey:@"DeliveryTimeId"] integerValue];
    checkoutCard.orderDetails.dropoffTime = [dictOrderDetailes objectForKey:@"DropoffTime"];
    checkoutCard.orderDetails.deliveryId = [[dictOrderDetailes objectForKey:@"DeliveryId"] integerValue];
    checkoutCard.orderDetails.cutoffTime = [dictOrderDetailes objectForKey:@"CutoffTime"];
    checkoutCard.orderDetails.orderDate = [dictOrderDetailes objectForKey:@"OrderDate"];
    checkoutCard.orderDetails.orderStatusId = [[dictOrderDetailes objectForKey:@"OrderStatusId"] integerValue];
    checkoutCard.orderDetails.orderStatus = [dictOrderDetailes objectForKey:@"OrderStatus"];
    checkoutCard.orderDetails.additionalInstructions = [dictOrderDetailes objectForKey:@"AdditionalInstructions"];
    
    NSArray * arrayOrderItems = [dictOrderDetailes objectForKey:@"OrderItems"];
    
    for (int i = 0 ; i < arrayOrderItems.count ; i ++) {
        
        CheckoutOrderItem * orderItem = [[CheckoutOrderItem alloc] init];
        NSDictionary * dictOrderItem = [arrayOrderItems objectAtIndex:i];
        
        orderItem.orderItemHistoryId = [[dictOrderItem objectForKey:@"OrderItemHistoryId"] integerValue];
        orderItem.orderHistoryId = [[dictOrderItem objectForKey:@"OrderHistoryId"] integerValue];
        orderItem.specialInstructions = [dictOrderItem objectForKey:@"SpecialInstructions"];
        orderItem.menuItemId = [[dictOrderItem objectForKey:@"MenuItemId"] integerValue];
        orderItem.itemName = [dictOrderItem objectForKey:@"ItemName"];
        orderItem.price = [[dictOrderItem objectForKey:@"Price"] doubleValue];
        
        [checkoutCard.orderDetails.orderItems addObject:orderItem];
    }
    
    checkoutCard.orderDetails.created = [dictOrderDetailes objectForKey:@"Created"];
    checkoutCard.orderDetails.recorded = [dictOrderDetailes objectForKey:@"Recorded"];
    checkoutCard.orderDetails.couponId = [[dictOrderDetailes objectForKey:@"CouponId"] integerValue];
    checkoutCard.orderDetails.couponCode = [dictOrderDetailes objectForKey:@"CouponCode"];
    checkoutCard.orderDetails.itemSubTotal = [[dictOrderDetailes objectForKey:@"ItemSubTotal"] integerValue];
    checkoutCard.orderDetails.couponSubTotal = [[dictOrderDetailes objectForKey:@"CouponSubTotal"] integerValue];
    checkoutCard.orderDetails.taxSubTotal = [[dictOrderDetailes objectForKey:@"TaxSubTotal"] integerValue];
    checkoutCard.orderDetails.storeFee = [[dictOrderDetailes objectForKey:@"StoreFee"] integerValue];
    checkoutCard.orderDetails.foodsbyFee = [[dictOrderDetailes objectForKey:@"FoodsbyFee"] integerValue];
    checkoutCard.orderDetails.orderTotal = [[dictOrderDetailes objectForKey:@"OrderTotal"] integerValue];
    checkoutCard.orderDetails.transactionId = [dictOrderDetailes objectForKey:@"TransactionId"];
    checkoutCard.orderDetails.deliveryLocationId = [[dictOrderDetailes objectForKey:@"DeliveryLocationId"] integerValue];
    checkoutCard.orderDetails.locationName = [dictOrderDetailes objectForKey:@"LocationName"];
    checkoutCard.orderDetails.restaurantId = [[dictOrderDetailes objectForKey:@"RestaurantId"] integerValue];
    checkoutCard.orderDetails.restaurantName = [dictOrderDetailes objectForKey:@"RestaurantName"];
    
    NSDictionary * dictReceiptDetails = [info objectForKey:@"ReceiptDetails"];
    
    checkoutCard.receiptDetails.deliveryLocationId = [[dictReceiptDetails objectForKey:@"DeliveryLocationId"] integerValue];
    checkoutCard.receiptDetails.orderId = [[dictReceiptDetails objectForKey:@"OrderId"] integerValue];
    
    checkoutCard.receiptDetails.transactionId = [dictReceiptDetails objectForKey:@"TransactionId"];
    checkoutCard.receiptDetails.locationName = [dictReceiptDetails objectForKey:@"LocationName"];
    checkoutCard.receiptDetails.dropoffTime = [dictReceiptDetails objectForKey:@"DropoffTime"];
    checkoutCard.receiptDetails.orderDate = [dictReceiptDetails objectForKey:@"OrderDate"];
    checkoutCard.receiptDetails.restaurantName = [dictReceiptDetails objectForKey:@"RestaurantName"];
    checkoutCard.receiptDetails.pickupInstruction = [dictReceiptDetails objectForKey:@"PickupInstruction"];
    checkoutCard.receiptDetails.phone = [dictReceiptDetails objectForKey:@"Phone"];
    checkoutCard.receiptDetails.showSMS = [[dictReceiptDetails objectForKey:@"ShowSMS"] integerValue];
    checkoutCard.receiptDetails.smsNumber = [dictReceiptDetails objectForKey:@"SMSNumber"];
    
    return checkoutCard;
}

- (CheckoutCard *) didCheckoutCard:(NSDictionary *)info {
    
    return [self checkout:info];
}

- (CheckoutCard *) didCheckoutSavedCard:(NSDictionary *) info {

    return  [self checkout:info];
}

- (CheckoutCard *) didCheckoutFreeMeal:(NSDictionary *) info {
    
    return [self checkout:info];
}


@end
