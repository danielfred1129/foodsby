//
//  FindApiParser.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "FindApiParser.h"

@implementation FindApiParser

static FindApiParser * sharedFindApiParser = nil;

+ (FindApiParser *) sharedFindApiParser {
    
    if (sharedFindApiParser == nil) {
        
        sharedFindApiParser = [[FindApiParser alloc] init];
    }
    
    return sharedFindApiParser;
}


#pragma mark - FindApiParserDelegate methods parsing

- (void) error:(NSDictionary *)errorInfo {
    
    
}

- (NSMutableArray *) didSearchOffice:(NSArray *)info {
    
    NSMutableArray * arrayOffices = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < info.count ; i ++) {
        
        [arrayOffices addObject:[info objectAtIndex:i]];
    }
    
    return arrayOffices;
}

- (NSMutableArray *) didSearchCompanyDetails:(NSArray *) info {
 
    NSMutableArray * arrayCompanyDetails = [[NSMutableArray alloc] init];
    
    for ( int i = 0 ; i < info.count ; i ++) {
        
        CompanyDetail * companyDetail = [[CompanyDetail alloc] init];
        NSDictionary * dict = [info objectAtIndex:i];
        
        companyDetail.count = [[dict objectForKey:@"Count"] integerValue];
        companyDetail.officeId = [[dict objectForKey:@"OfficeId"] integerValue];
        companyDetail.officeName = [dict objectForKey:@"OfficeName"];
        companyDetail.validatedAddressId = [[dict objectForKey:@"ValidatedAddressId"] integerValue];
        companyDetail.deliveryLocationId = [[dict objectForKey:@"DeliveryLocationId"] integerValue];
        companyDetail.deliveryLine1 = [dict objectForKey:@"DeliveryLine1"];
        companyDetail.lastLine = [dict objectForKey:@"LastLine"];
        companyDetail.longitude = [dict objectForKey:@"Longitude"];
        companyDetail.latitude = [dict objectForKey:@"Latitude"];
        
        [arrayCompanyDetails addObject:companyDetail];
    }
    
    return arrayCompanyDetails;
}

@end
