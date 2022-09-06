//
//  JHRecycleUploadProductBusiness.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleUploadSeleteTypeModel.h"
#import "JHRecycleSquareHomeModel.h"
#import "JHRecycleMeAttentionModel.h"
#import "JHRecycleUploadExampleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleUploadProductBusiness : NSObject

/// 回收商品类型选择页面  /recycle/capi/auth/selectPage
+ (void)requestRecycleProductSeleteTypeCompletion:(void(^)(NSError *_Nullable error, JHRecycleUploadSeleteTypeModel *_Nullable model))completion;


/// 回收商品发布页面  /recycle/capi/auth/launch
+ (void)requestRecycleProductPublishProductCategoryId:(NSInteger)categoryId
                                       andProductDesc:(NSString*)productDesc
                                       andBusinessId:(NSString*)businessId
                                       andexpectPrice:(NSString*)expectPrice
                                    andProductImgUrls:(NSArray*)productImgUrls
                                 andProductDetailUrls:(NSArray*)productDetailUrls
                                        andCompletion:(void(^)(NSError *_Nullable error))completion;


/// 仲裁上传信息页面  /recycle/capi/auth/mineSale/appeal/summit
+ (void)requestRecycleArbitrationUploadOrderId:(NSInteger)orderId
                                       andDesc:(NSString*)desc
                                    andImgUrls:(NSArray*)imageUrlsArr
                                 andCompletion:(void(^)(NSError *_Nullable error))completion;


/// 回收广场列表（分页） /recycle/capi/auth/recycleSquare/listRecycleProductPage
+ (void)requestRecycleSquareHomeListWithParams:(NSDictionary *_Nullable)params
                                Completion:(void(^)(NSError *_Nullable error, JHRecycleSquareHomeModel *_Nullable model))completion;


/// 我的收藏列表（分页）  /recycle/capi/auth/recycleSquare/listProcutCollection
+ (void)requestRecycleMeAttentionListPageNo:(NSInteger)pageNo
                                andPageSize:(NSInteger)pageSize
                                 Completion:(void(^)(NSError *_Nullable error, JHRecycleMeAttentionModel *_Nullable model))completion;

/// 我的收藏 移除收藏  recycle/capi/auth/recycleSquare/cancelCollectionProduct
+ (void)requestRecycleMeAttentionRemoveProductIDs:(NSArray*)productIDArr
                                       Completion:(void(^)(NSError *_Nullable error))completion;



/// 回收商品发布示例  /recycle/capi/auth/queryExample
+ (void)requestRecycleUploadQueryExampleCategoryId:(NSInteger)categoryID
                                        Completion:(void(^)(NSError *_Nullable error, JHRecycleUploadExampleTotalModel *_Nullable model))completion;

/// 回收广场分类筛选  /recycle/capi/auth/recycleSquare/listRecycleDict
+ (void)requestRecycleSquareSelectListWithParams:(NSDictionary *_Nullable)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
