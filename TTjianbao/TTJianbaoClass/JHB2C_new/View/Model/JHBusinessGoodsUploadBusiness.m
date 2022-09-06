//
//  JHBusinessGoodsUploadBusiness.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessGoodsUploadBusiness.h"

@implementation JHBusinessGoodsUploadBusiness
+ (void)requestB2CUploadProductWithModel:(JHBusinesspublishModel *)model completion:(void (^)(NSError * _Nullable,JHC2CPublishSuccessBackModel *_Nullable model))completion{
    NSDictionary *par = [model mj_keyValues];
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/publishMallProduct") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHC2CPublishSuccessBackModel *backModel = [JHC2CPublishSuccessBackModel  mj_objectWithKeyValues:respondObject.data];
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, backModel);
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
            completion(error, nil);
        }
    }];

    
}

+ (void)requestB2CEditProductWithModel:(JHBusinesspublishModel *)model completion:(void (^)(NSError * _Nullable,JHC2CPublishSuccessBackModel *_Nullable model))completion{
    NSDictionary *par = [model mj_keyValues];
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/editB2cProduct") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHC2CPublishSuccessBackModel *backModel = [JHC2CPublishSuccessBackModel  mj_objectWithKeyValues:respondObject.data];
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, backModel);
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
            completion(error, nil);
        }
    }];

    
}

+ (void)requestB2CBackProductWithModel:(NSString *)productId Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/getB2cProductEditDetail") Parameters:@{@"productId":productId,@"imageType":@"m"} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
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
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(nil, error);
        }
    }];
}
@end
