//
//  OrderItemModifier.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItemModifier : NSObject

@property (nonatomic) NSInteger                depth;
@property (nonatomic) NSInteger                orderItemModifierId;
@property (nonatomic) NSMutableArray *         answers;

@end
