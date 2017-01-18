//
//  CustomizeDetailViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/27/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CustomizeDetailViewController.h"
#import "Utils.h"

@interface CustomizeDetailViewController ()

@end

@implementation CustomizeDetailViewController

@synthesize arrayQuestionItems;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setCustomNavBar];
    
    _tableViewQuestion.delegate = self;
    _tableViewQuestion.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setCustomNavBar {
    
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    
    self.navigationItem.title = @"Customize";
}

#pragma mark - UI Action methods

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView Delegate & Datasrouce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return arrayQuestionItems.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    MenuQuestionItem * item = [arrayQuestionItems objectAtIndex:section];
    
    return item.answerItems.count;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomizeDetailHeaderCell"];
    
    UILabel * labelTitle = (UILabel *)[cell viewWithTag:1];
    
    MenuQuestionItem * item = [arrayQuestionItems objectAtIndex:section];
    
    if (item.minimumSelection > 0)
        labelTitle.text = [NSString stringWithFormat:@"* %@", item.displayText];
    else
        labelTitle.text = item.displayText;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * CellIdentifier = @"CustomizeCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    
    MenuQuestionItem * item = [arrayQuestionItems objectAtIndex:indexPath.section];
    MenuAnswerItem * answerItem = [item.answerItems objectAtIndex:indexPath.row];
    
    if (answerItem.questionItems.count > 0)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    else {
        
        if (answerItem.autoSelected == YES)
            answerItem.selected = YES;

        if (answerItem.selected == YES)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (answerItem.price != 0)
        cell.textLabel.text = [answerItem.displayText stringByAppendingString:[NSString stringWithFormat:@" (add $%.02lf)", answerItem.price]];
    else
        cell.textLabel.text = answerItem.displayText;

    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MenuQuestionItem * item = [arrayQuestionItems objectAtIndex:indexPath.section];
    MenuAnswerItem * answerItem = [item.answerItems objectAtIndex:indexPath.row];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (answerItem.questionItems.count > 0) {
        
        if (item.showAsRadio == 0) {
            
            for (int i = 0 ; i < item.answerItems.count ; i ++) {
                
                MenuAnswerItem * answer = [item.answerItems objectAtIndex:i];
                
                if (answerItem.autoSelected == YES)
                    answerItem.selected = YES;

                else if (answer.selected == YES)
                    answer.selected = NO;
            }
        }
        
        answerItem.selected = YES;
        
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        CustomizeDetailViewController * viewController  = (CustomizeDetailViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_CustomizeDetailViewController"];
        viewController.arrayQuestionItems = answerItem.questionItems;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        
        if (item.showAsRadio == 0) {
            
            answerItem.selected = !answerItem.selected;
            
            if (answerItem.autoSelected == YES)
                answerItem.selected = YES;

            if (answerItem.selected == YES)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
            
        } else if (item.showAsRadio == 1) {
            
            for (int i = 0 ; i < item.answerItems.count ; i ++) {
                
                MenuAnswerItem * answer = [item.answerItems objectAtIndex:i];
                
                if (answerItem.autoSelected == YES)
                    answerItem.selected = YES;

                else if (answer.selected == YES) {
                    
                    answer.selected = NO;
                    UITableViewCell * cellTemp = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                    cellTemp.accessoryType = UITableViewCellAccessoryNone;
                    
                    break;
                }
            }
            
            answerItem.selected = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return;
}

@end
