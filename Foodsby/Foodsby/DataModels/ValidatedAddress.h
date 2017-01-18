//
//  ValidatedAddress.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CandidateAddress.h"

@interface ValidatedAddress : NSObject

@property (nonatomic) NSInteger                     validatedAddressId;
@property (nonatomic) NSMutableArray *              candidates;
@property (nonatomic) BOOL                          success;

@end
