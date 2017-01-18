//
//  MenuAnswerItem.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuAnswerItem : NSObject

@property (nonatomic) NSInteger                     answerId;
@property (nonatomic) NSString *                    displayText;
@property (nonatomic) NSMutableArray *              questionItems;
@property (nonatomic) NSInteger                     parentQuestionId;
@property (nonatomic) BOOL                          selected;
@property (nonatomic) double                        price;
@property (nonatomic) BOOL                          showAsRadio;
@property (nonatomic) NSInteger                     depth;
@property (nonatomic) BOOL                          autoSelected;

@end
