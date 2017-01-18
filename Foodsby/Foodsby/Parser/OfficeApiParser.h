//
//  OfficeApiParser.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyDetail.h"

@interface OfficeApiParser : NSObject

- (void) error:(NSDictionary *) errorInfo;
- (void) didGetAllOffices:(NSArray *) info;
- (CompanyDetail *) didCreateOffice:(NSDictionary *) info;
- (CompanyDetail *) didGetOffice:(NSDictionary *) info;
- (void) didInviteOffice:(NSDictionary *) info;


+ (OfficeApiParser *)sharedOfficeApiParser;

@end
