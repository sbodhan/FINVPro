//
//  User.h
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 7/28/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;

@end
