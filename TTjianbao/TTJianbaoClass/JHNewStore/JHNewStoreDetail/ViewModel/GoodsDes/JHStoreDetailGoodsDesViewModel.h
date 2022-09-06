//
//  JHStoreDetailGoodsDesViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品介绍 viewModel

#import "JHStoreDetailCellBaseViewModel.h"

static const CGFloat GoodsDesTitleFontSize = 13.0f;
static const CGFloat GoodsDesTitleTopSpace = 14.0f;
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailGoodsDesViewModel : JHStoreDetailCellBaseViewModel
/// 商品介绍文本
@property (nonatomic, copy) NSString *titleText;

/// 是否展开评论
@property(nonatomic ) BOOL  openFold;

@end

NS_ASSUME_NONNULL_END
