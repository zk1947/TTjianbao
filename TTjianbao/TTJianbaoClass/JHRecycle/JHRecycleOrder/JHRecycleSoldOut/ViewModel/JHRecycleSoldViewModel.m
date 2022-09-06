//
//  JHRecycleSoldViewModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleSoldViewModel.h"

@implementation JHRecycleSoldViewModel

+ (void)getSoldList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHRecycleSoldModel *> * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/capi/recycleOrderToC/auth/listByCustomer") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *array = [JHRecycleSoldModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"resultList"]];
        if (completion) {
            completion(nil,array);
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

+ (void)getGoldUrlString:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSString * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/capi/recycleOrderToC/auth/cjtOrderList") Parameters:params requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel * _Nullable respondObject) {
        if (completion) {
            completion(nil,respondObject.data);
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
