//
//  OrderItem.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject

@property (nonatomic) NSString *                itemName;
@property (nonatomic) double                    price;
@property (nonatomic) NSInteger                 orderItemId;
@property (nonatomic) NSString *                specialInstructions;
@property (nonatomic) NSMutableArray *          modifiers;

@end
