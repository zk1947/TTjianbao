//
//  JHStoreRankListViewModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreRankListViewModel.h"

@implementation JHStoreRankListViewModel

+ (void)getRankTagList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, JHStoreRankTagModel * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/top/info") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHStoreRankTagModel *tagModel = [JHStoreRankTagModel mj_objectWithKeyValues:respondObject.data];
        if (completion) {
            completion(nil,tagModel);
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

+ (void)getRankStoreList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHStoreRankListModel *> * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/top/listShop") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *array = [JHStoreRankListModel mj_objectArrayWithKeyValuesArray:respondObject.data];
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

+ (void)followStoreRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/mall/shop/follow") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
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
