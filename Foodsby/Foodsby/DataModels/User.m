//
//  User.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "User.h"

@implementation User

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        _userId = -1;
        _inviteCode = nil;
        _userName = nil;
        _email = nil;
        _firstName = nil;
        _lastName = nil;
        _phone = nil;
        _officeId = -1;
        _deliveryLocationId = -1;
        _created = nil;
        _birthday = nil;
        _status = -1;
        _token = nil;
        _tokenExpire = nil;
        _smsNotify = NO;
    }
    
    return self;
}

@end
