//
//  JHStoreDetailShopViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品店铺ViewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailCellBaseViewModel.h"
#import "JHStoreDetailShopItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailShopViewModel : JHStoreDetailCellBaseViewModel

/// items
@property (nonatomic, strong) NSMutableArray<JHStoreDetailShopItemViewModel *> *itemList;

@end

NS_ASSUME_NONNULL_END
