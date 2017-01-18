//
//  OrderItemModifierAnswer.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderItemModifierAnswer.h"

@implementation OrderItemModifierAnswer

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _answerId = -1;
        _itemName = nil;
        _price = 0.0;
    }
    
    return self;
}

@end
