//
//  Exception.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exception : NSObject

@property (nonatomic) NSInteger                     globalExceptionId;
@property (nonatomic) NSString *                    exceptionDate;
@property (nonatomic) NSInteger                     duration;

@end
