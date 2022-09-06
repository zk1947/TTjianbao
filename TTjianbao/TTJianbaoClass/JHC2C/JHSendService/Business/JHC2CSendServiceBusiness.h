//
//  JHC2CSendServiceBusiness.h
//  TTjianbao
//
//  Created by hao on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSendServiceBusiness : NSObject
///上门取件
+ (void)requestPickupWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///提交预约取件
+ (void)requestPickupAppointmentSubmitWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///填写快递单号-获取快递logo
+ (void)requestWriteOrderGetExpressInfoWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
///填写快递单号-取消寄件
+ (void)requestWriteOrderCancelMailingWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
///填写快递单号-确认邮寄
+ (void)requestWriteOrderConfirmMailingWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///自助寄出
+ (void)requestSelfMailingWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
///确认自助寄出
+ (void)requestConfirmSelfMailingWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
