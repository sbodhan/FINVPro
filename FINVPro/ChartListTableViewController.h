//
//  ChartListTableViewController.h
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 8/4/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ChartListTableViewController : UITableViewController

//Database properties
@property(strong, nonatomic) NSString *databasePath;
@property(nonatomic) sqlite3 *DB;

@property int userIDFromDataEntryVC;
@property (strong, nonatomic) NSString *userNameFromDataEntry;

@property (strong, nonatomic) NSString *expenseCategory;
@property (strong, nonatomic) NSString *amountPerCategory;
@property (strong, nonatomic) NSMutableArray *dbUserDataArray;

@end
