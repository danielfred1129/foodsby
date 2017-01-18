//
//  SubMenu.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubMenu : NSObject

@property (nonatomic) NSInteger                     subMenuId;
@property (nonatomic) NSString *                    subMenuName;
@property (nonatomic) NSMutableArray *              menuItems;
@property (nonatomic) NSString *                    subMenuDescription;

@end
