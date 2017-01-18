//
//  LocationApiParser.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DeliveryLocation.h"
#import "StoreForLocation.h"
#import "DeliveryTimes.h"
#import "DeliveryDaysThisWeek.h"

@interface LocationApiParser : NSObject

- (void) error:(NSDictionary *) errorInfo;
- (void) didGetDeliveryLocations:(NSArray *) info;
- (DeliveryLocation *) didGetSpecificDeliveryLocation:(NSDictionary *)info;
- (void) didGetLocationSchedule:(NSDictionary *)info;


+ (LocationApiParser *)sharedLocationApiParser;

@end
