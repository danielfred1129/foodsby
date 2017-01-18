//
//  ValidatedAddress.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "ValidatedAddress.h"

@implementation ValidatedAddress

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _validatedAddressId = -1;
        _candidates = [[NSMutableArray alloc] init];
        _success = NO;
    }
    
    return self;
}

@end
