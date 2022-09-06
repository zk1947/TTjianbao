//
//  JHAppAlertModel.h
//  TTjianbao
//
//  Created by apple on 2020/5/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHAppAlertBodyModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHAppAlertType)
{
    /// 随机红包
    JHAppAlertTypeRedPacket = 1,
    
    /// 超级红包
    JHAppAlertTypeBigRedPacket = 2,
    
    /// 活动
    JHAppAlertTypeActivity = 3,
    
    /// 风险提示
    JHAppAlertTypeRiskWarning = 4,
    
    /// 版本更新
    JHAppAlertTypeAppUpdate = 5,
    
    /// 去商店评价
    JHAppAlertTypeAppRaise = 6,
    
    /// 新人优惠券
    JHAppAlertTypeNewUserRedPacket = 7,
    
    /// 新人礼物
    JHAppAlertTypeGift = 8,
    
    /// 鉴定问题
    JHAppAlertTypeAppraiseProblem = 9,
    
    /// 新人9块9
    JHAppAlertType99Free = 10,
    
    /// 推送开启 - 提示
    JHAppAlertTypeNotification = 100,
};

typedef NS_ENUM(NSInteger, JHAppAlertLocalType)
{
    /// 无
    JHAppAlertLocalTypeNone = 0,
    
    /// 首页
    JHAppAlertLocalTypeHome = 1,
    
    /// 直播间
    JHAppAlertLocalTypeLiveRoom = 2,
    
    /// 直播间外
    JHAppAlertLocalTypeLiveRoomOut = 3,
    
    /// 任何位置
    JHAppAlertLocalTypeAll = 4,
    
    /// 源头直购-直播购物
    JHAppAlertLocalTypeMallPage = 5,
    
};


/// app升级弹框
extern NSString *const AppAlertUpdateVersion;

/// 新人礼包卖场
extern NSString *const AppAlertNewSellerPacket;

/// 新人鉴定礼包
extern NSString *const AppAlertNewAppraisePacket;

/// 活动弹窗
extern NSString *const AppAlertActivity;

/// 活动弹窗
extern NSString *const AppAlertActivityRoom;

/// 鉴定问题
extern NSString *const AppAlertAppraiseProblem;

/// 签到
extern NSString *const AppAlertSign;

/// 超级红包
extern NSString *const AppAlertSuperRedPacket;

/// 引导市场
extern NSString *const AppAlertGuideMarket;

/// 原石风险
extern NSString *const AppAlertRough;

/// 随机红包
extern NSString *const AppAlertRandomRedPacket;

/// 新人9块9
extern NSString *const AppAlertName99Free;

/// 推送开启 - 提示
extern NSString *const AppAlertNameNotification;

@interface JHAppAlertModel : NSObject

/// 弹框种类
@property (nonatomic, assign) JHAppAlertType type;

/// 弹框可展示位置
@property (nonatomic, assign) JHAppAlertLocalType localType;

/// 弹框种类
@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSDictionary *param;

@property (nonatomic, strong) id body;



@end

NS_ASSUME_NONNULL_END
