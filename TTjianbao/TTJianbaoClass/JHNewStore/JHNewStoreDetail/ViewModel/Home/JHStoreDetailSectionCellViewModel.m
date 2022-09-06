//
//  JHStoreDetailSectionCellViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailSectionCellViewModel.h"

@implementation JHStoreDetailSectionCellViewModel

#pragma mark - Life Cycle Functions
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Private Functions
#pragma mark - Action functions

#pragma mark - Lazy
- (NSMutableArray<JHStoreDetailCellBaseViewModel *> *)cellViewModelList {
    if (!_cellViewModelList) {
        _cellViewModelList = [NSMutableArray array];
    }
    return _cellViewModelList;
}
@end
