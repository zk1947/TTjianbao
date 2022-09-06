//
//  JHStoreDetailShopViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailShopViewModel.h"
@interface JHStoreDetailShopViewModel()

@end
@implementation JHStoreDetailShopViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = ShopCell;
    self.height = [JHStoreDetailShopItemViewModel getItemHeight] + LeftSpace + 1;
}
#pragma mark - Action functions
#pragma mark - Lazy

- (NSMutableArray<JHStoreDetailShopItemViewModel *> *)itemList {
    if (!_itemList) {
        _itemList = [[NSMutableArray alloc] init];
    }
    return _itemList;
}
@end
