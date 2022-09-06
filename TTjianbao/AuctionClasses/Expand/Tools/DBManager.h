//
//  DBManager.h
//  Aidangbao
//
//  Created by jiangchao on 15/5/27.
//  Copyright (c) 2015年 jiangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
//#import "UserMode.h"

@interface DBManager : NSObject
{
    FMDatabase* _db;
    NSString *_path;
}
@property(nonatomic,strong)FMDatabase* db;
@property(nonatomic,strong) NSString *path;

@property(nonatomic,strong) NSString *Accountpath;
+(DBManager*)getInstance;
-(BOOL)creat_db;
-(BOOL)creat_table_user;
//-(void)insert_userTable:(UserMode*)user;
//-(UserMode*)select_userTable_info;
//-(void)updateTable:(UserMode*)user;
-(void)updateTablePargrams:(NSString*)parameter andValue:(NSString*)value;
-(void)del_userTableInfo;

@end
