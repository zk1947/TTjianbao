//
//  CStoreChannelGoodsListModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/2/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  商城首页-获取某个分类标签下的商品列表
//

#import "YDBaseModel.h"
#import "CStoreHomeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CStoreChannelGoodsListModel : YDBaseModel

//商品列表 <data>
@property (nonatomic, strong) NSMutableArray<CStoreHomeGoodsData *> *list;

- (NSString *)toUrlWithChannelId:(NSInteger)channelId cateType:(NSInteger)cateType;
- (void)configModel:(CStoreChannelGoodsListModel *)model;

@end

NS_ASSUME_NONNULL_END
