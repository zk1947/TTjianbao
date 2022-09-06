//
//  JHRecycleHomeGoodsBusiness.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeGoodsBusiness.h"

@implementation JHRecycleHomeGoodsBusiness
+ (void)requestRecycleHomeGoodsListWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/opt/shopList") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                completion(respondObject, nil);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(nil, error);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(nil, error);
        }
    }];
}
+ (void)requestRecycleHomeGoodsCateWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/opt/getAggProductCate") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                completion(respondObject, nil);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(nil, error);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(nil, error);
        }
    }];
}
@end
