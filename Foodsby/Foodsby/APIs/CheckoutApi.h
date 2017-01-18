//
//  CheckoutApi.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "CheckoutInfo.h"

@class CheckoutApi;

@protocol CheckoutApiDelegate

@required

- (void) error:(NSDictionary *) errorInfo;

@optional

- (void) didCheckoutCard:(NSDictionary *) info;
- (void) didCheckoutSavedCard:(NSDictionary *) info;
- (void) didCheckoutFreeMeal:(NSDictionary *) info;

@end

@interface CheckoutApi : NSObject {

    NSObject <CheckoutApiDelegate> *        delegate;
    enum API_CALL_TYPE                      currentCallType;
}

+ (CheckoutApi *) sharedCheckoutApi;
- (void)setDelegate:(NSObject <CheckoutApiDelegate> *) apiDelegate;

- (void) checkoutSavedCard:(NSInteger )orderId cCProfileId:(NSInteger)ccProfileId isProduction:(BOOL) isProduction;
- (void) checkoutCard:(CheckoutInfo * ) info;
- (void) checkoutFreeMeal:(NSInteger) orderId;

@end
