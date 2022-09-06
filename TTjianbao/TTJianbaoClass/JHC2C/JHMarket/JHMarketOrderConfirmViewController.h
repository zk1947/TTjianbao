//
//  JHMarketOrderConfirmViewController.h
//  TTjianbao
//
//  Created by 张坤 on 2021/6/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  集市下单

#import "JHBaseViewExtController.h"
#import "TTjianbaoMarcoEnum.h"

typedef void(^JHPayBlock)(void);

@interface JHMarketOrderConfirmViewController : JHBaseViewExtController

@property(strong,nonatomic) NSString* orderId;
//埋点来源
@property(copy,nonatomic) NSString *fromString;

//主动下单 用于一口价和特卖
@property(assign,nonatomic) BOOL activeConfirmOrder;
//主动下单  （require）
@property(copy,nonatomic) NSString *orderCategory;
//主动下单  （require）
@property(strong,nonatomic) NSString* goodsId;
//主动下单 （require）
@property(assign,nonatomic) JHOrderType orderType;
//主动下单  （require）//专场id，没有可以不传，否则必传
@property(copy,nonatomic) NSString *showId;

//主动下单 页面来源接口需要 （require）
@property(strong,nonatomic) NSString* source;
//主动下单 原石所属的订单id （optional）
@property(copy,nonatomic) NSString *parentOrderId;
///支付结果回调
@property (nonatomic, copy) JHPayBlock payBlock;

@end

