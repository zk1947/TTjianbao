//
//  JHPushServiceManager.h
//  TTjianbao
//
//  Created by jiangchao on 2020/6/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
NS_ASSUME_NONNULL_BEGIN
@interface JHPushServiceManager : UIView
+ (instancetype)sharedInstance;
-(void)initJPushService:(id<JPUSHRegisterDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
