//
//  JHHttpSession.m
//  TTjianbao
//
//  Created by Jesse on 2020/8/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHttpSession.h"
#import "JHHttpSessionManager.h"
#import "SVProgressHUD.h"

@interface JHHttpSession ()

//返回子队列（子线程）
@property (nonatomic, strong) JHHttpSessionManager* httpSessionsManager;

@end

@implementation JHHttpSession

- (JHHttpSessionManager *)httpSessionsManager
{
    if(!_httpSessionsManager)
    {
        _httpSessionsManager = [JHHttpSessionManager manager];
    }
    return _httpSessionsManager;
}

- (void)setSessionCompleteQueue:(BOOL)isSubQueue
{
    if(isSubQueue)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.httpSessionsManager.completionQueue = queue;
    }
    else
    {
        self.httpSessionsManager.completionQueue = nil;
    }
}

#pragma mark - network - > get & post & put & delete
- (void)getWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure
{
    NSString* url = [request fullUrl];
    NSDictionary* params = [request paramsDict];
    NSLog(@">>&>1>get request url: %@ \r\n parameters: %@", url, params);
    
    [self.httpSessionsManager setSessionManager:RequestSerializerTypeHttp encryptParams:nil timeoutInterval:kDefaultTimeoutInterval]; //http
    [self.httpSessionsManager GET:url parameters:params headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        //do nothing
    } success:^(NSURLSessionDataTask* _Nonnull task, id  _Nullable responseObject) {
        
        [self completeSessionTask:task success:success failure:failure responseData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self completeSessionTask:task success:nil failure:failure responseData:error];
    }];
}
///post->仅有参数
- (void)postWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure  requestSerializerType:(RequestSerializerType)serializerType
{
    NSString* url = [request fullUrl];
    NSDictionary* params = [request paramsDict];
    NSLog(@">>&>2.1>post request url: %@ \r\n parameters: %@", url, params);
    
    [self.httpSessionsManager setSessionManager:serializerType encryptParams:nil timeoutInterval:self.sessionTimeoutInterval];
    [self.httpSessionsManager POST:url parameters:params headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        //do nothing
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self completeSessionTask:task success:success failure:failure responseData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self completeSessionTask:task success:nil failure:failure responseData:error];
    }];
}

///post->有参数+有上传进度回调的方法
- (void)postWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure uploadProgress:(uploadProgressBlock)progressBlock requestSerializerType:(RequestSerializerType)serializerType
{
    NSString* url = [request fullUrl];
    NSDictionary* params = [request paramsDict];
    NSLog(@">>&>2.2>post request & progress url: %@ \r\n parameters: %@", url, params);
    
    [self.httpSessionsManager setSessionManager:serializerType encryptParams:nil timeoutInterval:kDefaultTimeoutInterval];
    [self.httpSessionsManager POST:url parameters:params headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [self uploadingProgress:progressBlock uploadProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self completeSessionTask:task success:success failure:failure responseData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self completeSessionTask:task success:nil failure:failure responseData:error];
    }];
}
///post->有参数+有加密
- (void)postWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure encrypt:(BOOL)isEncrypt requestSerializerType:(RequestSerializerType)serializerType
{
    NSString* url = [request fullUrl];
    NSDictionary* params = [request paramsDict];
    NSLog(@">>&>2.3>post request & encrypt url: %@ \r\n parameters: %@", url, params);
    
    [self.httpSessionsManager setSessionManager:serializerType encryptParams:(isEncrypt ? params : nil) timeoutInterval:kDefaultTimeoutInterval];
    [self.httpSessionsManager POST:url parameters:params headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        //do nothing
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self completeSessionTask:task success:success failure:failure responseData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self completeSessionTask:task success:nil failure:failure responseData:error];
    }];
}
///put(放置到服务器固定路径)->有参数
- (void)putWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure  requestSerializerType:(RequestSerializerType)serializerType
{
    NSString* url = [request fullUrl];
    NSDictionary* params = [request paramsDict];
    NSLog(@">>&>3>put request url: %@ \r\n parameters: %@", url, params);
    
    [self.httpSessionsManager setSessionManager:serializerType encryptParams:nil timeoutInterval:kDefaultTimeoutInterval];
    [self.httpSessionsManager PUT:url parameters:params headers:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self completeSessionTask:task success:success failure:failure responseData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self completeSessionTask:task success:nil failure:failure responseData:error];
    }];
}
///delete(删除服务器资源)->有参数
- (void)deleteWithModel:(JHReqModel*)request success:(JHSuccess)success failure:(JHFailure)failure  requestSerializerType:(RequestSerializerType)serializerType
{
    NSString* url = [request fullUrl];
    NSDictionary* params = [request paramsDict];
    NSLog(@">>&>4>delete request url: %@ \r\n parameters: %@", url, params);
    
    [self.httpSessionsManager setSessionManager:serializerType encryptParams:nil timeoutInterval:kDefaultTimeoutInterval];
    [self.httpSessionsManager DELETE:url parameters:params headers:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self completeSessionTask:task success:success failure:failure responseData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self completeSessionTask:task success:nil failure:failure responseData:error];
    }];
}

#pragma mark - network - > call back
///上传进度回调
- (void)uploadingProgress:(uploadProgressBlock)progressBlock uploadProgress:(NSProgress *)uploadProgress
{
    if (!uploadProgress)
        return;
    
    if (progressBlock)
    {
        progressBlock(uploadProgress);
    }
}
/**成功与失败回调:
 *  成功->success is not nil
 *  失败->success is nil and responseData is NSError
 */
- (void)completeSessionTask:(NSURLSessionDataTask*)task success:(JHSuccess)success failure:(JHFailure)failure responseData:(id)responseData
{
    BOOL isMainThread = [NSThread isMainThread];
    NSLog(@">>&>0>>network callback is main thread ? << %d >>complete request session URL:%@", isMainThread, task.originalRequest.URL);
    
    if(!success && [responseData isKindOfClass:[NSError class]])
    {//网络失败或者没有发出网络请求
        JHNetworkResponse *model = [[JHNetworkResponse alloc] init];
        model.code = ((NSError*)responseData).code;
        model.message = kNetworkLinkFailTips;
        [self dismissLoading:isMainThread]; //主动  停掉请求loading
        if (failure)
            failure(model.message);
    }
    else
    {//网络请求成功
        JHNetworkResponse *model = [JHNetworkResponse mj_objectWithKeyValues:responseData];
        if (model.code == kNetworkResponseCodeSuccess)
        {
//            [self dismissLoading:isMainThread]; //TODO:原来这里没加是遗忘了吗？还是故意没加？？
            if (success)
                success(model.data);
        }
        else  if (model.code == kNetworkResponseCodeUnauthorized)
        {//未登陆或者token过期
            [self dismissLoading:isMainThread]; //主动  停掉请求loading
            if (failure)
                failure(model.message);
        }
        else
        {
            if (!model.message || ![model.message isKindOfClass:[NSString class]])
            {
                model.message = kNetworkOkRequestFailTips;
            }
            [self dismissLoading:isMainThread]; //主动  停掉请求loading
            if (failure)
                failure(model.message);
        }
    }
}
///按理说不该加在网络模块中？？！！~~
- (void)dismissLoading:(BOOL)isMainThread
{
    if(isMainThread)
    { ///主线程直接dismiss
        [SVProgressHUD dismiss];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

@end
