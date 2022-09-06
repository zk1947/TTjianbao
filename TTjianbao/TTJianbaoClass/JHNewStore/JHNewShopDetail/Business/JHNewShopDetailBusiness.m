//
//  JHNewShopDetailBusiness.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//


#import "JHNewShopDetailBusiness.h"

@interface JHNewShopDetailBusiness ()
@end

@implementation JHNewShopDetailBusiness

+ (void)requestWithURL:(NSString *)url params:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(url) Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                completion(respondObject, nil);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(nil, error);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(nil, error);
        }
    }];
}

///获取店铺头部信息
+ (void)requestShopDetailInfoWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [self requestWithURL:@"/api/mall/shop/detail" params:params Completion:^(RequestModel *respondObject, NSError * _Nullable error) {
        if (respondObject) {
            completion(respondObject, nil);
        } else {
            completion(nil, error);
        }
    }];
}

///关注/取关 店铺
+ (void)requestShopFollowWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [self requestWithURL:@"/auth/mall/shop/follow" params:params Completion:^(RequestModel *respondObject, NSError * _Nullable error) {
        if (respondObject) {
            completion(respondObject, nil);
        } else {
            completion(nil, error);
        }
    }];
}

///领取优惠券
+ (void)requestShopGetCouponsWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [self requestWithURL:@"/auth/mall/coupon/receiveCouponById" params:params Completion:^(RequestModel *respondObject, NSError * _Nullable error) {
        if (respondObject) {
            completion(respondObject, nil);
        } else {
            completion(nil, error);
        }
    }];

}

///店铺评价
+ (void)requestShopUserCommentWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [self requestWithURL:@"/api/mall/order/list" params:params Completion:^(RequestModel *respondObject, NSError * _Nullable error) {
        if (respondObject) {
            completion(respondObject, nil);
        } else {
            completion(nil, error);
        }
    }];
}

///店铺商品列表
+ (void)requestShopProductListWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion{
    [self requestWithURL:@"/api/mall/shop/listProduct" params:params Completion:^(RequestModel *respondObject, NSError * _Nullable error) {
        if (respondObject) {
            completion(respondObject, nil);
        } else {
            completion(nil, error);
        }
            
    }];
}

@end
