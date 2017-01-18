//
//  MenuApiParser.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/8/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "MenuApiParser.h"
#import "Utils.h"

@implementation MenuApiParser

static MenuApiParser * sharedMenuApiParser = nil;

+ (MenuApiParser *) sharedMenuApiParser {
    
    if (sharedMenuApiParser == nil) {
        
        sharedMenuApiParser = [[MenuApiParser alloc] init];
    }
    
    return sharedMenuApiParser;
}

#pragma mark - MenuApiDelegate methods parsing

- (void) error:(NSDictionary *)errorInfo {
    
    
}

- (MenuList *) didGetMenu:(NSDictionary *)info {
    
    if ((info == nil) || (info.count == 0))
        return nil;
    
    MenuList * menu = [[MenuList alloc] init];
    
    menu.locationName = [info objectForKey:@"LocationName"];
    menu.pickupInstruction = [info objectForKey:@"PickupInstruction"];
    menu.dayOfWeek = [[info objectForKey:@"DayOfWeek"] integerValue];
    menu.dateOfDayForWeek = [[info objectForKey:@"DateOfDayForWeek"] integerValue];
    menu.deliveryLocationId = [[info objectForKey:@"DeliveryLocationId"] integerValue];
    menu.restaurantName = [info objectForKey:@"RestaurantName"];
    menu.dropoffTime = [info objectForKey:@"dropoffTime"];
    menu.cutOffTime = [info objectForKey:@"CutOffTime"];
    menu.timeZoneInfoId = [info objectForKey:@"TimeZoneInfoId"];

    NSArray * arraySubMenus = (NSArray *)[Utils utilsObject:[info objectForKey:@"SubMenus"]];
    
    for (int i = 0 ; i < arraySubMenus.count ; i ++) {
        
        SubMenu * subMenu = [[SubMenu alloc] init];
        NSDictionary * dictSubMenu = [arraySubMenus objectAtIndex:i];
        
        subMenu.subMenuId = [[dictSubMenu objectForKey:@"SubMenuId"] integerValue];
        subMenu.subMenuName = [dictSubMenu objectForKey:@"SubMenuName"];
        
        NSArray * arrayMenuItems = [dictSubMenu objectForKey:@"Items"];
        
        for (int j = 0 ; j < arrayMenuItems.count ; j ++) {
            
            NSDictionary * dictItem = [arrayMenuItems objectAtIndex:j];
            MenuItem * menuItem = [[MenuItem alloc] init];
            
            menuItem.menuItemId = [[dictItem objectForKey:@"MenuItemId"] integerValue];
            menuItem.displayText = [dictItem objectForKey:@"DisplayText"];
            menuItem.price = [[dictItem objectForKey:@"Price"] doubleValue];

            menuItem.menuItemDescription = (NSString *)[Utils utilsObject:[dictItem objectForKey:@"Description"]];
            
            menuItem.specialInstructions = (NSString *)[Utils utilsObject:[dictItem objectForKey:@"SpecialInstructions"]];
            
//            NSArray * arrayQuestionItems = [dictItem objectForKey:@"QuestionItems"];
//            
//            for (int k = 0 ; k < arrayQuestionItems.count ; k ++) {
//                
//                NSDictionary * dictQuestionItem = [arrayQuestionItems objectAtIndex:k];
//                MenuQuestionItem * menuQuestionItem = [[MenuQuestionItem alloc] init];
//                
//                menuQuestionItem.displayText = [dictQuestionItem objectForKey:@"DisplayText"];
//                menuQuestionItem.questionId = [[dictQuestionItem objectForKey:@"QuestionId"] integerValue];
//
//                //AnswerItems
//                
//                menuQuestionItem.minimumSelection = [[dictQuestionItem objectForKey:@"MinimumSelection"] integerValue];
//                menuQuestionItem.maximumSelection = [[dictQuestionItem objectForKey:@"MaximumSelection"] integerValue];
//                menuQuestionItem.showAsRadio = [[dictQuestionItem objectForKey:@"ShowAsRadio"] integerValue];
//                
//                [menuItem.questionItems addObject:menuQuestionItem];
//            }
//            
//            NSArray * arraySelectedAnswers = [dictItem objectForKey:@"SelectedAnswers"];;
//            
//            for (int k = 0 ; k < arraySelectedAnswers.count ; k ++) {
//                
//                NSDictionary * dictSelectedAnswer = [arraySelectedAnswers objectAtIndex:k];
//                MenuAnswerItem * menuAnswerItem = [[MenuAnswerItem alloc] init];
//                
//                menuAnswerItem.answerId = [[dictSelectedAnswer objectForKey:@"AnswerId"] integerValue];
//                menuAnswerItem.displayText = [dictSelectedAnswer objectForKey:@"DisplayText"];
//
//                //QuestionItems
//                
//                menuAnswerItem.parentQuestionId = [[dictSelectedAnswer objectForKey:@"ParentQuestionId"] integerValue];
//                menuAnswerItem.selected = [[dictSelectedAnswer objectForKey:@"Selected"] integerValue];
//                menuAnswerItem.price = [[dictSelectedAnswer objectForKey:@"Price"] doubleValue];
//                menuAnswerItem.showAsRadio = [[dictSelectedAnswer objectForKey:@"ShowAsRadio"] integerValue];
//                menuAnswerItem.depth = [[dictSelectedAnswer objectForKey:@"Depth"] integerValue];
//                menuAnswerItem.autoSelected = [[dictSelectedAnswer objectForKey:@"AutoSelected"] integerValue];
//
//                [menuItem.selectedAnswers addObject:menuAnswerItem];
//            }
            
            [subMenu.menuItems addObject:menuItem];
        }

        subMenu.subMenuDescription = (NSString *) [Utils utilsObject:[dictSubMenu objectForKey:@"Description"]];
        
        [menu.subMenus addObject:subMenu];
    }
    
    menu.soldOut = [[info objectForKey:@"SoldOut"] boolValue];
    menu.orderId = [[info objectForKey:@"OrderId"] integerValue];
    menu.orderItemsCount = [[info objectForKey:@"OrderItemsCount"] integerValue];
    menu.logoLink = [info objectForKey:@"LogoLink"];
    menu.hasPastOrder = [[info objectForKey:@"HasPastOrder"] boolValue];
    
    return menu;
}

- (MenuItem *) didGetMenuItem:(NSDictionary *)info {
    
    MenuItem * menuItem = [[MenuItem alloc] init];
    
    menuItem.menuItemId = [[info objectForKey:@"MenuItemId"] integerValue];
    menuItem.displayText = [info objectForKey:@"DisplayText"];
    menuItem.price = [[info objectForKey:@"Price"] doubleValue];

    menuItem.menuItemDescription = (NSString *)[Utils utilsObject:[info objectForKey:@"Description"]];
    
    menuItem.specialInstructions = (NSString *)[Utils utilsObject:[info objectForKey:@"SpecialInstructions"]];
    
    menuItem.questionItems = [self getQuetiosnItems:info];
    
    
//    NSArray * arraySelectedAnswers = [info objectForKey:@"SelectedAnswers"];
//    
//    for (int k = 0 ; k < arraySelectedAnswers.count ; k ++) {
//        
//        NSDictionary * dictSelectedAnswer = [arraySelectedAnswers objectAtIndex:k];
//        MenuAnswerItem * menuAnswerItem = [[MenuAnswerItem alloc] init];
//        
//        menuAnswerItem.answerId = [[dictSelectedAnswer objectForKey:@"AnswerId"] integerValue];
//        menuAnswerItem.displayText = [dictSelectedAnswer objectForKey:@"DisplayText"];
//        
//        //QuestionItems
//        
//        menuAnswerItem.parentQuestionId = [[dictSelectedAnswer objectForKey:@"ParentQuestionId"] integerValue];
//        menuAnswerItem.selected = [[dictSelectedAnswer objectForKey:@"Selected"] integerValue];
//        menuAnswerItem.price = [[dictSelectedAnswer objectForKey:@"Price"] doubleValue];
//        menuAnswerItem.showAsRadio = [[dictSelectedAnswer objectForKey:@"ShowAsRadio"] integerValue];
//        menuAnswerItem.depth = [[dictSelectedAnswer objectForKey:@"Depth"] integerValue];
//        menuAnswerItem.autoSelected = [[dictSelectedAnswer objectForKey:@"AutoSelected"] integerValue];
//        
//        [menuItem.selectedAnswers addObject:menuAnswerItem];
//    }
    
    return menuItem;
}


- (NSMutableArray *) getQuetiosnItems:(NSDictionary *) info {
    
    NSArray * arrayQuestionItems = [info objectForKey:@"QuestionItems"];
    
    NSMutableArray * arrayQuestions = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < arrayQuestionItems.count ; i ++) {
        
        NSDictionary * dictQuestionItem = [arrayQuestionItems objectAtIndex:i];
        MenuQuestionItem * menuQuestionItem = [[MenuQuestionItem alloc] init];
        
        menuQuestionItem.displayText = [dictQuestionItem objectForKey:@"DisplayText"];
        menuQuestionItem.questionId = [[dictQuestionItem objectForKey:@"QuestionId"] integerValue];
        menuQuestionItem.minimumSelection = [[dictQuestionItem objectForKey:@"MinimumSelection"] integerValue];
        menuQuestionItem.maximumSelection = [[dictQuestionItem objectForKey:@"MaximumSelection"] integerValue];
        menuQuestionItem.showAsRadio = [[dictQuestionItem objectForKey:@"ShowAsRadio"] boolValue];
        
        
        NSArray * arrayAnswerItems = [dictQuestionItem objectForKey:@"AnswerItems"];
        
        for (int j = 0 ; j < arrayAnswerItems.count ; j ++) {
            
            NSDictionary * dictAnswerItem = [arrayAnswerItems objectAtIndex:j];
            
            MenuAnswerItem * menuAnswerItem = [[MenuAnswerItem alloc] init];
            
            menuAnswerItem.answerId = [[dictAnswerItem objectForKey:@"AnswerId"] integerValue];
            menuAnswerItem.autoSelected = [[dictAnswerItem objectForKey:@"AutoSelected"] integerValue];
            menuAnswerItem.depth = [[dictAnswerItem objectForKey:@"Depth"] integerValue];
            menuAnswerItem.displayText = [dictAnswerItem objectForKey:@"DisplayText"];
            menuAnswerItem.parentQuestionId = [[dictAnswerItem objectForKey:@"ParentQuestionId"] integerValue];
            menuAnswerItem.price = [[dictAnswerItem objectForKey:@"Price"] doubleValue];
            menuAnswerItem.selected = [[dictAnswerItem objectForKey:@"Selected"] boolValue];
            menuAnswerItem.showAsRadio = [[dictAnswerItem objectForKey:@"ShowAsRadio"] boolValue];
            
            menuAnswerItem.questionItems = [self getQuetiosnItems:dictAnswerItem];
            
            [menuQuestionItem.answerItems addObject:menuAnswerItem];
        }
        
        [arrayQuestions addObject:menuQuestionItem];
    }
    
    return arrayQuestions;
}


@end
