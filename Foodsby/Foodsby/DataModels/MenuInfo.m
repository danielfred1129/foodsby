//
//  MenuInfo.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/5/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "MenuInfo.h"

@implementation MenuInfo

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _deliveryTimeId = -1;
        _deliveryLocationId = -1;
        _storeId = -1;
        _deliveryId = -1;
        _dayOfWeek = 0;
    }
    
    return self;
}

@end
