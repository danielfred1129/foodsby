//
//  Utils.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/11/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "Utils.h"
#import "MenuViewController.h"

#import "DeliveryDaysThisWeek.h"
#import "StoreForLocation.h"


@implementation Utils

@synthesize dashboardViewController;
@synthesize selectMenuViewController;
@synthesize orderSummaryViewController;

static Utils * sharedUtils = nil;

- (id) init {
    
    // Call superclass's initializer
    self = [super init];
    
    if( self != nil ) {
        
        [self resetUtils];
    }
    
    return self;
}

- (void) resetUtils {
    
    _officeId = -1;
    _deliveryLocationId = -1;
    _menuItemId = -1;
    _orderId = -1;
    _orderItemsCount = 0;
    _preferredCard = -1;
    _isProduction = YES;
    
    _user = [[User alloc] init];
    _arrayCards = [[NSMutableArray alloc] init];
    _arrayDeliveryLocations = [[NSMutableArray alloc] init];
    _arrayAllOffices = [[NSMutableArray alloc] init];
    _office = nil;
    _deliveryLocationSchedule = [[DeliveryLocationSchedule alloc] init];
    _identifiers = [[MenuInfo alloc] init];
    _arrayExceptions = [[NSMutableArray alloc] init];
    _arrayReorder = [[NSMutableArray alloc] init];
    _menu = nil;
    _arraySubMenus = nil;
    _subMenu = nil;
    _arrayItems = nil;
    _qa = nil;
    _promo = nil;
    _order = nil;
    _orderDetails = nil;
    _receiptDetails = nil;

}

+ (Utils *) sharedUtils {
    
    if (sharedUtils == nil) {
        
        sharedUtils = [[Utils alloc] init];
    }
    
    return sharedUtils;
}


+ (BOOL)validateEmail:(NSString *)email {
    
    NSString * emailRegex = @"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
    
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;

    if([emailTest evaluateWithObject:email]) {
        
        aRange = [email rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [email length])];
        int indexOfDot = (int)aRange.location;
        
        if(aRange.location != NSNotFound) {
            
            NSString *topLevelDomain = [email substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];

            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                return YES;
            }
        }
    }
    
    return NO;
}

+ (NSObject *)utilsObject:(NSObject *) object {
    
    if ([object isKindOfClass:[NSNull class]] == NO)
        return object;
        
    return nil;
}

- (void) setMenuType:(UINavigationController *)nav type:(NSInteger)nType {
    
    MenuViewController * menu = (MenuViewController *)[SlideNavigationController sharedInstance].rightMenu;
    menu.nMenuType = nType;
    menu.menuNavigationController = nav;
    
    [menu.tableViewMenu reloadData];
}

- (NSString *) convertCurrentTimeZone:(NSString *) time {
    
    NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZ"];
    NSDate * date = [dateFormate dateFromString:time];
    [dateFormate setDateFormat:@"hh:mm a"];
    return [dateFormate stringFromDate:date];
}

- (BOOL) hasMissingInfo {
    
    if (([Utils utilsObject:_user.email] != nil) || (_user.email == nil) || ([_user.email isEqualToString:@""] == YES))
        return YES;
    
    if (([Utils utilsObject:_user.firstName] != nil) || (_user.firstName == nil) || ([_user.firstName isEqualToString:@""] == YES))
        return YES;
    
    if (([Utils utilsObject:_user.lastName] != nil) || (_user.lastName == nil) || ([_user.lastName isEqualToString:@""] == YES))
        return YES;
    
    if (([Utils utilsObject:_user.phone] != nil) || (_user.phone == nil) || ([_user.phone isEqualToString:@""] == YES))
        return YES;
    
    return NO;
}

- (BOOL) hasSavedCards {
    
    if (_arrayCards.count > 0)
        return YES;
    
    return NO;
}

- (void) standardError:(NSDictionary *) error {
    
    NSString * errorDescription = [error objectForKey:@"NSLocalizedDescription"];
    
    if ([errorDescription rangeOfString:@"canceled"].location != NSNotFound) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"An internet connection is required to proceed. Please try again when a connection is present." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Sorry, but we've run into an error on our end. Please try again later." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
    }
    
}

- (void) setupNotifications:(DeliveryLocationSchedule *) schedule {
    
    [self clearNotifications];
     
    NSInteger notificationTime =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationTime"] integerValue];
    
    if (notificationTime == 0) {
        
        notificationTime = 30;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:notificationTime] forKey:@"NotificationTime"];
    }

    for (int i = 0 ; i < schedule.deliveryDaysThisWeek.count ; i ++) {
        
        DeliveryDaysThisWeek * deliveryDay = [schedule.deliveryDaysThisWeek objectAtIndex:i];
        
        for (int j = 0 ; j < deliveryDay.stores.count ; j ++) {
            
            StoreForLocation * store = [deliveryDay.stores objectAtIndex:j];
            
            BOOL bState =  [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"LocalNotification%ld", store.storeId]] boolValue];
            
            if (bState == YES)
                continue;
            
            NSString * cutoffString = [self convertCurrentTimeZone:store.cutOffDateTime];
            
            NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
            [dateFormate setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZ"];
            NSDate * cutoffDate = [dateFormate dateFromString:store.cutOffDateTime];
            

            cutoffDate = [cutoffDate dateByAddingTimeInterval: - notificationTime * 60];
            
            NSDate * nowDate = [NSDate date];
            
            if ([cutoffDate compare:nowDate] == NSOrderedDescending) {
                
                // Notification will fire in one minute
                UILocalNotification * localNotif = [[UILocalNotification alloc] init];
                
                if (localNotif == nil)
                    return;
                
                localNotif.fireDate = cutoffDate;
                localNotif.timeZone = [NSTimeZone defaultTimeZone];
                
                // Notttification details
                localNotif.alertBody = [NSString stringWithFormat:@"The cutoff time is almost up! Please your order by %@", cutoffString];
                
                // Set the action button
                localNotif.alertAction = store.store.restaurantName;
                
                NSDictionary * userDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:store.storeId]forKey:@"StoreId"];
                localNotif.userInfo = userDict;
                
                localNotif.soundName = UILocalNotificationDefaultSoundName;
                localNotif.repeatInterval = NSCalendarUnitWeekday;
                
                localNotif.applicationIconBadgeNumber ++;
                
                // Schedule the notification
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];

            }
        }
    }
}

- (void) clearNotifications {

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


@end
