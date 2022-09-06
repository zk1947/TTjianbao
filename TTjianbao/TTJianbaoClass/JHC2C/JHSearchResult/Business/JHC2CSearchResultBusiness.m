//
//  JHC2CSearchResultBusiness.m
//  TTjianbao
//
//  Created by hao on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSearchResultBusiness.h"
#import "JHNewStoreTypeModel.h"

@implementation JHC2CSearchResultBusiness
+ (void)requestSearchResultWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/search/getProductList") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
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


+ (void)requestSearchCateListWithParams:(NSDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreTypeTableCellViewModel*> * _Nullable))completion{
    NSString *urlString = @"/api/mall/search/getSearchCateList";
    if ([params[@"businessLineType"] isEqualToString:@"MALL"]) {
        urlString = @"/api/mall/search/getSearchB2cCateList";
    }
    [HttpRequestTool postWithURL:FILE_BASE_STRING(urlString) Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSMutableArray<JHNewStoreTypeModel* > *modeArr = [JHNewStoreTypeModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (modeArr) {
            NSMutableArray *viewModelArr = [NSMutableArray arrayWithCapacity:0];
            [modeArr enumerateObjectsUsingBlock:^(JHNewStoreTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [viewModelArr addObject:[JHNewStoreTypeTableCellViewModel viewModelWithNewStoryTypeModel:obj]];
            }];
            if (completion) {
                completion(nil, viewModelArr);
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

+ (void)requestSearchChildrenCateListWithParams:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreTypeTableCellViewModel*> * _Nullable))completion{
    NSString *urlStr = @"/api/mall/frontCateC2c/listWithTreeById";
    if ([params[@"fromStatus"] isEqualToString:@"B2C"]) {
        urlStr = @"/api/mall/frontCate/listByFrontCateId";
    }
    [params removeObjectForKey:@"fromStatus"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(urlStr) Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSMutableArray<JHNewStoreTypeModel* > *modeArr = [JHNewStoreTypeModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (modeArr) {
            NSMutableArray *viewModelArr = [NSMutableArray arrayWithCapacity:0];
            [modeArr enumerateObjectsUsingBlock:^(JHNewStoreTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [viewModelArr addObject:[JHNewStoreTypeTableCellViewModel viewModelWithNewStoryTypeModel:obj]];
            }];
            if (completion) {
                completion(nil, viewModelArr);
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

@end
