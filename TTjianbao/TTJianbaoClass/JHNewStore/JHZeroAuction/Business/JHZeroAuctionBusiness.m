//
//  JHZeroAuctionBusiness.m
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHZeroAuctionBusiness.h"

@implementation JHZeroAuctionBusiness

+ (void)loadStealTowerListData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, JHZeroAuctionModel *model))completion{
    NSString *url = FILE_BASE_STRING(@"/mall/search/zeroAuction/page/query");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHZeroAuctionModel *model = [JHZeroAuctionModel mj_objectWithKeyValues:respondObject.data];
        if (!model) {
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
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,nil);
       }
    }];
}

+ (void)loadCellData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, JHNewStoreHomeGoodsProductListModel *model))completion{
    NSString *url = FILE_BASE_STRING(@"/mall/search/zeroAuction/single/query");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHNewStoreHomeGoodsProductListModel *model = [JHNewStoreHomeGoodsProductListModel mj_objectWithKeyValues:respondObject.data];
        if (!model) {
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
