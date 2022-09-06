//
//  JHStoreListBusiness.m
//  TTjianbao
//
//  Created by zk on 2021/10/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreListBusiness.h"

@implementation JHStoreListBusiness

+ (void)loadData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, NSArray *_Nullable resourceArr, NSString *_Nullable isHaveData))completion{
    NSString *url = FILE_BASE_STRING(@"/mall/search/search");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                NSArray *array = [NSArray modelArrayWithClass:[JHStoreListModel class] json:respondObject.data[@"shopList"]];
                completion(nil,array,respondObject.data[@"isMallProduct"]);
            }
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil,nil);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,nil,nil);
       }
    }];
}

@end
