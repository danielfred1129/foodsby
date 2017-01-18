//
//  CheckoutInfo.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CheckoutInfo.h"

@implementation CheckoutInfo

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _orderId = -1;
        _street = nil;
        _city = nil;
        _state = nil;
        _zip = nil;
        _payment = [[PaymentInfo alloc] init];
        _saveCard = NO;
        _isProduction = NO;
    }
    
    return self;
}

@end
