//
//  JHRecycleOrderNodeViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderNodeViewModel.h"

@implementation JHRecycleOrderNodeViewModel


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
- (NSMutableArray<JHRecycleOrderNodeBaseViewModel *> *)itemList {
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
