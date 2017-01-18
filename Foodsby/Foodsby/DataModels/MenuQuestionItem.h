//
//  MenuQuestionItem.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuQuestionItem : NSObject

@property (nonatomic) NSString *                    displayText;
@property (nonatomic) NSInteger                     questionId;
@property (nonatomic) NSMutableArray *              answerItems;
@property (nonatomic) NSInteger                     minimumSelection;
@property (nonatomic) NSInteger                     maximumSelection;
@property (nonatomic) BOOL                          showAsRadio;

@end
