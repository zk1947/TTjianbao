//
//  JHRecyclePickupViewController.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  回收上门取件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecyclePickupViewController : JHBaseViewController
/** 订单ID*/
@property (nonatomic, copy) NSString *orderId;
/** 订单编号*/
@property (nonatomic, copy) NSString *orderCode;
/** 商品二级分类ID*/
@property (nonatomic, copy) NSString *productTypeId;
/** 商品三级分类ID*/
@property (nonatomic, copy) NSString *goodsTypeId;
/** 预约状态 0:未预约 1:已预约*/
@property (nonatomic, assign) NSInteger reservationStatus;
///监听预约成功
@property (nonatomic, strong) RACSubject *appointmentSuccessSubject;

@end

NS_ASSUME_NONNULL_END
