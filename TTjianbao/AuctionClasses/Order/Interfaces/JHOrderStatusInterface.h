//
//  JHOrderStatusInterface.h
//  TTjianbao
//
//  Created by miao on 2021/7/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHOrderFactory.h"
#import "JHAppBusinessModelManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHOrderStatusInterface <NSObject>

@optional

/// 设置订单的经营模式 .直发/过仓
/// @param bModel 经营模式
- (void)setBusinessModel:(JHBusinessModel)bModel;
/// 获得订单经营模式
- (JHBusinessModel)getGoodsBusinessModel;

/// 获得不同订单状态的文字
/// @param orderStatus 订单类型
- (nullable NSString *)getOrderStatusString:(JHVariousStatusOfOrders)orderStatus
                           isDirectDelivery:(BOOL)isDirectDelivery
                                    isBuyer:(JHCustomerOrderSide)side;

/// 设置客户端orderStatus
/// @param orderStatus 状态字符串
- (void)setOrderStatus:(NSString *)orderStatus;
/// 设置客户端orderStatus
- (NSString *)getOrderStatus;

/// 是不是买家端
- (BOOL)currentSideIsBuyers;

@end

NS_ASSUME_NONNULL_END
