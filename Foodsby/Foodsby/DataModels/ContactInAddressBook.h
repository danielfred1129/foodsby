//
//  ContactInAddressBook.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/20/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactInAddressBook : NSObject

@property (nonatomic) NSString *    firstName;
@property (nonatomic) NSString *    lastName;
@property (nonatomic) NSString *    companyName;
@property (nonatomic) NSString *    email;
@property (nonatomic) BOOL          selected;

@end
