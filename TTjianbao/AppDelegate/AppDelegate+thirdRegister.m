//
//  AppDelegate+thirdRegister.m
//  TTjianbao
//
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "AppDelegate+thirdRegister.h"
#import "JHException.h"
#import "JHAntiFraud.h"
#import "DBManager.h"
#import "UMengManager.h"
#import "JHQYChatManage.h"
#import "GrowingManager.h"
#import "Tracking.h"
#import "JHCustomBugly.h"
#import "SVProgressHUD.h"
#import "STRIAPManager.h"
#import <GDTActionSDK/GDTAction.h>
#import "NTESDemoConfig.h"
#import "NTESLogManager.h"
#import "NTESAttachDecoder.h"
#import "JHBuryPointOperator.h"
#import "SourceMallApiManager.h"
#import "JHMessageCenterData.h"
#import "JHNimNotificationManager.h"
#import "JHGuestLoginNIMSDKManage.h"
#import "TTjianbaoMarcoKeyword.h"
#import "UserInfoRequestManager.h"
#import "JHAPPAsyncConfigManager.h"
#import "AppDelegate+push.h"
#import "JHJVerfication.h"
#import "JHSkinManager.h"
#import "JHSkinSceneManager.h"
#import "JHTracking.h"
#import "UserInfoRequestManager.h"
#import <TTSDKFramework/TTVideoEngineHeader.h>
#import <TTSDKFramework/TTSDKManager.h>
#import <AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "JHPasteboardManager.h"

#define APP_ID @"201004"
#define APP_NAME @"testvideo"
#define CHANNEL @"testvideo"
#define BUNDLE_ID @"com.tianmou.jianbao"

@implementation AppDelegate (thirdRegister)

- (void)launchingRegisterThirdWithOptions:(NSDictionary *)launchOptions
{
    //神策
    [JHTracking registTrackSDKWithLaunchOptions:launchOptions];
    /** 播放器初始化*/
    [self registTTSDK];
	
    [self configurationFMDB];
    [JHJVerfication startJVerfication];
    [JHCustomBugly buglySetUp];
    [self checkChannelCode];
    [SVProgressHUD setMaximumDismissTimeInterval:1];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAppInitData) name:FirstNetNotifaction object:nil];
    [[UserInfoRequestManager sharedInstance] netWorkReachable];
    /// IDFA申请权限
    if (@available(iOS 14.5, *)) {
        @weakify(self);
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            @strongify(self);
            [self requestIDFAInfo];
        }];
    }
    [self getAppInitData];
    [JHQYChatManage setUpQY];
    [Growing startWithAccountId:@"be51dd67d0c41c21"];
    //Umeng注册
    [[UMengManager shareInstance] setUMeng:launchOptions];
    #if DEBUG
        /**由于Umeng注册后,关闭上报,导致控制台无法打印,这里自定义异常打印*/
        [JHException setupExceptionHandler];
    #endif
    [JHAntiFraud registerExtHandler]; //数美注册
    
    [self configurationNIM];
    //启动时候检查内购凭证
    [STRIAPManager shareSIAPManager];
    [JHNimNotificationManager sharedManager];
    [JHGuestLoginNIMSDKManage sharedInstance];
    
    [GDTAction init:@"1109261411" secretKey:@"067d1aa6af1ab5254d2f4433b6df7ea8"];
    
    [[JHAPPAsyncConfigManager shareInstance] updateAsyncConfig];
    
    [self uploadPushClickEventWithLaunchingOptions:launchOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pasteMethod) name:UIMenuControllerWillShowMenuNotification object:nil];
}

- (void)registTTSDK {
    TTSDKConfiguration *configuration = [TTSDKConfiguration defaultConfigurationWithAppID:APP_ID];
    configuration.appName = APP_NAME;
    configuration.channel = CHANNEL;
    configuration.bundleID = BUNDLE_ID;
    configuration.licenseFilePath = [NSBundle.mainBundle pathForResource:@"TTLicense.txt" ofType:nil];
    [TTSDKManager startWithConfiguration:configuration];
    
    // 1. 配置
    TTVideoEngine.ls_localServerConfigure.maxCacheSize = 300 * 1024 * 1024;// 300M
    NSString *cacheDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"com.video.cache"];
    TTVideoEngine.ls_localServerConfigure.cachDirectory = cacheDir;
    [TTVideoEngine ls_start];
}

- (void)pasteMethod {
    NSString *pasteString = [UIPasteboard generalPasteboard].string;
    if([pasteString containsString:@"http"]) {
        pasteString = [NSString stringWithFormat:@"%@ ",pasteString];
        [[UIPasteboard generalPasteboard] setString:pasteString];
    }
}

- (void)ttJianbaoWillResignActive:(UIApplication *)application {
    [TTVideoEngine stopOpenGLESActivity];
}

- (void)ttJianbaoDidBecomeActive:(UIApplication *)application
{
    [JHPasteboardManager pasteboardParse];
    
    [TTVideoEngine startOpenGLESActivity];
    [GDTAction logAction:GDTSDKActionNameStartApp actionParam:@{@"value":@"123"}];
    [[UserInfoRequestManager sharedInstance] syncServeTime];
    [[JHBuryPointOperator shareInstance] devInBury];
    [self clearBadgeNumber];// 清除角标
    //打印customerId,方便数据查询
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    NSLog(@"didBecomeActive>customerId<%@~~ ",userId);
}

- (void)ttJianbaoWillTerminate:(UIApplication *)application
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[JHBuryPointOperator shareInstance] devOutBury];
    });
}

- (void)ttJianbaoWillEnterForeground:(UIApplication *)application
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [GrowingManager appEnterForeroundRecordTime];///记录当前时间
        [JHUserStatistics resumeBrowseDurationEvent]; //用户画像恢复事件
    });
}

- (void)ttJianbaoDidEnterBackground:(UIApplication *)application
{
    ///进入前台计算从后台到前台的时间差
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [GrowingManager appEnterForeround];
        [[JHBuryPointOperator shareInstance] devOutBury];
        [JHUserStatistics suspendBrowseDurationEvent]; //用户画像中断事件
    });
}

#pragma mark - third register & initial
-(void)getAppInitData
{
    [JHSkinManager requeastSkinData];
    
    [[UserInfoRequestManager sharedInstance] getGen_session_id];
    [[UserInfoRequestManager sharedInstance] refreshToken];
    [[UserInfoRequestManager sharedInstance] getAppInitData:nil];
    [[UserInfoRequestManager sharedInstance] getVideoCate:nil];
    [[UserInfoRequestManager sharedInstance] getDictsConfig:nil];
    [[UserInfoRequestManager sharedInstance] getOrderStatusTip];
    [[UserInfoRequestManager sharedInstance] getCateAllWithType:0 successBlock:nil  failureBlock:nil];
    [[UserInfoRequestManager sharedInstance] getNewFlyOrder_successBlock:nil failureBlock:nil];

    [[UserInfoRequestManager sharedInstance] getApplyMicInfoComplete:nil];
    [[UMengManager shareInstance] requestShareDomain];
    [SourceMallApiManager getMallCateCompletion:nil];
    [JHMessageCenterData requestSyncMessage];//启动时调用,同步聚合消息
    
    //热云
    [Tracking initWithAppKey:@"11c597ae6ea71e9d9390480b112b1dad" withChannelId:UMengChannel];
    [[JHBuryPointOperator shareInstance] appStartBury];
    
    [self registerPush];
}

-(void)configurationNIM
{
    //appkey是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信Demo包，请勿修改appkey，开发自己的应用时，请替换为自己的appkey.
    //并请对应更换Demo代码中的获取好友列表、个人信息等网易云信SDK未提供的接口。
    NSString *appKey = [[NTESDemoConfig sharedConfig] appKey];
    NSString *cerName= [[NTESDemoConfig sharedConfig] cerName];
    [[NIMSDK sharedSDK] registerWithAppID:appKey
                                  cerName:cerName];
    
    [self registerPushService];
    //直播间消息
    [NIMCustomObject registerCustomDecoder:[NTESAttachDecoder new]];
    //
    // [[NTESNetDetectManger sharedmanager]startNetDetect];
    
    [[NTESLogManager sharedManager] start];

    ///搬进 GetGen_session_id
//    [[JHGuestLoginNIMSDKManage sharedInstance] requestGuestNimInfo];
}
- (void)registerPushService
{
    if (@available(iOS 11.0, *))
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[UIApplication sharedApplication].keyWindow makeToast:@"请开启推送功能否则无法收到推送通知" duration:2.0 position:CSToastPositionCenter];
                });

            }
        }];
    }
    else
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }

    [[UIApplication sharedApplication] registerForRemoteNotifications];


//    // 注册push权限，用于显示本地推送
//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
}


-(void)configurationFMDB
{
    [[DBManager getInstance] creat_db];
    [[DBManager getInstance] creat_table_user];
}

- (void)checkChannelCode {
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    NSString *code = paste.string;
    if ([code hasPrefix:@"ttjb_"]) {
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:InstallChannelCode];
        [[NSUserDefaults standardUserDefaults] synchronize];
        paste.string = @"";
    }
}

#pragma mark - private method
/// 每次启动获取IDFA信息然后请求一次接口
- (void)requestIDFAInfo {
    NSString *url = FILE_BASE_STRING(@"/index/openDevice");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
    } failureBlock:^(RequestModel * _Nullable respondObject) {
    }];
}


@end
