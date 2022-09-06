//
//  JHOrderFactory.m
//  TTjianbao
//
//  Created by miao on 2021/7/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderFactory.h"
#import "JHBuyersOrderModel.h"
#import "JHMerchantsOrderModel.h"
#import "JHOrderStatusInterface.h"

@implementation JHOrderFactory

+ (id<JHOrderStatusInterface>)getOrderStatusModel:(JHCustomerOrderSide)side {
    
    NSString *buyersClassName = NSStringFromClass([JHBuyersOrderModel class]);
    NSString *merchantsClassName = NSStringFromClass([JHMerchantsOrderModel class]);
    NSString *className = side == JHCustomerOrderSide_Buyers ? buyersClassName : merchantsClassName;
    Class handleClass = NSClassFromString(className);
    id<JHOrderStatusInterface> orderModel = [handleClass new];
    return orderModel;
}

+ (JHVariousStatusOfOrders)getVariousStatusOfOrders:(NSString *)orderStatus {
    if ([JHOrderFactory p_getWaitPay:orderStatus]) {
        return JHVariousStatusOfOrders_WaitPay;
    } else if ([orderStatus isEqualToString:@"waitsellersend"]) {
        return JHVariousStatusOfOrders_WaitDeliver;
    } else if ([orderStatus isEqualToString:@"waitportalappraise"]) {
        return JHVariousStatusOfOrders_WaitIdentification;
    } else if ([orderStatus isEqualToString:@"waitportalsend"]) {
        return JHVariousStatusOfOrders_WaitPlatformSend;
    }
    else if ([orderStatus isEqualToString:@"sellersent"]) {
        return JHVariousStatusOfOrders_WaitPlatformReceiving;
    } else if ([orderStatus isEqualToString:@"portalsent"]) {
        return JHVariousStatusOfOrders_WaitReceiving;
    } else if ([JHOrderFactory p_getOrdersComplete:orderStatus]) {
        return  JHVariousStatusOfOrders_Complete;
    } else if ([orderStatus isEqualToString:@"cancel"]) {
        return JHVariousStatusOfOrders_Cancel;
    } else if ([orderStatus isEqualToString:@"all"]) {
        return JHVariousStatusOfOrders_All;
    }  else if ([orderStatus isEqualToString:@"customizing"]) {
        return JHVariousStatusOfOrders_ApplyForCustom;
    } else if ([orderStatus isEqualToString:@"splited"]) {
        return JHVariousStatusOfOrders_HaveBomb;
    } else if ([orderStatus isEqualToString:@"sale"]) {
        return JHVariousStatusOfOrders_Sale;
    } else if([orderStatus isEqualToString:@"refund"]) {
        return JHVariousStatusOfOrders_ReturnGoodsAfter;
    } else if ([orderStatus isEqualToString:@"refunded"]) {
        return JHVariousStatusOfOrders_Refunded;
    }
    else if ([JHOrderFactory p_getRefunding:orderStatus]) {
        return JHVariousStatusOfOrders_Refunding;
    }
    
    return JHVariousStatusOfOrders_Cancel;
}

+ (BOOL)p_getWaitPay:(NSString *)orderStatus {
    if ([orderStatus isEqualToString:@"waitpay"] ||
        [orderStatus isEqualToString:@"paying"] ||
        [orderStatus isEqualToString:@"waitack"]) {
        return YES;
    }
    return NO;
}

//+ (BOOL)p_getWaitIdentification:(NSString *)orderStatus {
//    if ([orderStatus isEqualToString:@"waitportalappraise"] ||
//        [orderStatus isEqualToString:@"waitportalsend"]) {
//        return YES;
//    }
//    return NO;
//}

+ (BOOL)p_getOrdersComplete:(NSString *)orderStatus {
    if ([orderStatus isEqualToString:@"buyerreceived"]||
        [orderStatus isEqualToString:@"completion"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)p_getRefunding:(NSString *)orderStatus {
    if ([orderStatus isEqualToString:@"refunding"]/* ||
        [orderStatus isEqualToString:@"refunded"]*/) {
        return YES;
    }
    return NO;
}

@end
