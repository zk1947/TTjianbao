//
//  AppDelegate+push.h
//  TTjianbao
//  Description:推送Push(包括直播)及Message Center
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "AppDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (push)

- (void)uploadPushClickEventWithLaunchingOptions:(NSDictionary *)launchOptions;
// 清除角标数字
- (void)clearBadgeNumber;
- (void)registerPush;
@end

NS_ASSUME_NONNULL_END
