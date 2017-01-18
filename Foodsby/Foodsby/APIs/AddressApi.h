//
//  AddressApi.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@class AddressApi;

@protocol AddressApiDelegate

@required

- (void) error:(NSDictionary *) errorInfo;

@optional

- (void) didValidateAddress:(NSDictionary *) info;
- (void) didGetDeliveryAddress:(NSDictionary *) info;

@end

@interface AddressApi : NSObject {
    
    NSObject <AddressApiDelegate> *         delegate;
    enum API_CALL_TYPE                      currentCallType;
}

+ (AddressApi *) sharedAddressApi;
- (void)setDelegate:(NSObject <AddressApiDelegate> *) apiDelegate;

- (void) validateAddress:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(NSString *) zip;
- (void) getDevliveryAddress:(NSInteger) addressId;

@end
