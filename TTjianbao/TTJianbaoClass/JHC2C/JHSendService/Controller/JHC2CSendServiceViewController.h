//
//  JHC2CSendServiceViewController.h
//  TTjianbao
//
//  Created by hao on 2021/6/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  邮寄服务

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSendServiceViewController : JHBaseViewController
/** 订单ID*/
@property (nonatomic, copy) NSString *orderId;
/** 订单编号*/
@property (nonatomic, copy) NSString *orderCode;
/** 商品id*/
@property (nonatomic, copy) NSString *productId;
/** 商品名称*/
@property (nonatomic, copy) NSString *productName;
/** 预约来源 0正向 2逆向*/
@property (nonatomic, assign) NSInteger appointmentSource;
///用户标记 1：买家 2：卖家
@property (nonatomic, assign) NSInteger customerFlag;

/** 邮寄类型 0:上门取件 1:自助寄出*/
@property (nonatomic, assign) NSInteger sendStatus;
///成功回调刷新
@property (nonatomic, strong) RACSubject *requestSuccessSubject;

@end

NS_ASSUME_NONNULL_END
