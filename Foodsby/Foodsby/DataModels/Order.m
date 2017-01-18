//
//  Order.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "Order.h"

@implementation Order

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _orderId = -1;
        _storeId = -1;
        _userId = -1;
        _deliveryTimeId = -1;
        _orderDate = nil;
        _orderStatus = -1;
        _additionalInstructions = nil;
        _orderItems = [[NSMutableArray alloc] init];
        _created = nil;
        _itemSubTotal = 0.0;
        _couponSubTotal = 0.0;
        _taxSubTotal = 0.0;
        _orderTotal = 0.0;
        _transactionId = nil;
        _deliveryLocationId = -1;
        _foodsbyFee = 0.0;
    }
    
    return self;
}

@end
