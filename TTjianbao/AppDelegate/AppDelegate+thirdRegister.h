//
//  AppDelegate+thirdRegister.h
//  TTjianbao
//  Description:三方接入(包括JH)注册及初始化
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (thirdRegister)

//三方注册初始化:注意初始化顺序
- (void)launchingRegisterThirdWithOptions:(NSDictionary *)launchOptions;
//App热启动
- (void)ttJianbaoDidBecomeActive:(UIApplication *)application;
//App即将进入前台
- (void)ttJianbaoWillEnterForeground:(UIApplication *)application;
//App进入后台
- (void)ttJianbaoDidEnterBackground:(UIApplication *)application;
- (void)ttJianbaoWillTerminate:(UIApplication *)application;

- (void)ttJianbaoWillResignActive:(UIApplication *)application;
@end

NS_ASSUME_NONNULL_END
