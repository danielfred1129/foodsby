//
//  CheckoutOrderItem.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CheckoutOrderItem.h"

@implementation CheckoutOrderItem

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _orderItemHistoryId = -1;
        _orderHistoryId = -1;
        _specialInstructions = nil;
        _menuItemId = -1;
        _itemName = nil;
        _price = 0.0;
    }
    
    return self;
}

@end
