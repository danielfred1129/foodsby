//
//  DeliveryLocationsAndOffices.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeliveryLocationForAddress.h"
#import "DeliveryOffice.h"

@interface DeliveryLocationsAndOffices : NSObject

@property (nonatomic) NSInteger                     validatedAddressId;
@property (nonatomic) NSMutableArray *              deliveryLocations;
@property (nonatomic) NSString *                    deliveryLine1;
@property (nonatomic) NSString *                    lastLine;
@property (nonatomic) NSMutableArray *              offices;
@property (nonatomic) NSString *                    latitude;
@property (nonatomic) NSString *                    longitude;

@end
