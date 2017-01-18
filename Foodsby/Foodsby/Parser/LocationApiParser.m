//
//  LocationApiParser.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "LocationApiParser.h"
#import "Utils.h"

@implementation LocationApiParser

static LocationApiParser * sharedLocationApiParser = nil;

+ (LocationApiParser *) sharedLocationApiParser {
    
    if (sharedLocationApiParser == nil) {
        
        sharedLocationApiParser = [[LocationApiParser alloc] init];
    }
    
    return sharedLocationApiParser;
}


#pragma mark - LocationApiDelegate methods parsing

- (void) error:(NSDictionary *) errorInfo {
    
    
}

- (void) didGetDeliveryLocations:(NSArray *) info {
    
    if ([Utils sharedUtils].arrayDeliveryLocations.count > 0)
        [[Utils sharedUtils].arrayDeliveryLocations removeAllObjects];
    
    for (int i = 0 ; i < info.count ; i ++ ) {
        
        NSDictionary * dict = [info objectAtIndex:i];
        
        DeliveryLocation * location = [[DeliveryLocation alloc] init];
        
        location.deliveryLocationId = [[dict objectForKey:@"DeliveryLocationId"] integerValue];
        location.locationName = [dict objectForKey:@"LocationName"];
        location.dropoffInstruction = [dict objectForKey:@"DropoffInstruction"];
        location.pickupInstruction = [dict objectForKey:@"PickupInstruction"];
        location.deliveryLine1 = [dict objectForKey:@"DeliveryLine1"];
        location.lastLine = [dict objectForKey:@"LastLine"];
        location.longitude = [dict objectForKey:@"Longitude"];
        location.latitude = [dict objectForKey:@"Latitude"];
        
        [[Utils sharedUtils].arrayDeliveryLocations addObject:location];
    }
}

- (DeliveryLocation *) didGetSpecificDeliveryLocation:(NSDictionary *)info {
    
    DeliveryLocation * location = [[DeliveryLocation alloc] init];
    
    location.deliveryLocationId = [[info objectForKey:@"DeliveryLocationId"] integerValue];
    location.locationName = [info objectForKey:@"LocationName"];
    location.dropoffInstruction = [info objectForKey:@"DropoffInstruction"];
    location.pickupInstruction = [info objectForKey:@"PickupInstruction"];
    location.deliveryLine1 = [info objectForKey:@"DeliveryLine1"];
    location.lastLine = [info objectForKey:@"LastLine"];
    location.longitude = [info objectForKey:@"Longitude"];
    location.latitude = [info objectForKey:@"Latitude"];
    
    return location;
}

- (void) didGetLocationSchedule:(NSDictionary *)info {

    if ([Utils sharedUtils].deliveryLocationSchedule.storesForLocation.count > 0)
        [[Utils sharedUtils].deliveryLocationSchedule.storesForLocation removeAllObjects];
    
    if ([Utils sharedUtils].deliveryLocationSchedule.deliveryDaysThisWeek.count > 0)
        [[Utils sharedUtils].deliveryLocationSchedule.deliveryDaysThisWeek removeAllObjects];
    
    NSArray * arrayStoresForLocation = [info objectForKey:@"StoresForLocation"];
    NSArray * arrayDeliveryDaysThisWeek = [info objectForKey:@"DeliveryDaysThisWeek"];
    [Utils sharedUtils].deliveryLocationSchedule.today = [info objectForKey:@"Today"];
    [Utils sharedUtils].deliveryLocationSchedule.locationName = [info objectForKey:@"LocationName"];
    
    for (int i = 0 ; i < arrayStoresForLocation.count ; i ++) {
        
        NSDictionary * dict = [arrayStoresForLocation objectAtIndex:i];
        StoreForLocation * storeForLocation = [[StoreForLocation alloc] init];

        storeForLocation.storeId = [[dict objectForKey:@"StoreId"] integerValue];
        
        //Store
        NSDictionary * dictStore = [dict objectForKey:@"Store"];
        NSDictionary * dictRestaurant = [dictStore objectForKey:@"Restaurant"];
        
        storeForLocation.store.restaurantName = [dictRestaurant objectForKey:@"RestaurantName"];
        
        storeForLocation.store.storeName = [dictStore objectForKey:@"StoreName"];
        
        storeForLocation.cutOffTime = [dict objectForKey:@"CutOffTime"];
        storeForLocation.cutOffDateTime = [dict objectForKey:@"CutOffDateTime"];
        
        //DeliveryTimes
        
        NSArray * arrayDeliveryTimes = (NSArray *)[Utils utilsObject:[dict objectForKey:@"DeliveryTimes"]];
        
        for (int j = 0 ; j < arrayDeliveryTimes.count ; j ++) {
            
            NSDictionary * dictDeliveryTimes = [arrayDeliveryTimes objectAtIndex:j];
            DeliveryTimes * deliveryTimes = [[DeliveryTimes alloc] init];
            deliveryTimes.dropoffTime = [dictDeliveryTimes objectForKey:@"DropoffTime"];
            deliveryTimes.dropoffDateTime = [dictDeliveryTimes objectForKey:@"DropoffDateTime"];
            deliveryTimes.deliveryTimeId = [[dictDeliveryTimes objectForKey:@"DeliveryTimeId"] integerValue];
            deliveryTimes.deliveryLocationId = [[dictDeliveryTimes objectForKey:@"DeliveryLocationId"] integerValue];
            deliveryTimes.deliveryId = [[dictDeliveryTimes objectForKey:@"DeliveryId"] integerValue];
            deliveryTimes.deliveryName = [dictDeliveryTimes objectForKey:@"DeliveryName"];
            deliveryTimes.isPending = [[dictDeliveryTimes objectForKey:@"IsPending"] boolValue];
            deliveryTimes.inZone = [[dictDeliveryTimes objectForKey:@"InZone"] boolValue];
            
            [storeForLocation.deliveryTimes addObject:deliveryTimes];
        }
        
        storeForLocation.logoLink = [dict objectForKey:@"LogoLink"];
        storeForLocation.timeZoneInfoId = [dict objectForKey:@"TimeZoneInfoId"];
        storeForLocation.maxWeight = [[dict objectForKey:@"MaxWeight"] integerValue];
        
        NSArray * arrayAvailableDays = (NSArray *)[Utils utilsObject:[dict objectForKey:@"AvailableDays"]];
        
        for (int j = 0 ; j < arrayAvailableDays.count ; j ++) {
            
            NSString * strDay = [arrayAvailableDays objectAtIndex:j];
            [storeForLocation.availableDays addObject:strDay];
        }
    
        storeForLocation.currentWeight = [[dict objectForKey:@"CurrentWeight"] integerValue];
        storeForLocation.inZone = [[dict objectForKey:@"InZone"] boolValue];
        storeForLocation.mondayCount = [[dict objectForKey:@"MondayCount"] integerValue];
        storeForLocation.tuesdayCount = [[dict objectForKey:@"TuesdayCount"] integerValue];
        storeForLocation.wednesdayCount = [[dict objectForKey:@"WednesdayCount"] integerValue];
        storeForLocation.thursdayCount = [[dict objectForKey:@"ThursdayCount"] integerValue];
        storeForLocation.fridayCount = [[dict objectForKey:@"FridayCount"] integerValue];
        storeForLocation.saturdayCount = [[dict objectForKey:@"SaturdayCount"] integerValue];
        storeForLocation.sundayCount = [[dict objectForKey:@"SundayCount"] integerValue];
        
        [[Utils sharedUtils].deliveryLocationSchedule.storesForLocation addObject:storeForLocation];

    }
    
    for (int i = 0 ; i < arrayDeliveryDaysThisWeek.count ; i ++) {

        DeliveryDaysThisWeek * deliveryDayThisWeek = [[DeliveryDaysThisWeek alloc] init];

        NSDictionary * dictMain = [arrayDeliveryDaysThisWeek objectAtIndex:i];
        deliveryDayThisWeek.dayOfWeek = [[dictMain objectForKey:@"DayOfWeek"] integerValue];
        deliveryDayThisWeek.dateOfDayForWeek = [dictMain objectForKey:@"DateOfDayForWeek"];
        
        NSArray * arrayStores = [dictMain objectForKey:@"Stores"];
        
        for (int k = 0 ; k < arrayStores.count ; k ++) {
            
            NSDictionary * dict = [arrayStores objectAtIndex:k];
            StoreForLocation * storeForLocation = [[StoreForLocation alloc] init];
            
            storeForLocation.storeId = [[dict objectForKey:@"StoreId"] integerValue];
            
            //Store
            storeForLocation.store = [[Store alloc] init];
            NSDictionary * dictStore = [dict objectForKey:@"Store"];
            NSDictionary * dictRestaurant = [dictStore objectForKey:@"Restaurant"];
            
            storeForLocation.store.restaurantName = [dictRestaurant objectForKey:@"RestaurantName"];

            storeForLocation.store.storeName = [dictStore objectForKey:@"StoreName"];
            
            storeForLocation.cutOffTime = [dict objectForKey:@"CutOffTime"];
            storeForLocation.cutOffDateTime = [dict objectForKey:@"CutOffDateTime"];
            
            //DeliveryTimes
            NSArray * arrayDeliveryTimes = (NSArray *)[Utils utilsObject:[dict objectForKey:@"DeliveryTimes"]];
            
            for (int j = 0 ; j < arrayDeliveryTimes.count ; j ++) {
                
                NSDictionary * dictDeliveryTimes = [arrayDeliveryTimes objectAtIndex:j];
                DeliveryTimes * deliveryTimes = [[DeliveryTimes alloc] init];
                deliveryTimes.dropoffTime = [dictDeliveryTimes objectForKey:@"DropoffTime"];
                deliveryTimes.dropoffDateTime = [dictDeliveryTimes objectForKey:@"DropoffDateTime"];
                deliveryTimes.deliveryTimeId = [[dictDeliveryTimes objectForKey:@"DeliveryTimeId"] integerValue];
                deliveryTimes.deliveryLocationId = [[dictDeliveryTimes objectForKey:@"DeliveryLocationId"] integerValue];
                deliveryTimes.deliveryId = [[dictDeliveryTimes objectForKey:@"DeliveryId"] integerValue];
                deliveryTimes.deliveryName = [dictDeliveryTimes objectForKey:@"DeliveryName"];
                deliveryTimes.isPending = [[dictDeliveryTimes objectForKey:@"IsPending"] boolValue];
                deliveryTimes.inZone = [[dictDeliveryTimes objectForKey:@"InZone"] boolValue];
                
                [storeForLocation.deliveryTimes addObject:deliveryTimes];
            }
            
            storeForLocation.logoLink = [dict objectForKey:@"LogoLink"];
            storeForLocation.timeZoneInfoId = [dict objectForKey:@"TimeZoneInfoId"];
            storeForLocation.maxWeight = [[dict objectForKey:@"MaxWeight"] integerValue];
            
            NSArray * arrayAvailableDays = (NSArray *)[Utils utilsObject:[dict objectForKey:@"AvailableDays"]];
            
            for (int j = 0 ; j < arrayAvailableDays.count ; j ++) {
                
                NSString * strDay = [arrayAvailableDays objectAtIndex:j];
                [storeForLocation.availableDays addObject:strDay];
            }
            
            storeForLocation.currentWeight = [[dict objectForKey:@"CurrentWeight"] integerValue];
            storeForLocation.inZone = [[dict objectForKey:@"InZone"] boolValue];
            storeForLocation.mondayCount = [[dict objectForKey:@"MondayCount"] integerValue];
            storeForLocation.tuesdayCount = [[dict objectForKey:@"TuesdayCount"] integerValue];
            storeForLocation.wednesdayCount = [[dict objectForKey:@"WednesdayCount"] integerValue];
            storeForLocation.thursdayCount = [[dict objectForKey:@"ThursdayCount"] integerValue];
            storeForLocation.fridayCount = [[dict objectForKey:@"FridayCount"] integerValue];
            storeForLocation.saturdayCount = [[dict objectForKey:@"SaturdayCount"] integerValue];
            storeForLocation.sundayCount = [[dict objectForKey:@"SundayCount"] integerValue];
            
            [deliveryDayThisWeek.stores addObject:storeForLocation];
            
        }
        
        [[Utils sharedUtils].deliveryLocationSchedule.deliveryDaysThisWeek addObject:deliveryDayThisWeek];
    }
}

@end
