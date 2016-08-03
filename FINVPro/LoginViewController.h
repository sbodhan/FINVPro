//
//  LoginViewController.h
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 7/29/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "User.h"

@interface LoginViewController : UIViewController

//Database properties
@property(strong, nonatomic) NSString *databasePath;
@property(nonatomic) sqlite3 *DB;

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;


- (IBAction)loginToAccount:(id)sender;

@end
