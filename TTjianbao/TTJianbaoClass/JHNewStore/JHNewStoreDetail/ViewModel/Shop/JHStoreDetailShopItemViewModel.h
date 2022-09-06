//
//  JHStoreDetailShopItemViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 店铺推荐商品 viewModel

#import "JHStoreDetailCellBaseViewModel.h"

static const CGFloat shopItemSpace = 8.0f;
static const CGFloat shopItemTitleTop = 6.0f;
static const CGFloat shopItemTitleHeight = 34.0f;
static const CGFloat shopItemPriceTop = 2.0f;
static const CGFloat shopItemPriceHeight = 19.0f;

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailShopItemViewModel : JHStoreDetailCellBaseViewModel
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, strong) NSAttributedString *priceText;

- (void)setupPrice : (NSString *)price;
+ (CGFloat)getItemHeight;
@end

NS_ASSUME_NONNULL_END
