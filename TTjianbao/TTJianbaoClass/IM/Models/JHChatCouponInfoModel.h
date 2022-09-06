//
//  JHChatCouponModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "JHIMHeader.h"
NS_ASSUME_NONNULL_BEGIN
@class JHChatCouponInfoModel;

@interface JHChatCustomCouponModel : NSObject<NIMCustomAttachment>
@property (nonatomic, assign) JHChatCustomType type;
@property (nonatomic, strong) JHChatCouponInfoModel *body;
@end

@interface JHChatCouponInfoModel : NSObject
/// id
@property (nonatomic, copy) NSString *couponId;
/// 商家id
@property (nonatomic, copy) NSString *sellerId;
/// 券名称
@property (nonatomic, copy) NSString *name;
/// 券规则，EFR：每满减 FR：满减 OD：折扣
@property (nonatomic, copy) NSString *ruleType;
/// 使用条件
@property (nonatomic, copy) NSString *ruleFrCondition;
/// 优惠值
@property (nonatomic, copy) NSString *price;
/// 使用时间类型 R相对时间,A:绝对时间
@property (nonatomic, copy) NSString *timeType;
/// timeType为'R'时的可用天数（自获得券后，剩余有效天数）
@property (nonatomic, copy) NSString *timeTypeRDay;
///  timeType类型为'A'时,可用的开始时间
@property (nonatomic, copy) NSString *timeTypeAStartTime;
/// timeType类型为'A'时,可用的结束时间  ----- 消息使用时-取截止时间
@property (nonatomic, copy) NSString *timeTypeAEndTime;
/// 适用范围  1 全部 2 直播间 3 商城
@property (nonatomic, assign) NSUInteger supplySellerType;

/** -------- 已下界面用---------*/
/// 选中状态
@property (nonatomic, assign) BOOL isSelected;


- (NSString *)getCouponRuleText;
/// 获取使用规则文本
- (NSString *)getCouponDescText;
- (NSAttributedString *)getMoneyText : (UIFont *)leftFont rightFont : (UIFont *) rightFont;
@end


@class JHChatCouponSendInfo;

@interface JHChatCouponSendModel : NSObject
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, strong) NSArray<JHChatCouponSendInfo *> *coupons;

@end

@interface JHChatCouponSendInfo : NSObject
@property (nonatomic, assign) NSUInteger couponId;
@property (nonatomic, copy) NSString *startUseTime;
@property (nonatomic, copy) NSString *endUseTime;

@end
NS_ASSUME_NONNULL_END
