//
//  JHMyCompeteResultBusiness.h
//  TTjianbao
//
//  Created by miao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JHMyCompeteHttpRequestCompleteBlock)(RequestModel * _Nonnull respondObject);
typedef void(^JHMyCompeteHttpRequestFailedBlock)(NSError * __nonnull error);

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCompeteResultBusiness : NSObject

/// 我的参拍网络请求
/// @param params 请求参数
/// @param completion 请求成功
/// @param completion 请求失败
+ (void)requestMyCompeteWithParams:(NSDictionary *)params
                        completion:(JHMyCompeteHttpRequestCompleteBlock)completion
                              fail:(JHMyCompeteHttpRequestFailedBlock)fail;


@end

NS_ASSUME_NONNULL_END
