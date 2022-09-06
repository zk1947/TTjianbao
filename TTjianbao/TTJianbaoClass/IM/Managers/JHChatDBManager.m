//
//  JHChatDBManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatDBManager.h"

@interface JHChatDBManager()
@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) FMDatabaseQueue *queue;
@end
@implementation JHChatDBManager

+ (instancetype)sharedManager
{
    static JHChatDBManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHChatDBManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupManager];
    }
    return self;
}
/// 获取用户信息
- (void)getUserInfo : (NSString *)userId handler : (UserInfoHandler)handler{
    
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery: @"select * from userInfo where userId = ?", userId];
        JHChatUserInfo *userInfo;
        while([result next]) {
            userInfo = [[JHChatUserInfo alloc] init];
            userInfo.userId = [result stringForColumn:@"userId"];
            userInfo.userName = [result stringForColumn:@"userName"];
            userInfo.nickName = [result stringForColumn:@"nickName"];
            userInfo.vatarUrl = [result stringForColumn:@"vatarUrl"];
            userInfo.customerId = [result stringForColumn:@"customerId"];
            userInfo.customerType = [result intForColumn:@"customerType"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(userInfo);
        });
        
    }];
    
}
- (void)getAllInfo : (UserInfosHandler)handler {
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery: @"select * from userInfo"];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        while([result next]) {
            JHChatUserInfo *userInfo = [[JHChatUserInfo alloc] init];
            userInfo.userId = [result stringForColumn:@"userId"];
            userInfo.userName = [result stringForColumn:@"userName"];
            userInfo.nickName = [result stringForColumn:@"nickName"];
            userInfo.vatarUrl = [result stringForColumn:@"vatarUrl"];
            userInfo.customerId = [result stringForColumn:@"customerId"];
            userInfo.customerType = [result intForColumn:@"customerType"];
            [array appendObject:userInfo];
        }
        handler(array);
    }];
    
}
- (void)insterUserInfo : (JHChatUserInfo *) userInfo {
    
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        [db executeUpdate:@"insert or replace into userInfo (userId, userName, nickName, vatarUrl, customerId, customerType) values (?,?,?,?,?,?)",
         userInfo.userId,
         userInfo.userName,
         userInfo.nickName,
         userInfo.vatarUrl,
         userInfo.customerId,
         @(userInfo.customerType)];
    }];
    
}
- (void)setupManager {
    
    //初始化数据表
    [self addUserInfoTable];
    
}
-(void)addUserInfoTable{
    NSString *userInfoSQL = @"create table if not exists userInfo (userId text PRIMARY KEY, userName text, nickName text, vatarUrl text, customerId text, customerType int)";
    
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:userInfoSQL ];
        if (result) {
            NSLog(@"创建表格成功");
        } else {
            NSLog(@"创建表格失败");
        }
        
    }];
}

- (NSString *)getPath {
    //获得Documents目录路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
    //文件路径
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"chatNewUserInfo.db"];
    
    return filePath;
}
- (FMDatabase *)db {
    if (!_db) {
        _db = [FMDatabase databaseWithPath:[self getPath]];
    }
    return _db;
}
- (FMDatabaseQueue *)queue {
    if (!_queue) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:[self getPath]];
    }
    return _queue;
}
@end
