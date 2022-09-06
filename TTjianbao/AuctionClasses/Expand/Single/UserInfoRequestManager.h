//
//  UserInfoManager.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/12.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "TTjianbaoMarcoEnum.h"
#import <Foundation/Foundation.h>
#import "HttpRequestTool.h"
#import "User.h"
#import "JHUserLevelInfoMode.h"
#import "JHHomeActivityMode.h"
#import "JHOrderFactory.h"
@protocol JHOrderStatusInterface;

// 更改OrderStatusTipModel的desc的条件
typedef NS_ENUM(NSUInteger, JHChangeDesCondition) {
    JHChangeDesCondition_None = 0,   // 无需更改
    JHChangeDesCondition_Buyers_WaitReceiving_SH = 1, // 买家&&待收货&&直发
    JHChangeDesCondition_Buyers_WaitPay_SH = 2,       // 买家&&待付款&&直发
};

#define ThumbSmallByOrginal(_FILE_)   [_FILE_ stringByAppendingString: [UserInfoRequestManager sharedInstance].iswyPhotoServe?@"?imageView&thumbnail=250x250":@""]
#define ThumbMiddleByOrginal(_FILE_)  [_FILE_ stringByAppendingString: [UserInfoRequestManager sharedInstance].iswyPhotoServe?@"?imageView&thumbnail=500x500":@""]

@class ChannelMode;

@interface ChannelInfoConfigDict : NSObject
@property(nonatomic, copy)NSString *channelLocalId;
@end

//
@interface OrderStatusTipModel : NSObject
@property(nonatomic, copy)NSString *orderStatus;
@property(nonatomic, copy)NSString *title;//描述加粗部分
@property(nonatomic, copy)NSString *desc;//描述信息
@property(nonatomic, copy)NSString *icon;//状态icon
@property(nonatomic, copy)NSString *name;//状态文字
///改变描述文字的条件
@property(nonatomic, assign)JHChangeDesCondition changeDesCondition;

@end

@interface AppInitDataModel : NSObject
@property(nonatomic, copy)NSString *oneTouchImgUrl; //一键登录下方的活动图片地址字段
@property(nonatomic, copy)NSString *loginway;
@property (nonatomic, strong) NSDictionary *orderCategoryIcons;
@property (nonatomic, strong) NSArray *temporaryMuteTimes;//禁言时间列表
@property(nonatomic, copy)NSString *roomReportShow;//直播间举报是否显示
@property(nonatomic, copy)NSString *imgServer;
@property (nonatomic, strong) ChannelInfoConfigDict *infoConfigDict;
@property (nonatomic, copy)  NSString *versionSwitch; //0显示330直播卖场  1显示334
@property (nonatomic, assign) BOOL enableUnion; //是否开启银联支付
@property (nonatomic, strong) NSDictionary *orderConfigDict;
@property (nonatomic, copy) NSString* hiddenHomeSaleTips; //是否隐藏放心购
@property (nonatomic, copy) NSString *showActivityFlag; //是否展示活动标签,0-不展示, 1-展示
@property (nonatomic, copy) NSString *activityIcon; //活动标识链接地址
/// 活动正则
@property (nonatomic, copy) NSArray<NSString *> *activityRegulars;
@end
@interface DictsConfigMode : NSObject
//根据ordCerCategory 查找tag文字
@property (nonatomic, strong) NSDictionary *AppOrderCategory;
//根据transitionState（流转状态）   查找tag文字
@property (nonatomic, strong) NSDictionary *StoneRestoretransitionState;
//打印保卡订单类型
@property (nonatomic, strong) NSDictionary *orderCateType;

@end

typedef enum : NSUInteger {
    JHNetWorkUnKnown,    //未知
    JHNetWorkNotReachable, // 没有网络
    JHNetWorkWWAN,   //4G流量
    JHNetWorkWiFi,   //wifi
} JHNetWorkStatus;

typedef void (^JHUserLevelInfoHandler)( JHUserLevelInfoMode *mode ,  NSError *error);
@interface UserInfoRequestManager : NSObject
/** 监听网络状态*/
@property (nonatomic, assign) JHNetWorkStatus netWorkStatus;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) JHUserLevelInfoMode *levelModel;

/// 周年庆 0未知（接口还没返回）   1未开始或者已经结束   2进行中
/// 强制登录或者周年庆结束后删掉
@property (nonatomic, assign) NSInteger anniversaryType;
/// 是否可以显示了


@property (nonatomic, strong)  NSString *versionSwitch; //0显示330直播卖场  1显示334
@property (nonatomic, assign) BOOL enableUnion; //是否开启银联支付 1是开启
@property (nonatomic, assign) BOOL hiddenHomeSaleTips; //是否隐藏放心购
@property (nonatomic, assign) BOOL anniversaryViewShow;
@property (nonatomic, assign) int loginway;
@property (nonatomic, assign) BOOL iswyPhotoServe;
@property (nonatomic, assign) NSTimeInterval timeDifference;
@property (nonatomic, strong) NSString * nickRandomNumber;
@property (nonatomic, strong) NSString * registrationID;
@property (nonatomic, strong) NSArray *temporaryMuteTimes;
@property (nonatomic, assign) BOOL roomReportShow;
@property (nonatomic, strong) NSArray *pickerDataArray;
/// 针对飞单单独处理
@property (nonatomic, strong) NSArray *feidanPickerDataArray;

@property (nonatomic, strong) NSDictionary *orderCategoryIcons;
@property (nonatomic, strong) NSMutableDictionary *orderCategoryIconImages;
@property (nonatomic, strong) ChannelInfoConfigDict *infoConfigDict;//channelLocalId
@property (nonatomic, strong) JHHomeActivityMode *homeActivityMode;
@property (nonatomic, strong) DictsConfigMode *dictConfigMode;//
@property(nonatomic, copy)NSString *oneTouchImgUrl; //一键登录下方的活动图片地址字段
/// 银联签约是否显示
@property (nonatomic, assign) BOOL unionSignIsShow;
/// 银联签约状态
@property (nonatomic, assign) JHUnionSignStatus unionSignStatus;
/// 银联签约失败错误信息
@property (nonatomic, copy) NSString *unionSignFailReason;
/// 银联签约中 电子签约地址
@property (nonatomic, copy) NSString *unionSignRequestInfoUrl;
//意向单金额
@property (nonatomic, copy) NSString *customizedIntentionPriceMax;
/// 显示橱窗
@property (nonatomic, assign) BOOL showShopwindow;

@property (nonatomic, strong) NSArray<OrderStatusTipModel*>*orderStatusTipArr;
@property (nonatomic, assign) BOOL showActivityFlag; //是否展示活动标签,0-不展示, 1-展示
@property (nonatomic, copy) NSString *activityIcon; //活动标识链接地址

@property (nonatomic, assign) BOOL isFindLandingTarget;
/// deepLink进入 是否显示启动引导层
@property (nonatomic, assign) BOOL isDeepLinkInto;

+ (instancetype)sharedInstance;
+ (void)destroyInstance;
- (void)netWorkReachable;
- (void)getUserInfo;
- (void)getUserInfoSuccess:(succeedBlock)success;
- (void)getUserInfoSuccess:(succeedBlock)success failure:(failureBlock)failure;
- (void)bindDeviceToken:(succeedBlock)success;
- (void)unBindDeviceToken:(succeedBlock)success;
- (void)refreshToken;
- (void)getLoginWay;
- (void)getGen_session_id;
- (void)getVideoCate:(succeedBlock)success;
- (void)syncServeTime;
- (void)getAppInitData:(JHFinishBlock)complete;
//获取不同订单状态显示的提示文案
- (void)getOrderStatusTip;
//获取当前用户连麦状态
-(void)getApplyMicInfoComplete:(JHFinishBlock)complete;
//获取当前用户定制连麦状态
-(void)getApplyCustomizeInfo:(NSString *)currentRoomId finishComplete:(JHFinishBlock)complete;
//获取当前用户回收连麦状态
-(void)getApplyRecycleInfo:(NSString *)currentRoomId finishComplete:(JHFinishBlock)complete;
//判断customId是否是同一用户
- (BOOL)sameUser:(NSString*)customId;
//普通用户=0,即观众
- (BOOL)commonUser;

/**
 通过protuctId进入目标界面
 */
- (void)findLandingTargetWithProductId:(NSString *)productId;

/// 获取类别
/// @param type 0鉴定师评估报告 1卖货主播飞单类型
/// @param success
/// @param failure 
- (void)getCateAllWithType:(NSInteger)type successBlock:(succeedBlock) success failureBlock:(failureBlock)failure;

/*
 * v3.8.8 飞单修改品类信息
 */
- (void)getNewFlyOrder_successBlock:(succeedBlock) success failureBlock:(failureBlock)failure;


- (NSString *)findValue:(NSDictionary*)dict byKey:(NSString *)key;
/**
 @param completion completion description
 */
- (void)getUserLeveIlnfoCompletion:(JHUserLevelInfoHandler)completion;
- (void)getAppraiseIssuelnfoCompletion:(JHApiRequestHandler)completion;
- (void)getHomePageActivitylnfoCompletion:(JHApiRequestHandler)completion;
- (void)getDictsConfig:(JHApiRequestHandler)completion;
- (NSMutableDictionary *)getEnterChatRoomExtWithChannel:(ChannelMode *)model;

/// 根据订单状态查找订单提示信息
/// @param status status description
+ (OrderStatusTipModel *)findOrderTip:(NSString *)status;

///推荐的开关
- (void)getRecommendSwitch;

///// 订单状态查找订单详情title信息
///// @param orderStatusModel 商家端还是客户端
///// @param orderStatus 订单状态
//+ (OrderStatusTipModel *)findNewTip:(id<JHOrderStatusInterface>)orderStatusModel
//                      variousStatus:(JHVariousStatusOfOrders)orderStatus;

/// 订单状态查找订单详情title信息
/// @param condition 修改描述信息的条件
/// @param status 订单状态
+ (OrderStatusTipModel *)findNewTip:(JHChangeDesCondition)condition
                             status:(NSString *)status;
                      

@end


