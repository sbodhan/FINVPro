//
//  DataEntryViewController.m
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 8/2/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import "DataEntryViewController.h"
#import "LoginViewController.h"

//Function returns a trimmed string for text passed as parameter
NSString *trimmedText(NSString *textString) {
    NSString *trimmedString;
    return trimmedString = [textString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@interface DataEntryViewController () {
    NSArray *_pickerData;
    NSInteger pickerRow;
    NSString *pickerRowText;
}
@end

@implementation DataEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self databaseSetup];
    //Pass USER ID from the login screen to the user ID text box in data entry.
    NSString *userIDFromLoginVCStr;
    userIDFromLoginVCStr = [NSString stringWithFormat:@"%d", _userIDFromLoginVC];
    
    _userIDTF.text = userIDFromLoginVCStr;
    
    [self currentDayDate];
    [self controllerWelcomeTitle];
    [self categoryPickerArray];
}

-(void)databaseSetup {
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    //Build the path to the database
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"finvpro.db"]];
    //NSLog(@"Login Database Created at %@: ", _databasePath);
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if ([fileMgr fileExistsAtPath:_databasePath] == NO) {
        const char *dbPath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbPath, &_DB) == SQLITE_OK) {
            char *errorMessage;
            //Create database table if it does not already exists
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS EXPENSES (expenseid INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, expenseamount DOUBLE, comment TEXT, expensedate DATE, userid INTEGER);";
            
            //check for database table creation result, if there is an error throw an alert (exception)
            if (sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                [self showUIAlertWithMessage:@"Failed to create the table" andTitle:@"Error"];
            } else {
                [self showUIAlertWithMessage:@"Created the table(s)" andTitle:@"Message"];
            }
            sqlite3_close(_DB);
        }
        else {
            [self showUIAlertWithMessage:@"Failed to open/create the table" andTitle:@"Error"];
        }
    }
}

//Create alert messages on database error or successful completion
-(void) showUIAlertWithMessage:(NSString *)message andTitle:(NSString *)title {
    UIAlertController *alert =  [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)selectPickerValue {
    pickerRow = [_picker selectedRowInComponent:0];
    pickerRowText = [_pickerData objectAtIndex:pickerRow];
}

-(void)currentDayDate {
    //Set current date to date text field
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    _currentDateTF.text = [NSString stringWithFormat:@"%@", dateString];
}

-(void)controllerWelcomeTitle {
    //Create custom title on the user data entry screen
    self.navigationItem.hidesBackButton = YES;
    
    NSString *welcomeString = [NSString stringWithFormat:@"Hi %@",_userNameFromLogin];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor]};
    
    self.title = welcomeString;

}

-(void)categoryPickerArray {
    //Initialize picker data
    _pickerData = @[@"Groceries", @"Eating Out", @"Household", @"Clothing", @"Transport", @"Travel", @"Medical", @"Utilities", @"Rent", @"Fun", @"Gifts", @"Education", @"Car", @"Gas", @"Other"];
    
    // Connect data
    self.picker.dataSource = self;
    self.picker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

- (IBAction)addTransactionToDB:(id)sender {
    double expenseAmount = [_amountTF.text doubleValue];
    
    [self selectPickerValue];
    NSLog(@"Selected: %@",pickerRowText);
    
    Expense *newExpense = [[Expense alloc] init];
    newExpense.userID = _userIDTF.text;
    newExpense.comment = _commentTF.text;
    newExpense.category = pickerRowText;
    newExpense.amount = expenseAmount;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *dateConv = [formatter dateFromString:_currentDateTF.text];
    newExpense.currentDate = dateConv;

    
    sqlite3_stmt *statement;
    const char *dbPath = [_databasePath UTF8String];
    
    
    if (sqlite3_open(dbPath, &_DB) == SQLITE_OK) {
        
            NSString *trimmedAmount = trimmedText(_amountTF.text);
            
            if ([trimmedAmount isEqualToString:@""]) {
                [self showUIAlertWithMessage:@"Please enter the amount" andTitle:@"Message"];
            }
            else {
                NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO EXPENSES (category, expenseamount, comment, expensedate, userid) VALUES (\"%@\", \"%f\", \"%@\", \"%@\", \"%@\")", newExpense.category, newExpense.amount, newExpense.comment, newExpense.currentDate, newExpense.userID];
                
                const char *insert_statement = [insertSQL UTF8String];
                sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
                
                //Show alert indicating user add to the database and clear out/reset all the text boxes to empty
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    [self showUIAlertWithMessage:@"Expense added to the database" andTitle:@"Message"];
                    _commentTF.text = @"";
                    _amountTF.text = @"";
                }
                else {
                    //Throw error if user add to the database fails
                    [self showUIAlertWithMessage:@"Failed to add expense" andTitle:@"Error"];
                }
            }
        
        //Close database connection
        sqlite3_close(_DB);
    }
}
@end
