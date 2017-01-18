//
//  UserApi.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "User.h"
#import "CustomerInfo.h"


@class UserApi;

@protocol UserApiDelegate

@required

- (void) error:(NSDictionary *) errorInfo;

@optional

- (void) didCreateUser:(NSDictionary *) info;
- (void) didGetUser:(NSDictionary *) info;
- (void) didResetPassword:(NSDictionary *) info;
- (void) didUpdateUser:(NSDictionary *) info;
- (void) didSetContactUserInfo:(NSDictionary *) info;
- (void) didChangePassword:(NSDictionary *) info;
- (void) didGetUserCards:(NSArray *) info;
- (void) didDeleteUserCards:(NSDictionary *) info;

- (void) didGetUserToken:(NSDictionary *) info;

- (void) didLogIn:(NSDictionary *) info;

@end

@interface UserApi : NSObject{
    
    NSObject <UserApiDelegate> *        delegate;
    enum API_CALL_TYPE                  currentCallType;
}

+ (UserApi *) sharedUserApi;
- (void)setDelegate:(NSObject <UserApiDelegate> *) apiDelegate;

- (void) getUser;
- (void) updateUser:(User *)info;
- (void) createUser:(NSString *)email password:(NSString *)password;
- (void) setContactUserInfo:(CustomerInfo *) info;
- (void) getUserCards;
- (void) resetPassword:(NSString *)email;
- (void) changePassword:(NSString *) oldPassword newPassword:(NSString *) newPassword;
- (void) deleteUserCards:(NSInteger)ccProfileId IsProduction:(BOOL)isProduction;

- (void) getUserToken;

- (void) logIn:(NSString *)email password:(NSString *)password;

@end
