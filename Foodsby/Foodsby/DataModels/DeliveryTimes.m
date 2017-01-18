//
//  DeliveryTimes.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "DeliveryTimes.h"

@implementation DeliveryTimes

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _dropoffTime = nil;
        _dropoffDateTime = nil;
        _deliveryTimeId = -1;
        _deliveryLocationId = -1;
        _deliveryId = -1;
        _deliveryName = nil;
        _isPending = NO;
        _inZone = NO;
    }
    
    return self;
}


@end
