//
//  JHStoreApiManager.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  商城Api
//

#import <Foundation/Foundation.h>
#import "BannerMode.h"
#import "CStoreHomeListModel.h"
#import "CGoodsDetailModel.h"
#import "CStoreCollectionModel.h"
#import "CStoreChannelModel.h"
#import "CStoreChannelGoodsListModel.h"
#import "JHStoreHomeCardModel.h"
#import "JHSecKillReqMode.h"

#import "JHShopWindowModel.h"
#import "JHShopWindowListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreApiManager : NSObject

///获取首页列表数据 - 标签栏以上的列表数据
//+ (void)getHomeDataList:(CStoreHomeListModel *)model block:(HTTPCompleteBlock)block;
///2.5新增  --todo lh
+ (void)getHomeDataListWithCompleteblock:(HTTPCompleteBlock)block;

///商城首页-分类标签列表
+ (void)getChannelList:(CStoreChannelModel *)model block:(HTTPCompleteBlock)block;

///商城首页-获取某个分类标签下的商品列表
+ (void)getGoodsListForChannel:(CStoreChannelGoodsListModel *)model channelId:(NSInteger)channelId cateType:(NSInteger)cateType block:(HTTPCompleteBlock)block;

///获取商品详情，传入商品id
+ (void)getGoodsDetailWithGoodsId:(NSString *)goodsId pageFrom:(NSString *)pageFrom block:(HTTPCompleteBlock)block;

///请求订单id
+ (void)getOrderIdWithGoodsId:(NSString *)goodsId block:(HTTPCompleteBlock)block;

///我的收藏列表
+ (void)getMyCollectionList:(CStoreCollectionModel *)model block:(HTTPCompleteBlock)block;

///收藏商品
+ (void)collectionWithGoodsId:(NSString *)goodsId block:(HTTPCompleteBlock)block;

///取消收藏商品
+ (void)cancelCollectionWithGoodsId:(NSString *)goodsId block:(HTTPCompleteBlock)block;

///商城热搜关键词
+ (void)getHotKeywords:(HTTPCompleteBlock)completeBlock;

///搜索结果数据
+ (void)getSearchResult:(CStoreCollectionModel *)model Keyword:(NSString *)keyword searchKey:(NSString *)searchKey sortType:(NSInteger)sortType  block:(HTTPCompleteBlock)block;

///获取秒杀列表标签
+ (void)getSeckillCateList:(JHApiRequestHandler)completion;

///秒杀列表
+ (void)getSeckillList:(JHSecKillReqMode*)reqMode completion:(JHApiRequestHandler)completion;

///秒杀提醒
+ (void)goodRemind:(NSString*)ses_id GoodId:(NSString*)goods_id completion:(JHApiRequestHandler)completion;
///秒杀取消提醒
+ (void)goodCancelRemind:(NSString*)ses_id GoodId:(NSString*)goods_id completion:(JHApiRequestHandler)completion;

///获取推荐数据
+ (void)getRecommendListWithParams:(NSDictionary *)params block:(HTTPCompleteBlock)block;

///商品详情页面评论列表数据
+ (void)getCommentListWithSellerId:(NSInteger)sellerId completeBlock:(HTTPCompleteBlock)completeBlock;

///获取专题列表数据 - （3.1.7弃用）
+ (void)getShowcaseWithId:(NSInteger)showcaseId pageNumber:(NSInteger)pageNumber latId:(NSInteger)lastId completeBlock:(HTTPCompleteBlock)completeBlock;

#pragma mark - 3.1.7专题(橱窗)页改版
///获取专题信息
+ (void)getWindowInfo:(JHShopWindowModel *)model block:(HTTPCompleteBlock)block;

///获取专题页导航标签下的商品列表
+ (void)getWindowList:(JHShopWindowListModel *)model block:(HTTPCompleteBlock)block;

///获取新人红包
+(void)getNewUserRedpacketWithCompleteBlock:(HTTPCompleteBlock)block;


///我的收藏列表 商品----新的
+ (void)getNewMyCollectionListBlock:(succeedBlock)block;
@end

NS_ASSUME_NONNULL_END
