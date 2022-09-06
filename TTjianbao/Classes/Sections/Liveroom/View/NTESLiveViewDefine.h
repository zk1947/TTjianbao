//
//  NTESLiveViewDefine.h
//  TTjianbao
//
//  Created by chris on 16/4/5.
//  Copyright © 2016年 Netease. All rights reserved.
//

#ifndef NTESLiveViewDefine_h
#define NTESLiveViewDefine_h

#import <NIMAVChat/NIMAVChat.h>

typedef NS_ENUM(NSInteger, NTESLiveRole){
    NTESLiveRoleAnchor,
    NTESLiveRoleAudience,
};

typedef NS_ENUM(NSInteger, NTESLiveType){
    NTESLiveTypeInvalid = -1,  //直播未开始
    NTESLiveTypeAudio = NIMNetCallMediaTypeAudio,    //音频直播
    NTESLiveTypeVideo = NIMNetCallMediaTypeVideo,    //视频直播
};
typedef NS_ENUM(NSInteger, NTESLiveActionType)
{
    
    NTESLiveActionTypeLive,     //点直播按钮
    NTESLiveActionTypeLike,     //点赞
    NTESLiveActionTypePresent,  //礼物
    NTESLiveActionTypeShare,    //分享
    NTESLiveActionTypeCamera,   //旋转摄像头
    NTESLiveActionTypeQuality,  //分辨率
    NTESLiveActionTypeInteract, //互动
    NTESLiveActionTypeBeautify, //美颜
    NTESLiveActionTypeMixAudio,  //混音
    NTESLiveActionTypeSnapshot,  //截图
    NTESLiveActionTypeChat,      //聊天
    NTESLiveActionTypeMoveUp,    //点上移按钮
    NTESLiveActionTypeMirror,    //镜像
    NTESLiveActionTypeWaterMark, //水印
    NTESLiveActionTypeFlash,   //闪光灯
    NTESLiveActionTypeZoom,      //焦距调节
    NTESLiveActionTypeFocus,      //开启手动对焦
    NTESLiveActionTypeMute,       //主播静音
    NTESLiveActionTypeGuess,       //主播竞猜
    NTESLiveActionTypeWishPaper,       //主播查看心愿单
    NTESLiveActionTypeMuteList,       //主播查看禁言列表
    NTESLiveActionTypeAnnouncement,       //主播公告

    NTESLiveActionTypeJubao,       //举报直播间
    NTESLiveActionTypeSendRedPacket,       //鉴定师发送红包
    NTESLiveActionTypeSendStarPlayTips,       //开播提醒

};

typedef NS_ENUM(NSInteger, NTESLiveQuality)
{
    NTESLiveQualityHigh,      //高清
    NTESLiveQualityNormal,    //流畅
};


typedef NS_ENUM(NSInteger, NTESLiveMicState)
{
    NTESLiveMicStateNone,       //初始状态
    NTESLiveMicStateWaiting,    //队列等待
    NTESLiveMicStateConnecting, //连接中   没用到
    NTESLiveMicStateConnected,  //已连接
    NTESLiveMicStateWait,  // 主播等待用户同意
 
};

typedef NS_ENUM(NSInteger, NTESLiveMicOnlineState)
{
     NTESLiveMicOnlineStateEnterRoom,  //进入房间
     NTESLiveMicOnlineStateExitRoom,  // 离开房间
};

typedef NS_ENUM(NSInteger, NTESLiveCustomNotificationType)
{
    NTESLiveCustomNotificationTypePushMic = 0,    //加入连麦队列通知
    NTESLiveCustomNotificationTypePopMic  = 1,    //退出连麦队列通知
    NTESLiveCustomNotificationTypeForceDisconnect  = 2,  //主播强制让连麦者断开
    NTESLiveCustomNotificationTypeAgreeConnectMic  = 3,  //主播同意连麦
    NTESLiveCustomNotificationTypeRejectAgree      = 4,  //拒绝主播的同意连麦   //没用到
    NTESLiveCustomNotificationTypeAudiencedAccept     = 5,  // 接受主播的同意连麦  //没用到
    NTESLiveCustomNotificationTypeAudiencedEnterOrExitLiveRoom  = 6,  // 用户进入房间 用户离开房间
    NTESLiveCustomNotificationTypeAudiencedAppraisalCountChange  = 7,  // 用户等待人数变更
    NTESLiveCustomNotificationTypeAudiencedRemoveQueue  = 8, //用户被主播主动移除队列
    NTESLiveCustomNotificationTypeAnchourDestroyQueue  = 9, //主播解散队列，所有人都被移除
    
      NTESLiveCustomNotificationTypeAudiencedCustomizeCountChange  = 10,  // 定制用户等待人数变更
      NTESLiveCustomNotificationTypeCustomizeAudiencedRemoveQueue  = 11, //定制用户被主播主动移除队列
      NTESLiveCustomNotificationTypeCustomizeAnchourDestroyQueue  = 12, //定制主播解散队列，所有人都被移除
    
    NTESLiveCustomNotificationTypeAudiencedRecycleCountChange  = 24121,  // 回收用户等待人数变更
    NTESLiveCustomNotificationTypeRecycleAudiencedRemoveQueue  = 24122, //回收用户被主播主动移除队列
    NTESLiveCustomNotificationTypeRecycleAnchourDestroyQueue  = 24123, //回收主播解散队列，所有人都被移除
    
    NTESLiveCustomNotificationTypeRefuseConnectMic  = 15,  //主播拒绝鉴定
    NTESLiveCustomNotificationTypeSendReporter  = 18,  //主播发送鉴定报告
    
    NTESLiveCustomNotificationTypeReverseLink = 36,  //反向连麦
    
    NTESLiveCustomNotificationTypeAssistantReceived  = 100,  //主播发送订单 助理和主播接受
    NTESLiveCustomNotificationTypeSendOrder  = 101,  //主播发送订单 用户接收
    NTESLiveCustomNotificationTypeRecvRedPocket  = 104,  //主播发送红包 用户接收
    NTESLiveCustomNotificationTypeRecvOrderChange  = 105,  //用户接收订单状态变化
    NTESLiveCustomNotificationTypeBeMuteUserSendToAnchorMsg  = 1008,  //被禁言用户给主播发私信
    NTESLiveCustomNotificationTypeAssistantCustomizeReceived = 200, // 定制服务订单 给卖家、助理 发送IM消息。
    NTESLiveCustomNotificationTypeSendCustomizeOrder = 201, // 定制服务订单给买家 发送IM消息，用户侧飞单信息 。
    
    NTESLiveCustomNotificationTypeAssistantCustomizeReceived_Two = 220, // 定制服务订单 给卖家、助理 发送IM消息。(二期)
    NTESLiveCustomNotificationTypeSendCustomizeOrder_Two = 221, // 定制服务订单给买家 发送IM消息，用户侧飞单信息 。(二期)
    /// 电商组 未读消息数量
    JHSystemMsgTypeShopOrderMessageCount = 1100,
    NTESLiveCustomNotificationTypeRecycleCountRefresh = 2000,//直播间待回收、出价数刷新通知
    //原石相关
    JHSystemMsgTypeStoneHaveNewPrice = 3001, //有人出价未读数-用户
    JHSystemMsgTypeStoneInSaleCount = 3003, //更新在售商品数量-主播
    JHSystemMsgTypeStoneUserInSaleCount = 3004, //消息-更新在售商品数量用户 去掉了
    
    JHSystemMsgTypeStoneUserActionCount = 3006, //消息-用户操作数量(前端计算)-回血主播助理 ---有人求看
        JHSystemMsgTypeStoneUserBuyAlert = 3008, //宝友购买弹窗 主播
    JHSystemMsgTypeStoneConfirmResaleAlert = 3009, //确认寄售弹窗
    JHSystemMsgTypeForRecvDealOrder = 3010, //确认加工
    JHSystemMsgTypeStoneBuyerConfirmBreakAlert = 3011, //买家确认拆单弹窗消息
    JHSystemMsgTypeStoneUserHavePriceAlert = 3012, //有人出价消息
    JHSystemMsgTypeStoneAcceptPriceAlert = 3013, //卖家出价被接受去付款消息
    JHSystemMsgTypeStoneRejectPriceAlert = 3014, //出价被拒绝消息
    JHSystemMsgTypeStoneWaitShelveCount = 3015, //消息：待上架原石总数
    JHSystemMsgTypeStoneStoneSaledAlert = 3016, //原石售出消息-用户
    JHSystemMsgTypeStoneConfirmEditPrice = 3017, //确认修改价格消息-用户
    JHSystemMsgTypeStoneOrderCount = 3018, //原石主播 原石订单数
    JHSystemMsgTypeStoneOrderMyBidCount = 3020, //我的出价
    JHSystemMsgTypeMyCenterWaitShelveCount = 3021, //个人中心待上架
    
    JHSystemMsgTypeBigRedPacketMsg = 3105, //大额随机红包 广播
    JHSystemMsgTypeBigRedPacketMsgPoint = 3106, //大额随机红包 点对点
    JHSystemMsgTypeBigRedPacketDeleteMsg = 3107, //大额随机红包 过期失效停播删除

    JHSystemMsgTypeSignUpTips = 3200, //签到提示 不用了
    JHSystemMsgTypeResaleStoneSignUpTips = 4001, //原始回血签约提示
    
    JHSystemMsgTypeFansUpgradeEquityMsg = 5000, //粉丝升级弹窗

     JHSystemMsgTypeFansUpexperienceMsg = 5001, //粉丝增加经验
    
    ///橱窗弹框
    JHSystemMsgTypeShopwindowAddGoods = 3022,
    
    ///橱窗弹框数量刷新主播。助理
    JHSystemMsgTypeShopwindowCount = 3023,
    
    ///橱窗弹框数量刷新用户
    JHSystemMsgTypeShopwindowAudienceCount = 3025,
    
    ///橱窗弹框刷新
    JHSystemMsgTypeShopwindowRefreash = 3024,
    
    ///点赞改变（朱运波）
    JHSystemMsgTypePraiseChange = 2007028796,
    
    ///评论改变
    JHSystemMsgTypeCommentChange = 2007028979,
    
    ///@评论
    JHSystemMsgTypeAtComment = 2101167456,
    
    ///@动态
    JHSystemMsgTypeAtDynamic = 2101167457,
    
    ///仓库回放  仓库直播
    JHSystemMsgTypeStoreLiving = 11301433,
    
    ///闪购商品上架消息:面向直播间用户
    FlashSalesMsg = 3026,
    ///闪购商品下架消息:面向直播间用户
    FlashDownMsg = 3027,
    ///闪购商品售罄消息:面向直播间用户和主播
    FlashSalesSellOutMsg = 3028,
};

typedef NS_ENUM(NSUInteger, NTESFilterType) {
    NTESFilterTypeNormal = 0,        //无滤镜.
    NTESFilterTypeSepia,             //黑白
    NTESFilterTypeZiran,             //自然
    NTESFilterTypeMeiyan1,           //粉嫩
    NTESFilterTypeMeiyan2,           //怀旧
};


typedef NS_ENUM(NSUInteger, NTESWaterMarkType) {
    NTESWaterMarkTypeNone = 0,            //无水印.
    NTESWaterMarkTypeNormal,              //静态水印
    NTESWaterMarkTypeDynamic,             //动态水印
};


typedef NS_ENUM(NSUInteger, NTESWaterMarkLocation) {
    NTESWaterMarkLocationRect = 0,      //由rect的origin定位置
    NTESWaterMarkLocationLeftUp,        //左上
    NTESWaterMarkLocationLeftDown,      //左下
    NTESWaterMarkLocationRightUp,       //右上
    NTESWaterMarkLocationRightDown,     //右下
    NTESWaterMarkLocationCenter         //中间
};


/**
 *  应用服务器错误码
 */
typedef NS_ENUM(NSInteger, NTESRemoteErrorCode) {
    /**
     *  数量超过上限
     */
    NTESRemoteErrorCodeOverFlow            = 419,
};



#endif /* NTESLiveViewDefine_h */

