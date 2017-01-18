//
//  OrderHistory.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHistory : NSObject

@property (nonatomic) NSInteger                 orderHistoryId;
@property (nonatomic) NSString *                additionalInstructions;
@property (nonatomic) NSMutableArray *          orderItems;

@end
