//
//  OfficeApi.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OfficeApi.h"
#import "AFNetworking.h"

#define URL_CREATEOFFICE                API_URL(@"office")
#define URL_INVITEOFFICE                API_URL(@"office/invite")
#define URL_GETOFFICE                   API_URL(@"office/%ld")
#define URL_GETALLOFFICES               API_URL(@"office")


@implementation OfficeApi

static OfficeApi * sharedOfficeApi = nil;

+ (OfficeApi *) sharedOfficeApi {
    
    if (sharedOfficeApi == nil) {
        
        sharedOfficeApi = [[OfficeApi alloc] init];
    }
    
    return sharedOfficeApi;
}

- (void)setDelegate:(NSObject <OfficeApiDelegate> *) apiDelegate{
    
    delegate = apiDelegate;
}

#pragma mark - ()

- (void) createOffice:(NSString *)companyName isCandidateAddress:(BOOL)isCandidateAddress selectedAddressId:(NSInteger) selectedAddressId {

    //Create an office
    
    currentCallType = CREATEOFFICE;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:companyName forKey:@"CompanyName"];
    
    NSString * bValue = @"true";
    if (isCandidateAddress == NO)
        bValue = @"false";
    
    [parameters setObject:bValue forKey:@"IsCandidateAddress"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", selectedAddressId] forKey:@"SelectedAddressId"];
    
    [self postRequest:URL_CREATEOFFICE parameters:parameters];

}

- (void) inviteOffice:(NSString *)emails officeId:(NSInteger)officeId {
    
    //Invite given emails to the given office
    
    currentCallType = INVITEOFFICE;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:emails forKey:@"InviteEmails"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", officeId] forKey:@"OfficeId"];
    
    [self postRequest:URL_INVITEOFFICE parameters:parameters];
}

- (void) getOffice:(NSInteger)officeId {
    
    //Retrieves an office for a given Id
    
    currentCallType = GETOFFICE;
    
    NSString * url = [NSString stringWithFormat:URL_GETOFFICE, officeId];
    
    [self getRequest:url parameters:nil];

}

- (void) getAllOffices {
    
    //Gets all offices
    
    currentCallType = GETALLOFFICES;
    
    [self getRequest:URL_GETALLOFFICES parameters:nil];
}

#pragma mark - API Call

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
        
        if (currentCallType == CREATEOFFICE) {
            
            if([delegate respondsToSelector:@selector(didCreateOffice:)])
                [delegate didCreateOffice:responseObject];
            
        } else if (currentCallType == INVITEOFFICE) {
            
            if([delegate respondsToSelector:@selector(didInviteOffice:)])
                [delegate didInviteOffice:responseObject];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
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
        
        NSLog(@"JSON: %@", responseObject);
        
        if (currentCallType == GETOFFICE) {
            
            if([delegate respondsToSelector:@selector(didGetOffice:)])
                [delegate didGetOffice:responseObject];
            
        } else if (currentCallType == GETALLOFFICES) {
            
            if([delegate respondsToSelector:@selector(didGetAllOffices:)])
                [delegate didGetAllOffices:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];
        
    }];
}

@end
