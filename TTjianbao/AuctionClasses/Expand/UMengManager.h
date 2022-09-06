//
//  UMengManager.h
//  KGLibrary
//
//  Created by yaoyao on 2017/11/13.
//  Copyright © 2017年 yaoyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
#import "ShareUserInfoModel.h"
#import "TTjianbaoMarcoEnum.h"
#import <UserNotifications/UserNotifications.h>
#import "AppraisalDetailMode.h"

//鉴定直播间分享：
//标题：我发现一个免费鉴定平台，看看我家的宝贝专家怎么说
//描述：专家团在线直播连线鉴定，平台承诺鉴定永久免费，让鉴定更简单。
//
//卖场直播间分享：
//标题：我找到一个翡翠玉石源头直卖的代购直播平台，邀请大家一起玩。
//描述：源头直供假一赔百万，直播鉴定全过程，数字化评估报告让宝贝没有秘密
//
//评估报告页分享：
//标题：看看天天鉴宝给我出的评估报告，就和手机跑分一样直观
//描述：天天鉴宝，首创行业鉴定新概念，大数据分值体系，让鉴定更直观。

#define ShareLiveAppraiseTitle @"天天鉴宝鉴定直播-专业文玩鉴定师【%@】老师正在直播，邀请你速来围观"
//@"我发现一个免费鉴定平台，看看我家的宝贝专家怎么说"
#define ShareLiveAppraiseText @"来天天鉴宝看专家实时鉴定，学最靠谱的文玩知识"
//@"专家团在线直播连线鉴定，平台承诺鉴定永久免费，让鉴定更简单。"

#define ShareLiveSaleTitle @"天天鉴宝文玩直播-【%@】正在直播，邀请你速来围观"
//@"我找到一个翡翠玉石源头直卖的代购直播平台，邀请大家一起玩"
#define ShareLiveSaleText @"来天天鉴宝看主播讲解，抢直播间大额红包，高货、大漏天天等你来"
//@"源头直供假一赔百万，直播鉴定全过程，数字化评估报告让宝贝没有秘密。"

#define ShareOrderReportTitle @"看看天天鉴宝给我出的评估报告，就和手机跑分一样直观"
#define ShareOrderReportText @"鉴定新概念，大数据分值体系，让评估报告就和手机跑分一样直观"//@"天天鉴宝，首创行业鉴定新概念，大数据分值体系，让鉴定更直观。"

//定制师分享
#define ShareLiveCustomizeTitle @"来天天鉴宝看定制师实时讲解，了解最靠谱的文玩知识及定制服务"
#define ShareLiveCustomizeText @"天天鉴宝定制直播-专业文玩定制师【%@】老师正在直播，邀请你速来围观"

//----------------------------UMENG----------------------

#define UMengAppKey @"5c1b667cb465f5511e000170"


#if DEBUG
#define UMengChannel @"test"
#else
#define UMengChannel @"AppStore"
#endif

//----------------------------END------------------------


//----------------------------QQ----------------------
//APP ID1107964101
//APP KEYJIsiIK6BhbZxWdTb
//-----Android QQ开放平台
#define QQAppKey @"1107964101"
#define QQAppSecret @"JIsiIK6BhbZxWdTb"

//----------------------------END------------------------


//----------------------------WeiXin----------------------
//#define WXAppKey @"wx628c6134de0f964d"
//#define WXAppSecret @"39a856e3b4492dcb2dc2728f7d8ef0bd"
//支付
#define PartnerID @"1507665171"
#define SecretKey @"EUlEP8dO00o4zyY2Ah5uZaCz6hKswU87"

//----------------------------END------------------------


//----------------------------Sina----------------------
#define SinaAppKey @"3921700954"
#define SinaAppSecret @"04b48b094faeb16683c32669824ebdad"

//----------------------------END------------------------



//平台用户信息回调
typedef void(^platformResult)(ShareUserInfoModel* result,NSError * error);

//点击并跳转了第三方分享平台 {"to_type":1-微信，2-朋友圈，3-q，4-q空间，5-微博}
typedef void(^SharePlatformBlock)(NSInteger toType);


typedef NS_ENUM(NSInteger, PushType) {
    PushTypeNone = 0,
    PushTypeNews,
    PushTypeVideo,
    PushTypeShop,
    PushTypeURL,
    PushTypeScore,
};

typedef NS_ENUM(NSInteger, SharePlatformType) {
    SharePlatformTypeNone = 0,
    SharePlatformTypeWeiXin,
    SharePlatformTypeWeiCircle,
    SharePlatformTypeQQ,
};


typedef NS_ENUM(NSInteger, ShareObjectType) {
    ShareObjectTypeAppraiseLive = 0,//鉴定直播
    ShareObjectTypeSaleLive = 1,//卖货直播
    ShareObjectTypeAppraiseVideo = 2,//鉴定视频
    ShareObjectTypeAnchorAppraisePreview = 3,//鉴定主播开播预览
    ShareObjectTypeAnchorSalePreview = 4,//卖场主播开播预览
    ShareObjectTypeReport = 5,//评估报告
    ShareObjectTypeSaleReport = 6,//订单评估报告
    ShareObjectTypeSocialArticial = 7,//社区文章ID
    ShareObjectTypeSocialFriend = 8,//社区宝友ID
    
    ShareObjectTypeWebShare = 9,//webview调起
    ShareObjectTypeSaleReportComment = 10,//从评价分享卖货评估报告
    ShareObjectTypeAgentPay = 11,//分享代付
    ShareObjectTypeStoreShop = 12, //社区商城 - 店铺
    ShareObjectTypeStoreSpecialTopic = 13, //社区商城 - 专题
    ShareObjectTypeStoreGoodsDetail = 14, //社区商城 - 商品详情
    ///340新增
    ShareObjectTypeTopicHomeList = 15, //话题主页分享话题
    ShareObjectTypePlateHomeList = 16, //从板块主页分享板块

    ShareObjectTypeCustomizeLive = 17,//定制直播
    
    ShareObjectTypeCustomizeNormal = 999,  /// 其他分享
    
};


@interface UMengManager : NSObject

+ (UMengManager*)shareInstance;

//点击并跳转了第三方分享
@property (nonatomic, copy) SharePlatformBlock sharePlatformBlock;

//举报回调
@property (nonatomic, copy) dispatch_block_t shareReportBlock;

//删除回调
@property (nonatomic, copy) dispatch_block_t shareDeleteBlock;


@property (nonatomic, copy) NSString *shareDomian;
@property (nonatomic, copy) NSString *shareLiveUrl;//  [FILE_BASE_STRING(@"/jianhuo/video.html?") stringByReplacingOccurrencesOfString:@"https://api.xianglipai.com/" withString:@"http://106.75.65.65/"]

@property (nonatomic, copy) NSString *shareReporterUrl;// [FILE_BASE_STRING(@"/jianhuo/baogao.html?") stringByReplacingOccurrencesOfString:@"https://api.xianglipai.com/" withString:@"http://106.75.65.65/"] //评估报告分享落地页

@property (nonatomic, copy) NSString *shareVideoUrl;// [FILE_BASE_STRING(@"/jianhuo/shipin.html?id=") stringByReplacingOccurrencesOfString:@"https://api.xianglipai.com/" withString:@"http://106.75.65.65/"]
@property (nonatomic, copy) NSString *shareSaleReporterUrl;

/// 原石详情页 分享
@property (nonatomic, copy) NSString *shareStoneDetailUrl;

@property (nonatomic, strong) AppraisalDetailMode *appraisalDetailMode;


- (void)requestShareDomain;
//umeng默认启动设置
- (void)setUMeng:(NSDictionary*)launchOptions;

//第三方系统回调(在Appdelege类- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url中需要调用)
- (BOOL)handleOpenURL:(NSURL*)url;


//返回对应平台的用户信息 (登录也可使用)
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType currentViewController:(UIViewController*)currentViewController userInfoResult:(platformResult)userInfoResult;

//取消授权
- (void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType;


//是否安装
-(BOOL) isInstall:(UMSocialPlatformType)platformType;


//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
//                             title:(NSString *)title
//                              text:(NSString *)text
//                          thumbUrl:(NSString *)thumbURL
//                            webURL:(NSString *)url
//                              type:(ShareObjectType)type
//                          pageFrom:(JHPageFromType)pageFrom
//                            object:(id)objectFlag;


////默认隐藏举报
//- (void)showShareWithTarget:(id)target
//                      title:(NSString *)title
//                       text:(NSString *)text
//                   thumbUrl:(NSString *)thumbURL
//                     webURL:(NSString *)url
//                       type:(ShareObjectType)type
//                     object:(id)objectFlag;

///v2.2.4 新增showReport - 是否显示举报，默认隐藏
//- (void)showShareWithTarget:(id)target
//                      title:(NSString *)title
//                       text:(NSString *)text
//                   thumbUrl:(NSString *)thumbURL
//                     webURL:(NSString *)url
//                       type:(ShareObjectType)type
//                     object:(id)objectFlag
//                 showReport:(BOOL)showReport;

///v2.2.6 新增自定义分享面板 isMe - 是否本人热帖
//- (void)showCustomShareTitle:(NSString *)title
//                        text:(NSString *)text
//                    thumbUrl:(NSString *)thumbURL
//                      webURL:(NSString *)url
//                        type:(ShareObjectType)type
//                      object:(id)objectFlag
//                  isShowMore:(BOOL)showMore
//                        isMe:(BOOL)isMe;


//- (void)shareVideoToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title
//                            text:(NSString *)text
//                        thumbUrl:(NSString *)thumbURL
//                          webURL:(NSString *)url
//                            type:(NSInteger)type;

//- (void)shareMiniProgramToPlatformType:(UMSocialPlatformType)platformType
//                             articleId:(NSString *)Id
//                              targetVC:(UIViewController *)tag
//                                 title:(NSString *)title
//                                  text:(NSString *)text
//                              thumbUrl:(NSString *)thumbURL
//                                webURL:(NSString *)url
//                                  type:(NSInteger)type;

//默认隐藏举报
//- (void)showShareImageWithTarget:(id)target
//                           title:(NSString *)title
//                            text:(NSString *)text
//                        thumbUrl:(id)thumbURL
//                            type:(ShareObjectType)type
//                          object:(id)objectFlag;

///v2.2.4 新增showReport - 是否显示举报，默认隐藏
//- (void)showShareImageWithTarget:(id)target
//                           title:(NSString *)title
//                            text:(NSString *)text
//                        thumbUrl:(id)thumbURL
//                            type:(ShareObjectType)type
//                          object:(id)objectFlag
//                          showReport:(BOOL)showReport;

//- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
//                           title:(NSString *)title
//                            text:(NSString *)text
//                        thumbUrl:(id)thumbURL
//                            type:(ShareObjectType)type
//                          object:(id)objectFlag;


- (NSString *)getUmengId;
- (NSString *)getUmengUtid;

//- (void)processPushInfo:(NSDictionary *)userInfo isApplicationActive:(BOOL)isActive;
//
//- (void)getPushInfo:(NSDictionary *)info;
//
//- (void)openAppWithString:(NSString *)string;
//
//- (void)presentVC:(UIViewController *)vc;

@end
