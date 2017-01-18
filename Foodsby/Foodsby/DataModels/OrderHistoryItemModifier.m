//
//  OrderHistoryItemModifier.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderHistoryItemModifier.h"

@implementation OrderHistoryItemModifier

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _questionName = nil;
        _answers = [[NSMutableArray alloc] init];
        _depth = -1;
    }
    
    return self;
}

@end
