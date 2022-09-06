//
//  JHRecycleGoodDetailInfoBusiness.m
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodDetailInfoBusiness.h"
#import "JHRecycleGoodsInfoModel.h"
#import "JHRecycleGoodsInfoViewModel.h"

@implementation JHRecycleGoodDetailInfoBusiness
/// 获取回收商品详情信息
+ (void)getRecycleGoodsDetailInfoRequest:(NSString *)productId
                              Completion:(void(^)(NSError *_Nullable error, JHRecycleGoodsInfoViewModel *_Nullable viewModel))completion {
    NSString *url = FILE_BASE_STRING(@"/recycle/capi/auth/productInfo/detail");
    NSDictionary *params = @{
        @"productId":productId,
        @"imageType":@"s,m,b,o"
    };
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHRecycleGoodsInfoModel *model = [JHRecycleGoodsInfoModel mj_objectWithKeyValues:respondObject.data];
        if (!respondObject.data || !model) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        JHRecycleGoodsInfoViewModel *viewModel = [JHRecycleGoodsInfoViewModel viewModel:model];
        if (completion) {
            completion(nil,viewModel);
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
