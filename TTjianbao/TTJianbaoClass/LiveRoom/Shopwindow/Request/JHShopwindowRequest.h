//
//  JHShopwindowRequest.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShopwindowReqBaseModel.h"
#import "JHShopwindowGoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHShopwindowRequest : NSObject

/// 获取商品数量
+ (void)requestshopwindowNumWithId:(NSString *)Id successBlock:(void (^) (NSString *text))successBlock;

/// 获取商品详情
+ (void)requestEditDetailWithId:(NSString *)Id successBlock:(void (^) (JHShopwindowGoodsListModel *data))successBlock;

/// 下架
+ (void)requestDownLineWithId:(NSString *)Id successBlock:(dispatch_block_t)successBlock;

/// 下架列表删除
+ (void)requestDownLineDeleteWithId:(NSString *)Id successBlock:(dispatch_block_t)successBlock;

/// 上架
+ (void)requestUpLineWithId:(NSString *)Id successBlock:(dispatch_block_t)successBlock;

/// 上架的删除
+ (void)requestUpListDeleteWithId:(NSString *)Id successBlock:(dispatch_block_t)successBlock;

/// 橱窗列表
/// @param channelLocalId 直播间ID(买家必传，主播可以不穿)
/// @param type 0-买家端列表    1-主播端上架中列表    2-主播端下架中列表
/// @param successBlock 成功后的回调
+ (void)requestUpListDeleteWithChannelLocalId:(NSString *__nullable)channelLocalId type:(NSInteger)type successBlock:(void (^) (NSArray <JHShopwindowGoodsListModel *> *data))successBlock;

/// 添加商品-add or edit
/// @param goodsModel 直播间商品model
/// @param successBlock 成功后的回调
+ (void)requestAddGoods:(JHShopwindowGoodsListModel*)goodsModel successBlock:(dispatch_block_t)successBlock;

@end

NS_ASSUME_NONNULL_END
