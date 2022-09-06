//
//  JHC2CProductDetailBusiness.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHC2CProoductDetailModel.h"
#import "JHC2CJiangPaiListModel.h"
#import "JHC2CSureMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductDetailBusiness : NSObject

/// C2C商品详情页    /api/mall/product/detail
+ (void)requestC2CProductDetailProductID:(NSString*)productID completion:(void(^)(NSError *_Nullable error, JHC2CProoductDetailModel *_Nullable model))completion;

+ (void)requestC2CProductComment:(NSDictionary *)parDic completion:(void (^)(NSError * _Nullable error, JHC2CProoductDetailModel * _Nullable model))completion;


+ (void)requestC2CProductDetailPaiMai:(NSString *)auctionSn completion:(void (^)(NSError * _Nullable error, JHC2CAuctionRefershModel * _Nullable model))completion;

//参拍列表
+ (void)requestC2CProductDetailPaiMaiList:(NSString *)productID page:(NSNumber *)page completion:(void (^)(NSError * _Nullable error, JHC2CJiangPaiListModel * _Nullable model))completion;


//浏览人数
+ (void)requestC2CProductDetailSeeCount:(NSString *)productID completion:(void (^)(NSError * _Nullable error, JHC2CProductDetailUserListModel * _Nullable model))completion;


//收藏人数
+ (void)requestC2CProductDetailCollectCount:(NSString *)productID completion:(void (^)(NSError * _Nullable error, JHC2CProductDetailUserListModel * _Nullable model))completion;


///收藏商品
+ (void)requestC2CProductDetailCollectProduct:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable error))completion;

///取消收藏商品
+ (void)requestC2CProductDetailCancleCollectProduct:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable error))completion;


///出价 以及代理出价
+ (void)requestC2CSetPriceProductSn:(NSString *)productSn andPrice:(NSString*)price isDelegate:(BOOL)delegate completion:(void (^)(NSError * _Nullable error))completion;


///取消代理出价
+ (void)requestC2CCancleSetPriceProductSn:(NSString *)productSn completion:(void (^)(NSError * _Nullable error))completion;



///浏览或想要
+ (void)requestC2CProductSeeOrWant:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable error))completion;


///是否关注状态
+ (void)requestC2CProductBrowse:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable error, BOOL isFollow))completion;


///是否支付保证金
+ (void)requestC2CPaySureMoney:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable error, JHC2CSureMoneyModel *model))completion;


///评论数目
+ (void)requestC2CChatCount:(NSString *)parID  completion:(void (^)(NSError * _Nullable error, NSInteger count))completion;

@end

NS_ASSUME_NONNULL_END
