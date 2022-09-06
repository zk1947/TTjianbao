//
//  JHTracking.h
//  TTjianbao
//
//  Created by apple on 2020/12/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHTrackingBaseModel.h"
#import "NSString+SaTracking.h"

@class ChannelMode;
NS_ASSUME_NONNULL_BEGIN

@interface JHTrackLiveRoomModel : NSObject
///所在页面
@property (nonatomic, copy) NSString *page_position;
///直播间id
@property (nonatomic, copy) NSString *channel_id;
///直播间名称
@property (nonatomic, copy) NSString *channel_name;
///主播id
@property (nonatomic, copy) NSString *anchor_id;
///主播名称
@property (nonatomic, copy) NSString *anchor_nick_name;
///主播角色
@property (nonatomic, copy) NSString *anchor_role;
///频道id
@property (nonatomic, copy) NSString *channel_local_id;
///直播间一级分类
@property (nonatomic, copy) NSArray <NSString *>*first_channel;
///直播间二级分类
@property (nonatomic, copy) NSArray <NSString *>*second_channel;
///位置排序
@property (nonatomic, strong) NSNumber *position_sort;

/// 直播状态
@property (nonatomic, copy) NSString *channel_status;
/// 模块类别
@property (nonatomic, copy) NSString *model_type;
/// 直播间标签/传无
@property (nonatomic, copy) NSString *channel_label;

@end

@interface JHTracking : NSObject
/**
 初始化上报SDK
 */
+ (void)registTrackSDKWithLaunchOptions:(NSDictionary *)launchOptions;


/**
 设置公共属性：重复调用 registerSuperProperties: 会覆盖之前已设置的公共属性

 @param propertyDict 公共属性
 */
+ (void)registerSuperProperties:(NSDictionary *)propertyDict;


/**
 首次设置用户的一个或者几个 Profiles

 @param profileDict 要替换的那些 Profile 的内容
 */
+ (void)setOnce:(NSDictionary *)profileDict;

/**
 获取预制属性
 */
+ (NSDictionary *)presetProperties;

/**
 获取预制属性JSON字符串，移除了 请求头 User-Agent 中已有的字段
 */
+ (NSString *)presetPropertiesJSON;

/**
 用户注册/登录/初始化 SDK（如果能获取到登录 ID）后需将用户 ID 传给神策做匿名 ID 关联
 */
+ (void)loginedUserID:(NSString *)userID;


/**
 用户退出登录 ID 传给神策做匿名 ID 关联
 */
+ (void)logouted;

/**
 用户注册/登录时需将匿名 ID 传给服务端做用户 ID 关联
 */
+ (NSString *)userTrackAnonymousId;


/**
 直接设置用户的pushId

 @param pushKey pushId 的 key
 @param pushId pushId 的 id
 */
+ (void)profilePushKey:(NSString *)pushKey pushId:(NSString *)pushId;

/**
 * @abstract
 * 处理 url scheme 跳转打开 App
 *
 * @param url 打开本 app 的回调的 url
 */
+ (BOOL)handleSchemeUrl:(NSURL *)url;

/**
 神策联通webview中的上报

 @param webView 页面对象
 @param request 请求
 @return 是否成功
 */
+ (BOOL)showUpWebView:(id)webView withRequest:(NSURLRequest *)request;

/**
 发送model事件

 @param model 事件model
 */
+ (void)trackModel:(JHTrackingBaseModel *)model;

/**
 发送普通事件

 @param event 事件名
 @param property 事件属性
 */
+ (void)trackEvent:(NSString *)event property:(NSDictionary *)property;

/**
 字典转json字符串
 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
+ (void)setProfile : (NSDictionary *)params;

/**
 清除 keychain 缓存数据
 */
+ (void)clearKeychainData;

/**直播间点击埋点*/
+ (void)trackClickLiveRoom:(JHTrackLiveRoomModel *)trackModel;
+ (void)sa_clickLiveRoomList:(ChannelMode *)channel pagePosition:(NSString *)pagePosition;
///点击直播间 带当前下标
+ (void)sa_clickLiveRoomList:(ChannelMode *)channel pagePosition:(NSString *)pagePosition currentIndex:(NSString *_Nullable)currentIndex;
@end

NS_ASSUME_NONNULL_END
