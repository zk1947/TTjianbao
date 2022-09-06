//
//  JHRecyclePublishedViewModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePublishedViewModel.h"

@implementation JHRecyclePublishedViewModel

+ (void)getPublishedList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHRecyclePublishedModel *> * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/productInfo/queryLaunchedPage") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *array = [JHRecyclePublishedModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"resultList"]];
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

+ (void)getPriceList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHRecyclePriceModel *> * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/productInfo/queryBid") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *array = [JHRecyclePriceModel mj_objectArrayWithKeyValuesArray:respondObject.data];
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

+ (void)confirmPrice:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/productInfo/confirmBid") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
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

+ (void)deletePublishedRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/productInfo/delete") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
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

+ (void)onOrOffSalePublishedRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/productInfo/offOrBackShelf") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
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
