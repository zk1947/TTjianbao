//
//  JHC2CClassBusiness.m
//  TTjianbao
//
//  Created by hao on 2021/6/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CClassBusiness.h"
#import "JHNewStoreTypeModel.h"

@implementation JHC2CClassBusiness

+ (void)requestClassListCompletion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreTypeTableCellViewModel*> * _Nullable))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/frontCateC2c/list") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
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
/// 选择分类别表  /api/mall/backCate/list
+ (void)requestSelectClassListWithParams:(NSDictionary *)params Completion:(void(^)(NSError *_Nullable error, NSArray<JHNewStoreTypeTableCellViewModel*> *_Nullable models))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/backCate/listTreeNoSecLevel") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
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
