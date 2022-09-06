//
//  JHMarketProductAuthModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketProductAuthModel : NSObject
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, copy) NSString * orderCode;

///订单状态 waitack 待确认  waitpay  待支付
@property (nonatomic, copy) NSString * orderStatus;
@property (nonatomic, copy) NSString * orderStatusDesc;
@property (nonatomic, copy) NSString * goodsName;
@property (nonatomic, copy) NSString * payExpiredTime;
@end

NS_ASSUME_NONNULL_END
