//
//  OrderAddItem.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/5/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderAddItem.h"

@implementation OrderAddItem

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _orderId = -1;
        _menuItemId = -1;
        _specialInstructions = nil;
        _selectedAnswers = [[NSMutableArray alloc] init];        
    }
    
    return self;
}

@end
