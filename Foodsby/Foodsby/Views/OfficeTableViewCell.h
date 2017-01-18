//
//  OfficeTableViewCell.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/16/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfficeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelOfficeName;
@property (weak, nonatomic) IBOutlet UILabel *labelDeliveryLine;

@end
