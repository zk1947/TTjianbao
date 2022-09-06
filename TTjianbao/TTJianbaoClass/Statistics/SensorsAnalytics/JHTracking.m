//
//  JHTracking.m
//  TTjianbao
//
//  Created by apple on 2020/12/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTracking.h"
#import <SensorsAnalyticsSDK.h>
#import "SAKeyChainItemWrapper.h"
#import "UserInfoRequestManager.h"
#import "NSString+Common.h"
#import <SensorsABTest.h>

@implementation JHTrackLiveRoomModel


@end

@implementation JHTracking
// @"https://event-shence.ttjianbao.com/sa?project=default"; //神策

/**
 初始化上报SDK
 */
+ (void)registTrackSDKWithLaunchOptions:(NSDictionary *)launchOptions {
    
    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:JHEnvVariableDefine.sa_server_url launchOptions:launchOptions];
    /*
     * SensorsAnalyticsEventTypeAppClick 会和GIO 引起冲突导致崩溃
     */
//    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppViewScreen | SensorsAnalyticsEventTypeAppClick;
    /*
     * 3.8.0 下线全埋点screen 事件
     */
//    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppViewScreen;
    ///
    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd;
    // 开启 crash 信息自动采集
    options.enableTrackAppCrash = YES;
    options.enableVisualizedAutoTrack = YES;
    options.enableHeatMap = YES;
    options.enableJavaScriptBridge = YES;
    [SensorsAnalyticsSDK startWithConfigOptions:options];
    
    /*  registerSuperProperties
     1、公共属性，后续所有 track: 追踪的事件都将拥有公共属性，属性公共且值相同，值不同在BaseModel里设置
     */
    [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"product_name" : @"App"}];
    // 开启 可视化全埋点 分析，$AppClick 事件将会采集控件的 viewPath
//    [[SensorsAnalyticsSDK sharedInstance] enableVisualizedAutoTrack];
    // 开启 GPS 信息采集
//    [[SensorsAnalyticsSDK sharedInstance] enableTrackGPSLocation:YES];
    // 记录 AppInstall 激活事件
//    [[SensorsAnalyticsSDK sharedInstance] trackInstallation:@"AppInstall"];
    [[SensorsAnalyticsSDK sharedInstance] trackAppInstallWithProperties:@{@"DownloadChannel": @"AppStore"}];
    
    // 开启 日志
    [[SensorsAnalyticsSDK sharedInstance] enableLog:YES];

    // A/B Testing SDK 初始化  分流试验请求地址
    SensorsABTestConfigOptions *abtestConfigOptions = [[SensorsABTestConfigOptions alloc] initWithURL:JHEnvVariableDefine.sa_abTest_url];
    [SensorsABTest startWithConfigOptions:abtestConfigOptions];
    
    // 过滤全埋点页面
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"HomeVC"];
    [[SensorsAnalyticsSDK sharedInstance] ignoreAutoTrackViewControllers:array];
}

+ (void)registerSuperProperties:(NSDictionary *)propertyDict {
    
    [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:propertyDict];
}

+ (void)setOnce:(NSDictionary *)profileDict {
    
    [[SensorsAnalyticsSDK sharedInstance] setOnce:profileDict];
}

/**
 获取预制属性
 */
+ (NSDictionary *)presetProperties {
    
    return [[SensorsAnalyticsSDK sharedInstance] getPresetProperties];
}

/**
 获取预制属性JSON字符串，在XWJSensorsPresetPropertiesModel中移除了 请求头 User-Agent 中已有的字段
 */
+ (NSString *)presetPropertiesJSON {
    
//    XWJSensorsPresetPropertiesModel *presetModel = [[XWJSensorsPresetPropertiesModel alloc] initWithDictionary:[self presetProperties] error:nil];
//    // 解决中文问题
//    NSString *baseString = [NSString base64EncodedStringWithOriURLString:[presetModel toJSONString]];
    
    NSMutableDictionary *presetPropts = [NSMutableDictionary dictionaryWithDictionary:[self presetProperties]];
    // 移除 请求头 User-Agent 中已有的字段
    [presetPropts removeObjectsForKeys:@[@"$screen_width", @"$screen_height", @"$os", @"$os_version", @"$app_version", @"$model", @"$manufacturer"]];
    
    // 解决中文问题
    NSString *baseString = [self convertToJsonData:presetPropts];
    
    return baseString?:@"";
}

/**
 用户注册/登录/初始化 SDK（如果能获取到登录 ID） 成功 后需将用户 ID 传给神策做匿名 ID 关联
 */
+ (void)loginedUserID:(NSString *)userID {
    
    [[SensorsAnalyticsSDK sharedInstance] login:userID];
}

+ (void)logouted {
    
    [[SensorsAnalyticsSDK sharedInstance] logout];
}

/**
 用户注册/登录时需将匿名 ID 传给服务端做用户 ID 关联
 
 1）在集成了神策分析 SDK 的 App 中，SDK 会为每个设备分配一个匿名 ID，用于标记产生事件的未登录用户，并以此进行用户相关分析，如留存率、事件漏斗等。
 2）默认使用 IDFV 或 UUID 作为匿名 ID，如使用 1.9.10 之前的 SDK，当用户重新安装 App 时，匿名 ID 可能会发生变化。
 3）1.9.10 之后的 iOS SDK，将匿名 ID 和 trackInstallation 标记位存储到 Keychain 上，解决卸载重装后，匿名 ID 可能变化及重复发送 trackInstallation 的问题。
 4）1.10.18 之后的 SDK，如果项目中导入了 AdSupport 库，则 SDK 尝试获取 IDFA 作为匿名 ID；如果获取 IDFA 失败，则 SDK 尝试获取 IDFV 作为匿名 ID；如果获取 IDFV 失败，则会生成 UUID 作为匿名 ID。
 注意：使用 IDFA 作为匿名 ID，需要添加 AdSupport.framework 库
 */
+ (NSString *)userTrackAnonymousId {
    
    return [[SensorsAnalyticsSDK sharedInstance] anonymousId];
}

+ (void)profilePushKey:(NSString *)pushKey pushId:(NSString *)pushId {
    
    [[SensorsAnalyticsSDK sharedInstance] profilePushKey:pushKey pushId:pushId];
}

/**
 * @abstract
 * 处理 url scheme 跳转打开 App
 *
 * @param url 打开本 app 的回调的 url
 */
+ (BOOL)handleSchemeUrl:(NSURL *)url {
    
    if ([[SensorsAnalyticsSDK sharedInstance] handleSchemeUrl:url]) {
        return YES;
    }
    return NO;
}

/**
 神策联通webview中的上报
 */
+ (BOOL)showUpWebView:(id)webView withRequest:(NSURLRequest *)request {
    
    return NO;
}

/**
 发送model事件
 */
+ (void)trackModel:(JHTrackingBaseModel *)model {
    
    NSString *event = model.event;
    NSDictionary *property = model.properties;
    
    [self trackEvent:event property:property];
}

/**
 发送普通事件
 */
+ (void)trackEvent:(NSString *)event property:(NSDictionary *)property {
    
    if ([NSString isEmpty:event] || ![property isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[SensorsAnalyticsSDK sharedInstance] track:event withProperties:property];
    });
}

// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

+ (void)clearKeychainData {
    
    [[SensorsAnalyticsSDK sharedInstance] clearKeychainData];
    
}
+ (void)setProfile : (NSDictionary *)params {
    [[SensorsAnalyticsSDK sharedInstance] set:params];
}
/**直播间点击埋点*/
+ (void)trackClickLiveRoom:(JHTrackLiveRoomModel *)trackModel {
    NSDictionary *dict = [trackModel mj_keyValues];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    if([params valueForKey:@"position_sort"]) {
        [params removeObjectForKey:@"position_sort"];
    }
    [JHTracking trackEvent:@"channelClick" property:params];
}

///369神策埋点:直播间点击
+ (void)sa_clickLiveRoomList:(ChannelMode *)channel pagePosition:(NSString *)pagePosition {
    [JHTracking sa_clickLiveRoomList:channel pagePosition:pagePosition currentIndex:nil];
}

///369神策埋点:直播间点击
+ (void)sa_clickLiveRoomList:(ChannelMode *)channel
                pagePosition:(NSString *)pagePosition
                currentIndex:(NSString *_Nullable)currentIndex {
    JHTrackLiveRoomModel *model = [[JHTrackLiveRoomModel alloc] init];
    model.page_position = NONNULL_STR(pagePosition);
    model.channel_id = NONNULL_STR(channel.roomId);
    model.channel_name = NONNULL_STR(channel.title);
    model.anchor_id = NONNULL_STR(channel.anchorId);
    model.anchor_nick_name = NONNULL_STR(channel.anchorName);
    model.channel_local_id = NONNULL_STR(channel.channelLocalId);
    model.anchor_role = NONNULL_STR(channel.channelType);
    if ([channel.first_channel isNotBlank]) {
        model.first_channel = @[channel.first_channel];
    }
    if ([channel.second_channel isNotBlank]) {
        model.second_channel = @[channel.second_channel];
    }
    if ([currentIndex isNotBlank]) {
        model.position_sort = [NSNumber numberWithString:currentIndex];
    }
    [JHTracking trackClickLiveRoom:model];
}


@end
