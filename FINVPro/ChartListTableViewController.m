//
//  ChartListTableViewController.m
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 8/4/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import "ChartListTableViewController.h"
#import "DataChartViewController.h"

@interface ChartListTableViewController ()

@end

@implementation ChartListTableViewController
//NSArray *chartArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self controllerWelcomeTitle];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    //Build the path to the database
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"finvpro.db"]];
   // chartArray = @[@"LineChart",@"BarChart",@"CircleChart",@"PieChart",@"ScatterChart",@"RadarChart"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self getAmountFromDatabase];
}

-(void)controllerWelcomeTitle {
    //Create custom title on the user data entry screen
    self.navigationItem.hidesBackButton = YES;
    
    NSString *welcomeString = [NSString stringWithFormat:@"Hi %@",_userNameFromDataEntry];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor]};
    
    self.title = welcomeString;
    
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

-(void)getAmountFromDatabase {
    NSMutableArray *dbUserDataArray = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    const char *dbPath = [_databasePath UTF8String];
    
    
    if (sqlite3_open(dbPath, &_DB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT category, userid, SUM(expenseamount) AmountSpent FROM EXPENSES WHERE userid = \"%d\" GROUP BY category, userid", _userIDFromDataEntryVC];
        
        const char *query_statement = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_DB, query_statement, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
    //            NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                //  [self showUIAlertWithMessage:@"Found a match" andTitle:@"Message"];
                _expenseCategory = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                _amountPerCategory = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSLog(@"expense - %@, amount - %@, userid - %d", _expenseCategory, _amountPerCategory, _userIDFromDataEntryVC);
                
                int amountVal = [_amountPerCategory intValue];
                
          //      [_dataDictionary setObject:[NSString stringWithFormat:@"%@",_expenseCategory] forKey:@"Expense Category"];
          //      [_dataDictionary setObject:[NSString stringWithFormat:@"%@",_amountPerCategory] forKey:@"Amount Per Category"];
          //      [_dataDictionary setObject:[NSString stringWithFormat:@"%d",_userIDFromDataEntryVC] forKey:@"User ID"];
                
          //      NSString *str = [NSString stringWithFormat:@"%@::%@::%d",_expenseCategory, _amountPerCategory, _userIDFromDataEntryVC];
                NSString *str = [NSString stringWithFormat:@"%d",amountVal];
                
                [dbUserDataArray addObject:str];
                
                NSLog(@"%@", dbUserDataArray);
            }
      /*      else {
                [self showUIAlertWithMessage:@"NO TRANSACTIONS TO SHOW!!!" andTitle:@"Message"];
            } */
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DataChartViewController * viewController = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"lineChart"]) {
        
        //Add line chart
        
        viewController.title = @"Line Chart";
        
    } else if ([segue.identifier isEqualToString:@"barChart"])
    {
        //Add bar chart
        
        viewController.title = @"Bar Chart";
    } else if ([segue.identifier isEqualToString:@"circleChart"])
    {
        //Add circle chart
        
        viewController.title = @"Circle Chart";
        
    } else if ([segue.identifier isEqualToString:@"pieChart"])
    {
        //Add pie chart
        
        viewController.title = @"Pie Chart";
    } else if ([segue.identifier isEqualToString:@"scatterChart"])
    {
        //Add scatter chart
        
        viewController.title = @"Scatter Chart";
    }else if ([segue.identifier isEqualToString:@"radarChart"])
    {
        viewController.categoryArray = _dbUserDataArray;
        
        viewController.title = @"Radar Chart";
    }

}


@end
