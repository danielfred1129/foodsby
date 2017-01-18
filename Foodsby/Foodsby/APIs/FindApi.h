//
//  FindApi.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@class FindApi;

@protocol FindApiDelegate

@required

- (void) error:(NSDictionary *) errorInfo;

@optional

- (void) didSearchOffice:(NSArray *) info;
- (void) didSearchCompanyDetails:(NSArray *) info;

@end

@interface FindApi : NSObject {
    
    NSObject <FindApiDelegate> *        delegate;
    enum API_CALL_TYPE                  currentCallType;
}

+ (FindApi *) sharedFindApi;
- (void)setDelegate:(NSObject <FindApiDelegate> *) apiDelegate;

- (void) searchOffice:(NSInteger) officeId;
- (void) searchCompanyDetails:(NSInteger) companyId;

@end
