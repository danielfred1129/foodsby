//
//  CheckoutCard.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckoutOrderDetails.h"
#import "CheckoutReceiptDetails.h"
#import "CheckoutOrderItem.h"

@interface CheckoutCard : NSObject

@property (nonatomic) BOOL                          success;
@property (nonatomic) NSString *                    message;
@property (nonatomic) CheckoutOrderDetails *        orderDetails;
@property (nonatomic) CheckoutReceiptDetails *      receiptDetails;

@end
