//
//  UserCard.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "UserCard.h"

@implementation UserCard

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _lastFour = nil;
        _token = nil;
        _cCProfileId = -1;
    }
    
    return self;
}

@end
