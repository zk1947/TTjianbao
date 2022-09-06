//
//  JHOrderReturnMode.h
//  TTjianbao
//
//  Created by jiang on 2019/10/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface JHOrderReturnReasonMode : NSObject
@property (nonatomic, copy)NSString *label;
@property (nonatomic, copy)NSString * value;

@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderReturnMode : NSObject
@property (nonatomic, copy)NSString *appraisalFeeBuyer;
@property (nonatomic, copy)NSString * certificateFeeBuyer;
@property (nonatomic, copy)NSString *customerBountyReturn;
@property (nonatomic, copy)NSString * customerCashReturn;
@property (nonatomic, copy)NSString *customerCouponReturn;
@property (nonatomic, copy)NSString *expressFeeBuyer;
@property (nonatomic, copy)NSString *platformReturn;
@property (strong,nonatomic) NSString * partialRefundAmount; //部分退已退金额 单位：元
@property (assign,nonatomic) BOOL partialRefundFlag; //用于表示该订单是否为部分退 true是 false 否
@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface JHOrderReturnMoneyMode : NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString * cash;
@end
NS_ASSUME_NONNULL_END

