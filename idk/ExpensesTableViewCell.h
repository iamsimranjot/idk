//
//  ExpensesTableViewCell.h
//  idk
//
//  Created by Simranjot Singh on 19/09/16.
//  Copyright © 2016 Simranjot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpensesTableViewCell : UITableViewCell <UITextFieldDelegate>

//IBOutlets
@property (strong, nonatomic) IBOutlet UITextField *expenseDescription;
@property (strong, nonatomic) IBOutlet UITextField *expenseAmount;
@property (strong, nonatomic) IBOutlet UILabel *dateTime;

//Class Properties
@property (nonatomic, strong) NSIndexPath *indexPath;

//Class Methods
- (void)updateTableCell;

@end
