//
//  JHAppraisePayModel.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMarketOrderModel.h"
#import "CoponPackageMode.h"
#import "PayMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAppraisePayModel : JHMarketOrderModel
@property (strong,nonatomic)NSArray <CoponMode*>*myCouponVoList;
@property (strong,nonatomic)NSArray <PayWayMode*>*payWayArray;
/** 原价*/
//@property(nonatomic, strong) NSString *originOrderPrice;
/** 过期时间*/
//@property(nonatomic, strong) NSString *expireTime;
/** 红包抵扣金额*/
@property(nonatomic, strong) NSString *discountAmount;

@property(nonatomic, strong) NSString *defaultCouponId;


@end

NS_ASSUME_NONNULL_END
