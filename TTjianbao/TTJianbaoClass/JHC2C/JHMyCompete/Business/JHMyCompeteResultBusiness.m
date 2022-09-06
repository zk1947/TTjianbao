//
//  JHMyCompeteResultBusiness.m
//  TTjianbao
//
//  Created by miao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCompeteResultBusiness.h"

@implementation JHMyCompeteResultBusiness

+ (void)requestMyCompeteWithParams:(NSDictionary *)params
                        completion:(JHMyCompeteHttpRequestCompleteBlock)completion
                              fail:(JHMyCompeteHttpRequestFailedBlock)fail {
    
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/myAuction");
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
