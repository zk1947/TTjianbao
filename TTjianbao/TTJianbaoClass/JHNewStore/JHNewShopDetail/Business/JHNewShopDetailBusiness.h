//
//  JHNewShopDetailBusiness.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopDetailBusiness : NSObject

///获取店铺头部信息
+ (void)requestShopDetailInfoWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///关注/取关 店铺
+ (void)requestShopFollowWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///领取优惠券
+ (void)requestShopGetCouponsWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///店铺评价
+ (void)requestShopUserCommentWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///店铺商品列表
+ (void)requestShopProductListWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
