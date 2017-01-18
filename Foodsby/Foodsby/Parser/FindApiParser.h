//
//  FindApiParser.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyDetail.h"

@interface FindApiParser : NSObject

- (void) error:(NSDictionary *)errorInfo;
- (NSMutableArray *) didSearchOffice:(NSArray *)info;
- (NSMutableArray *) didSearchCompanyDetails:(NSArray *) info;


+ (FindApiParser *)sharedFindApiParser;

@end
