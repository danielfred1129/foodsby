//
//  OrderApi.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OrderApi.h"
#import "AFNetworking.h"

#define URL_APPLYCOUPONTOORDER          API_URL(@"order/applycoupon")
#define URL_REMOVEORDERITEM             API_URL(@"order/removeitem")
#define URL_GETORDER                    API_URL(@"order/%ld")
#define URL_GETORDERHISTORY             API_URL(@"order/history/%ld")
#define URL_ORDERADDITEM                API_URL(@"order/additem")
#define URL_REORDER                     API_URL(@"order/reorder")


@implementation OrderApi

static OrderApi * sharedOrderApi = nil;

+ (OrderApi *) sharedOrderApi {
    
    if (sharedOrderApi == nil) {
        
        sharedOrderApi = [[OrderApi alloc] init];
    }
    
    return sharedOrderApi;
}

- (void)setDelegate:(NSObject <OrderApiDelegate> *) apiDelegate{
    
    delegate = apiDelegate;
}

#pragma mark - ()

- (void) applyCouponToOrder:(NSInteger) orderId couponCode:(NSString *) couponCode {
    
    //Applies a coupon to a given order
    
    currentCallType = APPLYCOUPONTOORDER;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", orderId] forKey:@"OrderId"];
    [parameters setObject:couponCode forKey:@"CouponCode"];
    
    [self postRequest:URL_APPLYCOUPONTOORDER parameters:parameters];
}

- (void) removeOrderItem:(NSInteger) orderId orderItemId:(NSInteger) orderItemId {
    
    //Removes a given item from an order
    
    currentCallType = REMOVEORDERITEM;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", orderId] forKey:@"OrderId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", orderItemId] forKey:@"OrderItemId"];
    
    [self postRequest:URL_REMOVEORDERITEM parameters:parameters];
}

- (void) getOrder:(NSInteger) orderId {
    
    //Retrieves an order for a given order id

    currentCallType = GETORDER;
    
    NSString * url = [NSString stringWithFormat:URL_GETORDER, orderId];
    
    [self getRequest:url parameters:nil];
}

- (void) getOrderHistory:(NSInteger) storeId {
    
    //Retrieves orders placed for a given store by the user
    
    currentCallType = GETORDERHISTORY;
    
    NSString * url = [NSString stringWithFormat:URL_GETORDERHISTORY, storeId];
    
    [self getRequest:url parameters:nil];
}

- (void) addItemToOrder:(OrderAddItem *) info {
    
    //Adds a given item to an order
    
    currentCallType = ORDERADDITEM;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:[NSString stringWithFormat:@"%ld", info.orderId] forKey:@"OrderId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", info.menuItemId] forKey:@"MenuItemId"];
    [parameters setObject:info.specialInstructions forKey:@"SpecialInstructions"];
    
    NSMutableArray * arrayParam = [[NSMutableArray alloc] init];
    [parameters setObject:arrayParam forKey:@"SelectedAnswers"];
    
    for (SelectedAnswerInfo * object in info.selectedAnswers) {
        
        NSMutableDictionary * subParameters = [[NSMutableDictionary alloc] init];

        [subParameters setObject:[NSString stringWithFormat:@"%ld", object.answerId] forKey:@"AnswerId"];
        
        [subParameters setObject:[NSNumber numberWithBool:object.selected] forKey:@"Selected"];
        
        [subParameters setObject:[NSString stringWithFormat:@"%ld", object.depth] forKey:@"Depth"];
        
        [arrayParam addObject:subParameters];
    }
    

    //dataType: 'text',
    //contentType: 'application/json; charset=utf-8'

    [self postRequest:URL_ORDERADDITEM parameters:parameters];
}

- (void) reorder:(ReorderInfo *) info {
    
    //Reorder a previously placed order
    
    currentCallType = REORDER;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%lu", info.orderHistoryId] forKey:@"OrderHistoryId"];
    [parameters setObject:[NSString stringWithFormat:@"%lu", info.dayOfWeek] forKey:@"DayOfWeek"];
    [parameters setObject:[NSString stringWithFormat:@"%lu", info.storeId] forKey:@"StoreId"];
    [parameters setObject:[NSString stringWithFormat:@"%lu", info.deliveryTimeId] forKey:@"DeliveryTimeId"];
    [parameters setObject:[NSString stringWithFormat:@"%lu", info.deliveryLocationId] forKey:@"DeliveryLocationId"];
    
    [self postRequest:URL_REORDER parameters:parameters];
}

#pragma mark - API Call


- (void) postRequest:(NSString *)path parameters:(NSDictionary*)parameters{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    if (currentCallType == ORDERADDITEM) {
        
        AFJSONRequestSerializer * requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.requestSerializer = requestSerializer;
        
        //adding Authorization in Header
        NSString * email =  [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
        [requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
        
    } else {

        AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
        
        manager.requestSerializer = requestSerializer;
        
        //adding Authorization in Header
        NSString * email =  [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
        [requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    }
    
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        if (currentCallType == APPLYCOUPONTOORDER) {
            
            if([delegate respondsToSelector:@selector(didApplyCouponToOrder:)])
                [delegate didApplyCouponToOrder:responseObject];
            
        } else if (currentCallType == REMOVEORDERITEM) {
            
            if([delegate respondsToSelector:@selector(didRemoveOrderItem:)])
                [delegate didRemoveOrderItem:responseObject];
            
        } else if (currentCallType == ORDERADDITEM) {
            
            if([delegate respondsToSelector:@selector(didAddItemToOrder:)])
                [delegate didAddItemToOrder:responseObject];
            
        } else if (currentCallType == REORDER) {
            
            if([delegate respondsToSelector:@selector(didReorder:)])
                [delegate didReorder:responseObject];
            
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
    
    //adding Authorization in Header`
    
    NSString * email =  [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    [requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    
    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        if (currentCallType == GETORDER) {
            
            if([delegate respondsToSelector:@selector(didGetOrder:)])
                [delegate didGetOrder:responseObject];
            
        } else if (currentCallType == GETORDERHISTORY) {
            
            if([delegate respondsToSelector:@selector(didGetOrderHistory:)])
                [delegate didGetOrderHistory:responseObject];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];
        
    }];
}

@end
