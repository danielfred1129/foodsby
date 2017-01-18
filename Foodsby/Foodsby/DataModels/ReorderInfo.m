//
//  ReorderInfo.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/5/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "ReorderInfo.h"

@implementation ReorderInfo

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {

        _orderHistoryId = -1;
        _dayOfWeek = -1;
        _storeId = -1;
        _deliveryTimeId = -1;
        _deliveryLocationId = -1;
    }
    
    return self;
}

@end
