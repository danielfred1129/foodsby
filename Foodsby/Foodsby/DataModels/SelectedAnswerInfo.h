//
//  SelectedAnswerInfo.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/5/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedAnswerInfo : NSObject

@property (nonatomic) NSInteger         answerId;
@property (nonatomic) BOOL              selected;
@property (nonatomic) NSInteger         depth;

@end
