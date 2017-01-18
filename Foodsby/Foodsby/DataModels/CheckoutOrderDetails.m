//
//  CheckoutOrderDetails.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CheckoutOrderDetails.h"

@implementation CheckoutOrderDetails

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _orderHistoryId = -1;
        _orderId = -1;
        _storeId = -1;
        _storeName = nil;
        _userId = -1;
        _userName = nil;
        _deliveryTimeId = -1;
        _dropoffTime = nil;
        _deliveryId = -1;
        _cutoffTime = nil;
        _orderDate = nil;
        _orderStatusId = -1;
        _orderStatus = nil;
        _additionalInstructions = nil;
        _orderItems = [[NSMutableArray alloc] init];
        _created = nil;
        _recorded = nil;
        _couponId = -1;
        _couponCode = nil;
        _itemSubTotal = 0.0;
        _couponSubTotal = 0.0;
        _taxSubTotal = 0.0;
        _storeFee = 0.0;
        _foodsbyFee = 0.0;
        _orderTotal = 0.0;
        _transactionId = nil;
        _deliveryLocationId = -1;
        _locationName = nil;
        _restaurantId = -1;
        _restaurantName = nil;
    }
    
    return self;
}

@end
