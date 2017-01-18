//
//  MenuApiParser.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuList.h"

@interface MenuApiParser : NSObject

- (void) error:(NSDictionary *)errorInfo;
- (MenuList *) didGetMenu:(NSDictionary *)info;
- (MenuItem *) didGetMenuItem:(NSDictionary *)info;

    
+ (MenuApiParser *)sharedMenuApiParser;

@end
