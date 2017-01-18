//
//  DeliveryOffice.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryOffice : NSObject

@property (nonatomic) NSInteger                     officeId;
@property (nonatomic) NSString *                    officeName;
@property (nonatomic) NSInteger                     deliveryLocationId;

@end
