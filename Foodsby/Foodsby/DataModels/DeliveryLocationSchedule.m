//
//  DeliveryLocationSchedule.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "DeliveryLocationSchedule.h"

@implementation DeliveryLocationSchedule

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _storesForLocation = [[NSMutableArray alloc] init];
        _deliveryDaysThisWeek = [[NSMutableArray alloc] init];
        _today = nil;
        _locationName = nil;
    }
    
    return self;
}

@end
