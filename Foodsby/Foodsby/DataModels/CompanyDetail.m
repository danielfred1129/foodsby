//
//  CompanyDetail.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CompanyDetail.h"

@implementation CompanyDetail

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _count = -1;
        _officeId = -1;
        _officeName = nil;
        _validatedAddressId = -1;
        _deliveryLocationId = -1;
        _deliveryLine1 = nil;
        _lastLine = nil;
        _longitude = nil;
        _latitude = nil;
    }
    
    return self;
}

@end
