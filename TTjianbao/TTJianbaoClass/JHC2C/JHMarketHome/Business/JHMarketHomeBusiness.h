//
//  JHMarketHomeBusiness.h
//  TTjianbao
//
//  Created by plz on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMarketHomeViewModel.h"
#import "JHHotWordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketHomeBusiness : NSObject

/*
 * 搜索关键词
 */
+ (void)getSearchWordListData:(void(^)(NSError *_Nullable error, NSArray<JHHotWordModel *> * _Nullable respObj))completion;

/*
 * 运营位列表、专题列表
 */
+ (void)getMarketCategroyListData:(void(^)(NSError *_Nullable error, JHMarketHomeViewModel *_Nullable viewModel))completion;

/*
 * 推荐商品列表
 */
+ (void)getMarketGoodsListData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize productType:(NSInteger)productType Completion:(void(^)(NSError *_Nullable error, JHMarketHomeCellStyleGoodsViewModel *_Nullable viewModel))completion;

/*
 * 用户竞拍状态
 */
+ (void)getMyAcutionStatus:(void(^)(NSError *_Nullable error, JHMarketHomeLikeStatusModel *model))completion;

/// 判断用户是否被平台处罚或IM拉黑
/// @param limitType 处罚用户功能类型 1 发布商品 2 去支付 3 出价 4 留言
/// @param sellerId 卖家id
/// @param completion 回调
+ (void)cheakUserIsLimit:(int)limitType sellerId:(NSInteger)sellerId completion:(void(^)(NSString *_Nullable reason, int level))completion;

+(void)logProperty:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
