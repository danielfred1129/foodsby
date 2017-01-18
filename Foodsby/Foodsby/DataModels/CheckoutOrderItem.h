//
//  CheckoutOrderItem.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckoutOrderItem : NSObject

@property (nonatomic) NSInteger                     orderItemHistoryId;
@property (nonatomic) NSInteger                     orderHistoryId;
@property (nonatomic) NSString *                    specialInstructions;
@property (nonatomic) NSInteger                     menuItemId;
@property (nonatomic) NSString *                    itemName;
@property (nonatomic) double                        price;

@end
