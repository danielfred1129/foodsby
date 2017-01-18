//
//  ExceptionApiParser.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "ExceptionApiParser.h"
#import "Utils.h"

@implementation ExceptionApiParser

static ExceptionApiParser * sharedExceptionApiParser = nil;

+ (ExceptionApiParser *) sharedExceptionApiParser {
    
    if (sharedExceptionApiParser == nil) {
        
        sharedExceptionApiParser = [[ExceptionApiParser alloc] init];
    }
    
    return sharedExceptionApiParser;
}

#pragma mark - ExceptionApiParserDelegate methods parsing

- (void) error:(NSDictionary *)errorInfo {
    
}

- (void) didGetAllGlobalException:(NSArray *)info {

    if ([Utils sharedUtils].arrayExceptions.count > 0)
        [[Utils sharedUtils].arrayExceptions removeAllObjects];
    
    for (int i = 0 ; i < info.count ; i ++) {
        
        NSDictionary * dict = [info objectAtIndex:i];
        Exception * exception = [[Exception alloc] init];
        exception.globalExceptionId = [[dict objectForKey:@"GlobalExceptionId"] integerValue];
        exception.exceptionDate = [dict objectForKey:@"ExceptionDate"];
        exception.duration = [[dict objectForKey:@"Duration"] integerValue];
        
        [[Utils sharedUtils].arrayExceptions addObject:exception];
    }
}

- (void) didGetOpenTodayException:(BOOL) info {
    
    
}

@end
