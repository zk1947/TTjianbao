//
//  JHC2CWriteOrderNumViewController.h
//  TTjianbao
//
//  Created by hao on 2021/6/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  填写快递单号

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CWriteOrderNumViewController : JHBaseViewController
/** 订单ID*/
@property (nonatomic, copy) NSString *orderId;
/** 订单编号*/
@property (nonatomic, copy) NSString *orderCode;
/** 商品id*/
@property (nonatomic, copy) NSString *productId;
/** 预约来源 0正向 2逆向*/
@property (nonatomic, assign) NSInteger appointmentSource;

//已发货拒绝退款
///撤销工单 1
@property (nonatomic, assign) NSInteger cancelWorkOrder;
///工单
@property (nonatomic, copy) NSString *workOrderId;
///用户标记 1：买家 2：卖家
@property (nonatomic, assign) NSInteger customerFlag;

/** 来源 1:上门取件（非传）*/
@property (nonatomic, assign) NSInteger fromStatus;
///填写确认成功回调
@property (nonatomic, strong) RACSubject *writeSuccessSubject;

@end

NS_ASSUME_NONNULL_END
