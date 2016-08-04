//
//  DataEntryViewController.h
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 8/2/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Expense.h"

@interface DataEntryViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

//Database properties
@property(strong, nonatomic) NSString *databasePath;
@property(nonatomic) sqlite3 *DB;

@property (weak, nonatomic) IBOutlet UITextField *userIDTF;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UITextField *currentDateTF;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property int userIDFromLoginVC;
@property (strong, nonatomic) NSString *userNameFromLogin;

- (IBAction)addTransactionToDB:(id)sender;

@end
