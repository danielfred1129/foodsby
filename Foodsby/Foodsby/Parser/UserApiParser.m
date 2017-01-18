//
//  UserApiParser.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserApiParser.h"
#import "Utils.h"

@implementation UserApiParser

static UserApiParser * sharedUserApiParser = nil;

+ (UserApiParser *) sharedUserApiParser {
    
    if (sharedUserApiParser == nil) {
        
        sharedUserApiParser = [[UserApiParser alloc] init];
    }
    
    return sharedUserApiParser;
}

#pragma mark - UserApiParserDelegate methods parsing

- (void) error:(NSDictionary *)errorInfo {
    
    
}

- (void) didGetUser:(NSDictionary *) info {
    
    [Utils sharedUtils].user.userId = [[info objectForKey:@"UserId"] integerValue];
    [Utils sharedUtils].user.inviteCode = [info objectForKey:@"InviteCode"];
    [Utils sharedUtils].user.userName = (NSString *) [Utils utilsObject:[info objectForKey:@"UserName"]];
    [Utils sharedUtils].user.email = (NSString *) [Utils utilsObject:[info objectForKey:@"Email"]];
    [Utils sharedUtils].user.firstName = (NSString *) [Utils utilsObject:[info objectForKey:@"FirstName"]];
    [Utils sharedUtils].user.lastName = (NSString *) [Utils utilsObject:[info objectForKey:@"LastName"]];
    [Utils sharedUtils].user.phone = (NSString *) [Utils utilsObject:[info objectForKey:@"Phone"]];
    
    if ([Utils utilsObject:[info objectForKey:@"OfficeId"]] != nil)
        [Utils sharedUtils].user.officeId = [[info objectForKey:@"OfficeId"] integerValue];
    
    if ([Utils utilsObject:[info objectForKey:@"DeliveryLocationId"]] != nil)
        [Utils sharedUtils].user.deliveryLocationId = [[info objectForKey:@"DeliveryLocationId"] integerValue];
    
    [Utils sharedUtils].user.created = [info objectForKey:@"Created"];
    [Utils sharedUtils].user.birthday = [info objectForKey:@"Birthday"];
    [Utils sharedUtils].user.status = [[info objectForKey:@"Status"] integerValue];
    [Utils sharedUtils].user.token = [info objectForKey:@"Token"];
    [Utils sharedUtils].user.tokenExpire = [info objectForKey:@"TokenExpire"];
    [Utils sharedUtils].user.smsNotify = [[info objectForKey:@"SMSNotify"] boolValue];

}

- (void) didUpdateUser:(NSDictionary *) info {
    
    [self didGetUser:info];
}

- (void) didSetContactUserInfo:(NSDictionary *)info {
    
    [self didGetUser:info];
}

- (void) didCreateUser:(NSDictionary *)info {
    
    
    [[UserApi sharedUserApi] getUserToken];
}

- (void) didLogIn:(NSDictionary *) info {
    
    [[UserApi sharedUserApi] getUserToken];
}

- (void) didGetUserToken:(NSDictionary *)info {
    
    [[UserApi sharedUserApi] getUser];
    
//    NSString * token = [info objectForKey:@"Token"];
//    NSString * tokenExpire = [info objectForKey:@"TokenExpire"];

}

- (void) didResetPassword:(NSDictionary *)info {
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Please check your email for password reset instructions." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    
    [alert show];
    
}

- (BOOL) didChangePassword:(NSDictionary *)info {
    
    return [[info objectForKey:@"Success"] boolValue];
}

- (void) didDeleteUserCards:(NSDictionary *) info {
    
    BOOL    bSuccess = [info objectForKey:@"Success"];
    NSString *  message = [info objectForKey:@"Message"];
    
    if (bSuccess == YES)
        NSLog(@"Message - %@", message);
    else
        NSLog(@"Failed - %@", message);

}

- (void) didGetUserCards:(NSArray *) info {
    
    if ([Utils sharedUtils].arrayCards.count > 0)
        [[Utils sharedUtils].arrayCards removeAllObjects];
    
    for (int i = 0 ; i < info.count ; i ++) {
        
        UserCard * card = [[UserCard alloc] init];
        NSDictionary * dict = [info objectAtIndex:i];
        
        card.lastFour = [dict objectForKey:@"LastFour"];
        card.token = [dict objectForKey:@"Token"];
        card.cCProfileId = [[dict objectForKey:@"CCProfileId"] integerValue];
        
        [[Utils sharedUtils].arrayCards addObject:card];
    }
    
    if (info.count > 0) {
        
        UserCard * card = [[Utils sharedUtils].arrayCards objectAtIndex:0];
        
        [Utils sharedUtils].preferredCard = card.cCProfileId;
    }
        
}

@end
