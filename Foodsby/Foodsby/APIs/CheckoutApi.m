//
//  CheckoutApi.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CheckoutApi.h"
#import "AFNetworking.h"


#define URL_CHECKOUTSAVEDCARD           API_URL(@"checkout/savedcard")
#define URL_CHECKOUTCARD                API_URL(@"checkout")
#define URL_CHECKOUTFREEMEAL            API_URL(@"checkout/freemeal")


@implementation CheckoutApi

static CheckoutApi * sharedCheckoutApi = nil;

+ (CheckoutApi *) sharedCheckoutApi {
    
    if (sharedCheckoutApi == nil) {
        
        sharedCheckoutApi = [[CheckoutApi alloc] init];
    }
    
    return sharedCheckoutApi;
}

- (void)setDelegate:(NSObject <CheckoutApiDelegate> *) checkoutApiDelegate{
    
    delegate = checkoutApiDelegate;
}

#pragma mark - ()

- (void) checkoutSavedCard:(NSInteger )orderId cCProfileId:(NSInteger)ccProfileId isProduction:(BOOL) isProduction {
    
    //Checkout with a saved card
    
    currentCallType = CHECKOUTSAVEDCARD;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", orderId] forKey:@"OrderId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", ccProfileId] forKey:@"CCProfileId"];
    [parameters setObject:[NSString stringWithFormat:@"%d", isProduction] forKey:@"IsProduction"];
    
    [self postRequest:URL_CHECKOUTSAVEDCARD parameters:parameters];
}

- (void) checkoutCard:(CheckoutInfo * ) info {

    //Checkout with manual entry of a credit card
    
    currentCallType = CHECKOUTCARD;

    NSMutableDictionary * payment = [[NSMutableDictionary alloc] init];
    [payment setObject:info.payment.fistName forKey:@"FirstName"];
    [payment setObject:info.payment.lastName forKey:@"LastName"];
    [payment setObject:info.payment.cardNbr forKey:@"CardNbr"];
    [payment setObject:[NSString stringWithFormat:@"%ld", info.payment.expMonth] forKey:@"ExpMonth"];
    [payment setObject:[NSString stringWithFormat:@"%ld", info.payment.expYear] forKey:@"ExpYear"];
    [payment setObject:info.payment.cVV2 forKey:@"CVV2"];
    [payment setObject:[NSString stringWithFormat:@"%lf", info.payment.amount] forKey:@"Amount"];
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", info.orderId] forKey:@"OrderId"];
    [parameters setObject:info.street forKey:@"Street"];
    [parameters setObject:info.city forKey:@"City"];
    [parameters setObject:info.state forKey:@"State"];
    [parameters setObject:info.zip forKey:@"Zip"];
    [parameters setObject:payment forKey:@"Payment"];
    
    [parameters setObject:[NSString stringWithFormat:@"%d", info.saveCard] forKey:@"SaveCard"];
    [parameters setObject:[NSString stringWithFormat:@"%d", info.isProduction] forKey:@"IsProduction"];

    [self postRequest:URL_CHECKOUTCARD parameters:parameters];
    
}

- (void) checkoutFreeMeal:(NSInteger) orderId {
    
    //Checkout with a free meal
    
    currentCallType = CHECKOUTFREEMEAL;
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", orderId] forKey:@"OrderId"];
    
    [self postRequest:URL_CHECKOUTFREEMEAL parameters:parameters];
    
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
        
        if (currentCallType == CHECKOUTSAVEDCARD) {
            
            if([delegate respondsToSelector:@selector(didCheckoutSavedCard:)])
                [delegate didCheckoutSavedCard:responseObject];
            
        } else if (currentCallType == CHECKOUTCARD) {
            
            if([delegate respondsToSelector:@selector(didCheckoutCard:)])
                [delegate didCheckoutCard:responseObject];
            
        } else if (currentCallType == CHECKOUTFREEMEAL) {
            
            if([delegate respondsToSelector:@selector(didCheckoutFreeMeal:)])
                [delegate didCheckoutFreeMeal:responseObject];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        if ([delegate respondsToSelector:@selector(error:)])
            [delegate error:[error userInfo]];
        
    }];
}

@end
