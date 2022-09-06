//
//  JHRecycleUploadProductBusiness.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleUploadProductBusiness.h"

//#define RecycleTEST   0

@implementation JHRecycleUploadProductBusiness

+ (void)requestRecycleProductSeleteTypeCompletion:(void (^)(NSError * _Nullable, JHRecycleUploadSeleteTypeModel * _Nullable))completion{
#ifdef RecycleTEST
    JHRecycleUploadSeleteTypeModel *model = [JHRecycleUploadSeleteTypeModel  mj_objectWithKeyValues:[self getSeleTestDic]];
    completion(nil, model);
#else
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"imageType"] = @"s,m,b,o";
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/selectPage") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHRecycleUploadSeleteTypeModel *model = [JHRecycleUploadSeleteTypeModel  mj_objectWithKeyValues:respondObject.data];
        if (model) {
            if (completion) {
                completion(nil, model);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error, nil);
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];
#endif
}

+ (void)requestRecycleProductPublishProductCategoryId:(NSInteger)categoryId
                                       andProductDesc:(NSString*)productDesc
                                       andBusinessId:(NSString*)businessId
                                       andexpectPrice:(NSString*)expectPrice
                                    andProductImgUrls:(NSArray*)productImgUrls
                                 andProductDetailUrls:(NSArray*)productDetailUrls
                                        andCompletion:(void(^)(NSError *_Nullable error))completion{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"categoryId"] = [NSNumber numberWithInteger:categoryId];
    par[@"productDesc"] = productDesc;
    par[@"productImgUrls"] = productImgUrls;
    par[@"productDetailUrls"] = productDetailUrls;
    if (businessId.length) {
        par[@"businessId"] = businessId;
    }
    if (expectPrice.length) {
        par[@"exceptPrice"] = expectPrice;
    }
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/launch") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error);
            }
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


+ (void)requestRecycleArbitrationUploadOrderId:(NSInteger)orderId
                                       andDesc:(NSString *)desc
                                    andImgUrls:(NSArray *)imageUrlsArr
                                 andCompletion:(void (^)(NSError * _Nullable))completion{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"orderId"] = [NSNumber numberWithInteger:orderId];
    par[@"imgUrls"] = imageUrlsArr;
    par[@"description"] = desc;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/mineSale/appeal/summit") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error);
            }
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


+ (void)requestRecycleSquareHomeListWithParams:(NSDictionary *_Nullable)params
                                Completion:(void (^)(NSError * _Nullable, JHRecycleSquareHomeModel * _Nullable))completion{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/recycleSquare/listRecycleProductPage") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHRecycleSquareHomeModel *model = [JHRecycleSquareHomeModel  mj_objectWithKeyValues:respondObject.data];
        if (model) {
            if (completion) {
                completion(nil, model);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error, nil);
            }
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


+ (void)requestRecycleMeAttentionListPageNo:(NSInteger)pageNo
                                andPageSize:(NSInteger)pageSize
                                 Completion:(void (^)(NSError * _Nullable, JHRecycleMeAttentionModel * _Nullable))completion{
    
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"pageNo"] = [NSNumber numberWithInteger:pageNo];
    par[@"pageSize"] = [NSNumber numberWithInteger:pageSize];;
    par[@"imageType"] = @"s,m,b,o";

    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/recycleSquare/listProcutCollection") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHRecycleMeAttentionModel *model = [JHRecycleMeAttentionModel  mj_objectWithKeyValues:respondObject.data];
        if (model) {
            if (completion) {
                completion(nil, model);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error, nil);
            }
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

+ (void)requestRecycleMeAttentionRemoveProductIDs:(NSArray *)productIDArr
                                       Completion:(void (^)(NSError * _Nullable))completion{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/recycleSquare/cancelCollectionProduct") Parameters:@{@"productIds":productIDArr} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error);
            }
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

+ (void)requestRecycleUploadQueryExampleCategoryId:(NSInteger)categoryID
                                        Completion:(void (^)(NSError * _Nullable, JHRecycleUploadExampleTotalModel * _Nullable))completion{
    
#ifdef RecycleTEST

    JHRecycleUploadExampleTotalModel *model = [JHRecycleUploadExampleTotalModel  mj_objectWithKeyValues: [self getExampelArr]];
    completion(nil, model);
#else

    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"categoryId"] = [NSNumber numberWithInteger:categoryID];
    par[@"imageType"] = @"s,m,b,o";

    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/queryExample") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {

        JHRecycleUploadExampleTotalModel *model = [JHRecycleUploadExampleTotalModel  mj_objectWithKeyValues:respondObject.data];
        if (model) {
            if (completion) {
                completion(nil, model);
            }
        }else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error, nil);
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];
#endif
}


/// 回收广场分类筛选
+ (void)requestRecycleSquareSelectListWithParams:(NSDictionary *_Nullable)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/recycleSquare/listRecycleDict") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
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



#pragma mark -- <Test Data>


+ (NSDictionary*)getExampelArr{
//    1正面，2 背面 3 侧面 4 穿孔
    return @{@"singleImgSimples" :
                   @[
                     @{@"baseImage": @{@"origin": @"recycle_uploadproduct_guqianbi"},
                       @"categoryId": @1,
                       @"exampleDesc": @"正面",
                       @"exampleId": @1,
                       @"imgType": @1
                     },
                     @{@"baseImage": @{@"origin": @"recycle_uploadproduct_yinyuan"},
                         @"categoryId": @2,
                         @"exampleDesc": @"背面",
                         @"exampleId": @2,
                         @"imgType": @2
                     },
                     @{@"baseImage": @{@"origin": @"recycle_uploadproduct_yinyuan"},
                         @"categoryId": @2,
                         @"exampleDesc": @"背面",
                         @"exampleId": @2,
                         @"imgType": @2
                     },
                     @{@"baseImage": @{@"origin": @"recycle_uploadproduct_zhibi"},
                       @"categoryId": @3,
                       @"exampleDesc": @"侧面",
                       @"exampleId": @3,
                       @"imgType": @3
                     },
                   ],
             @"multiImgSimples":
                 @[@{@"baseImage": @{@"origin": @"recycle_uploadproduct_guqianbi"},
                    @"categoryId": @1,
                    @"exampleDesc": @"正面",
                    @"exampleId": @1,
                    @"imgType": @1
                },
                 @{@"baseImage": @{@"origin": @"recycle_uploadproduct_yinyuan"},
                             @"categoryId": @2,
                             @"exampleDesc": @"背面",
                             @"exampleId": @2,
                             @"imgType": @2
                         },
                 @{@"baseImage": @{@"origin": @"recycle_uploadproduct_zhibi"},
                             @"categoryId": @3,
                             @"exampleDesc": @"侧面",
                             @"exampleId": @3,
                             @"imgType": @3
                 },
                 ]
    };
}


+ (NSDictionary*)getSeleTestDic{
    
    return @{
            @"bannerImgUrls": @[
                    @{
                    @"detailsId": @0,
                    @"imageUrl": @"",
                    @"landingId": @"",
                    @"landingTarget": @"",
                    @"targetName": @""
                    },
                    @{
                    @"detailsId": @0,
                    @"imageUrl": @"",
                    @"landingId": @"",
                    @"landingTarget": @"",
                    @"targetName": @""
                    },
                    @{
                    @"detailsId": @0,
                    @"imageUrl": @"",
                    @"landingId": @"",
                    @"landingTarget": @"",
                    @"targetName": @""
                    },
                    @{
                    @"detailsId": @0,
                    @"imageUrl": @"",
                    @"landingId": @"",
                    @"landingTarget": @"",
                    @"targetName": @""
                    }
            ],
            @"categoryVOs": @[
                    @{
                        @"categoryId": @"1",
                        @"categoryImgUrl": @{@"origin": @"recycle_uploadproduct_guqianbi"},
                        @"categoryName": @"古钱币"
                    },
                    @{
                        @"categoryId": @"2",
                        @"categoryImgUrl": @{@"origin": @"recycle_uploadproduct_yinyuan"},
                        @"categoryName": @"银元"
                    },
                    @{
                        @"categoryId": @"3",
                        @"categoryImgUrl": @{@"origin": @"recycle_uploadproduct_zhibi"},
                        @"categoryName": @"纸币"
                    },
                    @{
                        @"categoryId": @"4",
                        @"categoryImgUrl": @{@"origin": @"recycle_uploadproduct_tongyuan"},
                        @"categoryName": @"铜元"
                    }
            ]
    };
}


@end
