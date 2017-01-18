//
//  MenuApi.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "MenuInfo.h"

@class MenuApi;

@protocol MenuApiDelegate

@required

- (void) error:(NSDictionary*) errorInfo;

@optional

- (void) didGetMenu:(NSDictionary*) info;
- (void) didGetMenuItem:(NSDictionary*) info;

@end

@interface MenuApi : NSObject {

    NSObject <MenuApiDelegate> *    delegate;
    enum API_CALL_TYPE              currentCallType;

}

+ (MenuApi *)sharedMenuApi;
- (void)setDelegate:(NSObject <MenuApiDelegate> *) apiDelegate;

- (void) getMenu:(MenuInfo *) menu;
- (void) getMenuItem:(NSInteger) itemId;

@end
