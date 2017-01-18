//
//  MenuItem.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/10/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (nonatomic) NSInteger                     menuItemId;
@property (nonatomic) NSString *                    displayText;
@property (nonatomic) double                        price;
@property (nonatomic) NSString *                    menuItemDescription;
@property (nonatomic) NSString *                    specialInstructions;
@property (nonatomic) NSMutableArray *              questionItems;
@property (nonatomic) NSMutableArray *              selectedAnswers;

@end
