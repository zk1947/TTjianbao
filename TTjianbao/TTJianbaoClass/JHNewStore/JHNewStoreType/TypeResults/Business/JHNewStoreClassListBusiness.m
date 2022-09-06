//
//  JHNewStoreClassListBusiness.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreClassListBusiness.h"

@implementation JHNewStoreClassListBusiness
///商品分类/搜索（408版本以前）
+ (void)requestProductClassResultWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    NSString *urlString = @"/api/mall/product/listCate";
    if ([params[@"type"] length] > 0) {
        urlString = @"/api/mall/search/listProduct";
    }
    [HttpRequestTool postWithURL:FILE_BASE_STRING(urlString) Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
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

///查询分类列表
+ (void)requestClassListWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/listCate") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
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
