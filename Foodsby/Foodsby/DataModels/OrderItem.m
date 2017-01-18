//
//  OrderItem.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _itemName = nil;
        _price = 0.0;
        _orderItemId = -1;
        _specialInstructions = nil;
        _modifiers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
