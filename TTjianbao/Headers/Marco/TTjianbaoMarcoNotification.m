//
//  TTjianbaoMarcoNotification.m
//  TTjianbao
//  
//  Created by jiangchao on 2018/1/10.
//  Copyright © 2018年 jiangchao. All rights reserved.
//

#import "TTjianbaoMarcoNotification.h"

@implementation TTjianbaoMarcoNotification

/** 经验值、称号等级消息通知 */
NSString *const JHNotification_ReceiveUserTask = @"JHNotification_ReceiveUserTask";

/** 登录成功选择控制器通知 */
NSString *const LOGINSUSSNotifaction = @"LOGINSUSSNotifaction";

/** 退出登录成功选择控制器通知 */
NSString *const LOGOUTSUSSNotifaction = @"LOGOUTSUSSNotifaction";

NSString *const PUBLISHCLASSNotifaction = @"PUBLISHCLASSNotifaction";

NSString *const ADDBANKNotifaction = @"ADDBANKNotifaction";

NSString *const WITHDRAWNotifaction = @"WITHDRAWNotifaction";

NSString *const SETUPDEFAULTBANKCARDNotifaction = @"SETUPDEFAULTBANKCARDNotifaction";

NSString *const STOREINFONotifaction = @"STOREINFONotifaction";
NSString *const NotificationNameFollowStatus = @"NotificationNameFollowStatus";
NSString *const NotificationNameLiveDuring = @"NotificationNameLiveDuring";
NSString *const WXLOGINSUSSNotifaction = @"WXLOGINSUSSNotifaction";
NSString *const WXBINDSUSSNotifaction = @"BINDSUSSNotifaction";
NSString *const NotificationNameEnterUser = @"NotificationNameEnterUser";
NSString *const NotificationNameSendOrderKeyBoard = @"NotificationNameSendOrderKeyBoard";

NSString *const NotificationNameSocilHomeMessageChange = @"NotificationNameSocilHomeMessageChange";

///领取红包后自动关注状态
NSString *const NotificationNameredpacketFollow = @"redpacketFollowNotification";

///红包 分享成功
NSString *const NotificationNameRedPacketShareSuccess = @"NotificationNameRedPacketShareSuccessMethod";

///红包 去分享
NSString *const NotificationNameRedPacketGotoShare = @"NotificationNameRedPacketGotoShare";

/// 直播间商家红包
NSString *const NotificationNameLiveWebRedPacket = @"NotificationNameLiveWebRedPacket";

/// 所有登陆成功之后的通知
NSString *const kAllLoginSuccessNotification = @"kAllLoginSuccessNotification";

NSString *const NotificationNameRechargeSuccess = @"NotificationNameRechargeSuccess";

/** 商城首页 - 今日推荐样式，所有数据倒计时结束通知 */
NSString *const JHStoreHomeRcmdListAllCountDownEndNotification = @"JHStoreHomeRcmdListAllCountDownEndNotification";

/** 商城首页 - 导航栏样式改变通知 */
NSString *const kTransformStorePageStyleNotification = @"kTransformStorePageStyleNotification";


NSString *const GoodsDetailCountDownEndNotification = @"GoodsDetailCountDownEndNotification";

///通知首页秒杀列表更新数据
NSString *const UpdateSeckillGoodsNotification = @"UpdateSeckillGoodsNotification";



///2.5新增 用于通知商品详情页面修改购买按钮状态的
NSString *const GoodsDetailShouldBeginSeckillNotification = @"GoodsDetailShouldBeginSeckillNotification";
NSString *const kStoreHomeImageHeightChangeNotification = @"StoreHomeImageHeightChangeNotification";


/** 从商品详情页点击店铺信息-进入店铺通知 */
//NSString *const GoodsDetailEnterShopPageNotification = @"GoodsDetailEnterShopPageNotification";

NSString *const ShopRefreshDataNotication = @"ShopRefreshDataNotication";

NSString *const kSQInterestUserListNeedRefreshNotication = @"SQInterestUserListNeedRefreshNotication";

///浏览商品埋点上报
NSString *const kUploadBrowseGoodsInfoNotification = @"kUploadBrowseGoodsInfoNotification";

///关闭浏览商品埋点定时器
NSString *const kInvalidateTimerNotifaication = @"kInvalidateTimerNotifaication";


///3.1.1新增
///更新个人中心上半部分信息布局
NSString *const kUpdatePersonCenterInfoViewLayoutsNotification = @"kUpdatePersonCenterInfoViewLayoutsNotification";

///签到红点显示
NSString *const kShowCheckInRedDotNotification = @"kShowCheckInRedDotNotification";

NSString *const kNeedShowliveSmallViewNotification = @"kNeedShowliveSmallViewNotification";

///静音开关通知
NSString *const kMuteStateChangedNotication = @"kMuteStateChangedNotication";

///切换到社区首页-推荐
NSString *const kSQNeedSwitchToRcmdTabNotication = @"kSQNeedSwitchToRcmdTabNotication";
///切换到社区首页-热帖
NSString *const kSQNeedSwitchToHotPostTabNotication = @"kSQNeedSwitchToHotPostTabNotication";
///切换到社区首页-板块
NSString *const kSQNeedSwitchToPlateTabNotication = @"kSQNeedSwitchToPlateTabNotication";

NSString *const kUpdateUserCenterInfoNotification = @"kUpdateUserCenterInfoNotification";

//分享成功通知
NSString *const kShareSuccessNotification = @"kShareSuccessNotification";

/// 3.5.0 鉴定直播间 去使用
NSString *const NotificationNameGotoUsedAppraiseRedPacket = @"NotificationNameGotoUsedAppraiseRedPacket";

/// 3.5.0 99包邮弹窗
NSString *const kMallPage99FreeNotification = @"MallPage99FreeNotification";

///通知社区推荐首页更新数据  主要是刷新用户刚发布帖子后显示的帖子内容
NSString *const kUpdateSQRecommendDataNotification = @"kUpdateSQRecommendDataNotification";
///版块主页发布帖子 更新帖子通知
NSString *const kUpdateSQPlateDetailDataNotification = @"kUpdateSQPlateDetailDataNotification";
///话题主页发布帖子 更新帖子通知
NSString *const kUpdateSQTopicDetailDataNotification = @"kUpdateSQTopicDetailDataNotification";

/// 首页所有列表的滑动 状态
NSString *const NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS = @"NOTIFICATION_HOME_SCROLLVIEW_STATUS";

/// 首页所有列表的返回顶部 状态
NSString *const NOTIFICATION_HOME_SCROLLVIEW_TO_TOP_STATUS = @"NOTIFICATION_HOME_SCROLLVIEW_TO_TOP_STATUS";

/// 购物鉴定 电视机位（仓库直播/回放）
NSString *const NOTIFICATION_APPRAISE_STORE_SYSTEM_MESSAGE = @"NOTIFICATION_APPRAISE_STORE_SYSTEM_MESSAGE";

NSString * const NotificationNameUserHeadUpdated = @"NotificationNameUserHeadUpdated";
@end

