//
//  ComboBox.m
//  Foodsby
//
//  Created by Alexander Antipov on 3/3/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "ComboBox.h"
#import "ComboBoxCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ComboBox

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];

    if (self) {
    
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"ComboBox" owner:self options:nil];
        [self addSubview:self.view];
        [self.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        defaultComboBoxTableSize = CGSizeMake(self.view.frame.size.width, 100);
        _comboBoxTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, _button.frame.origin.y+_button.frame.size.height, self.view.frame.size.width, 0)];
        _comboBoxTableView.layer.borderWidth = 1.0;
        _comboBoxTableView.layer.borderColor = [[UIColor blackColor] CGColor];
        self.view.layer.borderWidth = 1.0;
        self.view.layer.borderColor = [[UIColor blackColor] CGColor];
        _comboBoxTableView.delegate = self;
        _comboBoxTableView.dataSource = self;
        [self.view addSubview:_comboBoxTableView];
    }
    
    return self;
}

- (void)openComboBoxWithAnimation:(UITableView *)comboBoxTableView {
    
    [UIView animateWithDuration:0.25 animations:^(void) {
                         
                         [_comboBoxTableView setFrame:CGRectMake(self.view.frame.origin.x, _button.frame.origin.y+_button.frame.size.height, self.frame.size.width, defaultComboBoxTableSize.height)];
                         CGRect frame = self.frame;
                         frame.size.height = _button.frame.size.height+_comboBoxTableView.frame.size.height;
                         self.frame = frame;
                         frame = self.view.frame;
                         frame.size.height = _button.frame.size.height+_comboBoxTableView.frame.size.height;
                         self.view.frame = frame;
        
                     } completion:^(BOOL finished){
                         
                     }];
    
}

- (void)closeComboBoxWithAnimation:(UITableView *)comboBoxTableView{
    
    [UIView animateWithDuration:0.25 animations:^(void){
        
                         [_comboBoxTableView setFrame:CGRectMake(self.view.frame.origin.x, _button.frame.origin.y+_button.frame.size.height, self.frame.size.width, 0)];
                         CGRect frame = self.frame;
                         frame.size.height = _button.frame.size.height+_comboBoxTableView.frame.size.height;
                         self.frame = frame;
                         frame = self.view.frame;
                         frame.size.height = _button.frame.size.height+_comboBoxTableView.frame.size.height;
                         self.view.frame = frame;
        
                     } completion:^(BOOL finished){
                         
                     }];
}

- (void)setComboBoxSize:(CGSize)size{
    
    defaultComboBoxTableSize = size;
}


- (void)setComboBoxData:(NSArray *)comboBoxData{
    
    _comboBoxDataArray = [NSArray arrayWithArray:comboBoxData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 25;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _comboBoxDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *cellIdentifier = @"ComboCell";

    ComboBoxCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ComboBoxCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    CGRect frame = cell.frame;
    frame.size.width = self.frame.size.width;
    cell.frame = frame;
    
    cell.titleLabel.text = [_comboBoxDataArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_button setTitle:[_comboBoxDataArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self closeComboBoxWithAnimation:_comboBoxTableView];
    [self.delegate comboBox:self didSelectRowAtIndexPath:indexPath];
}

- (IBAction)openComboBox:(UIButton *)sender {
    
    if (_comboBoxTableView.frame.size.height == 0) {
    
        [_comboBoxTableView reloadData];
        [self openComboBoxWithAnimation:_comboBoxTableView];
        
    } else {
        
        [self closeComboBoxWithAnimation:_comboBoxTableView];
    }
    
}

-(void)setComboBoxTitle:(NSString *)title{
    
    [_button setTitle:title forState:UIControlStateNormal];
}

-(void)setComboBoxHintTitle:(NSString *) title {
    
    [_button setTitle:title forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

@end
