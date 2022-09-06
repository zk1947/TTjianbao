//
//  DBManager.m
//  Aidangbao
//
//  Created by jiangchao on 15/5/27.
//  Copyright (c) 2015年 jiangchao. All rights reserved.
//

#import "DBManager.h"
@implementation DBManager
@synthesize db = _db;
@synthesize path = _path;
@synthesize Accountpath;
static DBManager* instance = nil;
+(DBManager*)getInstance{
    if( instance == nil)
    {
        instance = [[self alloc] init];
    }
    return instance;
}
-(id)init{
    
    self = [super init];
    if (self) {
        self.path = NSHomeDirectory();
        self.path = [self.path stringByAppendingPathComponent:@"Documents/User.db"];
        
    }
    return self;
}
-(BOOL)creat_db{
    
    self.db = [FMDatabase databaseWithPath:self.path];
    BOOL res = [self.db open];
    if (res == NO ) {
        NSLog(@"打开失败");
        return NO;
    }else{
        NSLog(@"打开成功");
        return YES;
    }
}

-(BOOL)creat_table_user{
   
    BOOL  res = [self.db executeUpdate:@"create table if not exists User(name,mobile,icon,authStatus,invitationCode,loginWay,type,customerId,balance)"];//执行sql语句
    
    if (res == NO) {
        NSLog(@"创建失败");
        return NO;
    }else{
        NSLog(@"创建成功");
        return YES;
    }
}
-(void)insert_userTable:(User*)user;{
    
//    BOOL Res = [self.db open];
//    if (Res == NO ) {
//        NSLog(@"打开失败");
//
//    }else{
//        NSLog(@"打开成功");
//    }
//
//    if (user) {
//        [self del_userTableInfo];
//    }
//
//    BOOL res = [self.db executeUpdate:@"insert into User values (?,?,?,?,?,?,?,?)",
//                user.name,
//                user.mobile,
//                user.icon,
//                user.authStatus,
//                user.invitationCode,
//                user.loginWay,
//               [NSString stringWithFormat:@"%ld",user.type],
//                user.customerId,
//                 user.balance
//                ];
//    if (res == NO) {
//        NSLog(@"插入失败");
//    }else{
//        NSLog(@"插入成功");
//    }
//
//    [self close_db];
    
    NSDictionary *dict = [user mj_keyValues];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserInfoKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)updateTable:(User*)user
{
    
//    BOOL Res = [self.db open];
//    if (Res == NO ) {
//        NSLog(@"打开失败");
//
//    }else{
//        NSLog(@"打开成功");
//    }
//
//    [self creat_table_user];
//
//    BOOL res = [self.db executeUpdate:@"update User set name=? ,mobile=?,icon=?,authStatus=? ,invitationCode=?,loginWay=?,type=?, customerId=?,balance=?",
//
//                user.name,
//                user.mobile,
//                user.icon,
//                user.authStatus,
//                user.invitationCode,
//                user.loginWay,
//               [NSString stringWithFormat:@"%ld",user.type],
//                user.customerId,
//                user.balance
//
//                ];
//    if (res == NO) {
//        NSLog(@"更新失败");
//    }else{
//        NSLog(@"更新成功");
//    }
//
//    [self close_db];
    
    NSDictionary *dict = [user mj_keyValues];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserInfoKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)updateTablePargrams:(NSString*)parameter andValue:(NSString*)value
{
    
    BOOL Res = [self.db open];
    if (Res == NO ) {
        NSLog(@"打开失败");
        
    }else{
        NSLog(@"打开成功");
    }
    
    [self creat_table_user];
    
    NSString* UpdatetStr=[NSString stringWithFormat:@"update User set %@=?",parameter];
    BOOL res = [self.db executeUpdate:UpdatetStr ,value];
    if (res == NO) {
        NSLog(@"更新失败");
    }else{
        NSLog(@"更新成功");
    }
    
    [self close_db];
    
}

-(User*)select_userTable_info{
    
//    BOOL Res = [self.db open];
//    if (Res == NO ) {
//        NSLog(@"打开失败");
//
//    }else{
//        NSLog(@"打开成功");
//    }
//
//    FMResultSet* set = [self.db executeQuery:@"select * from User"];//FMResultSet相当于游标集
//    User* user = [[User alloc] init];
//    while ([set next]) {//有下一个的话，就取出它的数据，然后关闭数据库
//
//        NSString* mobile = [set stringForColumn:@"mobile"];
//        NSString* name = [set stringForColumn:@"name"];
//        NSString* icon = [set stringForColumn:@"icon"];
//        NSString* authStatus = [set stringForColumn:@"authStatus"];
//        NSString* invitationCode = [set stringForColumn:@"invitationCode"];
//        NSString* loginWay = [set stringForColumn:@"loginWay"];
//        NSString* type = [set stringForColumn:@"type"];
//        NSString* customerId = [set stringForColumn:@"customerId"];
////        NSString* balance = [set stringForColumn:@"balance"];
//
//        user.mobile=mobile;
//        user.name=name;
//        user.icon=icon;
//        user.authStatus=authStatus;
//        user.invitationCode=invitationCode;
//        user.loginWay=loginWay;
//        user.type=[type integerValue];
//        user.customerId=customerId;
////        user.balance = balance;
//    }
//
//    [self close_db];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserInfoKey"];
    User *user = [User mj_objectWithKeyValues:dict];
    if (dict == nil) {
        user = [self get_userTable_info];
        [self insert_userTable:user];
    }
    
    return user;
}
-(User*)get_userTable_info{
    
    BOOL Res = [self.db open];
    if (Res == NO ) {
        NSLog(@"打开失败");

    }else{
        NSLog(@"打开成功");
    }

    FMResultSet* set = [self.db executeQuery:@"select * from User"];//FMResultSet相当于游标集
    User* user = [[User alloc] init];
    while ([set next]) {//有下一个的话，就取出它的数据，然后关闭数据库

        NSString* mobile = [set stringForColumn:@"mobile"];
        NSString* name = [set stringForColumn:@"name"];
        NSString* icon = [set stringForColumn:@"icon"];
        NSString* authStatus = [set stringForColumn:@"authStatus"];
        NSString* invitationCode = [set stringForColumn:@"invitationCode"];
        NSString* loginWay = [set stringForColumn:@"loginWay"];
        NSString* type = [set stringForColumn:@"type"];
        NSString* customerId = [set stringForColumn:@"customerId"];
//        NSString* balance = [set stringForColumn:@"balance"];

        user.mobile=mobile;
        user.name=name;
        user.icon=icon;
        user.authStatus=authStatus;
        user.invitationCode=invitationCode;
        user.loginWay=loginWay;
        user.type=[type integerValue];
        user.customerId=customerId;
//        user.balance = balance;
    }

    [self close_db];
    
    return user;
}
-(void)del_userTableInfo{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserInfoKey"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:@"UserInfoKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (dict != nil) return;
    BOOL Res = [self.db open];
    if (Res == NO ) {
        NSLog(@"打开失败");

    }else{
        NSLog(@"打开成功");
    }

    BOOL res = [self.db executeUpdate:@"delete from User"];
    if (res == NO) {
        NSLog(@"删除失败");
    }else{
        NSLog(@"删除成功");
    }
}

-(void)close_db{
    [self.db close];
    
}
@end

