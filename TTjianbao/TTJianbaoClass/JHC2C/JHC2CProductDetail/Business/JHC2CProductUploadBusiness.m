//
//  JHC2CProductUploadBusiness.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductUploadBusiness.h"


@implementation JHC2CProductUploadBusiness

+ (void)requestC2CUploadProductDetailBackCateId:(NSString*)backCateId completion:(void(^)(NSError *_Nullable error, JHC2CUploadProductDetailModel *_Nullable model))completion{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"backCateId"] = backCateId;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/productPubDataBuild") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHC2CUploadProductDetailModel *model = [JHC2CUploadProductDetailModel  mj_objectWithKeyValues:respondObject.data];
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

+ (void)requestC2CUploadProductWithModel:(JHC2CUploadProductModel *)moodel completion:(void (^)(NSError * _Nullable,JHC2CPublishSuccessBackModel *_Nullable model))completion{
    NSDictionary *par = [moodel changePar];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/publish") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
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

@end
