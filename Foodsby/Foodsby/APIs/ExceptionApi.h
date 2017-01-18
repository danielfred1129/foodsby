//
//  ExceptionApi.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@class ExceptionApi;

@protocol ExceptionApiDelegate

@required

- (void) error:(NSDictionary *) errorInfo;

@optional

- (void) didGetAllGlobalException:(NSArray *) info;
- (void) didGetOpenTodayException:(BOOL) info;

@end

@interface ExceptionApi : NSObject {
    
    NSObject <ExceptionApiDelegate> *           delegate;
    enum API_CALL_TYPE                          currentCallType;
}

+ (ExceptionApi *) sharedExceptionApi;
- (void)setDelegate:(NSObject <ExceptionApiDelegate> *) apiDelegate;

- (void) getAllGlobalException;
- (void) getOpenTodayException;

@end
