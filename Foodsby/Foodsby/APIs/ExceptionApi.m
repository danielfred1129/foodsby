//
//  ExceptionApi.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "ExceptionApi.h"
#import "AFNetworking.h"

#define URL_GETALLGLOBALEXCEPTION                API_URL(@"exception")
#define URL_GETOEPNTODAYEXCEPTION                API_URL(@"exception/open")

@implementation ExceptionApi

static ExceptionApi * sharedExceptionApi = nil;

+ (ExceptionApi *) sharedExceptionApi {
    
    if (sharedExceptionApi == nil) {
        
        sharedExceptionApi = [[ExceptionApi alloc] init];
    }
    
    return sharedExceptionApi;
}

- (void)setDelegate:(NSObject <ExceptionApiDelegate> *) apiDelegate{
    
    delegate = apiDelegate;
}


#pragma mark - ()

- (void) getAllGlobalException {
    
    //Retrieves all global exceptions
    
    currentCallType = GETALLGLOBALEXCEPTION;
    
    [self getRequest:URL_GETALLGLOBALEXCEPTION parameters:nil];

}

- (void) getOpenTodayException {
    
    //Retrieves whether or not Foodsby is operational today
    
    currentCallType = GETOPENTODAYEXCEPTION;
    
    [self getRequest:URL_GETOEPNTODAYEXCEPTION parameters:nil];    
}

#pragma mark - API Call

- (void) getRequest:(NSString *)path parameters:(NSDictionary*)parameters{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.requestSerializer = requestSerializer;
    
    //adding Authorization in Header
    NSString * email =  [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    [requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    
    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        if (currentCallType == GETALLGLOBALEXCEPTION) {
            
            if([delegate respondsToSelector:@selector(didGetAllGlobalException:)])
                [delegate didGetAllGlobalException:responseObject];
            
        } else if (currentCallType == GETOPENTODAYEXCEPTION) {
            
            if([delegate respondsToSelector:@selector(didGetOpenTodayException:)])
                [delegate didGetOpenTodayException:responseObject];
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];
        
    }];
}

@end
