//
//  FirstViewController.h
//  idk
//
//  Created by Simranjot Singh on 19/09/16.
//  Copyright © 2016 Simranjot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpensesTableViewCell.h"
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface ExpensesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *expensesTableView;
@property (strong, nonatomic) FIRDatabaseReference *rootRef;

@end

