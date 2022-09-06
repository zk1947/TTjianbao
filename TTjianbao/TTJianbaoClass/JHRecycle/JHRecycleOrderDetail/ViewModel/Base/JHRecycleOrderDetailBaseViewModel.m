//
//  JHRecycleOrderBaseViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailBaseViewModel.h"

@implementation JHRecycleOrderDetailBaseViewModel
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

- (RACSubject *)reloadData {
    if (!_reloadData) {
        _reloadData = [RACSubject subject];
    }
    return _reloadData;
}
- (RACSubject *)clickEvent {
    if (!_clickEvent) {
        _clickEvent = [RACSubject subject];
    }
    return _clickEvent;
}
@end
