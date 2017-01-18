//
//  OrderHistory.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderHistory.h"

@implementation OrderHistory

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _orderHistoryId = -1;
        _additionalInstructions = nil;
        _orderItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
