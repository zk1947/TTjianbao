//
//  JHStoreDetailCycleViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCycleViewModel.h"

@interface JHStoreDetailCycleViewModel()

@end

@implementation JHStoreDetailCycleViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init {
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
    
}
#pragma mark - Action functions
#pragma mark - Lazy
- (NSMutableArray<JHStoreDetailCycleItemViewModel *> *)itemList {
    if (!_itemList) {
        _itemList = [[NSMutableArray alloc] init];
    }
    return _itemList;
}
- (RACReplaySubject *)refreshView {
    if (!_refreshView) {
        _refreshView = [RACReplaySubject subject];
    }
    return _refreshView;
}
@end
