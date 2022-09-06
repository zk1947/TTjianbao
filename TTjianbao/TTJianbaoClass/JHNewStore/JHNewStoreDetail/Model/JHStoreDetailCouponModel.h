//
//  JHStoreDetailCouponModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCouponModel : NSObject
/// 代金券id
@property (nonatomic, copy) NSString *couponId;
/// 代金券名称
@property (nonatomic, copy) NSString *name;
/// 代金券使用说明
@property (nonatomic, copy) NSString *remark;
/// 满减条件
@property (nonatomic, copy) NSString *ruleFrCondition;
/// 满减金额
@property (nonatomic, copy) NSString *price;
/// 使用时间类型:R相对时间,A:绝对时间
@property (nonatomic, copy) NSString *timeType;
/// 相对时间可用天数
@property (nonatomic, copy) NSString *timeTypeRDay;
/// 绝对时间开始时间
@property (nonatomic, copy) NSString * timeTypeAStartTime;
/// 绝对时间结束时间
@property (nonatomic, copy) NSString * timeTypeAEndTime;
/// 结束领取时间
@property (nonatomic, copy) NSString *showEndTime;
/// 优惠券状态。0正常1删除
@property (nonatomic, copy) NSString *delFlag;
/// 卖家id
@property (nonatomic, copy) NSString *sellerId;
/// 优惠券数量
@property (nonatomic, copy) NSString *count;
/// 创建者id
@property (nonatomic, copy) NSString *creatorId;
/// 前端显示样式9，1折，200元
@property (nonatomic, copy) NSString *viewValue;
/// 使用类型 FR:满减 ，OD:折扣券, EFR:每满减
@property (nonatomic, copy) NSString *ruleType;
/// 领用方式： 0：领取券 1：发放
@property (nonatomic, copy) NSString *getType;
/// 是否已经领取过： 0：没领取 1：已经领取过
@property (nonatomic, assign) BOOL isReceive;
@end


@interface JHStoreDetailReceiveCouponModel : NSObject
/// 领取卡券状态
@property (nonatomic, assign) NSInteger status;
/// 绝对时间开始时间
@property (nonatomic, copy) NSString * startUseTime;
/// 绝对时间结束时间
@property (nonatomic, copy) NSString * endUseTime;
/// 是否可以继续领取
@property (nonatomic, assign) BOOL canContinueReceive;

@end



NS_ASSUME_NONNULL_END
