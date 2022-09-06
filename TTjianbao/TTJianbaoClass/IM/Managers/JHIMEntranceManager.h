//
//  JHIMEntranceManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  IM 入口管理

#import <Foundation/Foundation.h>
#import "JHSessionViewController.h"
#import "JHIMHeader.h"
#import "JHOrderDetailMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHIMEntranceManager : NSObject
/// 调起客服
/// userId : 对方用户ID - customerId
/// sourceType : 来源
/// isBusiness : 对方是否为商家
+ (void)pushSessionWithUserId : (NSString *)userId
                   sourceType : (JHIMSourceType)sourceType;
/// 调起客服
/// account : 对方accid
/// sourceType : 来源
/// isBusiness : 对方是否为商家
+ (void)pushSessionWithAccount : (NSString *)account
                    sourceType : (JHIMSourceType)sourceType;
/// 调起客服
/// userId : 对方用户ID - customerId
/// goodsInfo : 商品信息
/// isBusiness : 对方是否为商家
+ (void)pushSessionWithUserId : (NSString *)userId
                   sourceType : (JHIMSourceType)sourceType
                    goodsInfo : (JHChatGoodsInfoModel *)goodsInfo;
/// 调起客服
/// userId : 对方用户ID - customerId
/// orderInfo : 订单信息
/// isBusiness : 对方是否为商家
+ (void)pushSessionWithUserId : (NSString *)userId
                    orderInfo : (JHChatOrderInfoModel *)orderInfo;

/// 调起客服 - b2c 订单
/// userId : 对方用户ID - customerId
/// orderInfo : 订单信息
/// isBusiness : 对方是否为商家
+ (void)pushSessionOrderWithUserId : (NSString *)userId
                         orderInfo : (JHOrderDetailMode *)orderInfo;
@end

NS_ASSUME_NONNULL_END
