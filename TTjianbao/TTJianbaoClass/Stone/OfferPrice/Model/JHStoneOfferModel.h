//
//  JHStoneOfferModel.h
//  TTjianbao
//
//  Created by jiang on 2019/12/5.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHGoodResaleListModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface JHStoneOfferModel : NSObject
@property (nonatomic, strong)   NSString* goodsUrl;
@property (nonatomic, strong)   NSString* goodsCode;
@property (nonatomic, strong)   NSString* goodsTitle;
@property (nonatomic, strong)   NSString* salePrice;
@property (nonatomic, strong)   NSString* sellerName;
@property (nonatomic, strong)    NSString *intentionMsg;
@property (nonatomic, assign)    float intentionRate;
@property (nonatomic, strong)   NSString * sellerAvatar;//买家图片
@property (nonatomic, strong)   NSString * stoneId;
@property (nonatomic, strong)   NSString * stoneRestoreOfferId;
/// 请求出价接口
///
///
/// @param stoneRestoreId stoneRestoreId
///  @param resaleFlag stoneRestoreId 是否为个人转售
/// @param completion completion description
+ (void)requestStoneOfferDetail:(NSString *)stoneRestoreId isResaleFlag:(BOOL)resaleFlag completion:(JHApiRequestHandler)completion;


/// 出价
/// @param completion completion description
+ (void)requestOffer:(JHGoodOrderSaveReqModel *)stoneMode completion:(JHApiRequestHandler)completion;
@end


@interface JHStoneIntentionInfoModel : NSObject
//intentionPrice (number, optional): 意向金 ,offerPrice (number, optional): 出价价格 ,serviceCostPrice (number, optional): 平台服务费
@property (nonatomic, strong)   NSString* intentionPrice;
@property (nonatomic, strong)   NSString* offerPrice;
@property (nonatomic, strong)   NSString* serviceCostPrice;
@end

NS_ASSUME_NONNULL_END
