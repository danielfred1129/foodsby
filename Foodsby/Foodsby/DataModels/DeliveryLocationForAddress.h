//
//  DeliveryLocationForAddress.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryLocationForAddress : NSObject

@property (nonatomic) NSInteger                     deliveryLocationId;
@property (nonatomic) NSString *                    locationName;
@property (nonatomic) BOOL                          active;

@end
