//
//  JHBillTotalModel.h
//  TTjianbao
//
//  Created by apple on 2019/12/18.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBillTotalModel : NSObject

/// 销售额
@property (nonatomic, assign) double originalOrderPriceAmount ;

/// 已经结算
@property (nonatomic, assign) double alreadySettleAmount;

/// 待结算
@property (nonatomic, assign) double waitSettleAmount;

/// 提现中
@property (nonatomic, assign) double withdrawIngAmount;


///已经提现
@property (nonatomic, assign) double alreadyWithdrawAmount;

/// 退款中
@property (nonatomic, assign) double refundingAmount;

/// 待结算退款
@property (nonatomic, assign) double waitSettleRefundingAmount;

/// 已经结算退款中
@property (nonatomic, assign) double alreadySettleRefundingAmount;


/// 销售额
@property (nonatomic, copy) NSString * originalOrderPriceAmountStr;

/// 已经结算
@property (nonatomic, copy) NSString * alreadySettleAmountStr;

/// 待结算
@property (nonatomic, copy) NSString * waitSettleAmountStr;

/// 提现中
@property (nonatomic, copy) NSString * withdrawIngAmountStr;

///已经提现
@property (nonatomic, copy) NSString * alreadyWithdrawAmountStr;

/// 退款中
@property (nonatomic, copy) NSString * refundingAmountStr;

/// 待结算退款
@property (nonatomic, copy) NSString * waitSettleRefundingAmountStr;

/// 已经结算退款中
@property (nonatomic, copy) NSString * alreadySettleRefundingAmountStr;

@end

NS_ASSUME_NONNULL_END
