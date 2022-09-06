//
//  JHChatUserManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHChatUserInfo.h"
#import "JHChatDBManager.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^BlackHandler)(BOOL isSuccess);
typedef void(^UserInfoHandler)(JHChatUserInfo *userInfo);

@interface JHChatUserManager : NSObject
@property (nonatomic, copy) NSString *userAccId;
@property (nonatomic, copy) NSString *userId;
/// 本人是否是商家
@property (nonatomic, assign) BOOL userIsBusiness;

@property (nonatomic, strong) NSMutableDictionary *userInfos;

+ (instancetype)sharedManager;

/// 是否在黑名单
- (BOOL)isUserInBlack : (NSString *)userId;
/// 是否在黑名单
+ (BOOL)isUserInBlack : (NSString *)userId;
/// 拉黑
- (void)addToBlack : (NSString *)userId handler : (BlackHandler)handler;
/// 移除黑名单
- (void)removeFromBlack : (NSString *)userId handler : (BlackHandler)handler;

- (void)getUserInfoWithID : (NSString *)userId handler : (UserInfoHandler)handler;

+ (void)getUserInfoWithID : (NSString *)userId handler : (UserInfoHandler)handler;

- (void)requestUserInfo : (NSString *)userId handler : (UserInfoHandler)handler;

@end

NS_ASSUME_NONNULL_END
