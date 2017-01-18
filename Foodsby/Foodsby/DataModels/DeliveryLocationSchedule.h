//
//  DeliveryLocationSchedule.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryLocationSchedule : NSObject

@property (nonatomic) NSMutableArray *          storesForLocation;
@property (nonatomic) NSMutableArray *          deliveryDaysThisWeek;
@property (nonatomic) NSString *                today;
@property (nonatomic) NSString *                locationName;

@end
