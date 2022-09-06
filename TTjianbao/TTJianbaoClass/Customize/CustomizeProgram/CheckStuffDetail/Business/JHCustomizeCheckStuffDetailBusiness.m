//
//  JHCustomizeCheckStuffDetailBusiness.m
//  TTjianbao
//
//  Created by user on 2020/12/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckStuffDetailBusiness.h"

@implementation JHCustomizeCheckStuffDetailBusiness

+ (void)getCustomizeCheckStuffDetail:(NSString *)customizeOrderId
                          Completion:(void (^)(NSError * _Nullable, JHCustomizeCheckStuffDetailModel * _Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/app/appraisal/customizeMaterial/findMaterialInfo");
    NSDictionary *dict = @{
        @"customizeOrderId":NONNULL_STR(customizeOrderId)
    };
    [HttpRequestTool getWithURL:url Parameters:dict successBlock:^(RequestModel *respondObject) {
        if (!respondObject.data) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        JHCustomizeCheckStuffDetailModel *model = [JHCustomizeCheckStuffDetailModel mj_objectWithKeyValues:respondObject.data];
        if (completion) {
            completion(nil,model);
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
