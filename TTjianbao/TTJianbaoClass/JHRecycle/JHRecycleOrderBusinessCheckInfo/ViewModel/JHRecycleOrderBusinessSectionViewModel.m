//
//  JHRecycleOrderBusinessSectionViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessSectionViewModel.h"

@implementation JHRecycleOrderBusinessSectionViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}

#pragma mark - Private Functions
- (void)setupData {
    
}
#pragma mark - Action functions
#pragma mark - Lazy
- (NSMutableArray<JHRecycleOrderBusinessBaseViewModel *> *)cellViewModelList {
    if (!_cellViewModelList) {
        _cellViewModelList = [NSMutableArray array];
    }
    return _cellViewModelList;
}
@end
