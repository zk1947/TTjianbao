//
//  JHSystemMsgAttachment.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/19.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSDK/NIMSDK.h"

typedef NS_ENUM(NSInteger, JHSystemMsgType) {
    
    JHSystemMsgTypeApplyAppraisal = 0,
    JHSystemMsgTypeCancelAppraisal = 1,
    JHSystemMsgTypeEndAppraisal = 2,
    JHSystemMsgTypeEndLive = 3,
    JHSystemMsgTypeFollow = 4,
    JHSystemMsgTypePresent = 16,
    JHSystemMsgType666 = 17,
    JHSystemMsgTypeSwitchAppraise = 19,
    
    JHSystemMsgTypeShowCustomizeOrder  = 34,  //显示定制中的订单
    JHSystemMsgTypeRemoveCustomizeOrder  = 35,  //移除定制中的订单
    
    JHSystemMsgTypeForbidLive = 500, //主播被禁播
    JHSystemMsgTypeWarning = 501, //主播被警告
    
    
    JHSystemMsgTypeNotification = 1000,//系统消息
    JHSystemMsgTypeOrderNotification = 1001,//飘屏消息
    JHSystemMsgTypeRoomNotification = 1002,//跑马灯公告
    JHSystemMsgTypeActivityNotification = 1006,//活动通知
    
    
    //原石回血相关 有通知有消息 某个用户的用通知 房间的用消息 标记主播的 助理也有
    JHSystemMsgTypeStoneStartLive = 1010, //关联直播间开播
    JHSystemMsgTypeStoneEndLive = 1011, //关联直播间停播
    
    JHSystemMsgTypeRecycleCountRefresh = 2000,//直播间待回收、出价数刷新通知
    
    JHSystemMsgTypeStoneForSaleCount = 3002, //寄售商品变化数量-原石直播间回血小窗
    
    JHSystemMsgTypeStoneWaitUserLookCount = 3005, //消息-直播间等待人数变化--原石直播间回血小窗
    
    JHSystemMsgTypeStoneReSalePriceCount = 3007, //消息-回血钱数更新 用户
    JHSystemMsgTypeStoneRefreshList = 3019, //消息-刷新列表 主播和用户
    
    
    //    /**
    //     * 红包被抢完，给红包创建人推送
    //     */
    //    JHSystemMsgTypeRedPacketFinishPushCreator = 3101,
    //
    //    /**
    //     * 红包到期未领完，给红包创建人推送
    //     */
    //    JHSystemMsgTypeRedPacketExpireTimePushCreator = 3102,
    
    /**
     * 移除过期或者抢完红包
     */
    JHSystemMsgTypeRedPacketRemove = 3103,
    
    /**
     * 新红包收到
     */
    JHSystemMsgTypeRedPacketShowNew = 3104,
    
    
    JHSystemMsgTypeRoomWatchCount = 4000, //直播间观看人数
    
    JHSystemMsgTypeStoneExplainMsg = 4002, //主播点击后,讲解状态
    JHSystemMsgTypePublishAnnoucementMsg = 4003, //发布公告
    //鉴定师红包的消息推送type
    JHSystemMsgTypeAppraiserRedpacketNewMsg = 4004, //新增（‘开’页面）时4004
    JHSystemMsgTypeAppraiserRedpacketGotMsg = 4005, //领完时（右下角小红包icon消失）变动  4005
    JHSystemMsgTypeLuckyBagUp = 4100, //福袋上架
    JHSystemMsgTypeLuckyBagDown = 4101, //福袋下架
    JHSystemMsgTypeLuckyBagRewardMsg = 4102, //福袋开奖
};

@interface JHSystemMsgAttachment : NSObject <NIMCustomAttachment>
@property (nonatomic, assign) JHSystemMsgType type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, copy) NSString *chartlet;


@property (nonatomic, copy) NSDictionary *giftInfo;
@property (nonatomic, copy) NSDictionary *receiver;

@property (nonatomic, copy) NSDictionary *sender;

@property (nonatomic, assign) NSInteger showStyle;

@property (nonatomic, assign) NSInteger yesOrNo;

@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *accid;
//直播间观看人数
@property (nonatomic, assign) NSInteger watchTotal;;

//
//giftInfo =     {
//    giftId = 2;
//    giftImg = "https://huifeideyu2.b0.upaiyun.com//20190104/1546599302720.png";
//    giftName = "\U68d2\U68d2\U54d2";
//    giftNum = 1;
//};
//receiver =     {
//    anchorId = 17;
//    icon = "";
//    nick = "\U592a\U968f\U4fbf";
//    userAccount = de70026f8d4147149762770743930b1b;
//};
//sender =     {
//    icon = "http://thirdwx.qlogo.cn/mmopen/vi_32/mPcOufbpy71ePaicHMv4iaFIChC0VBYNgK6BokPosJ3T0ibXqibwnfQCENNevtaNIn2Lic5URV5kjalLh3RnXcfpEfQ/132";
//    nick = "\U5566\U5566\U5566";
//    userAccount = 0dedc7292fc5407ba659c7d5d2604e67;
//    viewerId = 8;
//};


@end

@interface JHSystemMsg : NSObject
@property (nonatomic, assign) JHSystemMsgType type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, copy) NSString *chartlet;

@property (nonatomic, copy) NSDictionary *giftInfo;
@property (nonatomic, copy) NSDictionary *receiver;

@property (nonatomic, copy) NSDictionary *sender;

@property (nonatomic, assign) NSInteger grade;

@property (nonatomic, copy) NSString *userEnterEffect;


/**
 showStyle值： 102-创建订单， 103-支付成功
 */
@property (nonatomic, assign) NSInteger showStyle;

/// 1 代表金色星辰  2代表七彩祥云  3代表七彩祥云末世主宰，没有特效的返回空串
@property (copy, nonatomic) NSString *enter_effect;


/// 是否大客户
@property (nonatomic, assign) NSInteger userTycoonLevel;

@property (nonatomic, copy) NSString *levelImg;//粉丝牌
@end

