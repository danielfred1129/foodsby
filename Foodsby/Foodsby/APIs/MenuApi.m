//
//  MenuApi.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "MenuApi.h"
#import "AFNetworking.h"

#define URL_GETMENU             API_URL(@"menu")
#define URL_GETMENUITEM         API_URL(@"menu/item/%lu")


@implementation MenuApi

static MenuApi * sharedMenuApi = nil;

+ (MenuApi *) sharedMenuApi {
    
    if (sharedMenuApi == nil) {
        
        sharedMenuApi = [[MenuApi alloc] init];
    }
    
    return sharedMenuApi;
}

- (void)setDelegate:(NSObject <MenuApiDelegate> *) apiDelegate{
    
    delegate = apiDelegate;
}


#pragma mark - ()

- (void) getMenu:(MenuInfo *) menu {
    
    //Retrieve a menu
    
    currentCallType = GETMENU;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:[NSString stringWithFormat:@"%ld", menu.deliveryTimeId] forKey:@"DeliveryTimeId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", menu.deliveryLocationId] forKey:@"DeliveryLocationId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", menu.storeId] forKey:@"StoreId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", menu.deliveryId] forKey:@"DeliveryId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", menu.dayOfWeek] forKey:@"DayOfWeek"];

    [self postRequest:URL_GETMENU parameters:parameters ];

}

- (void) getMenuItem:(NSInteger) itemId {
    
    //Retrieve an item
    
    currentCallType = GETMENUITEM;
    
    NSString * url = [NSString stringWithFormat:URL_GETMENUITEM, itemId];
    
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
        
        if (currentCallType == GETMENU) {
            
            if([delegate respondsToSelector:@selector(didGetMenu:)])
                [delegate didGetMenu:responseObject];
            
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
        
        if (currentCallType == GETMENUITEM) {
            
            if([delegate respondsToSelector:@selector(didGetMenuItem:)])
                [delegate didGetMenuItem:responseObject];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];
        
    }];
}

@end
