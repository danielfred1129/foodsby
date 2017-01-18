//
//  CandidateAddress.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CandidateAddress.h"

@implementation CandidateAddress

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _candidateAddressId = -1;
        _deliveryLine1 = nil;
        _lastLine = nil;
    }
    
    return self;
}

@end
