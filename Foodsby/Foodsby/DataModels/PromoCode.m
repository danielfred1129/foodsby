//
//  PromoCode.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/28/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "PromoCode.h"

@implementation PromoCode

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _Id = -1;
        _code = nil;
    }
    
    return self;
}

@end
