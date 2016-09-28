//
//  FirstViewController.m
//  idk
//
//  Created by Simranjot Singh on 19/09/16.
//  Copyright © 2016 Simranjot. All rights reserved.
//

#import "ExpensesViewController.h"
#import "ExpensesTableViewCell.h"
@import Firebase;

@interface ExpensesViewController () <UIGestureRecognizerDelegate>{
    
    NSMutableArray *tableData;
    BOOL isNotSwiping;
}

@end

@implementation ExpensesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //To Dismiss Keyboard on tapping outside the TextField
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    //Notifications For Setting Content Insets of TableView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableViewInsetsUp:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableViewInsetsDown:) name:UIKeyboardWillHideNotification object:nil];
    
    //Configure Firebase Database
    [self configureDatabase];
    
    
    
    NSMutableArray *tabledata0 = [[NSMutableArray alloc] init];
    NSMutableArray *tabledata1 = [[NSMutableArray alloc] init];
    tableData = [[NSMutableArray alloc] init];
    //some default data
    for (int i = 0 ; i < 5 ; i++) {
        
        [tabledata0 addObject:@"Section0"];
        [tabledata1 addObject:@"Section1"];
    }
    
    [tableData addObject:tabledata0];
    [tableData addObject:tabledata1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    [_expensesTableView setEditing:editing animated:animated];
    
    if (editing) {
        [_expensesTableView beginUpdates];
        
        for (int i = 0 ; i < 2 ; i++) {
            
            [_expensesTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[tableData[i] count] inSection:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        isNotSwiping = YES;
        _expensesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_expensesTableView endUpdates];
        
    }else{
        
        [_expensesTableView beginUpdates];
        
        for (int i = 0 ; i < 2 ; i++) {
            
            [_expensesTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[tableData[i] count] inSection:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }

        isNotSwiping = NO;
        _expensesTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_expensesTableView endUpdates];
    }
}

#pragma mark Firebase Things

- (void)configureDatabase{
    
    _rootRef = [[FIRDatabase database] reference];
}

#pragma mark TableView Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return @"Know Your Expenses0";
        
    }else{
        
        return @"Know Your Expenses1";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int adjustment = [tableView isEditing] && isNotSwiping ? 1 : 0;
    return [tableData[section] count] + adjustment;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExpensesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpensesCell"];
    
    if(cell == nil){
        
        cell = [[ExpensesTableViewCell alloc] init];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.indexPath = indexPath;
    cell.dateTime.text = [self getDateTime];
    
    if (indexPath.row >= [tableData[indexPath.section] count] && [tableView isEditing]) {
        
        [cell.expenseAmount setHidden:YES];
        [cell.expenseDescription setHidden:YES];
        
    }else{
        
        [cell.expenseAmount setHidden:NO];
        [cell.expenseDescription setHidden:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableData[indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        
        [tableData[indexPath.section] addObject:@"New Object"];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
    if (indexPath.row >= [tableData[indexPath.section] count] && [tableView isEditing]) {
        
        return UITableViewCellEditingStyleInsert;
        
    }else{
        
        return UITableViewCellEditingStyleDelete;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
    if (indexPath.row >= [tableData[indexPath.section] count] && [tableView isEditing]) {
        
        return NO;
        
    }else{
        
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{

    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        
        [tableData[sourceIndexPath.section] exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];

    }else{
        
        [tableData[destinationIndexPath.section] insertObject:tableData[sourceIndexPath.section][sourceIndexPath.row] atIndex:destinationIndexPath.row];
        [tableData[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.row];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    
    if (proposedDestinationIndexPath.row >= [tableData[proposedDestinationIndexPath.section] count]) {
        
        return [NSIndexPath indexPathForRow:[tableData[proposedDestinationIndexPath.section] count] - 1 inSection:proposedDestinationIndexPath.section];
        
    }else{
        
        return proposedDestinationIndexPath;
    }
}


//Keyboard Dismissal on tapping outside

- (void)dismissKeyboard{
    
    [self.view endEditing:YES];
}

//Tableview Content Inset Methods

- (void)setTableViewInsetsUp: (NSNotification*)notification{
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardFrameBeginSize = [keyboardFrameBegin CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrameBeginSize.height, 0.0);
    
    _expensesTableView.contentInset = contentInsets;
    _expensesTableView.scrollIndicatorInsets = contentInsets;
    
}

- (void)setTableViewInsetsDown: (NSNotification*)notification{
    
    _expensesTableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 0, 0.0);
    _expensesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(44.0, 0.0, 0, 0.0);
}

- (NSString *)getDateTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark UIGesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([self.expensesTableView isEditing]) {
        return NO;
    }
    return YES;
}


//For Removing Observers and to Nil the Delegates
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
