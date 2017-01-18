//
//  MenuInfo.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/5/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuInfo : NSObject

@property (nonatomic) NSInteger     deliveryTimeId;
@property (nonatomic) NSInteger     deliveryLocationId;
@property (nonatomic) NSInteger     storeId;
@property (nonatomic) NSInteger     deliveryId;
@property (nonatomic) NSInteger     dayOfWeek;

@end
