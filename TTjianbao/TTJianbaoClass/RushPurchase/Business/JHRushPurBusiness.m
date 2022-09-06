//
//  JHRushPurBusiness.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRushPurBusiness.h"

@implementation JHRushPurBusiness


+ (void)requestRushPur:(NSDictionary *)par completion:(void (^)(NSError * _Nullable error, JHRushPurChaseModel * _Nullable model))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/seckill/getSeckillMainPage") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHRushPurChaseModel *model = [JHRushPurChaseModel  mj_objectWithKeyValues:respondObject.data];
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

+ (void)requestSalesReminder:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/seckill/salesReminder") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            completion(nil);
        }else{
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error);
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

@end
