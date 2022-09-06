//
//  JHFansClubBusiness.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansClubBusiness.h"

@implementation JHFansClubBusiness

+ (void)FansTaskReport:(JHFansTaskType )taskType anchorId:(NSString*)anchorId  channelId:(NSString*)channelId customerId:(NSString*)customerId{
    
    NSDictionary *dic = @{@"taskType":@(taskType),
                          @"anchorId":anchorId,
                          @"channelId":channelId,
                          @"customerId":customerId,
                          @"taskCondition":@(1),
    };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/fans/fans-exp/addExp") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:FansClubTaskNotifaction  object:nil];
        
    } failureBlock:^(RequestModel *respondObject) {
        
//        [JHKeyWindow makeToast:respondObject.message?:@"" duration:2 position:CSToastPositionCenter];
    }];
}
+ (void)getFansClubInfo:(NSString *)clubId completion:(JHApiRequestHandler)completion{
    
    NSDictionary *par = @{@"fansClubId" : clubId};
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-task/list");
    [HttpRequestTool getWithURL:url Parameters:par  successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

+ (void)checkAndSendReward:(NSString *)anchorId completion:(JHApiRequestHandler)completion{
    NSDictionary *par = @{@"anchorId" : anchorId};
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-club/checkAndSendReward");
    [HttpRequestTool getWithURL:url Parameters:par  successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

+ (void)getFansClubTitle:(NSString *)anchorId completion:(JHApiRequestHandler)completion{
    
    NSDictionary *par = @{@"anchorId" : anchorId};
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-club/fans-list/title");
    [HttpRequestTool getWithURL:url Parameters:par  successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

+ (void)getFansList:(NSString *)anchorId  pageNo:(NSInteger)pageNo  pageSize:(NSInteger)pageSize  completion: (JHApiRequestHandler)completion{
    
    NSDictionary *par = @{@"anchorId" : anchorId,
                          @"pageNo" : @(pageNo),
                          @"pageSize" : @(pageSize),};
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-club/fans-list");
    [HttpRequestTool getWithURL:url Parameters:par  successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}
@end
