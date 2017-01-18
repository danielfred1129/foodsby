//
//  OrderHistoryItem.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderHistoryItem.h"

@implementation OrderHistoryItem

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _specialInstructions = nil;
        _itemName = nil;
        _modifiers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
