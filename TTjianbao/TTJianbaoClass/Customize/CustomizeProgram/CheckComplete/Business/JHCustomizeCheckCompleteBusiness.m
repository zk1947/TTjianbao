//
//  JHCustomizeCheckCompleteBusiness.m
//  TTjianbao
//
//  Created by user on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckCompleteBusiness.h"

@implementation JHCustomizeCheckCompleteBusiness
+ (void)getCustomizeCheckComplete:(NSString *)customizeOrderId
                       Completion:(void (^)(NSError * _Nonnull, JHCustomizeCheckCompleteModel * _Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/app/appraisal/customizeWorks/findFinishWorks");
    NSDictionary *params = @{
        @"customizeOrderId":NONNULL_STR(customizeOrderId)
    };
    [HttpRequestTool getWithURL:url Parameters:params successBlock:^(RequestModel *respondObject) {
        if (!respondObject.data) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
        }
        JHCustomizeCheckCompleteModel *mode = [JHCustomizeCheckCompleteModel mj_objectWithKeyValues:respondObject.data];
        NSError *error = nil;
        if (completion) {
            completion(error,mode);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,nil);
       }
    }];
}


@end
