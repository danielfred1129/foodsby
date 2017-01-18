//
//  FindApi.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "FindApi.h"
#import "AFNetworking.h"

#define URL_SEARCHOFFICE                    API_URL(@"search/%ld")
#define URL_SEARCHCOMPANYDETAILS            API_URL(@"search/query/%ld")


@implementation FindApi

static FindApi * sharedFindApi = nil;

+ (FindApi *) sharedFindApi {
    
    if (sharedFindApi == nil) {
        
        sharedFindApi = [[FindApi alloc] init];
    }
    
    return sharedFindApi;
}

- (void)setDelegate:(NSObject <FindApiDelegate> *) apiDelegate{
    
    delegate = apiDelegate;
}


#pragma mark - ()

- (void) searchOffice:(NSInteger) officeId {
    
    //Search for an office in Foodsby's database
    
    currentCallType = SEARCHOFFICE;
    
    NSString * url = [NSString stringWithFormat:URL_SEARCHOFFICE, officeId];
    
    [self getRequest:url parameters:nil];
}

- (void) searchCompanyDetails:(NSInteger) companyId{
    
    //Search for company details in Foodsby's database
    
    currentCallType = SEARCHCOMPANYDETAILS;
    
    NSString * url = [NSString stringWithFormat:URL_SEARCHCOMPANYDETAILS, companyId];
    
    [self getRequest:url parameters:nil];
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
        
        if (currentCallType == SEARCHOFFICE) {
            
            if([delegate respondsToSelector:@selector(didSearchOffice:)])
                [delegate didSearchOffice:responseObject];
            
        } else if (currentCallType == SEARCHCOMPANYDETAILS) {
            
            if([delegate respondsToSelector:@selector(didSearchCompanyDetails:)])
                [delegate didSearchCompanyDetails:responseObject];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];
        
    }];
    
}

@end
