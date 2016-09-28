//
//  ExpensesTableViewCell.m
//  idk
//
//  Created by Simranjot Singh on 19/09/16.
//  Copyright © 2016 Simranjot. All rights reserved.
//

#import "ExpensesTableViewCell.h"

@implementation ExpensesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    _expenseAmount.delegate = self;
    _expenseDescription.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTableCell{
    
}
#pragma TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _expenseAmount) {
        
        textField.inputAccessoryView = [self getKeyboardToolBar];
        
        if(textField.text.length == 0){
            
            [textField setText:@"$"];
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _expenseAmount) {
        
        NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSString *amountString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        amountString = [[amountString componentsSeparatedByCharactersInSet:nonNumberSet] componentsJoinedByString:@""];
        
        if (amountString.length > 6) {
            amountString = [amountString substringToIndex:6];
        }
        
        [textField setText:[@"$" stringByAppendingString:amountString]];
        
        return NO;
        
    }else{
        
        if(range.length + range.location > textField.text.length){
            
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 17;
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _expenseAmount) {
        
        if (textField.text.length == 1) {
            
            textField.text = nil;
        }
    }
}

#pragma Keyboard ToolBar

- (UIToolbar *) getKeyboardToolBar{
    
    UIToolbar* keyboardToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    keyboardToolBar.backgroundColor = [UIColor clearColor];
    
    keyboardToolBar.items = [NSArray arrayWithObjects:
                           //[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyboard)],
                           nil];
    
    [keyboardToolBar sizeToFit];
    return keyboardToolBar;
}

- (void)doneWithKeyboard{
    
    [self endEditing:YES];
}

#pragma Nil Delegates

- (void)dealloc{
    
    _expenseDescription.delegate = nil;
    _expenseAmount.delegate = nil;
}

@end
