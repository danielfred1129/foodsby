//
//  UserApi.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "UserApi.h"
#import "AFNetworking.h"

#define URL_CREATEUSER              API_URL(@"user/createuser")
#define URL_GETUSERTOKEN            API_URL(@"token")
#define URL_GETUSER                 API_URL(@"user")
#define URL_LOGIN                   API_URL(@"login")
#define URL_RESETPASSWORD           API_URL(@"user/resetpassword")
#define URL_UPDATEUSER              API_URL(@"user")
#define URL_SETCONTACTUSERINFO      API_URL(@"user")
#define URL_CHANGEPASSWORD          API_URL(@"user/changepassword")
#define URL_GETUSERCARDS            API_URL(@"user/cards")
#define URL_DELETEUSERCARDS         API_URL(@"user/cards/delete")


@implementation UserApi

static UserApi * sharedUserApi = nil;

+ (UserApi *) sharedUserApi {
    
    if (sharedUserApi == nil) {
        
        sharedUserApi = [[UserApi alloc] init];
    }
    
    return sharedUserApi;
}

- (void)setDelegate:(NSObject <UserApiDelegate> *) apiDelegate{
    
    delegate = apiDelegate;
}

#pragma mark -

- (void) createUser:(NSString*)email password:(NSString *) password{
    
    //Create a user
    
    currentCallType = CREATEUSER;
    
    [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:email forKey:@"Email"];
    [parameters setObject:password forKey:@"Password"];
    [parameters setObject:@"0" forKey:@"SMSNotify"];
    
//    [parameters setObject:@"1" forKey:@"DeliveryLocationId"];
//    [parameters setObject:@"1" forKey:@"OfficeId"];

    [self postCreateUserRequest:URL_CREATEUSER parameters:parameters];
}

- (void) getUserToken{
    
    //Get the token for the current user
    
    currentCallType = GETUSERTOKEN;
    
    [self getRequest:URL_GETUSERTOKEN parameters:nil];
}

- (void) getUser {
    
    //Retrieves the current user
    
    currentCallType = GETUSER;
    
    [self getRequest:URL_GETUSER parameters:nil];
}

- (void) logIn:(NSString*)email password:(NSString *)password {
    
    //Login
    
    currentCallType = LOGIN;
    
    [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self getRequest:URL_LOGIN parameters:nil];
}

- (void) resetPassword:(NSString *)email {
    
    //Reset the password of the current user
    
    currentCallType = RESETPASSWORD;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:email forKey:@"email"];

    [self postRequest:URL_RESETPASSWORD parameters:parameters ];
}

- (void) updateUser:(User *)info {
    
    //Update the current user
    
    currentCallType = UPDATEUSER;

    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:info.firstName forKey:@"FirstName"];
    [parameters setObject:info.lastName forKey:@"LastName"];
    [parameters setObject:info.phone forKey:@"Phone"];
    [parameters setObject:[NSString stringWithFormat:@"%d", info.smsNotify] forKey:@"SMSNotify"];
    [parameters setObject:info.birthday forKey:@"Birthday"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", info.deliveryLocationId] forKey:@"DeliveryLocationId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", info.officeId] forKey:@"OfficeId"];
    
    [self postRequest:URL_UPDATEUSER parameters:parameters ];
}

- (void) setContactUserInfo:(CustomerInfo *) info {
    
    //set contact user info
    
    currentCallType = SETCONTACTUSERINFO;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:info.fistName forKey:@"FirstName"];
    [parameters setObject:info.lastName forKey:@"LastName"];
    [parameters setObject:[NSString stringWithFormat:@"%d", info.smsNotify] forKey:@"SMSNotify"];
    [parameters setObject:info.phone forKey:@"Phone"];
    
    [self postRequest:URL_SETCONTACTUSERINFO parameters:parameters ];
}

- (void) changePassword:(NSString *) oldPassword newPassword:(NSString *) newPassword {
    
    //Change the password of the current user
    
    currentCallType = CHANGEPASSWORD;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:oldPassword forKey:@"OldPassword"];
    [parameters setObject:newPassword forKey:@"NewPassword"];
    
    [self postRequest:URL_CHANGEPASSWORD parameters:parameters ];
}

- (void) getUserCards {
    
    //Get the Credit Card profile information for the user
    
    currentCallType = GETUSERCARDS;
    
    [self getRequest:URL_GETUSERCARDS parameters:nil];
}

- (void) deleteUserCards:(NSInteger)ccProfileId IsProduction:(BOOL)isProduction {
    
    //Delete a Credit Card profile on the current user's account
    
    currentCallType = DELETEUSERCARDS;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", ccProfileId] forKey:@"CCProfileId"];
    [parameters setObject:[NSString stringWithFormat:@"%d", isProduction] forKey:@"IsProduction"];
    
    [self postRequest:URL_DELETEUSERCARDS parameters:parameters];
}

#pragma mark - API Call

- (void) postCreateUserRequest:(NSString *)path parameters:(NSDictionary*)parameters{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.requestSerializer = requestSerializer;
    
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        if (currentCallType == CREATEUSER) {
            
            if([delegate respondsToSelector:@selector(didCreateUser:)])
                [delegate didCreateUser:responseObject];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);

        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];

    }];
}

- (void) postRequest:(NSString *)path parameters:(NSDictionary*)parameters{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.requestSerializer = requestSerializer;
    
    //adding Authorization in Header
    NSString * email =  [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    [requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        if (currentCallType == RESETPASSWORD) {

            if([delegate respondsToSelector:@selector(didResetPassword:)])
                [delegate didResetPassword:responseObject];
            
        } else if (currentCallType == UPDATEUSER) {
            
            if([delegate respondsToSelector:@selector(didUpdateUser:)])
                [delegate didUpdateUser:responseObject];

        } else if (currentCallType == SETCONTACTUSERINFO) {
            
            if([delegate respondsToSelector:@selector(didSetContactUserInfo:)])
                [delegate didSetContactUserInfo:responseObject];
            
        } else if (currentCallType == CHANGEPASSWORD) {
            
            if([delegate respondsToSelector:@selector(didChangePassword:)])
                [delegate didChangePassword:responseObject];
            
        } else if (currentCallType == DELETEUSERCARDS) {
            
            if([delegate respondsToSelector:@selector(didDeleteUserCards:)])
                [delegate didDeleteUserCards:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Error: %@", error);
        
        NSString * errorDescription = [error.userInfo objectForKey:@"NSLocalizedDescription"];

        if ([errorDescription rangeOfString:@"409"].location != NSNotFound) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"A user with that email address has already registered with Foodsby." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            
            [alert show];            
        }
        
        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];
        
    }];
}

- (void) getRequest:(NSString *)path parameters:(NSDictionary*)parameters{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];

    manager.requestSerializer = requestSerializer;

    //adding Authorization in Header
    NSString * email =  [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    [requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    
    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@ \n Status :%ld", responseObject, operation.response.statusCode);
        
        if (currentCallType == GETUSERTOKEN) {
            
            if([delegate respondsToSelector:@selector(didGetUserToken:)])
                [delegate didGetUserToken:responseObject];
            
        } else if (currentCallType == GETUSER) {
            
            if([delegate respondsToSelector:@selector(didGetUser:)])
                [delegate didGetUser:responseObject];
            
        } else if (currentCallType == LOGIN) {
            
            if([delegate respondsToSelector:@selector(didLogIn:)])
                [delegate didLogIn:responseObject];
            
        } else if (currentCallType == GETUSERCARDS) {
            
            if([delegate respondsToSelector:@selector(didGetUserCards:)])
                [delegate didGetUserCards:responseObject];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];
        
    }];
}

@end
