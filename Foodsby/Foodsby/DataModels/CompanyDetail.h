//
//  CompanyDetail.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyDetail : NSObject

@property (nonatomic) NSInteger         count;
@property (nonatomic) NSInteger         officeId;
@property (nonatomic) NSString *        officeName;
@property (nonatomic) NSInteger         validatedAddressId;
@property (nonatomic) NSInteger         deliveryLocationId;
@property (nonatomic) NSString *        deliveryLine1;
@property (nonatomic) NSString *        lastLine;
@property (nonatomic) NSString *        longitude;
@property (nonatomic) NSString *        latitude;

@end
