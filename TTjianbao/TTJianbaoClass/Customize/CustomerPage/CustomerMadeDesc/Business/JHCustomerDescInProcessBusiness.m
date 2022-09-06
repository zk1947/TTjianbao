//
//  JHCustomerDescInProcessBusiness.m
//  TTjianbao
//
//  Created by user on 2020/12/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerDescInProcessBusiness.h"

@implementation JHCustomerDescInProcessBusiness

+ (void)customizeSendLikeRequest:(NSString *)customizeOrderId
                      Completion:(void(^)(NSError *_Nullable error))completion {
    NSString *url = FILE_BASE_STRING(@"/appraisal/customize-order-like/like");
    long cusId = [customizeOrderId longLongValue];
    NSDictionary *dict = @{
        @"customizeOrderId":@(cusId)
    };
    [HttpRequestTool getWithURL:url Parameters:dict successBlock:^(RequestModel * _Nullable respondObject) {
        if (completion) {
            completion(nil);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
           completion(error);
        }
    }];
}

+ (void)customizeCancleLikeRequest:(NSString *)customizeOrderId
                        Completion:(void(^)(NSError *_Nullable error))completion {
    NSString *url = FILE_BASE_STRING(@"/appraisal/customize-order-like/cancel");
    long cusId = [customizeOrderId longLongValue];
    NSDictionary *dict = @{
        @"customizeOrderId":@(cusId)
    };
    [HttpRequestTool getWithURL:url Parameters:dict successBlock:^(RequestModel * _Nullable respondObject) {
        if (completion) {
            completion(nil);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
           completion(error);
        }
    }];
}


+ (void)addCommentRequest:(JHCustomizeCommentRequestModel *)model
               Completion:(nonnull void (^)(NSError * _Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/app/appraisal/customizeCommentItem/addCommentItem");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (completion) {
            completion(nil);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error);
        }
    }];
}

+ (void)hiddenRequest:(NSInteger)workId
             hideFlag:(NSString *)hideFlag
           Completion:(nonnull void (^)(NSError * _Nullable, RequestModel * _Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/app/appraisal/customizeComment/hide");
    NSDictionary *params = @{
        @"workId":@(workId),
        @"hideFlag":hideFlag
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


@end
