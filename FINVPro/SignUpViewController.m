//
//  SignUpViewController.m
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 7/22/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import "SignUpViewController.h"

//Function returns a trimmed string for text passed as parameter
NSString *getTrimmedText(NSString *textString) {
    NSString *trimmedString;
    return trimmedString = [textString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor]};
    
    self.title = @"FINVPro SignUp";
    
    [self createUserTable];

}


-(void)createUserTable {
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    //Build the path to the database
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"finvpro.db"]];
    NSLog(@"Database Created at %@: ", _databasePath);
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if ([fileMgr fileExistsAtPath:_databasePath] == NO) {
        const char *dbPath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbPath, &_DB) == SQLITE_OK) {
            char *errorMessage;
            //Create database table if it does not already exists
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS USERS (userid INTEGER PRIMARY KEY AUTOINCREMENT, firstname TEXT, lastname TEXT, email TEXT, username TEXT, password TEXT);"
                                        "CREATE TABLE IF NOT EXISTS FINCATEGORY (fincatid INTEGER PRIMARY KEY AUTOINCREMENT, fincatname TEXT, userid INTEGER);"
                                        "CREATE TABLE IF NOT EXISTS EXPENSES (expenseid INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, expenseamount TEXT, comment TEXT, expensedate TEXT, userid INTEGER);";
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpButton:(id)sender {
    User *newUser = [[User alloc]init];
    newUser.firstName = _firstNameTextField.text;
    newUser.lastName = _lastNameTextField.text;
    newUser.email = _emailTextField.text;
    newUser.userName = _userNameTextField.text;
    newUser.password = _passwordTextField.text;
    
    sqlite3_stmt *statement;
    const char *dbPath = [_databasePath UTF8String];
    
    NSLog(@"DB Path: %s", dbPath);
    
    if (sqlite3_open(dbPath, &_DB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT firstname FROM USERS WHERE username = \"%@\"", newUser.userName]; //Execute the select SQL on the database to verify if the username already exists in the database
        
        const char *query_statement = [querySQL UTF8String];
        if(sqlite3_prepare_v2(_DB, query_statement, -1, &statement, NULL) == SQLITE_OK) {
            //Verify that all the fields have been populated by the user while signup, if not throw an alert
            
            NSString *trimmedFirstName = getTrimmedText(_firstNameTextField.text);
            NSString *trimmedLastName = getTrimmedText(_lastNameTextField.text);
            NSString *trimmedEmail = getTrimmedText(_emailTextField.text);
            NSString *trimmedUserName = getTrimmedText(_userNameTextField.text);
            NSString *trimmedPassword = getTrimmedText(_passwordTextField.text);
            
            if ([trimmedFirstName isEqualToString:@""] || [trimmedLastName isEqualToString:@""] || [trimmedEmail isEqualToString:@""] || [trimmedUserName isEqualToString:@""] || [trimmedPassword isEqualToString:@""]) {
                [self showUIAlertWithMessage:@"WAIT!!! Fill in the blanks[ALL]" andTitle:@"Message"];
            }
            //Username already exists in the database after below check returns a ROW from database, throw an alert.
            else if (sqlite3_step(statement) == SQLITE_ROW) {
                [self showUIAlertWithMessage:@"OOPS!!! Username taken, please pick another" andTitle:@"Message"];
            }
            else {
                //Once the "empty fields and duplicate username" checks are successful, insert the form data into the database
                NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO USERS (firstname, lastname, email, username, password) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", newUser.firstName, newUser.lastName, newUser.email, newUser.userName, newUser.password]; //Insert SQL based on form data
                
                const char *insert_statement = [insertSQL UTF8String];
                sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
                
                //Show alert indicating user add to the database and clear out/reset all the text boxes to empty
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    [self showUIAlertWithMessage:@"Great, You are now all set to use FINVPro" andTitle:@"Message"];
                    _firstNameTextField.text = @"";
                    _lastNameTextField.text = @"";
                    _emailTextField.text = @"";
                    _userNameTextField.text = @"";
                    _passwordTextField.text = @"";
                }
                else {
                    //Throw error if user add to the database fails
                    [self showUIAlertWithMessage:@"BUMMER!!! We cannot setup your account at this time" andTitle:@"Error"];
                }
            }
        }
        else {
            //Throw error if the database could not be searched/reached
            [self showUIAlertWithMessage:@"Failed to search the database" andTitle:@"Error"];
        }
        //Close database connection
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
}
@end

