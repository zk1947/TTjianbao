//
//  JHOrderPayViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

@interface JHOrderPayViewController : JHBaseViewExtController
@property(strong,nonatomic) NSString* orderId;
@property(strong,nonatomic) NSString* orderCategory;
@property(assign,nonatomic)  Boolean isMarket;
/// 商品ID ，用于埋点
@property(strong,nonatomic) NSString* goodsId;

@property (nonatomic, assign) BOOL isAuction;//Yes-拍卖订单

@property(assign,nonatomic) BOOL directDelivery;

@end

