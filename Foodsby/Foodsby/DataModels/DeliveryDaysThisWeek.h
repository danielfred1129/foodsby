//
//  DeliveryDaysThisWeek.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryDaysThisWeek : NSObject

@property (nonatomic) NSInteger                 dayOfWeek;
@property (nonatomic) NSString *                dateOfDayForWeek;
@property (nonatomic) NSMutableArray *          stores;

@end
