//
//  JHRecyclePriceHistoryViewModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePriceHistoryViewModel.h"

@implementation JHRecyclePriceHistoryViewModel


+ (void)getPriceHistoryList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHRecyclePriceHistoryModel *> * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/capi/auth/recycleSquare/listProductBidPage") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *array = [JHRecyclePriceHistoryModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"resultList"]];
        if (completion) {
            completion(nil,array);
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
@end
