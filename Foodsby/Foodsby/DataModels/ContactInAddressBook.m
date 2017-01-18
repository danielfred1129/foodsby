//
//  ContactInAddressBook.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/20/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "ContactInAddressBook.h"

@implementation ContactInAddressBook

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _firstName = nil;
        _lastName = nil;
        _companyName = nil;
        _email = nil;
        _selected = NO;
    }
    
    return self;
}

@end
