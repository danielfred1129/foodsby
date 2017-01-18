//
//  StoreForLocation.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "StoreForLocation.h"

@implementation StoreForLocation

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _storeId = -1;
        _store = [[Store alloc] init];
        _cutOffTime = nil;
        _cutOffDateTime = nil;
        _deliveryTimes = [[NSMutableArray alloc] init];
        _logoLink = nil;
        _timeZoneInfoId = nil;
        _maxWeight = -1;
        _availableDays = [[NSMutableArray alloc] init];
        _currentWeight = -1;
        _inZone = NO;
        _mondayCount = -1;
        _tuesdayCount = -1;
        _wednesdayCount = -1;
        _thursdayCount = -1;
        _fridayCount = -1;
        _saturdayCount = -1;
        _sundayCount = -1;
    }
    
    return self;
}

@end
