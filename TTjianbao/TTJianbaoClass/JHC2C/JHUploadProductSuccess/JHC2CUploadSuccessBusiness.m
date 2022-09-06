//
//  JHC2CUploadSuccessBusiness.m
//  TTjianbao
//
//  Created by jiangchao on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CUploadSuccessBusiness.h"

@implementation JHC2CUploadSuccessBusiness
+ (void)getProdutListRecommend:(NSDictionary *)params completion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/listRecommendC2c") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
                    if (completion) {
                        completion(respondObject,error);
                    }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
}

+ (void)getC2CGuessLike:(NSDictionary *)params completion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/c2cGuessLike") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
                    if (completion) {
                        completion(respondObject,error);
                    }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
}

@end
