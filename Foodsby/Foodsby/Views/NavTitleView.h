//
//  NavTitleView.h
//  Foodsby
//
//  Created by Alexander Antipov on 2/13/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavTitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelSubTitle;


- (id)initWithNibName:(NSString*)nibNameOrNil;
- (id)initWithFrame:(CGRect)frame nibName:(NSString*)nibNameOrNil;


@end
