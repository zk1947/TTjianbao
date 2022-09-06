//
//  JHLiveApiManager.m
//  TTjianbao
//
//  Created by jiangchao on 2020/9/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveApiManager.h"
#import "JHNimNotificationManager.h"
#import "CommHelp.h"

@implementation JHLiveApiManager
+ (void)applyConnectMic:(NSString*)roomId images:(NSArray*)imgList  Completion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/connectMic/apply") Parameters:@{@"roomId":roomId,@"imgList":[CommHelp objectToJsonStr:imgList]} successBlock:^(RequestModel *respondObject)
     {
        NSError *error=nil;
        completion(respondObject,error);
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}
+ (void)applyRecycleConnectMic:(NSString*)roomId images:(NSArray*)imgList  Completion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/recycle/connectMic/apply") Parameters:@{@"roomId":roomId,@"imgList":[CommHelp objectToJsonStr:imgList]} successBlock:^(RequestModel *respondObject)
     {
        NSError *error=nil;
        completion(respondObject,error);
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}
+ (void)applyConnectCustomize:(NSString*)roomId orderCategory:(NSString*)orderCategory customizeOrderId:(NSString*)orderId Completion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/appraisal/connectMic/apply") Parameters:@{@"roomId":roomId,@"orderCategory":orderCategory,@"orderId":orderId} successBlock:^(RequestModel *respondObject)
     {
        NSError *error=nil;
        completion(respondObject,error);
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}

//定制主播反向连麦
+ (void)reverseApplyConnectCustomize:(NSString*)roomId viewerId:(NSString*)viewerId Completion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/appraisal/reverse/connectMic/apply") Parameters:@{@"roomId":roomId,@"viewerId":viewerId} successBlock:^(RequestModel *respondObject)
     {
        NSError *error=nil;
        completion(respondObject,error);
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}
//回收主播反向连麦
+ (void)reverseApplyConnectRecycle:(NSString*)roomId viewerId:(NSString*)viewerId Completion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/recycle/connectMic/reverse/apply") Parameters:@{@"roomId":roomId,@"viewerId":viewerId} successBlock:^(RequestModel *respondObject)
     {
        NSError *error=nil;
        completion(respondObject,error);
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}
+(void)getMicWaitingCountComplete:(JHFinishBlock)complete{
    
    NSString *url = [NSString stringWithFormat:@"/auth/connectMic/waitCount?roomId=%@",[JHNimNotificationManager sharedManager].micWaitMode.waitRoomId];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        JHMicWaitMode * mode=[JHMicWaitMode mj_objectWithKeyValues:respondObject.data];
        [JHNimNotificationManager sharedManager].micWaitMode.waitCount=mode.waitCount;
        [JHNimNotificationManager sharedManager].micWaitMode.singleWaitSecond=mode.singleWaitSecond;
        //  [JHNimNotificationManager sharedManager].micWaitMode.isWait=mode.isWait;
        complete();
        
    } failureBlock:^(RequestModel *respondObject) {
        
        complete();
    }];
    
    //  [SVProgressHUD show];
    
}
+(void)getRecycleMicWaitingCountComplete:(JHFinishBlock)complete{
    
    NSString *url = [NSString stringWithFormat:@"/recycle/connectMic/waitCount?roomId=%@",[JHNimNotificationManager sharedManager].recycleWaitMode.waitRoomId];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        JHMicWaitMode * mode=[JHMicWaitMode mj_objectWithKeyValues:respondObject.data];
        [JHNimNotificationManager sharedManager].recycleWaitMode.waitCount=mode.waitCount;
        [JHNimNotificationManager sharedManager].recycleWaitMode.singleWaitSecond=mode.singleWaitSecond;
        //  [JHNimNotificationManager sharedManager].micWaitMode.isWait=mode.isWait;
        complete();
        
    } failureBlock:^(RequestModel *respondObject) {
        
        complete();
    }];
    
    //  [SVProgressHUD show];
    
}
+(void)getCustomizeWaitingCountComplete:(JHFinishBlock)complete{
    
    NSString *url = [NSString stringWithFormat:@"/appraisal/connectMic/waitCount?roomId=%@",[JHNimNotificationManager sharedManager].customizeWaitMode.waitRoomId];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        JHMicWaitMode * mode=[JHMicWaitMode mj_objectWithKeyValues:respondObject.data];
        [JHNimNotificationManager sharedManager].customizeWaitMode.waitCount=mode.waitCount;
        [JHNimNotificationManager sharedManager].customizeWaitMode.singleWaitSecond=mode.singleWaitSecond;
        //  [JHNimNotificationManager sharedManager].micWaitMode.isWait=mode.isWait;
        complete();
        
    } failureBlock:^(RequestModel *respondObject) {
        
        complete();
    }];
    
    //  [SVProgressHUD show];
    
}
+(void)audienceEnter:(NSString*)roomId{
    
    if ([roomId isEqualToString:[JHNimNotificationManager sharedManager].micWaitMode.waitRoomId]) {
        NSString *url = [NSString stringWithFormat:@"/auth/connectMic/back?roomId=%@",roomId];
        [HttpRequestTool putWithURL: FILE_BASE_STRING(url) Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
    }
    else  if ([roomId isEqualToString:[JHNimNotificationManager sharedManager].customizeWaitMode.waitRoomId]) {
        NSString *customizeUrl = [NSString stringWithFormat:@"/appraisal/connectMic/back?roomId=%@",roomId];
        [HttpRequestTool putWithURL: FILE_BASE_STRING(customizeUrl) Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
    }
    else  if ([roomId isEqualToString:[JHNimNotificationManager sharedManager].recycleWaitMode.waitRoomId]) {
        NSString *url = [NSString stringWithFormat:@"/recycle/connectMic/back?roomId=%@",roomId];
        [HttpRequestTool putWithURL: FILE_BASE_STRING(url) Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
    }
    
    
}
+(void)audienceOut:(NSString*)roomId{
    
    if ([roomId isEqualToString:[JHNimNotificationManager sharedManager].micWaitMode.waitRoomId]){
        NSString *url = [NSString stringWithFormat:@"/auth/connectMic/leave?roomId=%@",roomId];
        [HttpRequestTool putWithURL:FILE_BASE_STRING(url) Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
    }
    
    else  if ([roomId isEqualToString:[JHNimNotificationManager sharedManager].customizeWaitMode.waitRoomId]){
        NSString *customizeUrl = [NSString stringWithFormat:@"/appraisal/connectMic/leave?roomId=%@",roomId];
        [HttpRequestTool putWithURL: FILE_BASE_STRING(customizeUrl) Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
    }
    
    else  if ([roomId isEqualToString:[JHNimNotificationManager sharedManager].recycleWaitMode.waitRoomId]){
        NSString *url = [NSString stringWithFormat:@"/recycle/connectMic/leave?roomId=%@",roomId];
        [HttpRequestTool putWithURL: FILE_BASE_STRING(url) Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
    }
}

+ (void)checkUserCanUseCustomizePackage:(NSInteger)customerId
                                version:(NSString *)version
                             Completion:(void (^ _Nullable)(NSError * _Nullable, RequestModel * _Nullable))completion {
    NSString *urlWithVersion = [NSString stringWithFormat:@"/appVersion/auth/%@/check",version];
    NSString *url = FILE_BASE_STRING(urlWithVersion);
    NSDictionary *params = @{
        @"customerId":@(customerId)
    };
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (completion) {
            completion(nil,respondObject);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,respondObject);
        }
    }];
}


+ (void)checkUserCustomizeListPackageWithCustomerId:(NSInteger)customerId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize Completion:(void(^)(NSError *_Nullable error, NSArray<JHCheckCustomizeOrderListModel *> *_Nullable array))completion {
    NSString *url = FILE_BASE_STRING(@"/orderCustomize/auth/canCustomizeOrderList");
    NSDictionary *params = @{
        @"customerId":@(customerId),
        @"pageIndex":@(pageIndex),
        @"pageSize":@(pageSize)
    };
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *array = [NSArray cast:respondObject.data];
        if (!array || array.count == 0) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        NSArray *arr = [array jh_map:^id _Nonnull(id  _Nonnull obj, NSUInteger idx) {
            JHCheckCustomizeOrderListModel *model = [JHCheckCustomizeOrderListModel mj_objectWithKeyValues:obj];
            return model;
        }];
        if (completion) {
            completion(nil,arr);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];
}

@end
