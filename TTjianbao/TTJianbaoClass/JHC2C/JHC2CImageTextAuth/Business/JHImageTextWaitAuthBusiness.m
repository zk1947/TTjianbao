//
//  JHImageTextWaitAuthBusiness.m
//  TTjianbao
//
//  Created by zk on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageTextWaitAuthBusiness.h"

@implementation JHImageTextWaitAuthBusiness

+ (void)getImageTextAuthListData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize Completion:(void(^)(NSError *_Nullable error, JHImageTextWaitAuthListModel *_Nullable model))completion{
    NSString *url = FILE_BASE_STRING(@"/appraisalImageText/capi/auth/appraisalTask/listWaitPage");
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
        @"imageType":@"s,m,b,o",
        @"pageNo":@(pageIndex),
        @"pageSize":@(pageSize)
    }];
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHImageTextWaitAuthListModel *model = [JHImageTextWaitAuthListModel mj_objectWithKeyValues:respondObject.data];
        if (!model || model.resultList.count == 0) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        if (completion) {
            completion(nil,model);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,nil);
       }
    }];
}

+ (void)getAuthStatus:(int)taskId Completion:(void(^)(BOOL canAuth))completion{
    NSString *url = FILE_BASE_STRING(@"/appraisalImageText/capi/auth/appraisalReportInfo/checkIsAppraisal");
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
        @"taskId":@(taskId)
    }];
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (![respondObject.data boolValue]) {
            if (completion) {
                completion(NO);
            }
            return;
        }
        if (completion) {
            completion(YES);
        }
    } failureBlock:^(RequestModel *respondObject) {
       if (completion) {
           completion(NO);
       }
    }];
}

+ (void)getImageTextAuthDetailData:(int)recordInfoId Completion:(void(^)(NSError *_Nullable error, JHImageTextWaitAuthDetailModel *_Nullable model))completion{
    
    NSString *url = FILE_BASE_STRING(@"/appraisalImageText/capi/auth/appraisalRecordInfo/get");
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
        @"imageType":@"s,m,b,o",
        @"recordInfoId":@(recordInfoId)
    }];
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHImageTextWaitAuthDetailModel *model = [JHImageTextWaitAuthDetailModel mj_objectWithKeyValues:respondObject.data];
        if (!model) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        if (completion) {
            completion(nil,model);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,nil);
       }
    }];
    
}

+ (void)jumpAuthStep:(int)taskId completion:(void(^)(BOOL isSuccess))completion{
    NSString *url = FILE_BASE_STRING(@"/appraisalImageText/capi/auth/appraisalTask/skip");
    NSDictionary *param = @{
        @"taskId":@(taskId),
    };
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        BOOL isSuccess = respondObject.code == 1000 ? YES : NO;
        if (completion) {
            completion(isSuccess);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (completion) {
            completion(NO);
        }
    }];
    
}

@end
