//
//  InviteContactsViewController.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/20/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfficeApi.h"
#import "SlideNavigationController.h"

@interface InviteContactsViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, OfficeApiDelegate> {
    
    NSMutableArray *        arrayContacts;
}

@property (weak, nonatomic) IBOutlet UITableView *  tableViewCotacts;
@property (weak, nonatomic) IBOutlet UIButton *     buttonSendInvitation;

@end
