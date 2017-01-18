//
//  SelectedAnswerInfo.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/5/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "SelectedAnswerInfo.h"

@implementation SelectedAnswerInfo

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _answerId = -1;
        _selected = NO;
        _depth = -1;
    }
    
    return self;
}

@end
