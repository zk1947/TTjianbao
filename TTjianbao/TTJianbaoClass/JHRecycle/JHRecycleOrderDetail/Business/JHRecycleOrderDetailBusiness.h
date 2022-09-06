//
//  JHRecycleOrderDetailBusiness.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-网络请求

#import <Foundation/Foundation.h>
#import "JHRecycleOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^detailInfoBlock)(JHRecycleOrderDetailModel * _Nullable respondObject);
typedef void (^cancelInfoBlock)(NSArray<JHRecycleCancelModel *> * _Nullable respondObject);
//typedef void (^couponInfoBlock)(NSArray<JHStoreDetailCouponModel *> * _Nullable respondObject);
//typedef void (^couponReceiveInfoBlock)(JHStoreDetailReceiveCouponModel * _Nullable respondObject);

@interface JHRecycleOrderDetailBusiness : NSObject

/// 获取订单详情
/// orderId : 订单ID
+ (void)getOrderInfoWithOrderId : (NSString *)orderId
                    successBlock:(detailInfoBlock) success
                    failureBlock:(failureBlock)failure;

/// 用户关闭订单
/// orderId : 订单ID
/// msg : 关闭原因
+ (void)orderCloseWithOrderId : (NSString *)orderId
                          msg : (NSString *)msg
                  successBlock:(succeedBlock) success
                  failureBlock:(failureBlock)failure;

/// 用户取消订单
/// msg : 取消原因
+ (void)orderCancelWithOrderId : (NSString *)orderId
                           msg : (NSString *)msg
                   successBlock:(succeedBlock) success
                   failureBlock:(failureBlock)failure;

/// 用户确认交易
/// orderId : 订单ID
+ (void)orderAcceptWithOrderId : (NSString *)orderId
                   successBlock:(succeedBlock) success
                   failureBlock:(failureBlock)failure;

/// 用户确认收货
/// msg : 订单ID
+ (void)orderReceivedWithOrderId : (NSString *)orderId
                   successBlock:(succeedBlock) success
                   failureBlock:(failureBlock)failure;

/// 用户删除订单
/// orderId : 订单ID
+ (void)orderDeleteWithOrderId : (NSString *)orderId
                   successBlock:(succeedBlock) success
                   failureBlock:(failureBlock)failure;

/// 用户确认销毁
/// orderId : 订单ID
+ (void)orderDestoryWithOrderId : (NSString *)orderId
                    successBlock:(succeedBlock) success
                    failureBlock:(failureBlock)failure;

/// 用户申请寄回
/// orderId : 订单ID
+ (void)orderReturnWithOrderId : (NSString *)orderId
                   successBlock:(succeedBlock) success
                   failureBlock:(failureBlock)failure;

/// 取消理由
/// orderId : 订单ID
+ (void)getOrderCancelListSuccessBlock:(cancelInfoBlock) success
                   failureBlock:(failureBlock)failure;

/// 取消理由
+ (void)getOrderCancelListWithRequestType:(NSInteger)requestType SuccessBlock:(cancelInfoBlock) success
                   failureBlock:(failureBlock)failure;

+ (void)getAppraisalOrderCancelListWithRequestSuccessBlock:(cancelInfoBlock)success failureBlock:(failureBlock)failure;

+ (void)getrefuseReasonListWithRequestSuccessBlock:(cancelInfoBlock)success failureBlock:(failureBlock)failure;
@end

NS_ASSUME_NONNULL_END
