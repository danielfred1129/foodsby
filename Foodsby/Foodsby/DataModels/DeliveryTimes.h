//
//  DeliveryTimes.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryTimes : NSObject

@property (nonatomic) NSString *                dropoffTime;
@property (nonatomic) NSString *                dropoffDateTime;
@property (nonatomic) NSInteger                 deliveryTimeId;
@property (nonatomic) NSInteger                 deliveryLocationId;
@property (nonatomic) NSInteger                 deliveryId;
@property (nonatomic) NSString *                deliveryName;
@property (nonatomic) BOOL                      isPending;
@property (nonatomic) BOOL                      inZone;

@end

