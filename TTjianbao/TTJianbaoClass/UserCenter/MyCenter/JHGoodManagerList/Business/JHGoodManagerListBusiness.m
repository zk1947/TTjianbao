//
//  JHGoodManagerListBusiness.m
//  TTjianbao
//
//  Created by user on 2021/8/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListBusiness.h"

@implementation JHGoodManagerListBusiness
/// 总接口
+ (void)getGoodManagerList:(JHGoodManagerListRequestModel *)model
                Completion:(void(^)(NSError *_Nullable error, JHGoodManagerListAllDataModel *_Nullable dataModel))completion {
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/listAndStatisticsMerchantProduct");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHGoodManagerListAllDataModel *model = [JHGoodManagerListAllDataModel mj_objectWithKeyValues:respondObject.data];
        if (completion) {
            completion(nil, model);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error, nil);
       }
    }];
}

/// tab 单独接口
+ (void)getGoodManagerListTabOnly:(JHGoodManagerListRequestModel *)model
                       Completion:(void(^)(NSError *_Nullable error, NSArray<JHGoodManagerListTabChooseModel *> *_Nullable array))completion {
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/statisticsMerchantProduct");
    model.productStatus = nil;
    model.lastId = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSArray *array = [NSArray cast:respondObject.data];
        if (!array || array.count == 0) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
        }
        NSArray *arr = [array jh_map:^id _Nonnull(id  _Nonnull obj, NSUInteger idx) {
            JHGoodManagerListTabChooseModel *model = [JHGoodManagerListTabChooseModel mj_objectWithKeyValues:obj];
            return model;
        }];
        if (completion) {
            completion(nil,arr);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error, nil);
       }
    }];
}



/// 商品列表
+ (void)getGoodManagerListGoodOnly:(JHGoodManagerListRequestModel *)model
                        Completion:(void(^)(NSError *_Nullable error, NSArray<JHGoodManagerListModel *> *_Nullable array))completion {
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/listMerchantProduct");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSArray *array = [NSArray cast:respondObject.data];
        if (!array || array.count == 0) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
        }
        NSArray *arr = [array jh_map:^id _Nonnull(id  _Nonnull obj, NSUInteger idx) {
            JHGoodManagerListModel *model = [JHGoodManagerListModel mj_objectWithKeyValues:obj];
            return model;
        }];
        if (completion) {
            completion(nil,arr);
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

/// 更新单条商品数据
+ (void)updateOnlyGoodManagerListItem:(NSString *)productId
                          productType:(NSInteger)productType
                            imageType:(NSString *)imageType
                           Completion:(void(^)(NSError *_Nullable error, JHGoodManagerListModel *_Nullable itemModel))completion {
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/getMerchantProductDetailByProductId");
    NSDictionary *params = @{
        @"productId":NONNULL_STR(productId),
        @"productType":@(productType),
        @"imageType":NONNULL_STR(imageType)
    };
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHGoodManagerListModel *model = [JHGoodManagerListModel mj_objectWithKeyValues:respondObject.data];
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


/// 上架
+ (void)putOnGood:(JHGoodManagerListItemPutOnRequestModel *)model
       Completion:(void(^)(NSError *_Nullable error))completion {
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/putOnShelfProduct");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
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


/// 下架
+ (void)goodOffTheShelf:(NSString *)productId
             Completion:(void(^)(NSError *_Nullable error))completion {
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/offShelfProduct");
    NSDictionary *dict = @{
        @"productId":NONNULL_STR(productId)
    };
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
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


/// 删除
+ (void)deleteGood:(NSString *)productId
        Completion:(void(^)(NSError *_Nullable error))completion {
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/deleteProduct");
    NSDictionary *dict = @{
        @"productId":NONNULL_STR(productId)
    };
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
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
