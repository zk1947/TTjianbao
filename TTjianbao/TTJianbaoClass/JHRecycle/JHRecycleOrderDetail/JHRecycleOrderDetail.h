//
//  JHRecycleOrderDetail.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#ifndef JHRecycleOrderDetail_h
#define JHRecycleOrderDetail_h

#import <YYKit/YYKit.h>
#import "JHRecycleHeader.h"
#import "CommAlertView.h"

static CGFloat const LeftSpace = 10.0f;
static CGFloat const ContentLeftSpace = 10.0f;

static CGFloat const RecycleOrderNomalTopSpace = 8.0f;
static CGFloat const RecycleOrderNomalBottomSpace = 12.0f;

static CGFloat const RecycleOrderDescribeFontSize = 12.0f;
/// 仲裁工具条高度
static CGFloat const RecycleOrderArbitrationToolbarHeight = 30.0f;

static CGFloat const RecycloOrderNodeHeight = 60.0f;
static CGFloat const RecycloOrderNodeNumWidth = 24.0f;


typedef NS_ENUM(NSInteger, RecycleOrderTitleStatus){
    /// 默认
    RecycleOrderTitleStatusNomal = 1,
    /// 带价格
    RecycleOrderTitleStatusPrice,
    /// 已经预约取件
    RecycleOrderTitleStatusIcon,
};

typedef NS_ENUM(NSInteger, RecycleOrderDetailCornerType){
    /// 顶部圆角
    RecycleOrderDetailCornerTop = 1,
    /// 底部圆角
    RecycleOrderDetailCornerBottom,
    /// 4个角都为圆角
    RecycleOrderDetailCornerAll,
    /// 无圆角
    RecycleOrderDetailCornerNo,
};

typedef NS_ENUM(NSInteger, RecycleOrderNodeType){
    ///
    RecycleOrderNodeTypeNomal = 1,
    ///
    RecycleOrderNodeTypeLine,
};


typedef enum : NSUInteger {
    /// 待回收商付款
    RecycleOrderStatusWaitPay = 0,      //待回收商付款：展示按钮【取消订单】和【订单追踪】
    /// 待发货- 商家已付款-用户预约物流
    RecycleOrderStatusWaitSend,         //待发货，物流=未预约快递：展示按钮【取消订单】和【预约上门取件】和【订单追踪】
    /// 待发货- 用户已经预约物流
    RecycleOrderStatusWaitTakeToSend,   //待发货，物流=已预约待取件：展示按钮【查看取件预约】和【订单追踪】
    /// 待回收商收货
    RecycleOrderStatusWaitReceive,      //待回收商收货：展示按钮【查看物流】和【订单追踪】
    /// 待确认交易- 待商家确认价格
    RecycleOrderStatusWaitConfirmPrice, //待确认交易，确认价格状态=待确认，展示按钮【查看物流】和【订单追踪】
    /// 待确认交易- 原价购买
    RecycleOrderStatusBuyOriginalPrice, //待确认交易，确认价格状态=原价购买，系统自动确认交易，订单状态流转到交易成功
    /// 待确认交易- 降价购买
    RecycleOrderStatusBuyDiscountPrice, //待确认交易，确认价格状态=减价购买，展示按钮【查看物流】和【订单追踪】和【确认报价】和【申请退回】
    /// 待确认交易- 拒绝购买
    RecycleOrderStatusBuyRefused,       
    /// 仲裁- 待处理
    RecycleOrderStatusArbitrationWaitTodo,
    /// 仲裁- 待沟通
    RecycleOrderStatusArbitrationWaitConnect,
    /// 仲裁- 鉴定为假退回
    RecycleOrderStatusArbitrationFalse, //待确认交易，仲裁结果=鉴定为假退回，展示按钮【查看物流】和【订单追踪】和【申请销毁】和【申请退回】
    /// 仲裁- 鉴定为真退回
    RecycleOrderStatusArbitrationTrue,  //待确认交易，仲裁结果=鉴定为真退回，展示按钮【查看物流】和【订单追踪】和【申请退回】
    /// 仲裁- 达成交易
    RecycleOrderStatusArbitrationDeal, //待确认交易，仲裁结果=达成交易，展示按钮【查看物流】和【订单追踪】和【确认报价】和【申请退回】
    /// 交易成功
    RecycleOrderStatusFinished,         //交易成功， 展示按钮【查看物流】和【订单追踪】
    /// 取消订单- 用户取消订单
    RecycleOrderStatusCancel,
    /// 取消订单- 待给回收商退款
    RecycleOrderStatusCancelWaitRefund, //取消订单，退款退货中（待平台给回收商退款）， 展示按钮【订单追踪】
    /// 取消订单- 已给商家退款
    RecycleOrderStatusCancelRefund,     //取消订单，退款完成，显示按钮【订单追踪】和【删除】
    
    /// 订单关闭-用户主动关闭交易
    RecycleOrderStatusClosed,
    RecycleOrderStatusClosedDeal,
//    /// 订单关闭-商家超时未付款
//    RecycleOrderStatusClosedWaitPay,    //关闭交易，订单状态=订单关闭，显示按钮【订单追踪】和【删除】
//    /// 订单关闭-待回收商发货
//    RecycleOrderStatusCloseWaitSend,    //关闭交易，退款退货中（待平台给回收商退款）， 展示按钮【订单追踪】
//    /// 订单关闭-用户申请销毁
//    RecycleOrderStatusCloseDestruction,    //关闭交易，退款完成，显示按钮【订单追踪】和【删除】
//    /// 订单关闭-已发货
//    RecycleOrderStatusCloseSend,        //关闭交易，退款退货中，退货物流=已发货，显示按钮【订单追踪】和【查看物流】和【确认收货】
//    /// 订单关闭-已收货
//    RecycleOrderStatusCloseDelivered,      //关闭交易，退款退货中，退货物流=已收货，显示按钮【订单追踪】和【查看物流】
//    RecycleOrderStatusCloseFinishedLogistics,   //关闭交易，退款完成，退货物流=已收货，显示按钮【订单追踪】和【查看物流】和【删除】

    RecycleOrderStatusEmpty,
    
} RecycleOrderStatus;















#endif /* JHRecycleOrderDetail_h */
