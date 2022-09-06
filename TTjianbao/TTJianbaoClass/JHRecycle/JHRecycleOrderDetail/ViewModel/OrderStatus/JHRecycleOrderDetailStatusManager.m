//
//  JHRecycleOrderDetailStatusManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailStatusManager.h"

@implementation JHRecycleOrderDetailStatusManager

- (void)setupOrderStatus : (RecycleOrderStatus) orderStatus {
    self.orderTitleStatus = RecycleOrderTitleStatusNomal;
    
    switch (orderStatus) {
        case RecycleOrderStatusWaitPay: // 待付款
            self.statusText = @"等待商家付款";
            self.describeText = @"";
            break;
        case RecycleOrderStatusWaitSend: // 已付款
            self.statusText = @"商家已付款, 请预约上门取件";
            self.describeText = @"后未预约上门取件，视为放弃交易，系统将关闭回收单";
            break;
        case RecycleOrderStatusWaitTakeToSend: // 已经预约取件
            self.statusText = @"上门取件预约成功";
            self.describeText = @"等待快递员上门取件，取消寄件视为放弃交易，如需帮助请联系客服";
            break;
        case RecycleOrderStatusWaitReceive: // 待收货
            self.statusText = @"等待商家收货";
            self.describeText = @"等待回收商收货并进行再次报价";
            break;
        case RecycleOrderStatusWaitConfirmPrice: // 待确认交易
            self.statusText = @"待确认交易";
            self.describeText = @"待商家进行宝贝验收";
            break;
        case RecycleOrderStatusBuyDiscountPrice: // 降价购买
            self.statusText = @"商家的验收价格: ";
            self.orderTitleStatus = RecycleOrderTitleStatusPrice;
            break;
        case RecycleOrderStatusBuyRefused: // 拒绝回收
            self.statusText = @"商家拒绝回收";
            break;
        case RecycleOrderStatusArbitrationWaitTodo: // 已申请仲裁 待处理
            self.statusText = @"已申请仲裁";
            self.describeText = @"待处理";
            break;
        case RecycleOrderStatusArbitrationWaitConnect: // 已申请仲裁/待沟通
            self.statusText = @"已申请仲裁";
            self.describeText = @"待沟通";
            break;
        case RecycleOrderStatusArbitrationTrue: // 仲裁结果为真
            self.statusText = @"仲裁结果: 退回";
            break;
        case RecycleOrderStatusArbitrationFalse: // 仲裁结果为假
            self.statusText = @"仲裁结果: 退回";
            break;
        case RecycleOrderStatusArbitrationDeal: // 仲裁结果交易
            self.statusText = @"仲裁结果: 达成交易";
            break;
        
        case RecycleOrderStatusFinished: // 交易成功
            self.statusText = @"交易成功";
            self.iconUrl = @"recycle_orderDetail_ordersuccess_icon";
            self.orderTitleStatus = RecycleOrderTitleStatusIcon;
            self.describeText = @"回收金额发放至已我的零钱";
            break;
        case RecycleOrderStatusClosed: // 订单关闭 - 商家未付款
            self.statusText = @"订单关闭";
            self.iconUrl = @"recycle_orderDetail_orderclose_icon";
            self.orderTitleStatus = RecycleOrderTitleStatusIcon;
            break;
            
        case RecycleOrderStatusClosedDeal: // 订单关闭 - 用户未发货
            self.statusText = @"关闭交易";
            self.iconUrl = @"recycle_orderDetail_orderclose_icon";
            self.orderTitleStatus = RecycleOrderTitleStatusIcon;
            break;
            
//        case RecycleOrderStatusClosed: // 订单关闭 - 用户主动关闭订单
//            self.statusText = @"订单关闭";
//            self.iconUrl = @"recycle_orderDetail_orderclose_icon";
//            self.orderTitleStatus = RecycleOrderTitleStatusIcon;
//            self.describeText = @"您已主动关闭交易";
//            break;
//
//        case RecycleOrderStatusCloseDestruction: // 订单关闭 - 用户申请销毁
//            self.statusText = @"订单关闭";
//            self.iconUrl = @"recycle_orderDetail_orderclose_icon";
//            self.orderTitleStatus = RecycleOrderTitleStatusIcon;
//            self.describeText = @"商品已申请销毁";
//            break;
//
//        case RecycleOrderStatusCloseWaitSend: // 订单关闭 - 待商家发货
//            self.statusText = @"订单关闭";
//            self.iconUrl = @"recycle_orderDetail_orderclose_icon";
//            self.orderTitleStatus = RecycleOrderTitleStatusIcon;
//            self.describeText = @"待商家发货";
//
//            break;
//        case RecycleOrderStatusCloseDelivered: // 订单关闭 - 商家已发货
//            self.statusText = @"订单关闭";
//            self.iconUrl = @"recycle_orderDetail_orderclose_icon";
//            self.orderTitleStatus = RecycleOrderTitleStatusIcon;
//            self.describeText = @"商家已发货，请关注物流并进行查收/商品已申请销毁";
//            break;
        case RecycleOrderStatusCancelWaitRefund: // 用户取消订单
            self.statusText = @"订单关闭";
            self.iconUrl = @"recycle_orderDetail_orderclose_icon";
            self.orderTitleStatus = RecycleOrderTitleStatusIcon;
            break;
        case RecycleOrderStatusCancel: // 用户取消订单
            self.statusText = @"订单已取消";
            self.iconUrl = @"recycle_orderDetail_orderclose_icon";
            self.orderTitleStatus = RecycleOrderTitleStatusIcon;
            break;
        case RecycleOrderStatusCancelRefund: // 用户取消订单
            self.statusText = @"订单关闭";
            self.iconUrl = @"recycle_orderDetail_orderclose_icon";
            self.orderTitleStatus = RecycleOrderTitleStatusIcon;
            break;
        default:
            self.statusText = @"";
            break;
    }
}
#pragma mark - Lazy

@end
