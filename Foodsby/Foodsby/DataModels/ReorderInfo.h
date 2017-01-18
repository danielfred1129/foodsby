//
//  ReorderInfo.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/5/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReorderInfo : NSObject

@property (nonatomic) NSInteger         orderHistoryId;
@property (nonatomic) NSInteger         dayOfWeek;
@property (nonatomic) NSInteger         storeId;
@property (nonatomic) NSInteger         deliveryTimeId;
@property (nonatomic) NSInteger         deliveryLocationId;

@end
