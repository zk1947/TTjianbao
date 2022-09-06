//
//  JHOrderConfirmEntryDataObject.h
//  TTjianbao
//
//  Created by miao on 2021/7/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTjianbaoMarcoEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderConfirmEntryDataObject : NSObject

/// 订单ID
@property (nonatomic, copy) NSString *orderId;
///  埋点来源
@property (nonatomic, copy) NSString *fromString;
/// 主动下单  （require）//专场id，没有可以不传，否则必传
@property (nonatomic, copy) NSString *showId;
/// 主动下单 原石所属的订单id （optional）
@property (nonatomic, copy) NSString *parentOrderId;
/// 主动下单 页面来源接口需要 （require）
@property (nonatomic, copy) NSString* source;
/// 主动下单  （require）
@property (nonatomic, copy) NSString *orderCategory;
/// 主动下单  （require）
@property (nonatomic, copy) NSString* goodsId;
/// 主动下单 用于一口价和特卖
@property (nonatomic, assign) BOOL activeConfirmOrder;
/// 主动下单 （require）
@property (nonatomic, assign) JHOrderType orderType;


@end

NS_ASSUME_NONNULL_END
