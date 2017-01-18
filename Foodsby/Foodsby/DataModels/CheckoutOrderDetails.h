//
//  CheckoutOrderDetails.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckoutOrderDetails : NSObject

@property (nonatomic) NSInteger                     orderHistoryId;
@property (nonatomic) NSInteger                     orderId;
@property (nonatomic) NSInteger                     storeId;
@property (nonatomic) NSString *                    storeName;
@property (nonatomic) NSInteger                     userId;
@property (nonatomic) NSString *                    userName;
@property (nonatomic) NSInteger                     deliveryTimeId;
@property (nonatomic) NSString *                    dropoffTime;
@property (nonatomic) NSInteger                     deliveryId;
@property (nonatomic) NSString *                    cutoffTime;
@property (nonatomic) NSString *                    orderDate;
@property (nonatomic) NSInteger                     orderStatusId;
@property (nonatomic) NSString *                    orderStatus;
@property (nonatomic) NSString *                    additionalInstructions;
@property (nonatomic) NSMutableArray *              orderItems;
@property (nonatomic) NSString *                    created;
@property (nonatomic) NSString *                    recorded;
@property (nonatomic) NSInteger                     couponId;
@property (nonatomic) NSString *                    couponCode;
@property (nonatomic) double                        itemSubTotal;
@property (nonatomic) double                        couponSubTotal;
@property (nonatomic) double                        taxSubTotal;
@property (nonatomic) double                        storeFee;
@property (nonatomic) double                        foodsbyFee;
@property (nonatomic) double                        orderTotal;
@property (nonatomic) NSString *                    transactionId;
@property (nonatomic) NSInteger                     deliveryLocationId;
@property (nonatomic) NSString *                    locationName;
@property (nonatomic) NSInteger                     restaurantId;
@property (nonatomic) NSString *                    restaurantName;

@end
