//
//  DBManager.h
//  Task Arranger
//
//  Created by Don Ka Cheung on 26/1/2017.
//  Copyright © 2017年 Don Ka Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

// public method 1
-(NSArray *)loadDataFromDB:(NSString *)query;

// public method 2
-(void)executeQuery:(NSString *)query;
@end
