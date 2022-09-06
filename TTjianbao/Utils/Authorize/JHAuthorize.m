//
//  JHAuthorize.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/8/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAuthorize.h"
#import "CommAlertView.h"
#import "JHAlertView.h"
#import "JHAppAlertModel.h"
#import "JHAppAlertViewManger.h"

#import "JHPushAlertView.h"

static NSInteger const LimitCyclicAuthorizeDay = 3 * 24 * 60 * 60;
static NSString *const NotificationAuthorizeKey = @"NotificationAuthorizeDate";

static NSString *const TriggerNotificationAuthorizeKey = @"TriggerNotificationAuthorizeKey";

@interface JHAuthorize ()
@property (nonatomic, assign) BOOL isOpenPush;
@end
@implementation JHAuthorize

#pragma mark - Public
+ (void)verifyNotificationAuthorizetion {
    
    [JHAuthorize authorizeNotification:^(BOOL isAuthorized) {
        // 埋点
        [JHAllStatistics setProfile:@{@"is_push": @(isAuthorized)}];
        
        if (isAuthorized == true) return;
        
        NSInteger date = [[NSUserDefaults standardUserDefaults] integerForKey:NotificationAuthorizeKey];
        NSInteger time = [JHAuthorize getNowDateInterval];
        NSInteger timeInterval = time - date;
        if (date > 0 && timeInterval <= LimitCyclicAuthorizeDay) return;
        [JHAuthorize addNotification];
    }];
}
+ (void)authorizeNotification : (AuthorizeHandler)handler{
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [queue addOperationWithBlock:^{
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                handler(true);
            }else {
                handler(false);
            }
        }];
    }];
}
// 添加到弹框队列
+ (void)addNotification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JHAppAlertModel *model = [[JHAppAlertModel alloc] init];
        model.type = JHAppAlertTypeNotification;
        model.typeName = AppAlertNameNotification;
        model.localType = JHAppAlertLocalTypeHome;
        [JHAppAlertViewManger addModelArray:@[model]];
    });
}
+ (void)showNotificationAlertView {
    [JHAlertView showWithTitle:@"开启消息通知" desc:@"实时获取活动、福利、订单进度" handler:^{
        [JHAuthorize openSettingsView];
    }];
    NSInteger time = [JHAuthorize getNowDateInterval];
    [[NSUserDefaults standardUserDefaults] setInteger:time forKey:NotificationAuthorizeKey];
}

+ (void)openSettingsView {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (NSTimeInterval)getNowDateInterval {
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeInterval timeSp = [datenow timeIntervalSince1970];
    return timeSp;
}

+ (void)clickTriggerPushAuthorizetion : (JHAuthorizeClickType)type {
    [[JHAuthorize sharedManager] triggerPushAuthorizetion : type];
}

+ (instancetype)sharedManager {
    static JHAuthorize *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHAuthorize alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupAuthorize];
    }
    return self;
}

- (void)triggerPushAuthorizetion : (JHAuthorizeClickType)type{
    if (self.isOpenPush) return;
    
    [JHAuthorize authorizeNotification:^(BOOL isAuthorized) {
        if (isAuthorized == true) {
            self.isOpenPush = true;
            return;
        }
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:TriggerNotificationAuthorizeKey];
        NSInteger date = [dict[@"date"] integerValue];
        NSInteger num = [dict[@"number"] integerValue];
        
        NSInteger time = [JHAuthorize getNowDateInterval];
        NSInteger timeInterval = time - date;
        
        if (date == 0 || timeInterval > LimitCyclicAuthorizeDay) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@(time) forKey:@"date"];
            [dict setValue:@(1) forKey:@"number"];
            [[NSUserDefaults standardUserDefaults] setValue:dict forKey:TriggerNotificationAuthorizeKey];
            [self showTriggerPushAlertView : type];
        }else {
            if (num > 2) return;
            [self showTriggerPushAlertView : type];
        }
    }];
}

#pragma mark - Private
- (void)setupAuthorize {
    @weakify(self)
    [JHAuthorize authorizeNotification:^(BOOL isAuthorized) {
        @strongify(self)
        self.isOpenPush = isAuthorized;
    }];
}
- (void)showTriggerPushAlertView : (JHAuthorizeClickType)type {
    
    JHAlertViewModel *model = [JHAlertViewModel getAlertViewModelWithType: type];
    // 延迟1秒弹框-防止覆盖 toast
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JHPushAlertView showWithTitle:model.titleText subTitle:model.subtitleText desc:model.detailText handler:^{
            [JHAuthorize openSettingsView];
            [self recordClickOpenSetting:model.titleText];
        }];
        [self recordTriggerPushAlert:model.titleText];
    });
    
    // 记录弹框弹出数
    [self recordPushShowNum];
}

- (void)recordPushShowNum {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:TriggerNotificationAuthorizeKey];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    NSInteger num = [dict[@"number"] integerValue];
    num += 1;
    [newDict setValue:@(num) forKey:@"number"];
    
    [[NSUserDefaults standardUserDefaults] setValue:newDict forKey:TriggerNotificationAuthorizeKey];
}

#pragma mark - 埋点
+ (void)reportIsOpenPush : (BOOL)isPush{
    // 点击事件 应与 源状态相反
    NSDictionary *par = @{
        @"is_push" : @(isPush),
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"profile_set"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
- (void)recordTriggerPushAlert : (NSString *)title {
    NSDictionary *par = @{
        @"layer_type" : @"场景引导PUSH",
        @"layer_name" : title,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"epOpenLayer"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}

- (void)recordClickOpenSetting : (NSString *)title {
    NSDictionary *par = @{
        @"layer_type" : @"场景引导PUSH",
        @"layer_name" : title,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickIntoLayer"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
@end
