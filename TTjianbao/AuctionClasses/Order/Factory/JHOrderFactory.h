//
//  JHOrderFactory.h
//  TTjianbao
//
//  Created by miao on 2021/7/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol JHOrderStatusInterface;

// 客户订单端枚举
typedef NS_ENUM(NSUInteger, JHCustomerOrderSide) {
    JHCustomerOrderSide_Merchants = 0,   // 商家订单端
    JHCustomerOrderSide_Buyers = 1, // 买家订单端
};

// 订单各种状态
typedef NS_ENUM(NSUInteger, JHVariousStatusOfOrders) {

    JHVariousStatusOfOrders_Refunding = 0,        //
    JHVariousStatusOfOrders_WaitPay = 1,          // 待付款
    JHVariousStatusOfOrders_Cancel = 2,           // 已取消
    JHVariousStatusOfOrders_WaitDeliver = 3,      // 待发货
    JHVariousStatusOfOrders_WaitReceiving = 4,     //待收货 ！！！！ 待平台收货
    JHVariousStatusOfOrders_WaitIdentification = 5, //待鉴定
    JHVariousStatusOfOrders_Complete = 6,           // 完成
    JHVariousStatusOfOrders_All = 7,              // 全部订单
    JHVariousStatusOfOrders_ApplyForCustom = 8,  // 申请定制
    JHVariousStatusOfOrders_HaveBomb = 9,    // 已拆单
    JHVariousStatusOfOrders_Sale = 10,     // 寄售中
    JHVariousStatusOfOrders_ReturnGoodsAfter = 11, // 退货售后中
    JHVariousStatusOfOrders_WaitPlatformReceiving = 12,     //待平台收货 ！！！！ 待收货
    JHVariousStatusOfOrders_Refunded = 13,     // 退款完成
    JHVariousStatusOfOrders_WaitPlatformSend, //待平台发货
};

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderFactory : NSObject

/// 获得商家/买家订单端Model
/// @param side 客户订单端枚举
+ (id<JHOrderStatusInterface>)getOrderStatusModel:(JHCustomerOrderSide)side;

/// 获得订单各种状态
/// @param orderStatus 客户订单状态标识
+ (JHVariousStatusOfOrders)getVariousStatusOfOrders:(NSString *)orderStatus;

@end

NS_ASSUME_NONNULL_END
