//
//  JHMerchantsOrderModel.m
//  TTjianbao
//
//  Created by miao on 2021/7/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMerchantsOrderModel.h"
#import "JHOrderFactory.h"

@interface JHMerchantsOrderModel ()

/// 商品经营模式
@property (nonatomic, assign) JHBusinessModel businessModel;
/// 订单状态的文字
@property (nonatomic, copy) NSString *oStatusText;

@end

@implementation JHMerchantsOrderModel

- (void)setBusinessModel:(JHBusinessModel)bModel {
    _businessModel = bModel;
}
- (JHBusinessModel)getGoodsBusinessModel {
    return _businessModel;
}

- (void)setOrderStatus:(NSString *)orderStatus {
    _oStatusText = orderStatus;
}

- (NSString *)getOrderStatus {
    return _oStatusText;
}

- (nullable NSString *)getOrderStatusString:(JHVariousStatusOfOrders)orderStatus
                           isDirectDelivery:(BOOL)isDirectDelivery
                                    isBuyer:(JHCustomerOrderSide)side {
    
    NSString *resultStatusText = nil;
    switch (orderStatus) {
        case JHVariousStatusOfOrders_WaitPay:
            resultStatusText = @"待买家付款";
            break;
        case JHVariousStatusOfOrders_WaitDeliver:
            if (side == JHCustomerOrderSide_Merchants) {
                resultStatusText = @"待发货";
            }else {
                resultStatusText = @"待卖家发货";
            }
            
            break;
        case JHVariousStatusOfOrders_WaitIdentification:
            resultStatusText = @"待平台鉴定";
            break;
        case JHVariousStatusOfOrders_WaitPlatformSend:
            resultStatusText = @"待平台发货";
            break;
        case JHVariousStatusOfOrders_WaitPlatformReceiving:
            resultStatusText = @"待平台收货";
            break;
        case JHVariousStatusOfOrders_WaitReceiving:
            resultStatusText = @"待买家收货";
            break;
        case JHVariousStatusOfOrders_Complete:
            resultStatusText = @"已完成";
            break;
        case JHVariousStatusOfOrders_Cancel:
            resultStatusText = @"已取消";
            break;
        case JHVariousStatusOfOrders_All:
            resultStatusText = @"全部订单";
            break;
        case JHVariousStatusOfOrders_ApplyForCustom:
            resultStatusText = @"已申请定制";
            break;
        case JHVariousStatusOfOrders_HaveBomb:
            resultStatusText = @"已拆单";
            break;
        case JHVariousStatusOfOrders_Sale:
            resultStatusText = @"寄售中";
            break;
        case JHVariousStatusOfOrders_ReturnGoodsAfter:
            resultStatusText = @"退货售后中";
            break;
        case JHVariousStatusOfOrders_Refunding:
            resultStatusText = @"退货退款中";
            break;
        case JHVariousStatusOfOrders_Refunded:
            resultStatusText = @"退款完成";
            break;
        default:
            break;
    }
    return resultStatusText;
}

- (BOOL)currentSideIsBuyers {
    return NO;
}

@end
