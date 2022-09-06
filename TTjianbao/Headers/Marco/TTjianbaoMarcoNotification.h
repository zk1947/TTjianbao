//
//  TTjianbaoMarcoNotification.h
//  TTjianbao
//  Description:通知等 ~头文件
//  Created by jiangchao on 2018/1/10.
//  Copyright © 2018年 jiangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ADRESSALTERSUSSNotifaction @"AdressAlterSussNotifaction"
#define SELECTADRESSSUSSNotifaction @"SelectAdressSussNotifaction"
#define ComeBackAppraisalLiveRoomNotifaction @"ComeBackAppraisalLiveRoomNotifaction"
#define EnterLiveRoomNotifaction @"EnterLiveRoomNotifaction"
#define APNSNotifaction @"APNSNotifaction"
#define HomePageActivityABtnNotifaction @"HomePageActivityABtnNotifaction"
#define MallSwitchNotifaction @"MallSwitchNotifaction"
#define JHNIMNotifaction @"JHNIMNotifaction"
#define TableBarSelectNotifaction @"TableBarSelectNotifaction"
#define TableBarSelectPersonNotifaction @"TableBarSelectPersonNotifaction"
//订单状态变更
#define ORDERSTATUSCHANGENotifaction @"OrderStatusChangeNotifaction"
#define FansClubTaskNotifaction @"FansClubTaskNotifaction"
#define ForbidSuccessNotifaction @"ForbidSuccessNotifaction"
#define OrderPayInfoStatusChangeNotifaction @"OrderPayInfoStatusChangeNotifaction"
#define kPicDetailWillShowKeyBoardNotification @"PicDetailWillShowKeyBoardNotification"
#define kChannelDataOfResponseNoticeName @"kChannelDataOfResponseNoticeName"
#define kRefreshFocucCateNoticeName @"kRefreshFocucCateNoticeName"
#define kAppearRedHotNoticeName @"kAppearRedHotNoticeName"
//刷新社区首页的频道信息
#define kDiscoverHomeRefreshChannelNoticeName @"kDiscoverHomeRefreshChannelNoticeName"
#define kRefreshNumNoticeName @"kRefreshNumNoticeName"
#define kAddShareCountNoticeName @"kAddShareCountNoticeName"

#define kDiscoverHomeAppearNoticeName @"kDiscoverHomeAppearNoticeName"
#define kDiscoverHomeDisAppearNoticeName @"kDiscoverHomeDisAppearNoticeName"

///登录成功后发放红包或者礼物的key
#define kGrantNotification  @"kGrantNotification"
#define kCelebrateRunningOrNotNotification  @"kCelebrateRunningOrNotNotification"
#define kPushStoneExplainNotification  @"kPushStoneExplainNotification"
#define JHNotifactionNameLiveLoginFinish @"LiveLoginFinishNotifaction"
//已经领取过红包
#define JHNotificationNameHaveGetedRedpacket @"JHNotificationNameHaveGetedRedpacket"
///成功领取红包，展示红包详情图片
#define JHNotificationNamePopRedpacketDetail @"JHNotificationNamePopRedpacketDetail"

@interface TTjianbaoMarcoNotification : NSObject

/** 经验值、称号等级消息通知 */
UIKIT_EXTERN NSString *const JHNotification_ReceiveUserTask;

/** 登录成功选择控制器通知 */
UIKIT_EXTERN NSString *const LOGINSUSSNotifaction;

/** 退出登录成功选择控制器通知 */
UIKIT_EXTERN NSString *const LOGOUTSUSSNotifaction;

UIKIT_EXTERN NSString *const PUBLISHCLASSNotifaction;

UIKIT_EXTERN NSString *const ADDBANKNotifaction;

UIKIT_EXTERN NSString *const WITHDRAWNotifaction;

UIKIT_EXTERN NSString *const SETUPDEFAULTBANKCARDNotifaction;

UIKIT_EXTERN NSString *const STOREINFONotifaction;


UIKIT_EXTERN NSString *const NotificationNameFollowStatus;
UIKIT_EXTERN NSString *const NotificationNameLiveDuring;
UIKIT_EXTERN NSString *const NotificationNameEnterUser;
UIKIT_EXTERN NSString *const NotificationNameSendOrderKeyBoard;

///社区首页顶部消息
UIKIT_EXTERN NSString *const NotificationNameSocilHomeMessageChange;

///领取红包后自动关注状态
UIKIT_EXTERN NSString *const NotificationNameredpacketFollow;

///红包 分享成功
UIKIT_EXTERN NSString *const NotificationNameRedPacketShareSuccess;

///红包 去分享
UIKIT_EXTERN NSString *const NotificationNameRedPacketGotoShare;

/// 直播间商家红包
UIKIT_EXTERN NSString *const NotificationNameLiveWebRedPacket;

//微信登陆成功通知
UIKIT_EXTERN NSString *const WXLOGINSUSSNotifaction;
//绑定微信
UIKIT_EXTERN NSString *const WXBINDSUSSNotifaction;

UIKIT_EXTERN NSString *const NotificationNameRechargeSuccess;

/** 商城首页 - 今日推荐样式，所有数据倒计时结束通知 */
UIKIT_EXTERN NSString *const JHStoreHomeRcmdListAllCountDownEndNotification;

UIKIT_EXTERN NSString *const kTransformStorePageStyleNotification;

///2.5新增 更新首页秒杀列表商品信息
UIKIT_EXTERN NSString *const UpdateSeckillGoodsNotification;

///2.5新增 修改购买按钮状态
UIKIT_EXTERN NSString *const GoodsDetailShouldBeginSeckillNotification;
///倒计时结束时通知详情页面刷新状态
UIKIT_EXTERN NSString *const GoodsDetailCountDownEndNotification;

///专题图片高度变化后通知reload
UIKIT_EXTERN NSString *const kStoreHomeImageHeightChangeNotification;

//UIKIT_EXTERN NSString *const GoodsDetailEnterShopPageNotification;
///通知店铺列表刷新数据
UIKIT_EXTERN NSString *const ShopRefreshDataNotication;

UIKIT_EXTERN NSString *const kUploadBrowseGoodsInfoNotification;

UIKIT_EXTERN NSString *const kInvalidateTimerNotifaication;

///3.1.1新增
///更新个人中心上半部分信息布局
UIKIT_EXTERN NSString *const kUpdatePersonCenterInfoViewLayoutsNotification;
///显示签到红点
UIKIT_EXTERN NSString *const kShowCheckInRedDotNotification;
//直播间push下级vc显示小窗直播
UIKIT_EXTERN NSString *const kNeedShowliveSmallViewNotification;

//3.1.8
UIKIT_EXTERN NSString *const kSQInterestUserListNeedRefreshNotication;
///静音开关通知
UIKIT_EXTERN NSString *const kMuteStateChangedNotication;

///切换到社区首页-推荐
UIKIT_EXTERN NSString *const kSQNeedSwitchToRcmdTabNotication;
///切换到社区首页-热帖
UIKIT_EXTERN NSString *const kSQNeedSwitchToHotPostTabNotication;
///切换到社区首页-板块
UIKIT_EXTERN NSString *const kSQNeedSwitchToPlateTabNotication;

/// 所有登陆成功的通知
UIKIT_EXTERN NSString *const kAllLoginSuccessNotification;

///个人主页用户点赞后更新分页数据
UIKIT_EXTERN NSString *const kUpdateUserCenterInfoNotification;

///分享成功通知
UIKIT_EXTERN NSString *const kShareSuccessNotification;

/// 3.5.0 鉴定直播间 去使用
UIKIT_EXTERN NSString *const NotificationNameGotoUsedAppraiseRedPacket;
///99包邮弹窗的通知
UIKIT_EXTERN NSString *const kMallPage99FreeNotification;

///355新增  - 更新刚刚发布帖子后的列表数据
///推荐页面发布帖子
UIKIT_EXTERN NSString *const kUpdateSQRecommendDataNotification;
///版块主页发布帖子 更新帖子通知
UIKIT_EXTERN NSString *const kUpdateSQPlateDetailDataNotification;
///话题主页发布帖子 更新帖子通知
UIKIT_EXTERN NSString *const kUpdateSQTopicDetailDataNotification;

/// 首页所有列表的滑动 状态 @YES~@NO
UIKIT_EXTERN NSString *const NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS;

/// 首页所有列表的返回顶部 状态 @YES~@NO
UIKIT_EXTERN NSString *const NOTIFICATION_HOME_SCROLLVIEW_TO_TOP_STATUS;

/// 购物鉴定 电视机位（仓库直播/回放）
UIKIT_EXTERN NSString *const NOTIFICATION_APPRAISE_STORE_SYSTEM_MESSAGE;
/// 用户头像更新
UIKIT_EXTERN NSString *const NotificationNameUserHeadUpdated;
@end


