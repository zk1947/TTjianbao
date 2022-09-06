//
//  JHRecycleOrderPurseViewModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderPurseViewModel.h"

@implementation JHRecycleOrderPurseViewModel


+ (void)getOrderPursueList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHRecycleOrderPursueModel *> * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/capi/recycleOrderToB/auth/recycleOrderLine") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *array = [JHRecycleOrderPursueModel mj_objectArrayWithKeyValuesArray:respondObject.data];
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

+ (void)getRecycleLogisticsList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, JHRecycleLogisticsModel *_Nullable logisticsModel))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/recycle/queryExpressTrack") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHRecycleLogisticsModel *logisticsModel = [JHRecycleLogisticsModel mj_objectWithKeyValues:respondObject.data];
        if (completion) {
            completion(nil,logisticsModel);
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


+ (void)getZhifaLogisticsList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, JHRecycleLogisticsModel *_Nullable logisticsModel))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/express/orderExpressTrack") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHRecycleLogisticsModel *logisticsModel = [JHRecycleLogisticsModel mj_objectWithKeyValues:respondObject.data];
        if (completion) {
            completion(nil,logisticsModel);
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
