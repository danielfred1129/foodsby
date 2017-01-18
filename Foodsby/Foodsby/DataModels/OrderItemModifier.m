//
//  OrderItemModifier.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderItemModifier.h"

@implementation OrderItemModifier

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _depth = -1;
        _orderItemModifierId = -1;
        _answers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
