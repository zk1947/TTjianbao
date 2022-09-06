//
//  JHC2CPickupViewController.h
//  TTjianbao
//
//  Created by hao on 2021/6/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  上门取件

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CPickupViewController : JHBaseViewController<JXCategoryListContentViewDelegate>
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
/** 来源 0:C2C, 1:Recycle */
@property (nonatomic, assign) NSInteger fromStatus;

///监听预约成功回调
@property (nonatomic, strong) RACSubject *appointmentSuccessSubject;
@end

NS_ASSUME_NONNULL_END
