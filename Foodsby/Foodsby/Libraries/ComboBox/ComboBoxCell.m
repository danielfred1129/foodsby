//
//  ComboBoxCell.m
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "ComboBoxCell.h"

@implementation ComboBoxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
