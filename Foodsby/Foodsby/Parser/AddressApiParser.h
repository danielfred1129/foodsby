//
//  AddressApiParser.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeliveryLocationsAndOffices.h"
#import "ValidatedAddress.h"

@interface AddressApiParser : NSObject

- (void) error:(NSDictionary *) errorInfo;
- (DeliveryLocationsAndOffices *) didGetDeliveryAddress:(NSDictionary *)info;
- (ValidatedAddress *) didValidateAddress:(NSDictionary *)info;

+ (AddressApiParser *)sharedAddressApiParser;

@end
