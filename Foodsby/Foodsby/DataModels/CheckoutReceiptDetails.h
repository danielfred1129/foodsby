//
//  CheckoutReceiptDetails.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckoutReceiptDetails : NSObject

@property (nonatomic) NSInteger                     deliveryLocationId;
@property (nonatomic) NSInteger                     orderId;
@property (nonatomic) NSString *                    transactionId;
@property (nonatomic) NSString *                    locationName;
@property (nonatomic) NSString *                    dropoffTime;
@property (nonatomic) NSString *                    orderDate;
@property (nonatomic) NSString *                    restaurantName;
@property (nonatomic) NSString *                    pickupInstruction;
@property (nonatomic) NSString *                    phone;
@property (nonatomic) BOOL                          showSMS;
@property (nonatomic) NSString *                    smsNumber;

@end
