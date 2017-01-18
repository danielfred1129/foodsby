//
//  ExceptionApiParser.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExceptionApi.h"
#import "Exception.h"

@interface ExceptionApiParser : NSObject <ExceptionApiDelegate>

- (void) error:(NSDictionary *)errorInfo;
- (void) didGetAllGlobalException:(NSArray *)info;
- (void) didGetOpenTodayException:(BOOL) info;

    
+ (ExceptionApiParser *)sharedExceptionApiParser;

@end
