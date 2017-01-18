//
//  CheckoutApiParser.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckoutCard.h"

@interface CheckoutApiParser : NSObject

- (void) error:(NSDictionary *) errorInfo;

- (CheckoutCard *) checkout:(NSDictionary *)info;
- (CheckoutCard *) didCheckoutCard:(NSDictionary *)info;
- (CheckoutCard *) didCheckoutSavedCard:(NSDictionary *) info;
- (CheckoutCard *) didCheckoutFreeMeal:(NSDictionary *) info;


+ (CheckoutApiParser *)sharedCheckoutApiParser;

@end
