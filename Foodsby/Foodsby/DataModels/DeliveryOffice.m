//
//  DeliveryOffice.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "DeliveryOffice.h"

@implementation DeliveryOffice

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _officeId = -1;
        _officeName = nil;
        _deliveryLocationId = -1;
    }
    
    return self;
}

@end
