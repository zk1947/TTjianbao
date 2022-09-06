//
//  JHCustomizeCheckProgramBusiess.m
//  TTjianbao
//
//  Created by user on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckProgramBusiess.h"

@implementation JHCustomizeCheckProgramBusiess

+ (void)getCustomizeCheckProgram:(NSString *)customizePlanId Completion:(void (^)(NSError * _Nonnull, JHCustomizeCheckProgramModel *_Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/orderCustomizePlan/auth/queryCustomizePlan");
    NSDictionary *dict = @{
        @"customizePlanId":NONNULL_STR(customizePlanId)
    };
    [HttpRequestTool getWithURL:url Parameters:dict successBlock:^(RequestModel * _Nullable respondObject) {
        if (!respondObject.data) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
        }
        JHCustomizeCheckProgramModel *mode = [JHCustomizeCheckProgramModel mj_objectWithKeyValues:respondObject.data];
        NSError *error = nil;
        if (completion) {
            completion(error,mode);
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

/// 提交定制方案
+ (void)uploadCustomizeCheckProgram:(NSString *)customizeOrderId
                         Completion:(void (^)(NSError * _Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/orderCustomizePlan/auth/commitCustomizePlan");
    NSDictionary *dict = @{
        @"customizeOrderId":NONNULL_STR(customizeOrderId)
    };
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        if (completion) {
            completion(nil);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error);
       }
    }];
}


/// 删除定制方案
+ (void)deleteCustomizeCheckProgram:(NSString *)customizePlanId
                   customizeOrderId:(NSString *)customizeOrderId
                         Completion:(void (^)(NSError * _Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/orderCustomizePlan/auth/delCustomizePlan");
    NSDictionary *dict = @{
        @"customizePlanId":NONNULL_STR(customizePlanId),
        @"customizeOrderId":NONNULL_STR(customizeOrderId)
    };
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        if (completion) {
            completion(nil);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error);
       }
    }];
}

@end
