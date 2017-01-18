//
//  DeliveryDaysThisWeek.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "DeliveryDaysThisWeek.h"

@implementation DeliveryDaysThisWeek

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _dayOfWeek = -1;
        _dateOfDayForWeek = nil;
        _stores = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
