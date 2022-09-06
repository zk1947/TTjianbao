//
//  JHChatDBManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHChatUserInfo.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^UserInfoHandler)(JHChatUserInfo *userInfo);
typedef void(^UserInfosHandler)( NSArray <JHChatUserInfo *> *userInfos);

@interface JHChatDBManager : NSObject

+ (instancetype)sharedManager;
/// 获取用户信息
- (void)getUserInfo : (NSString *)userId handler : (UserInfoHandler)handler;
/// 插入数据
- (void)insterUserInfo : (JHChatUserInfo *) userInfo;
@end

NS_ASSUME_NONNULL_END
