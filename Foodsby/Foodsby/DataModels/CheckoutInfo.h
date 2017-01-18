//
//  CheckoutInfo.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/4/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentInfo.h"

@interface CheckoutInfo : NSObject

@property (nonatomic) NSInteger     orderId;
@property (nonatomic) NSString *    street;
@property (nonatomic) NSString *    city;
@property (nonatomic) NSString *    state;
@property (nonatomic) NSString *    zip;
@property (nonatomic) PaymentInfo * payment;
@property (nonatomic) BOOL          saveCard;
@property (nonatomic) BOOL          isProduction;

@end
