//
//  LoginViewController.h
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 7/22/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface LoginViewController : UIViewController

//Database properties
@property(strong, nonatomic) NSString *databasePath;
@property(nonatomic) sqlite3 *DB;

//VC Properties
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
