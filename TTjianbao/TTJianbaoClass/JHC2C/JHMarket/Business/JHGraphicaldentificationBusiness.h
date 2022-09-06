//
//  JHGraphicaldentificationBusiness.h
//  TTjianbao
//
//  Created by miao on 2021/7/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JHGraphicalHttpRequestCompleteBlock)(RequestModel * _Nonnull respondObject);
typedef void(^JHGraphicalHttpRequestFailedBlock)(NSError * __nonnull error);

NS_ASSUME_NONNULL_BEGIN

@interface JHGraphicaldentificationBusiness : NSObject

/// 删除图文鉴定的数据
/// @param params 请求参数
/// @param completion 请求成功回调
/// @param fail 请求失败
+ (void)requestDeleteGraphicalWithParams:(NSDictionary *)params
                        completion:(JHGraphicalHttpRequestCompleteBlock)completion
                              fail:(JHGraphicalHttpRequestFailedBlock)fail;


/// 取消鉴定
/// @param params 请求参数
/// @param completion 成功
/// @param fail 失败
+ (void)requestCancelIdentificationWithParams:(NSDictionary *)params
                                   completion:(JHGraphicalHttpRequestCompleteBlock)completion
                                         fail:(JHGraphicalHttpRequestFailedBlock)fail;

/// 图文鉴定详情页的网络请求
/// @param params 请求参数
/// @param completion 成功回调
/// @param fail 失败
+ (void)requestGraphicOrderDetailWithParams:(NSDictionary *)params
                                 completion:(JHGraphicalHttpRequestCompleteBlock)completion
                                       fail:(JHGraphicalHttpRequestFailedBlock)fail;

@end

NS_ASSUME_NONNULL_END
