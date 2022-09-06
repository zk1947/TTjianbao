//
//  JHPushServiceManager.m
//  TTjianbao
//
//  Created by jiangchao on 2020/6/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPushServiceManager.h"
#import "UserInfoRequestManager.h"

#ifdef DEBUG
 BOOL production =NO;
#else
 BOOL production =YES;
#endif
static JHPushServiceManager *instance;
@interface JHPushServiceManager ()
@end
@implementation JHPushServiceManager
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHPushServiceManager alloc] init];
    });
    return instance;
}
-(void)initJPushService:(id<JPUSHRegisterDelegate>)delegate{
    
    // Required init Push
    
    [JPUSHService setupWithOption:nil appKey:@"ce5736172f26bb361ebd777d"
                                      channel:@"AppStore"
                                       apsForProduction:production];
       //Required init APNS
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
       if (@available(iOS 12.0, *)) {
           entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
       } else {
            entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
       }
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
          // 可以添加自定义 categories
          // NSSet<UNNotificationCategory *> *categories for iOS10 or later
          // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        }

    [JPUSHService registerForRemoteNotificationConfig:entity delegate:delegate];
    [JPUSHService setDebugMode];
    
//
   [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
    NSLog(@"registrationID=%@",registrationID);
   [JHTracking profilePushKey:@"jiguangID" pushId:registrationID];
    //方便找问题，如果注册id为空传0000
    [UserInfoRequestManager sharedInstance].registrationID=registrationID?:@"0000";
    [[UserInfoRequestManager sharedInstance]bindDeviceToken:nil];
    
    }];
}

@end
