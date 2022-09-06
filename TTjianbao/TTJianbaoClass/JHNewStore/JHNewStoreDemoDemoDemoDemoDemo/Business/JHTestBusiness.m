//
//  JHTestBusiness.m
//  TTjianbao
//
//  Created by user on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTestBusiness.h"
#import "JHTestModel.h"

@implementation JHTestBusiness

/// 物流信息
+ (void)requestCustomizeLogistics:(NSString *)orderId
                         userType:(NSString *)userType
                       Completion:(void(^)(NSError *_Nullable error, NSArray<JHTestTableViewCellViewModel *>* _Nullable models))completion {
    NSDictionary *dict = @{
        @"orderId":NONNULL_STR(orderId),
        @"userType":NONNULL_STR(userType)
    };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderCustomize/auth/queryOrderExpress") Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHCustomizeLogisticsModelTestModel *mode = [JHCustomizeLogisticsModelTestModel mj_objectWithKeyValues:respondObject.data];
        if (mode) {
            NSArray<JHTestTableViewCellViewModel *> *array = [JHTestTableViewCellViewModel setViewModelImpl:mode];
            if (completion) {
                completion(nil, array);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error, nil);
            }
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
