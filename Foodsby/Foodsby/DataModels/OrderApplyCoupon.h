//
//  OrderApplyCoupon.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"

@interface OrderApplyCoupon : NSObject

@property (nonatomic) BOOL                          success;
@property (nonatomic) NSString *                    message;
@property (nonatomic) Order *                       order;

@end
