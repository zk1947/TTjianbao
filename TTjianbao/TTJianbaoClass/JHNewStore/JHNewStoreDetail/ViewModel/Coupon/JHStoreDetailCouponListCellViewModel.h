//
//  JHStoreDetailCouponListCellViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 优惠券cell ViewModel

#import "JHStoreDetailCellBaseViewModel.h"


typedef NS_ENUM(NSUInteger, CouponStatus) {
    /// 可用
    CouponStatusNormal = 0,
    /// 已领取
    CouponStatusReceive,
    /// 已失效
    CouponStatusInvalid,
    /// 已抢光
    CouponStatusSellout,
    /// 继续领取
    CouponStatusContinueReceive,
};

typedef NS_ENUM(NSUInteger, CouponTimeType) {
    /// 日期
    CouponStatusTimeDate = 0,
    /// 可用天数
    CouponStatusTimeDay,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCouponListCellViewModel : JHStoreDetailCellBaseViewModel

/// 优惠券状态 
@property (nonatomic, assign) CouponStatus couponStatus;
/// 金额
@property (nonatomic, copy) NSAttributedString *moneyText;
/// 满减
@property (nonatomic, copy) NSString *moneyRuleText;
/// title
@property (nonatomic, copy) NSString *titleText;
/// 日期
@property (nonatomic, copy) NSString *dateText;
/// 时间类型
@property (nonatomic, assign) CouponTimeType timeType;
/// 领取事件
@property (nonatomic, strong) RACSubject *receiveAction;

/// 设置优惠券金额
- (void)setMoney : (NSString *)money;
/// 设置优惠券折扣
- (void)setSaleMoney : (NSString *)money;
/// 设置优惠券 还有多少天到期
- (void)setDateWithDay : (NSString *)day;
/// 设置优惠券 起止时间
- (void)setDate : (NSString *)start endDate : (NSString *)end;
@end

NS_ASSUME_NONNULL_END
