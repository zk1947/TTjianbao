//
//  JHIdentificationDetailsBusiness.h
//  TTjianbao
//
//  Created by miao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JHIdentDetailHttpRequestCompleteBlock)(RequestModel * _Nonnull respondObject);
typedef void(^JHIdentDetailHttpRequestFailedBlock)(NSError * __nonnull error);

NS_ASSUME_NONNULL_BEGIN

@interface JHIdentificationDetailsBusiness : NSObject

/// 鉴定详情的接口
/// @param params 请求参数
/// @param completion 请求成功
/// @param fail 请求失败
+ (void)requestIdentDetailWithParams:(NSDictionary *)params
                          completion:(JHIdentDetailHttpRequestCompleteBlock)completion
                                fail:(JHIdentDetailHttpRequestFailedBlock)fail;

@end

NS_ASSUME_NONNULL_END
