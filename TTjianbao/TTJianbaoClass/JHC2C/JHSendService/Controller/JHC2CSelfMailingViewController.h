//
//  JHC2CSelfMailingViewController.h
//  TTjianbao
//
//  Created by hao on 2021/6/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  自助邮寄

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "JHC2CSendServiceViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSelfMailingViewController : JHBaseViewController<JXCategoryListContentViewDelegate>
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

//已发货拒绝退款
///撤销工单 1
@property (nonatomic, assign) NSInteger cancelWorkOrder;
///工单
@property (nonatomic, copy) NSString *workOrderId;
///用户标记 1：买家 2：卖家
@property (nonatomic, assign) NSInteger customerFlag;


/** 订单状态 1:退款未预约，隐藏上门取件 */
@property (nonatomic, assign) NSInteger orderStatus;
///监听预约成功回调
@property (nonatomic, strong) RACSubject *selfMailingSuccessSubject;
@end

NS_ASSUME_NONNULL_END
