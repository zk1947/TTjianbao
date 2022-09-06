//
//  JHRefundDetailBusiness.h
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRefundDetailBusiness : NSObject
///退款详情
+ (void)requestRefundDetailWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///删除工单  /order/marketOrder/auth/deleteWorkOrderCust
+ (void)requestRefundDeleteWorkOrderWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///撤销工单  /order/marketOrder/auth/cancelWorkOrderCust
+ (void)requestRefundCancelWorkOrderWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///买家提醒卖家收货  /order/marketOrder/auth/remindReceiptWorker
+ (void)requestRefundWarnReceiveWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///卖家同意退款   /order/marketOrder/auth/agreeRefund
+ (void)requestAgreeRefundWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///卖家提醒发货   /order/marketOrder/auth/remindShipWorker
+ (void)requestRefundRemindShipWorkerWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
