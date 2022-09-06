//
//  JHNewStoreTypeBusiness.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreTypeBusiness.h"
#import "JHNewStoreTypeModel.h"

@implementation JHNewStoreTypeBusiness

+ (void)requestNewStoreTypeCompletion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreTypeTableCellViewModel*> * _Nullable))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/frontCate/list") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSMutableArray<JHNewStoreTypeModel* > *modeArr = [JHNewStoreTypeModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (modeArr) {
            NSMutableArray *viewModelArr = [NSMutableArray arrayWithCapacity:0];
            [modeArr enumerateObjectsUsingBlock:^(JHNewStoreTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                JHNewStoreTypeTableCellViewModel *model = [JHNewStoreTypeTableCellViewModel viewModelWithNewStoryTypeModel:obj];
                [viewModelArr addObject:model];
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

+ (void)loadClassPageListData:(void(^)(NSError * _Nullable error,JHNewStoreTypePageViewModel *model))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/mall/search/category/searchCategoryPage") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHNewStoreTypePageViewModel *resultModel = [JHNewStoreTypePageViewModel mj_objectWithKeyValues:respondObject.data];
        if (resultModel) {
            if (completion) {
                completion(nil,resultModel);
            }
        }else{
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
