//
//  CustomerInfo.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/5/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerInfo : NSObject

@property (nonatomic) NSString *    fistName;
@property (nonatomic) NSString *    lastName;
@property (nonatomic) NSString *    phone;
@property (nonatomic) BOOL          smsNotify;

@end
