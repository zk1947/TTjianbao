//
//  AppDelegate+push.m
//  TTjianbao
//
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "AppDelegate+push.h"
#import "JHPushDataModel.h"
#import "QYSDK.h"
#import "JHLaunchOptionsModel.h"
#import "UserInfoRequestManager.h"
#import "JHPushServiceManager.h"
#import "JPUSHService.h"
#import "CommHelp.h"
#import "SensorsFocusHelper.h"
#import <NIMSDK/NIMSDK.h>

typedef NS_ENUM(NSInteger, JHPushReportType)
{
    JHPushReportTypeDefault = 0,    //默认
    JHPushReportTypeAppLaunch  = JHPushReportTypeDefault,
    JHPushReportTypeReceiveNotify,
    JHPushReportTypeEnd,
};
JHPushReportType pushReportType;

@interface AppDelegate () <UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate (push)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma mark - register XG Jpush
- (void)registerPush
{
  [[JHPushServiceManager sharedInstance] initJPushService:self];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenString = [CommHelp ConvertDataToString:deviceToken];
    NSLog(@"deviceTokenStr=%@\n deviceToken=%@",deviceTokenString,deviceToken);
    
    [JPUSHService registerDeviceToken:deviceToken];
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
    [JHPushDataModel saveUserDeviceToken:deviceToken];
    [[NIMSDK sharedSDK] updateApnsToken: deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"didReceiveRemoteNotification=%@",userInfo);
    // 记录 推送打开 事件
    [SensorsFocusHelper trackSensorsFocusAppOpenNotificationWithUserInfo:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"jPush-willPresentNotification=%@",userInfo);
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
  NSDictionary * userInfo = response.notification.request.content.userInfo;
    // 记录 推送打开 事件
    [SensorsFocusHelper trackSensorsFocusAppOpenNotificationWithUserInfo:userInfo];
  NSLog(@"点击%@",userInfo);
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
    [self uploadPushClickEventRecieveNotify:response];
    [[NSNotificationCenter defaultCenter] postNotificationName:APNSNotifaction object:response.notification];
   }
  completionHandler();  // 系统要求执行这个方法
}
// 清除角标数字
- (void)clearBadgeNumber
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; //清除角标
    pushReportType = JHPushReportTypeReceiveNotify;
}
#pragma mark - up report
- (void)uploadPushClickEventWithLaunchingOptions:(NSDictionary *)launchOptions
{
    JHLaunchOptionsModel *model = [JHLaunchOptionsModel convertData:launchOptions];
    if(model.remoteNotification.pushId)
    {
        [JHPushDataModel requestPushClicked:model.remoteNotification.pushId];
    }

    pushReportType = JHPushReportTypeAppLaunch;
}

- (void)uploadPushClickEventRecieveNotify:(UNNotificationResponse *)response
{
    if(pushReportType > JHPushReportTypeAppLaunch)
    {
        NSDictionary* info = response.notification.request.content.userInfo;
        JHLaunchOptionsNotifyModel* model = [JHLaunchOptionsNotifyModel convertData:info];
        if(model.pushId)
        {
            [JHPushDataModel requestPushClicked:model.pushId];
        }
    }
}

@end
