//
//  Expense.h
//  FINVPro
//
//  Created by Srinivas Bodhanampati on 8/3/16.
//  Copyright © 2016 Srinivas Bodhanampati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject

@property int userID;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *currentDate;

//@property (strong, nonatomic) NSDate *currentDate;
//@property double amount;

@end
