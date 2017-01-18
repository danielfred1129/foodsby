//
//  OrderItemModifierAnswer.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItemModifierAnswer : NSObject

@property (nonatomic) NSInteger                answerId;
@property (nonatomic) NSString *               itemName;
@property (nonatomic) double                   price;

@end
