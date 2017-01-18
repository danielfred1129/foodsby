//
//  DeliveryLocation.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/6/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryLocation : NSObject

@property (nonatomic) NSInteger         deliveryLocationId;
@property (nonatomic) NSString *        locationName;
@property (nonatomic) NSString *        dropoffInstruction;
@property (nonatomic) NSString *        pickupInstruction;
@property (nonatomic) NSString *        deliveryLine1;
@property (nonatomic) NSString *        lastLine;
@property (nonatomic) NSString *        longitude;
@property (nonatomic) NSString *        latitude;

@end
