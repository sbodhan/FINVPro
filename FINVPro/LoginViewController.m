//
//  LoginViewController.m
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 7/29/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import "LoginViewController.h"
#import "DataEntryViewController.h"

//Function returns a trimmed string for text passed as parameter
NSString *trimmedText(NSString *textString) {
    NSString *trimmedString;
    return trimmedString = [textString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@interface LoginViewController ()

@property int userID;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor]};
    
    self.title = @"Log In";

    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    //Build the path to the database
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"finvpro.db"]];
    //NSLog(@"Login Database Created at %@: ", _databasePath);
 
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    _usernameTF.text = @"";
    _passwordTF.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)loginToAccount:(id)sender {
    
    User *currentUser = [[User alloc]init];
    currentUser.userName = _usernameTF.text;
    currentUser.password = _passwordTF.text;
    
    sqlite3_stmt *statement;
    const char *dbPath = [_databasePath UTF8String];
    
    
    if (sqlite3_open(dbPath, &_DB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT userid FROM USERS WHERE username = \"%@\" AND password = \"%@\"", currentUser.userName, currentUser.password]; //Execute the select SQL on the database to verify if the username and password are in the database
        
        const char *query_statement = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_DB, query_statement, -1, &statement, NULL) == SQLITE_OK) {
            //Verify that all the fields have been populated by the user while signup, if not throw an alert
            
            NSString *trimmedUserName = trimmedText(_usernameTF.text);
            NSString *trimmedPassword = trimmedText(_passwordTF.text);
            
            if ([trimmedUserName isEqualToString:@""] || [trimmedPassword isEqualToString:@""]) {
                [self showUIAlertWithMessage:@"Please complete the entire form" andTitle:@"Message"];
            }
            //Username already exists in the database after below check returns a ROW from database, throw an alert.
            else if (sqlite3_step(statement) == SQLITE_ROW) {
              //  [self showUIAlertWithMessage:@"Found a match" andTitle:@"Message"];
                _userID = sqlite3_column_int(statement, 0);
            }
            else {
                [self showUIAlertWithMessage:@"Username/Password incorrect" andTitle:@"Message"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        DataEntryViewController *vc = [segue destinationViewController];
        vc.userIDFromLoginVC = _userID;
        vc.userNameFromLogin = _usernameTF.text;
        NSLog(@"Firing....");
    }
    else {
        NSLog(@"Not working");
    }
}

@end
