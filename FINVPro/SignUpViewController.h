//
//  SignUpViewController.h
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 7/22/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SignUpViewController : UIViewController

//Database properties
@property(strong, nonatomic) NSString *databasePath;
@property(nonatomic) sqlite3 *DB;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


- (IBAction)signUpButton:(id)sender;

@end
