//
//  PaymentInfo.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentInfo : NSObject

@property (nonatomic) NSString *    fistName;
@property (nonatomic) NSString *    lastName;
@property (nonatomic) NSString *    cardNbr;
@property (nonatomic) NSInteger     expMonth;
@property (nonatomic) NSInteger     expYear;
@property (nonatomic) NSString *    cVV2;
@property (nonatomic) double        amount;

@end
