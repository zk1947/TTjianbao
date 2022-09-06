//
//  JHQiYuVIPCustomerServiceManager.m
//  TTjianbao
//
//  Created by user on 2020/11/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHQiYuVIPCustomerServiceManager.h"
#import "UserInfoRequestManager.h"

@implementation JHQiYuVIPCustomerServiceManager

+ (JHQiYuVIPCustomerServiceManager *)shared {
    static dispatch_once_t    once;
    static JHQiYuVIPCustomerServiceManager *shared;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qYloginSuccess:) name:kAllLoginSuccessNotification object:nil];
    });
    return shared;
}

- (void)loadQiYuInfo:(BOOL)isNewLogin {
    BOOL isLogin = [JHRootController isLogin];
    if (!isLogin) {
        return;
    }
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    if (!customerId || [customerId isEqualToString:@""]) {
        return;
    }
    /// 一天之内只能请求一次
    NSUserDefaults *userDefault    = [NSUserDefaults standardUserDefaults];
    NSDate *now                    = [NSDate date];
    NSDate *agoDate                = [userDefault objectForKey:@"jhqy_NowDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *ageDateString        = [dateFormatter stringFromDate:agoDate];
    NSString *nowDateString        = [dateFormatter stringFromDate:now];
    NSLog(@"日期比较：之前：%@ 现在：%@",ageDateString,nowDateString);
    
    if (isNewLogin) {
        [self load];
    } else {
        if ([ageDateString isEqualToString:nowDateString]) {
            /// 每天最多只可以请求一次哦
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"jh_qy_vip"];
            if (dict) {
                [self setQiYuInfo:dict];
            }
        } else {
            [self load];
        }
    }
}

- (void)load {
    NSDictionary *parameters = @{
        @"customerId":[UserInfoRequestManager sharedInstance].user.customerId
    };
    NSString *url = FILE_BASE_STRING(@"/app/customer/qiyu/find-staff");
    [HttpRequestTool postWithURL:url Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSLog(@"qi yu request succeed");
        if (!respondObject.data) {
            return;
        }
        NSDictionary *dict = (NSDictionary *)respondObject.data;
        if (!dict) {
            return;
        }
        
        NSDictionary *newDict = [self deleteNull:dict];
        [self setQiYuInfo:newDict];
        BOOL isSave = [self saveQiYuInfo:newDict];
        if (!isSave) {
            return;
        }
        NSDate *nowDate = [NSDate date];
        NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
        [dataUser setObject:nowDate forKey:@"jhqy_NowDate"];
        [dataUser synchronize];
    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"qi yu request failed");
    }];
}

- (void)setQiYuInfo:(NSDictionary *)data {
    if ([[data allKeys] containsObject:@"groupId"]) {
        if (data[@"groupId"] && ![data[@"groupId"] isEqualToString:@""]) {
            [JHQiYuVIPCustomerServiceManager shared].groupId = data[@"groupId"];
        } else {
            [JHQiYuVIPCustomerServiceManager shared].groupId = @"";
        }
    }
    
    if ([[data allKeys] containsObject:@"staffId"]) {
        if (data[@"staffId"] && ![data[@"staffId"] isEqualToString:@""]) {
            [JHQiYuVIPCustomerServiceManager shared].staffId = data[@"staffId"];
        } else {
            [JHQiYuVIPCustomerServiceManager shared].staffId = @"";
        }
    }
     
    if ([[data allKeys] containsObject:@"vipLevel"]) {
        if (data[@"vipLevel"]) {
            [JHQiYuVIPCustomerServiceManager shared].vipLevel = (NSInteger)data[@"vipLevel"];
        } else {
            [JHQiYuVIPCustomerServiceManager shared].vipLevel = 0;
        }
    }
}


- (NSDictionary *)deleteNull:(NSDictionary *)dict {
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dict.allKeys) {
        if ([[dict objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        } else {
            [mutableDic setObject:[dict objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

- (BOOL)saveQiYuInfo:(NSDictionary *)data {
    if (!data) {
        return NO;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSArray *keyArray = data.allKeys;
    for (NSString *key in keyArray) {
        [params setValue:[data valueForKey:key] forKey:key];
    }
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    [dataUser setObject:params forKey:@"jh_qy_vip"];
    [dataUser synchronize];
    return YES;
}

+ (void)qYloginSuccess:(NSNotification *)no {
    [[self shared] loadQiYuInfo:YES];
}

@end
