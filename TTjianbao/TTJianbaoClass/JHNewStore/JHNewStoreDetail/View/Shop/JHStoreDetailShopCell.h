//
//  JHStoreDetailShopCell.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品店铺推荐区

#import <UIKit/UIKit.h>
#import "JHStoreDetailBaseCell.h"
#import "JHStoreDetailShopViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailShopCell : JHStoreDetailBaseCell
@property (nonatomic, strong) JHStoreDetailShopViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
