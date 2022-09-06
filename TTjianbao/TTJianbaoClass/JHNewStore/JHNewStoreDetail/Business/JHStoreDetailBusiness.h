//
//  JHStoreDetailBusiness.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品详情 - 网络请求

#import <Foundation/Foundation.h>
#import "JHStoreDetailModel.h"
#import "JHStoreSnapShootDetailModel.h"
#import "JHStoreDetailCouponModel.h"
#import "JHNewStoreHomeModel.h"


NS_ASSUME_NONNULL_BEGIN
typedef void (^detailInfoBlock)(JHStoreDetailModel * _Nullable respondObject);
typedef void (^snapShootDetailInfoBlock)(JHStoreSnapShootDetailModel * _Nullable respondObject);
typedef void (^couponInfoBlock)(NSArray<JHStoreDetailCouponModel *> * _Nullable respondObject);
typedef void (^couponReceiveInfoBlock)(JHStoreDetailReceiveCouponModel * _Nullable respondObject);


@interface JHStoreDetailBusiness : NSObject

/// 获取商品详情信息
/// productId : 商品ID
+ (void)getStoreDetailInfoWithProductId : (NSString *)productId
                            successBlock:(detailInfoBlock) success
                            failureBlock:(failureBlock)failure;

/// 获取订单快照信息
/// orderd : 订单ID
+ (void)getStoreSnapShootWithOrderId : (NSString *)orderId
                            successBlock:(snapShootDetailInfoBlock) success
                         failureBlock:(failureBlock)failure ;
/// 收藏商品
/// productId : 商品ID
+ (void)followProduct : (NSString *)productId
          successBlock:(succeedBlock) success
          failureBlock:(failureBlock)failure;

/// 取消收藏商品
/// productId : 商品ID
+ (void)followCancelProduct : (NSString *)productId
                successBlock:(succeedBlock) success
                failureBlock:(failureBlock)failure;

/// 店铺关注、取关
/// couponId : 优惠券ID
/// type : 关注类型: 1关注 0取关
+ (void)shopFollowWithShopId : (NSString *)shopId
                        type : (NSString *) type
                successBlock:(succeedBlock) success
                failureBlock:(failureBlock)failure;

/// 开售提醒
/// productId : 商品ID
+ (void)salesRemindWithProductId : (NSString *)productId
                successBlock:(succeedBlock) success
                failureBlock:(failureBlock)failure;


/// 获取优惠券列表
/// productId : 商品ID
+ (void)couponlistWithSellerId : (NSString *)sellerId
                successBlock:(couponInfoBlock) success
                    failureBlock:(failureBlock)failure;

/// 领取优惠券
/// couponId : 优惠券ID
+ (void)receiveCouponWithID : (NSString *)couponId
                successBlock:(couponReceiveInfoBlock) success
                failureBlock:(failureBlock)failure;


/// 店铺评论
/// @param sellerId 卖家id
/// @param completion 返回
+ (void)requestCommentListWithSellerID:(NSString*)sellerId
                            completion:(void (^)(NSError * _Nullable error, JHStoreCommentModel* _Nullable model))completion;

/// 店铺标签
/// @param sellerId 卖家id
/// @param completion  返回
+ (void)requestTagsWithSellerID:(NSString*)sellerId
                     completion:(void (^)(NSError * _Nullable error, NSArray<CommentTagMode *>* _Nullable arr))completion;



/// 同店好货
/// @param productID
/// @param shopId
/// @param completion
+ (void)requestSameShopGoodProduct:(NSString *)productID
                            shopId:(NSString *)shopId completion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreHomeGoodsProductListModel*> * _Nullable))completion;


/// 推荐
/// @param productID
/// @param page
/// @param completion
+ (void)requestRecommendProductGoodProduct:(NSString *)productID
                                      page:(NSInteger)page
                                completion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreHomeGoodsProductListModel *> * _Nullable))completion;

/// 属性说明
/// @param attrId
/// @param completion
+ (void)requestQueryAttrDecsContentByAttrId:(NSString*)attrId  completion:(void (^)(NSError * _Nullable error, JHProductIntrductModel* _Nullable model))completion;


/// 删除评论
/// @param commentID
/// @param completion
+ (void)requestDelComment:(NSString *)commentID
               completion:(void (^)(NSError * _Nullable))completion;

+ (void)requestProductDetailPaiMai:(NSString *)auctionSn
                           completion:(void (^)(NSError * _Nullable error, JHB2CAuctionRefershModel * _Nullable model))completion;

///出价 以及代理出价
+ (void)requestB2CSetPriceProductSn:(NSString *)productSn andPrice:(NSString*)price isDelegate:(BOOL)delegate completion:(void (^)(NSError * _Nullable error))completion;


///取消代理出价
+ (void)requestB2CCancleSetPriceProductSn:(NSString *)productSn completion:(void (^)(NSError * _Nullable error))completion;


@end



NS_ASSUME_NONNULL_END
