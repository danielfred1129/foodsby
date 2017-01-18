//
//  Exception.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "Exception.h"

@implementation Exception

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _globalExceptionId = -1;
        _exceptionDate = nil;
        _duration = -1;
    }
    
    return self;
}

@end
