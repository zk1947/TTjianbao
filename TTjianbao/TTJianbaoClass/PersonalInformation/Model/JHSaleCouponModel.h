//
//  JHSaleCouponModel.h
//  TTjianbao
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSaleCouponModel : JHResponseModel
@property (strong,nonatomic) NSString * Id; //代金券id
@property (strong,nonatomic) NSString * name; //代金券名称
@property (strong,nonatomic) NSString * img; //商家头像
@property (strong,nonatomic) NSString * ruleType; //代金券类型 - FR:满减 ，OD:折扣券, EFR:每满减
@property (strong,nonatomic) NSString * getType; // 领用方式：0领取券 1发放
@property (strong,nonatomic) NSString * price; //面值
@property (strong,nonatomic) NSString * ruleFrCondition; //满减起步金额 NSNumber
@property (strong,nonatomic) NSString * ruleFrConditionTip; //满减条件说明
@property (strong,nonatomic) NSString * usefulLife;//有效期说明
@property (strong,nonatomic) NSString * timeTypeRDay; //有效期、可用天数
@property (strong,nonatomic) NSString * timeTypeAEndTime;//开始时间 "2019-08-12T06:23:30.312Z"
@property (strong,nonatomic) NSString * timeTypeAStartTime;//结束时间 "2019-08-12T06:23:30.312Z"

@property (assign,nonatomic) BOOL isShow; //是否已停止发放，0：已停止 ，1：未停止
@property (assign,nonatomic) NSInteger currentCount; //发行量（用setCount，不用这个字段）
@property (assign,nonatomic) NSInteger setCount;//发行量
@property (assign,nonatomic) NSInteger enCount; //不确定什么意思，用不到！！！
@property (assign,nonatomic) NSInteger getCount;//领取人数、发放人数
@property (assign,nonatomic) NSInteger useCount;//使用人数
@property (assign,nonatomic) NSInteger unCount; //未使用数量

@property (assign,nonatomic) NSInteger forbidStop; //是否禁止停止发放，1：禁止 ，0：允许
@end


@interface GetCouponUserModel : NSObject
@property (strong,nonatomic)NSString *customerName;
@property (strong,nonatomic)NSString *getTime;
@property (strong,nonatomic)NSString *useTime;
@property (strong,nonatomic)NSString *orderId;
@property (strong,nonatomic)NSString *state;
@property (strong,nonatomic)NSString *img;

@end

NS_ASSUME_NONNULL_END
