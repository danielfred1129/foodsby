//
//  MenuQuestionItem.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "MenuQuestionItem.h"

@implementation MenuQuestionItem

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _displayText = nil;
        _questionId = -1;
        _answerItems = [[NSMutableArray alloc] init];
        _minimumSelection = -1;
        _maximumSelection = -1;
        _showAsRadio = NO;
    }
    
    return self;
}

@end
