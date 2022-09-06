//
//  JHChatUserManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatUserManager.h"
#import "JHIMHeader.h"
#import "NTESLoginManager.h"
#import "JHChatBusiness.h"


@interface JHChatUserManager()<NIMUserManagerDelegate>
@property (nonatomic, strong) JHChatDBManager *dbManager;
@end

@implementation JHChatUserManager

+ (instancetype)sharedManager
{
    static JHChatUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHChatUserManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUserManager];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Public
+ (void)getUserInfoWithID : (NSString *)userId handler : (UserInfoHandler)handler {
    JHChatUserManager *manager = [JHChatUserManager sharedManager];
    [manager getUserInfoWithID:userId handler:handler];
    
}
- (void)getUserInfoWithID : (NSString *)userId handler : (UserInfoHandler)handler {
    
    JHChatUserInfo *userInfo = self.userInfos[userId];
    if (userInfo != nil) {
        if (handler == nil) return;
        handler(userInfo);
        return;
    }else {
        // 更新数据库
        [self requestUserInfo:userId handler:^(JHChatUserInfo * _Nonnull userInfo) {
        }];
    }
    
    [self.dbManager getUserInfo:userId handler:^(JHChatUserInfo * _Nonnull userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (userInfo != nil) {
                [self.userInfos setValue:userInfo forKey:userId];
                if (handler == nil) return;
                handler(userInfo);
            }else {
                [self requestUserInfo:userId handler:^(JHChatUserInfo * _Nonnull userInfo) {
                    [self.userInfos setValue:userInfo forKey:userId];
                    if (handler == nil) return;
                    handler(userInfo);
                }];
            }
        });
    }];
}
#pragma mark - Private
- (void)requestUserInfo : (NSString *)userId handler : (UserInfoHandler)handler{
    if (userId == nil) return;
    [JHChatBusiness getUserInfoWithId:userId
                         successBlock:^(JHChatUserInfo * _Nonnull respondObject){
        
        [self.dbManager insterUserInfo:respondObject];
        if (handler) {
            handler(respondObject);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (handler) {
            handler([[JHChatUserInfo alloc] init]);
        }
    }];
}
/// 是否在黑名单
- (BOOL)isUserInBlack : (NSString *)userId {
    return [[NIMSDK sharedSDK].userManager isUserInBlackList:userId];
}
/// 是否在黑名单
+ (BOOL)isUserInBlack : (NSString *)userId {
    return [[NIMSDK sharedSDK].userManager isUserInBlackList:userId];
}
/// 拉黑
- (void)addToBlack : (NSString *)userId handler : (BlackHandler)handler {
    [[NIMSDK sharedSDK].userManager addToBlackList:userId completion:^(NSError * _Nullable error) {
        if (handler == nil) return;
        handler(error == nil);
    }];
}
/// 移除黑名单
- (void)removeFromBlack : (NSString *)userId handler : (BlackHandler)handler {
    [[NIMSDK sharedSDK].userManager removeFromBlackBlackList:userId completion:^(NSError * _Nullable error) {
        if (handler == nil) return;
        handler(error == nil);
    }];
}
- (void)onBlackListChanged {
    
}

- (void)setupUserManager {
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserInfo) name:NotificationNameUserHeadUpdated object:nil];
    
    NTESLoginData *data = [[NTESLoginManager sharedManager] currentNTESLoginData];
    self.userAccId = [data account];
    [self reloadUserInfo];
    User *user = [UserInfoRequestManager sharedInstance].user;
    self.userId = user.customerId;
}
- (void)needReloadUserInfo : (NSString *)userId {
    
}
- (void)reloadUserInfo {
    [self requestUserInfo:self.userAccId handler:^(JHChatUserInfo * _Nonnull userInfo) {
        [self.userInfos setValue:userInfo forKey:self.userAccId];
        self.userId = userInfo.customerId;
        NSArray *types = @[@2,@4,@6,@7,@9]; // 商家类型
        if ([types containsObject: @(userInfo.customerType)]) {
            NSString *isBusiness = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserIsBusiness"];
            if (isBusiness == nil) {
                [[NSUserDefaults standardUserDefaults] setValue: @"business" forKey:@"UserIsBusiness"];
            }
        }
    }];
}
#pragma mark - Lazy
- (JHChatDBManager *)dbManager {
    if (!_dbManager){
        _dbManager = [JHChatDBManager sharedManager];
    }
    return _dbManager;
}
- (BOOL)userIsBusiness {
    NSString *isBusiness = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserIsBusiness"];
    return [isBusiness isEqualToString:@"business"];
}
- (NSMutableDictionary *)userInfos {
    if (!_userInfos) {
        _userInfos = [[NSMutableDictionary alloc] init];
    }
    return _userInfos;
}
@end
