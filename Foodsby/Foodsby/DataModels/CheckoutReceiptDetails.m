//
//  CheckoutReceiptDetails.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CheckoutReceiptDetails.h"

@implementation CheckoutReceiptDetails

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {

        _deliveryLocationId = -1;
        _orderId = -1;
        _transactionId = nil;
        _locationName = nil;
        _dropoffTime = nil;
        _orderDate = nil;
        _restaurantName = nil;
        _pickupInstruction = nil;
        _phone = nil;
        _showSMS = NO;
        _smsNumber = nil;
    }
    
    return self;
}

@end
