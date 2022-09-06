//
//  JHFoucsShopListImageCell.h
//  TTjianbao
//
//  Created by apple on 2020/2/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
#import "JHFoucsShopModel.h"

@class JHGoodsInfoMode;
NS_ASSUME_NONNULL_BEGIN
/// 我关注的人的商品信息
@interface JHFoucsShopListImageCell : JHWBaseTableViewCell
///商品数据
@property (nonatomic,strong) NSArray <JHFoucsShopProductInfo *> *goodsArray;

@property (nonatomic, copy) dispatch_block_t enterShopBlock;

@end

NS_ASSUME_NONNULL_END
