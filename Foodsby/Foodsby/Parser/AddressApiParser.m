//
//  AddressApiParser.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/9/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "AddressApiParser.h"
#import "Utils.h"

@implementation AddressApiParser

static AddressApiParser * sharedAddressApiParser = nil;

+ (AddressApiParser *) sharedAddressApiParser {
    
    if (sharedAddressApiParser == nil) {
        
        sharedAddressApiParser = [[AddressApiParser alloc] init];
    }
    
    return sharedAddressApiParser;
}


#pragma mark - AddressApiParserDelegate methods parsing

- (void) error:(NSDictionary *) errorInfo {
    
}

- (DeliveryLocationsAndOffices *) didGetDeliveryAddress:(NSDictionary *)info {
    
    DeliveryLocationsAndOffices * deliveryLocationsAndOffices = [[DeliveryLocationsAndOffices alloc] init];
    
    deliveryLocationsAndOffices.validatedAddressId = [[info objectForKey:@"ValidatedAddressId"] integerValue];
    
    NSArray * arrayDeliveryLocations = [info objectForKey:@"DeliveryLocations"];
    
    for (int i = 0 ; i < arrayDeliveryLocations.count ; i ++) {
        
        NSDictionary * dictDeliveryLocation = [arrayDeliveryLocations objectAtIndex:i];
        DeliveryLocationForAddress * deliveryLocation = [[DeliveryLocationForAddress alloc] init];
        
        deliveryLocation.deliveryLocationId = [[dictDeliveryLocation objectForKey:@"DeliveryLocationId"] integerValue];
        deliveryLocation.locationName = [dictDeliveryLocation objectForKey:@"LocationName"];
        deliveryLocation.active = [[dictDeliveryLocation objectForKey:@"Active"] boolValue];
        
        [deliveryLocationsAndOffices.deliveryLocations addObject:deliveryLocation];
    }

    deliveryLocationsAndOffices.deliveryLine1 = [info objectForKey:@"DeliveryLine1"];
    deliveryLocationsAndOffices.lastLine = [info objectForKey:@"LastLine"];
    
    NSArray * arrayOffices = [info objectForKey:@"Offices"];
    
    for (int i = 0 ; i < arrayOffices.count ; i++) {
        
        NSDictionary * dictOffice = [arrayOffices objectAtIndex:i];
        DeliveryOffice * deliveryOffice = [[DeliveryOffice alloc] init];
        
        deliveryOffice.officeId = [[dictOffice objectForKey:@"OfficeId"] integerValue];
        deliveryOffice.officeName = [dictOffice objectForKey:@"OfficeName"];
        deliveryOffice.deliveryLocationId = [[dictOffice objectForKey:@"DeliveryLocationId"] integerValue];
        
        [deliveryLocationsAndOffices.offices addObject:deliveryOffice];
    }
    
    deliveryLocationsAndOffices.latitude = [info objectForKey:@"Latitude"];
    deliveryLocationsAndOffices.longitude = [info objectForKey:@"Longitude"];
    
    return deliveryLocationsAndOffices;
}

- (ValidatedAddress *) didValidateAddress:(NSDictionary *)info {
    
    ValidatedAddress * validatedAddress = [[ValidatedAddress alloc] init];
    
    if ([Utils utilsObject:[info objectForKey:@"ValidatedAddressId"]] != nil)
        validatedAddress.validatedAddressId = [[info objectForKey:@"ValidatedAddressId"] integerValue];
    
    NSArray * arrayCandidates = (NSArray *)[Utils utilsObject:[info objectForKey:@"Candidates"]];

    for (int i = 0 ; i < arrayCandidates.count ; i++) {
        
        NSDictionary * dictCandicate = [arrayCandidates objectAtIndex:i];
        CandidateAddress * candidateAddress = [[CandidateAddress alloc] init];
        
        if ([Utils utilsObject:[dictCandicate objectForKey:@"CandidateAddressId"]] != nil)
            candidateAddress.candidateAddressId = [[dictCandicate objectForKey:@"CandidateAddressId"] integerValue];
        
        candidateAddress.deliveryLine1 = [dictCandicate objectForKey:@"DeliveryLine1"];
        candidateAddress.lastLine = [dictCandicate objectForKey:@"LastLine"];
        
        [validatedAddress.candidates addObject:candidateAddress];
    }
    
    validatedAddress.success = [[info objectForKey:@"Success"] boolValue];
    
    return validatedAddress;
}

@end
