//
//  UserApiParser.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserApi.h"
#import "UserCard.h"

@interface UserApiParser : NSObject <UserApiDelegate>

- (void) error:(NSDictionary *)errorInfo;
- (void) didGetUser:(NSDictionary *) info;
- (void) didUpdateUser:(NSDictionary *) info;
- (void) didCreateUser:(NSDictionary *)info;
- (void) didLogIn:(NSDictionary *) info;
- (void) didGetUserToken:(NSDictionary *)info;
- (void) didResetPassword:(NSDictionary *)info;
- (BOOL) didChangePassword:(NSDictionary *)info;
- (void) didDeleteUserCards:(NSDictionary *) info;
- (void) didGetUserCards:(NSArray *) info;


+ (UserApiParser *)sharedUserApiParser;

@end
