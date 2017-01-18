//
//  OrderAddItem.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/5/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderAddItem : NSObject

@property (nonatomic) NSInteger         orderId;
@property (nonatomic) NSInteger         menuItemId;
@property (nonatomic) NSString *        specialInstructions;
@property (nonatomic) NSMutableArray *  selectedAnswers;

@end
