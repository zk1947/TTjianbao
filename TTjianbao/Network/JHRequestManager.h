//
//  JHRequestManager.h
//  TTjianbao
//  Description:网络请求管理:1、默认主线程返回 2、返回子线程
//  Created by Jesse on 2019/12/5.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNetwork.h"

/**
 * 网络管理对外提供单例
 */
#define JH_REQUEST  kSingleInstance(JHRequestManager)

NS_ASSUME_NONNULL_BEGIN

@interface JHRequestManager : NSObject

singleton_h(JHRequestManager);

//设置主线程返回的timeout,默认20秒
- (void)setMainSessionTimeoutInterval:(NSTimeInterval)interval;
//设置子线程返回的timeout,默认20秒
- (void)setSubQueueSessionTimeoutInterval:(NSTimeInterval)interval;

#pragma mark - 返回主线程
- (void)asynGet:(JHReqModel*)reqModel success:(JHSuccess)success failure:(JHFailure)failure;
//post request
- (void)asynPost:(JHReqModel*)reqModel success:(JHSuccess)success failure:(JHFailure)failure;
//暂时未用到
- (void)asynPost:(JHReqModel*)reqModel requestSerializerTypes:(RequestSerializerType)serializerType  success:(JHSuccess)success failure:(JHFailure)failure;
//put request
- (void)asynPut:(JHReqModel*)reqModel requestSerializerTypes:(RequestSerializerType)serializerType success:(JHSuccess)success failure:(JHFailure)failure;
//delete request
- (void)asynDelete:(JHReqModel*)reqModel success:(JHSuccess)success failure:(JHFailure)failure;

#pragma mark - 返回【子线程】:dispatch_get_global_queue
- (void)asynGet:(JHReqModel*)reqModel subQueueSuccess:(JHSuccess)success subQueueFailure:(JHFailure)failure;
//post request
- (void)asynPost:(JHReqModel*)reqModel subQueueSuccess:(JHSuccess)success subQueueFailure:(JHFailure)failure;
//暂时未用到
- (void)asynPost:(JHReqModel*)reqModel requestSerializerTypes:(RequestSerializerType)serializerType  subQueueSuccess:(JHSuccess)success subQueueFailure:(JHFailure)failure;
//put request
- (void)asynPut:(JHReqModel*)reqModel requestSerializerTypes:(RequestSerializerType)serializerType subQueueSuccess:(JHSuccess)success subQueueFailure:(JHFailure)failure;
/*默认requestSerializerType:RequestSerializerTypeHttp*/
- (void)asynDelete:(JHReqModel*)reqModel subQueueSuccess:(JHSuccess)success subQueueFailure:(JHFailure)failure;

@end

NS_ASSUME_NONNULL_END
