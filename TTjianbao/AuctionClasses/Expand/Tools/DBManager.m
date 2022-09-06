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
    
    BOOL  res = [self.db executeUpdate:@"create table if not exists User(infoId,mobile,gender,ID,nickname,image,username,mobileVerifyStatus,birthday)"];//执行sql语句
    
    if (res == NO) {
        NSLog(@"创建失败");
        return NO;
    }else{
        NSLog(@"创建成功");
        return YES;
    }
}
-(void)insert_userTable:(UserMode*)user;{
    
    BOOL Res = [self.db open];
    if (Res == NO ) {
        NSLog(@"打开失败");
       
    }else{
          NSLog(@"打开成功");
    }
    
    if (user) {
      [self del_userTableInfo];
        }
    
    BOOL res = [self.db executeUpdate:@"insert into User values (?,?,?,?,?,?,?,?,?)",
                     user.infoId,
                     user.mobile,
                     user.gender,
                     user.ID,
                     user.nickname,
                     user.image,
                     user.username,
                     user.mobileVerifyStatus,
                     user.birthday
                  ];
            if (res == NO) {
                NSLog(@"插入失败");
            }else{
                NSLog(@"插入成功");
            }
    
      [self close_db];
}

-(void)updateTable:(UserMode*)user
{
    
    BOOL Res = [self.db open];
    if (Res == NO ) {
        NSLog(@"打开失败");
        
    }else{
        NSLog(@"打开成功");
    }

    [self creat_table_user];
    
    BOOL res = [self.db executeUpdate:@"update User set infoId=? ,mobile=?,gender=?, ID=?,nickname=?,image=?,username=?,mobileVerifyStatus=?,birthday=?",
                user.infoId,
                user.mobile,
                user.gender,
                user.ID,
                user.nickname,
                user.image,
                user.username,
                user.mobileVerifyStatus,
                user.birthday
                ];
    if (res == NO) {
        NSLog(@"更新失败");
    }else{
        NSLog(@"更新成功");
    }
    
    [self close_db];
    
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

-(UserMode*)select_userTable_info{
    
    BOOL Res = [self.db open];
    if (Res == NO ) {
        NSLog(@"打开失败");
        
    }else{
        NSLog(@"打开成功");
    }
    
    FMResultSet* set = [self.db executeQuery:@"select * from User"];//FMResultSet相当于游标集
    UserMode* user = [[UserMode alloc] init];
    while ([set next]) {//有下一个的话，就取出它的数据，然后关闭数据库
        
        
        NSString* infoId = [set stringForColumn:@"infoId"];
        NSString* mobile = [set stringForColumn:@"mobile"];
        NSString* gender = [set stringForColumn:@"gender"];
        NSString* ID = [set stringForColumn:@"ID"];
        NSString* nickname = [set stringForColumn:@"nickname"];
        NSString* image = [set stringForColumn:@"image"];
        NSString* username = [set stringForColumn:@"username"];
        NSString* mobileVerifyStatus = [set stringForColumn:@"mobileVerifyStatus"];
        NSString* birthday = [set stringForColumn:@"birthday"];
    
        user.infoId=infoId;
        user.mobile=mobile;
        user.gender=gender;
        user.ID=ID;
        user.nickname=nickname;
        user.image=image;
        user.username=username;
        user.mobileVerifyStatus=mobileVerifyStatus;
        user.birthday=birthday;
    
    }
    
    [self close_db];
    
    return user;
}
-(void)del_userTableInfo{
   
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
