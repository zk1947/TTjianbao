//
//  JHGraphicaldentificationBusiness.m
//  TTjianbao
//
//  Created by miao on 2021/7/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGraphicaldentificationBusiness.h"

@implementation JHGraphicaldentificationBusiness

+ (void)requestDeleteGraphicalWithParams:(NSDictionary *)params
                        completion:(JHGraphicalHttpRequestCompleteBlock)completion
                                    fail:(JHGraphicalHttpRequestFailedBlock)fail {
    
    NSString *url = FILE_BASE_STRING(@"/order/appraisalOrder/auth/delete");
    [HttpRequestTool postWithURL:url
                      Parameters:params
           requestSerializerType:RequestSerializerTypeJson
                    successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                completion(respondObject);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (fail) {
                fail(error);
            }
        }
       
        
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (fail) {
            fail(error);
        }
    }];
    
}

+ (void)requestCancelIdentificationWithParams:(NSDictionary *)params
                                   completion:(JHGraphicalHttpRequestCompleteBlock)completion
                                         fail:(JHGraphicalHttpRequestFailedBlock)fail {
    NSString *url = FILE_BASE_STRING(@"/order/appraisalOrder/auth/cancel");
    [HttpRequestTool postWithURL:url
                      Parameters:params
           requestSerializerType:RequestSerializerTypeJson
                    successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                completion(respondObject);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (fail) {
                fail(error);
            }
        }
       
        
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (fail) {
            fail(error);
        }
    }];
}

+ (void)requestGraphicOrderDetailWithParams:(NSDictionary *)params
                                 completion:(JHGraphicalHttpRequestCompleteBlock)completion
                                       fail:(JHGraphicalHttpRequestFailedBlock)fail {
    
    NSString *url = FILE_BASE_STRING(@"/order/appraisalOrder/auth/detail");
    [HttpRequestTool postWithURL:url
                      Parameters:params
           requestSerializerType:RequestSerializerTypeJson
                    successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                completion(respondObject);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (fail) {
                fail(error);
            }
        }
       
        
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (fail) {
            fail(error);
        }
    }];
}

@end
