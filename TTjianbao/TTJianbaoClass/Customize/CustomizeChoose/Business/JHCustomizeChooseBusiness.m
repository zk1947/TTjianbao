//
//  JHCustomizeChooseBusiness.m
//  TTjianbao
//
//  Created by user on 2020/12/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeChooseBusiness.h"

@implementation JHCustomizeChooseBusiness

+ (void)getChooseCustomizeListCompletion:(void (^)(NSError * _Nullable, JHCustomizeChooseListModel * _Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/anon/customize/fee/works-template-list?filterFeeFlag=1");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        JHCustomizeChooseListModel *model = [JHCustomizeChooseListModel mj_objectWithKeyValues:respondObject.data];
        if (!model || model.templates.count == 0) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        if (completion) {
            completion(nil,model);
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




/// 定制师列表
+ (void)getChooseCustomize:(JHCustomizeChooseRequestModel *)model
                Completion:(nonnull void (^)(NSError * _Nullable, NSArray<JHCustomizeChooseModel *> * _Nullable))completion{
    NSString *url = FILE_BASE_STRING(@"/anon/customize/fee/list-customer-for-select");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSArray *array = [NSArray cast:respondObject.data];
        if (!array || array.count == 0) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
        }
        NSArray *arr = [array jh_map:^id _Nonnull(id  _Nonnull obj, NSUInteger idx) {
            JHCustomizeChooseModel *model = [JHCustomizeChooseModel mj_objectWithKeyValues:obj];
            return model;
        }];
        if (completion) {
            completion(nil,arr);
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
