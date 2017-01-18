//
//  MenuList.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "MenuList.h"

@implementation MenuList

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _locationName = nil;
        _pickupInstruction = nil;
        _dayOfWeek = -1;
        _dateOfDayForWeek = -1;
        _deliveryLocationId = -1;
        _restaurantName = nil;
        _dropoffTime = nil;
        _cutOffTime = nil;
        _timeZoneInfoId = nil;
        _subMenus = [[NSMutableArray alloc] init];
        _soldOut = NO;
        _orderId = -1;
        _orderItemsCount = 0;
        _logoLink = nil;
        _hasPastOrder = NO;
    }
    
    return self;
}


@end
