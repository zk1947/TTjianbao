//
//  JHOrderOutgoingServer.m
//  TTjianbao
//
//  Created by miao on 2021/7/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderOutgoingServer.h"
#import "JHOrderConfirmViewController.h"
#import "JHOrderConfirmEntryDataObject.h"

@implementation JHOrderOutgoingServer

+(JHOrderConfirmViewController *)getOrderConfirmVC:(JHOrderConfirmEntryDataObject *)jumpObject {
    
    JHOrderConfirmViewController *orderConfirmVC = [[JHOrderConfirmViewController alloc]init];
    if (!isEmpty(jumpObject.goodsId)) {
        orderConfirmVC.goodsId = jumpObject.goodsId;
    }
    if (!isEmpty(jumpObject.fromString)) {
        orderConfirmVC.fromString = jumpObject.fromString;
    }
    if (!isEmpty(jumpObject.showId)) {
        orderConfirmVC.showId = jumpObject.showId;
    }
    if (!isEmpty(jumpObject.parentOrderId)) {
        orderConfirmVC.parentOrderId = jumpObject.parentOrderId;
    }
    if (!isEmpty(jumpObject.source)) {
        orderConfirmVC.source = jumpObject.source;
    }
    if (!isEmpty(jumpObject.orderCategory)) {
        orderConfirmVC.orderCategory = jumpObject.orderCategory;
    }
    orderConfirmVC.orderType = jumpObject.orderType;
    orderConfirmVC.activeConfirmOrder = jumpObject.activeConfirmOrder;
    return orderConfirmVC;
}

@end
