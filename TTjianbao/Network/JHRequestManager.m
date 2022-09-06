//
//  JHRequestManager.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/5.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHRequestManager.h"
#import "JHHttpSession.h"

@interface JHRequestManager ()

@property (nonatomic, strong) JHHttpSession* mainSession; //默认返回主线程
@property (nonatomic, strong) JHHttpSession* subQueueSession; //返回子线程
@end

@implementation JHRequestManager

singleton_m(JHRequestManager)

- (JHHttpSession *)mainSession
{
    if(!_mainSession)
    {
        _mainSession = [JHHttpSession new];
    }
    return  _mainSession;
}

- (JHHttpSession *)subQueueSession
{
    if(!_subQueueSession)
    {
        _subQueueSession = [JHHttpSession new];
        [_subQueueSession setSessionCompleteQueue:YES];
    }
    return _subQueueSession;
}

- (void)setMainSessionTimeoutInterval:(NSTimeInterval)interval
{
    self.mainSession.sessionTimeoutInterval = interval;
}

- (void)setSubQueueSessionTimeoutInterval:(NSTimeInterval)interval
{
    self.subQueueSession.sessionTimeoutInterval = interval;
}

#pragma mark - 返回主线程
- (void)asynGet:(JHReqModel*)reqModel success:(JHSuccess)success failure:(JHFailure)failure
{
    [self.mainSession getWithModel:reqModel success:^(id respData) {
        success(respData);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    }];
}

- (void)asynPost:(JHReqModel*)reqModel success:(JHSuccess)success failure:(JHFailure)failure
{
    [self asynPost:reqModel requestSerializerTypes:RequestSerializerTypeJson success:success failure:failure];
}

- (void)asynPost:(JHReqModel*)reqModel requestSerializerTypes:(RequestSerializerType)serializerType  success:(JHSuccess)success failure:(JHFailure)failure
{
    [self.mainSession postWithModel:reqModel success:^(id respData) {
        success(respData);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    } requestSerializerType:serializerType];
}

- (void)asynPut:(JHReqModel*)reqModel requestSerializerTypes:(RequestSerializerType)serializerType success:(JHSuccess)success failure:(JHFailure)failure
{
    [self.mainSession putWithModel:reqModel success:^(id respData) {
        success(respData);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    } requestSerializerType:serializerType];
}

- (void)asynDelete:(JHReqModel*)reqModel success:(JHSuccess)success failure:(JHFailure)failure
{
    [self.mainSession deleteWithModel:reqModel success:^(id respData) {
        success(respData);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    } requestSerializerType:RequestSerializerTypeHttp];
}

#pragma mark - 返回【子线程】:dispatch_get_global_queue
- (void)asynGet:(JHReqModel*)reqModel subQueueSuccess:(JHSuccess)success subQueueFailure:(JHFailure)failure
{
    [self.subQueueSession getWithModel:reqModel success:^(id respData) {
        success(respData);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    }];
}

- (void)asynPost:(JHReqModel*)reqModel subQueueSuccess:(JHSuccess)success subQueueFailure:(JHFailure)failure
{
    [self asynPost:reqModel requestSerializerTypes:RequestSerializerTypeJson subQueueSuccess:success subQueueFailure:failure];
}
//暂时未用到
- (void)asynPost:(JHReqModel*)reqModel requestSerializerTypes:(RequestSerializerType)serializerType  subQueueSuccess:(JHSuccess)success subQueueFailure:(JHFailure)failure
{
    [self.subQueueSession postWithModel:reqModel success:^(id respData) {
        success(respData);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    } requestSerializerType:serializerType];
}

- (void)asynPut:(JHReqModel*)reqModel requestSerializerTypes:(RequestSerializerType)serializerType subQueueSuccess:(JHSuccess)success subQueueFailure:(JHFailure)failure
{
    [self.subQueueSession putWithModel:reqModel success:^(id respData) {
        success(respData);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    } requestSerializerType:serializerType];
}
/*默认requestSerializerType:RequestSerializerTypeHttp*/
- (void)asynDelete:(JHReqModel*)reqModel subQueueSuccess:(JHSuccess)success subQueueFailure:(JHFailure)failure
{
    [self.subQueueSession deleteWithModel:reqModel success:^(id respData) {
        success(respData);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    } requestSerializerType:RequestSerializerTypeHttp];
}

@end
