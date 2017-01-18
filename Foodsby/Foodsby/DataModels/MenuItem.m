//
//  MenuItem.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/10/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _menuItemId = -1;
        _displayText = nil;
        _price = 0.0;
        _menuItemDescription = nil;
        _specialInstructions = nil;
        _questionItems = [[NSMutableArray alloc] init];
        _selectedAnswers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
