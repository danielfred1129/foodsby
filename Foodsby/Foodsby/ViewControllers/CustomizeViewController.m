//
//  CustomizeViewController.m
//  Foodsby
//
//  Created by Alexander Antipov on 2/24/15.
//  Copyright (c) 2015 Alexander Antipov. All rights reserved.
//

#import "CustomizeViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "CustomizeDetailViewController.h"
#import "SelectMenuViewController.h"
#import "OrderSummaryViewController.h"

@interface CustomizeViewController ()


@end

@implementation CustomizeViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    arrayQuestionItems = [Utils sharedUtils].qa.questionItems;
    
    orderItems = [[OrderAddItem alloc] init];
    nClickedButton = 0;
    
    [self setCustomNavBar];
    
    _tableViewQuestion.delegate = self;
    _tableViewQuestion.dataSource = self;
    
    [[Utils sharedUtils] setMenuType:self.navigationController type:2];
    
    _buttonCheckout.layer.cornerRadius = 5;
    _buttonCheckout.clipsToBounds = YES;

    _buttonNextItem.layer.cornerRadius = 5;
    _buttonNextItem.clipsToBounds = YES;
    
    _textViewInstruction.layer.borderWidth = 1.0f;
    _textViewInstruction.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.textViewInstruction action:@selector(resignFirstResponder)];
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.items = [NSArray arrayWithObject:barButton];
    
    self.textViewInstruction.inputAccessoryView = toolbar;
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void) setCustomNavBar {
    
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary * navBarTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    
    self.navigationItem.title = @"Customize";
}


#pragma mark - SlideNavigationController Methods -

- (BOOL) slideNavigationControllerShouldDisplayLeftMenu {
    
    return NO;
}

- (BOOL) slideNavigationControllerShouldDisplayRightMenu {
    
    return YES;
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
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomizeHeaderCell"];

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
    
    MenuQuestionItem * item = [arrayQuestionItems objectAtIndex:indexPath.section];
    MenuAnswerItem * answerItem = [item.answerItems objectAtIndex:indexPath.row];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];

    if (answerItem.questionItems.count > 0) {
        
        if (item.showAsRadio == 1) {
            
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
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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


#pragma mark - Keyboard Notification

- (void) keyboardWillShow:(NSNotification *) notification {
    
    CGRect rect = self.view.frame;
    
    if (rect.origin.y < 0)
        return;
    
    NSDictionary * info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    rect.origin.y -= kbSize.height;
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *) notification {
    
    CGRect rect = self.view.frame;
    
    if (rect.origin.y >= 0)
        return;
    
    NSDictionary * info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    rect.origin.y += kbSize.height;
    
    self.view.frame = rect;
    [UIView commitAnimations];
}


- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    
    [self.textViewInstruction resignFirstResponder];

}


#pragma mark - UI Action methods

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNextItem:(id)sender {
    
    [self.textViewInstruction resignFirstResponder];
    
    nClickedButton = 1;
    
    orderItems.orderId = [Utils sharedUtils].orderId;
    orderItems.menuItemId = [Utils sharedUtils].menuItemId;
    orderItems.specialInstructions = _textViewInstruction.text;
    [orderItems.selectedAnswers removeAllObjects];
    
    if ([self checkSelectedAnswers:arrayQuestionItems depth:0] == NO)
        return;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[OrderApi sharedOrderApi] setDelegate:self];
    [[OrderApi sharedOrderApi] addItemToOrder:orderItems];
}

- (IBAction)onCheckout:(id)sender {
    
    [self.textViewInstruction resignFirstResponder];
    
    nClickedButton = 2;
    
    orderItems.orderId = [Utils sharedUtils].orderId;
    orderItems.menuItemId = [Utils sharedUtils].menuItemId;
    orderItems.specialInstructions = _textViewInstruction.text;
    [orderItems.selectedAnswers removeAllObjects];
    
    if ([self checkSelectedAnswers:arrayQuestionItems depth:0] == NO)
        return;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[OrderApi sharedOrderApi] setDelegate:self];
    [[OrderApi sharedOrderApi] addItemToOrder:orderItems];
    
}


#pragma mark - check selections

- (BOOL) checkSelectedAnswers:(NSArray *) arrayQuestions depth:(NSInteger) treeDepth {
    
    for (int i = 0 ; i < arrayQuestions.count ; i ++) {
        
        MenuQuestionItem * questionItem = [arrayQuestions objectAtIndex:i];
        
        int count = 0;
        
        for (int j = 0 ; j < questionItem.answerItems.count ; j ++) {
            
            MenuAnswerItem * answerItem = [questionItem.answerItems objectAtIndex:j];
            
            if (answerItem.autoSelected == YES)
                answerItem.selected = YES;
            
            if (answerItem.selected == YES) {
             
                count ++;
                
                SelectedAnswerInfo * object = [[SelectedAnswerInfo alloc] init];
                object.answerId = answerItem.answerId;
                object.selected = YES;
                object.depth = treeDepth;
                
                [orderItems.selectedAnswers addObject:object];
            }
            
            if (answerItem.questionItems.count > 0) {
                
                if (answerItem.selected == YES) {
                
                    if ([self checkSelectedAnswers:answerItem.questionItems depth:treeDepth + 1] == NO)
                        return NO;
                }
            }
        }
        
        if (questionItem.minimumSelection > count) {
            
            NSString * message;
            
            if (questionItem.minimumSelection > 1)
                message = [NSString stringWithFormat:@"You must select at least %ld options.", questionItem.minimumSelection];
            else
                message = [NSString stringWithFormat:@"You must select at least %ld option.", questionItem.minimumSelection];
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:questionItem.displayText message:message  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [alert show];
            
            return NO;
        }
        
        if ((questionItem.maximumSelection != 0) && (questionItem.maximumSelection < count)) {
            
            NSString * message;
            
            if (questionItem.maximumSelection > 1)
                message = [NSString stringWithFormat:@"You can only select up to %ld options.", questionItem.maximumSelection];
            else
                message = [NSString stringWithFormat:@"You can only select up to %ld option.", questionItem.maximumSelection];
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:questionItem.displayText message:message  delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [alert show];
            
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - OrderApiDelegate

- (void) error:(NSDictionary *)errorInfo {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString * errorDescription = [errorInfo objectForKey:@"NSLocalizedDescription"];
    
    if ([errorDescription rangeOfString:@"canceled"].location != NSNotFound) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"An internet connection is required to proceed. Please try again when a connection is present." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"There was a problem processing your item. Please try again." message: nil delegate:nil  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
    }
    
}

- (void) didAddItemToOrder:(NSDictionary *)info {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [Utils sharedUtils].orderItemsCount ++;
    
    if (nClickedButton == 1) {
     
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SelectMenuViewController * viewController  = (SelectMenuViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_SelectMenuViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if (nClickedButton == 2) {
        
        UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        OrderSummaryViewController * viewController  = (OrderSummaryViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ID_OrderSummaryViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}


@end
