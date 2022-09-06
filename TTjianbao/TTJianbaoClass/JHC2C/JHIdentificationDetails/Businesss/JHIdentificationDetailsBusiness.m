//
//  JHIdentificationDetailsBusiness.m
//  TTjianbao
//
//  Created by miao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentificationDetailsBusiness.h"

@implementation JHIdentificationDetailsBusiness

+ (void)requestIdentDetailWithParams:(NSDictionary *)params
                          completion:(JHIdentDetailHttpRequestCompleteBlock)completion
                                fail:(JHIdentDetailHttpRequestFailedBlock)fail {
    
    NSString *url = FILE_BASE_STRING(@"/appraisalImageText/capi/auth/appraisalRecordInfo/get");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
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
