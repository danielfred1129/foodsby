//
//  OfficeApiParser.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "OfficeApiParser.h"
#import "Utils.h"

@implementation OfficeApiParser

static OfficeApiParser * sharedOfficeApiParser = nil;

+ (OfficeApiParser *) sharedOfficeApiParser {
    
    if (sharedOfficeApiParser == nil) {
        
        sharedOfficeApiParser = [[OfficeApiParser alloc] init];
    }
    
    return sharedOfficeApiParser;
}


#pragma mark - OfficeApiParserDelegate methods parsing

- (void) error:(NSDictionary *) errorInfo {
    
    
}

- (void) didGetAllOffices:(NSArray *) info {
    
    if ([Utils sharedUtils].arrayAllOffices > 0)
        [[Utils sharedUtils].arrayAllOffices removeAllObjects];
    
    for (int i = 0 ; i < info.count ; i ++) {
        
        NSDictionary * dict = [info objectAtIndex:i];
        CompanyDetail * office = [[CompanyDetail alloc] init];
        
        if ([Utils utilsObject:[dict objectForKey:@"OfficeId"]] != nil)
            office.officeId = [[dict objectForKey:@"OfficeId"] integerValue];
        
        office.officeName = [dict objectForKey:@"OfficeName"];
        
        if ([Utils utilsObject:[dict objectForKey:@"ValidatedAddressId"]] != nil)
            office.validatedAddressId = [[dict objectForKey:@"ValidatedAddressId"] integerValue];
        
        if ([Utils utilsObject:[dict objectForKey:@"DeliveryLocationId"]] != nil)
            office.deliveryLocationId = [[dict objectForKey:@"DeliveryLocationId"] integerValue];
        
        office.deliveryLine1 = [dict objectForKey:@"DeliveryLine1"];
        office.lastLine = [dict objectForKey:@"LastLine"];
        office.longitude = [dict objectForKey:@"Longitude"];
        office.latitude = [dict objectForKey:@"Latitude"];
        
        [[Utils sharedUtils].arrayAllOffices addObject:office];
    }

    return;
}

- (CompanyDetail *) didCreateOffice:(NSDictionary *) info {
    
    CompanyDetail * office = [[CompanyDetail alloc] init];
    
    office.count = [[info objectForKey:@"Count"] integerValue];
    
    if ([Utils utilsObject:[info objectForKey:@"OfficeId"]] != nil)
        office.officeId = [[info objectForKey:@"OfficeId"] integerValue];
    
    office.officeName = [info objectForKey:@"OfficeName"];
    
    if ([Utils utilsObject:[info objectForKey:@"ValidatedAddressId"]] != nil)
        office.validatedAddressId = [[info objectForKey:@"ValidatedAddressId"] integerValue];
    
    if ([Utils utilsObject:[info objectForKey:@"DeliveryLocationId"]] != nil)
        office.deliveryLocationId = [[info objectForKey:@"DeliveryLocationId"] integerValue];
    
    office.deliveryLine1 = [info objectForKey:@"DeliveryLine1"];
    office.lastLine = [info objectForKey:@"LastLine"];
    office.longitude = [info objectForKey:@"Longitude"];
    office.latitude = [info objectForKey:@"Latitude"];
    
    return office;
}

- (CompanyDetail *) didGetOffice:(NSDictionary *) info {
    
    CompanyDetail * office = [[CompanyDetail alloc] init];
    
    office.count = [[info objectForKey:@"Count"] integerValue];
    
    if ([Utils utilsObject:[info objectForKey:@"OfficeId"]] != nil)
        office.officeId = [[info objectForKey:@"OfficeId"] integerValue];
    
    office.officeName = [info objectForKey:@"OfficeName"];
    
    if ([Utils utilsObject:[info objectForKey:@"ValidatedAddressId"]] != nil)
        office.validatedAddressId = [[info objectForKey:@"ValidatedAddressId"] integerValue];
    
    if ([Utils utilsObject:[info objectForKey:@"DeliveryLocationId"]] != nil)
        office.deliveryLocationId = [[info objectForKey:@"DeliveryLocationId"] integerValue];
    
    office.deliveryLine1 = [info objectForKey:@"DeliveryLine1"];
    office.lastLine = [info objectForKey:@"LastLine"];
    office.longitude = [info objectForKey:@"Longitude"];
    office.latitude = [info objectForKey:@"Latitude"];
    
    return office;
}

- (void) didInviteOffice:(NSDictionary *) info {
    
    
}

@end
