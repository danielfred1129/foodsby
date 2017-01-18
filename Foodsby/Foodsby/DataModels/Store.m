//
//  Store.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "Store.h"

@implementation Store

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _restaurantName = nil;
        _storeName = nil;
    }
    
    return self;
}

@end
