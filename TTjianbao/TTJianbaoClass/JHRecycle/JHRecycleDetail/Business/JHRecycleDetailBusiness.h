//
//  JHRecycleDetailBusiness.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收详情 - 网络请求

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleDetailBusiness : NSObject
+ (void)requestRecycleDetailWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
//*****用户*****
///商品上下架
+ (void)requestRecycleDetailOnOrOffShelfWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
///删除商品
+ (void)requestRecycleDetailDeleteProductWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;


//*****商户*****
///收藏/取消收藏商品 - collectionStatus：1收藏 2取消收藏
+ (void)requestRecycleDetailCollectionProductWithParams:(NSDictionary *)params collectionStatus:(NSInteger )collectionStatus Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
///出价
+ (void)requestRecycleDetailGoBidWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
