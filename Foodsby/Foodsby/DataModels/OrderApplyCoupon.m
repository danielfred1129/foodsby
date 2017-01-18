//
//  OrderApplyCoupon.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderApplyCoupon.h"

@implementation OrderApplyCoupon

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _success = NO;
        _message = nil;
        _order = [[Order alloc] init];
    }
    
    return self;
}

@end
