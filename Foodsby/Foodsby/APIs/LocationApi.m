//
//  LocationApi.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "LocationApi.h"
#import "AFNetworking.h"

#define URL_GETLOCATIONSCHEDULE                             API_URL(@"location/%ld/schedule")
#define URL_GETDELIVERYLOCATIONS                            API_URL(@"location")
#define URL_GETSPECIFICDELIVERYLOCATIONS                    API_URL(@"location/%ld")


@implementation LocationApi

static LocationApi * sharedLocationApi = nil;

+ (LocationApi *) sharedLocationApi {
    
    if (sharedLocationApi == nil) {
        
        sharedLocationApi = [[LocationApi alloc] init];
    }
    
    return sharedLocationApi;
}

- (void)setDelegate:(NSObject <LocationApiDelegate> *) apiDelegate{
    
    delegate = apiDelegate;
}


#pragma mark - ()

- (void) getLocationSchedule:(NSInteger) locationId {
    
    //Retrieves the schedule for a given Delivery Location Id
    
    currentCallType = GETLOCATIONSCHEDULE;
    
    NSString * url = [NSString stringWithFormat:URL_GETLOCATIONSCHEDULE, locationId];
    
    [self getRequest:url parameters:nil];

}

- (void) getDeliveryLocations {
    
    //Retrieves all Delivery Locations
    
    currentCallType = GETDELIVERYLOCATIONS;
    
    [self getRequest:URL_GETDELIVERYLOCATIONS parameters:nil];
}

- (void) getSpecificDeliveryLocation:(NSInteger) locationId{
    
    //Retrieves a specific Delivery Location for a given Id
    
    currentCallType = GETSPECIFICDELIVERYLOCATION;
    
    NSString * url = [NSString stringWithFormat:URL_GETSPECIFICDELIVERYLOCATIONS, locationId];

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
        
        if (currentCallType == GETLOCATIONSCHEDULE) {
            
            if([delegate respondsToSelector:@selector(didGetLocationSchedule:)])
                [delegate didGetLocationSchedule:responseObject];
            
        } else if (currentCallType == GETDELIVERYLOCATIONS) {
            
            if([delegate respondsToSelector:@selector(didGetDeliveryLocations:)])
                [delegate didGetDeliveryLocations:responseObject];
            
        } else if (currentCallType == GETSPECIFICDELIVERYLOCATION) {
            
            if([delegate respondsToSelector:@selector(didGetSpecificDeliveryLocation:)])
                [delegate didGetSpecificDeliveryLocation:responseObject];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];
        
    }];
}

@end
