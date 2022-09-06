//
//  JHStoreDetailCouponViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCouponViewModel.h"
@interface JHStoreDetailCouponViewModel()

@end
@implementation JHStoreDetailCouponViewModel
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
    self.cellType = CouponCell;
    self.height = 46;
}
#pragma mark - Action functions
#pragma mark - Lazy
- (NSMutableArray<JHStoreDetailCouponItemViewModel *> *)itemList {
    if (!_itemList) {
        _itemList = [[NSMutableArray alloc] init];
    }
    return _itemList;
}

@end


