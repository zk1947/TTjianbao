//
//  JHAuthorize.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/8/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  系统权限

#import <Foundation/Foundation.h>
#import "JHAlertViewModel.h"

typedef void(^AuthorizeHandler)(BOOL isAuthorized);
NS_ASSUME_NONNULL_BEGIN

@interface JHAuthorize : NSObject
/// 权限验证单例
+ (instancetype)sharedManager;
/// 是否开启了通知权限 + 打开通知弹框
+ (void)verifyNotificationAuthorizetion;
/// 获取通知权限
+ (void)authorizeNotification : (AuthorizeHandler)handler;
/// 开启通知弹框
+ (void)showNotificationAlertView;
/// 点击触发验证是否开启了push
+ (void)clickTriggerPushAuthorizetion : (JHAuthorizeClickType)type;
@end

NS_ASSUME_NONNULL_END
