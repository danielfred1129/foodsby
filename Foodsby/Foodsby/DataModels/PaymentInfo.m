//
//  PaymentInfo.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "PaymentInfo.h"

@implementation PaymentInfo

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _fistName = nil;
        _lastName = nil;
        _cardNbr = nil;
        _expMonth = 0;
        _expYear = 0;
        _cVV2 = nil;
        _amount = 0.0;
    }
    return self;
}

@end
