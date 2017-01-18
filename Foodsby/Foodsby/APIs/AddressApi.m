//
//  AddressApi.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "AddressApi.h"
#import "AFNetworking.h"

#define URL_ADDRESSVALIDATE                API_URL(@"address/validate")
#define URL_DELIVERYADDRESS                API_URL(@"address/%lu")


@implementation AddressApi

static AddressApi * sharedAddressApi = nil;

+ (AddressApi *) sharedAddressApi {
    
    if (sharedAddressApi == nil) {
        
        sharedAddressApi = [[AddressApi alloc] init];
    }
    
    return sharedAddressApi;
} 

- (void)setDelegate:(NSObject <AddressApiDelegate> *) apiDelegate{
    
    delegate = apiDelegate;
}


#pragma mark - ()

- (void) validateAddress:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(NSString *) zip {

    //Validates a given address
    
    currentCallType = ADDRESSVALIDATE;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:street forKey:@"Street"];
    [parameters setObject:city forKey:@"City"];
    [parameters setObject:state forKey:@"State"];
    [parameters setObject:zip forKey:@"Zip"];
    
    [self postRequest:URL_ADDRESSVALIDATE parameters:parameters];
}

- (void) getDevliveryAddress:(NSInteger) addressId {
    
    //Retrieves delivery locations and offices for a given validated address id
    
    currentCallType = DELIVERYADDRESS;
    
    NSString * url = [NSString stringWithFormat:URL_DELIVERYADDRESS, addressId];
    
    [self getRequest:url parameters:nil];
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
        
        if (currentCallType == ADDRESSVALIDATE) {
            
            if([delegate respondsToSelector:@selector(didValidateAddress:)])
                [delegate didValidateAddress:responseObject];
            
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
        
        if (currentCallType == DELIVERYADDRESS) {
            
            if([delegate respondsToSelector:@selector(didGetDeliveryAddress:)])
                [delegate didGetDeliveryAddress:responseObject];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];
        
    }];
}

@end
