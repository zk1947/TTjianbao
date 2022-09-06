//
//  JHFoucsShopListImageCollectionViewCell.h
//  TTjianbao
//
//  Created by apple on 2020/2/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN
/// 我关注的人的单个商品
@interface JHFoucsShopListImageCollectionViewCell : JHBaseCollectionViewCell

@property (nonatomic, weak) UIImageView *goodsView;

@property (nonatomic, weak) UILabel *goodsNameLabel;

@end

NS_ASSUME_NONNULL_END
