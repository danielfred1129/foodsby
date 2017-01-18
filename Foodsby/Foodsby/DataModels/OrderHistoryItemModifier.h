//
//  OrderHistoryItemModifier.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHistoryItemModifier : NSObject

@property (nonatomic) NSString *                    questionName;
@property (nonatomic) NSMutableArray *              answers;
@property (nonatomic) NSInteger                     depth;

@end
