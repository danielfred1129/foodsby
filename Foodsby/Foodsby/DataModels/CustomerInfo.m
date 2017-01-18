//
//  CustomerInfo.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/5/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CustomerInfo.h"

@implementation CustomerInfo

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _fistName = nil;
        _lastName = nil;
        _phone = nil;
        _smsNotify = NO;

    }
    
    return self;
}

@end
