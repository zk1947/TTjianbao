//
//  JHRecycleOrderDetailToolbarViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailToolbarViewModel.h"

@implementation JHRecycleOrderDetailToolbarViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
        [self bindData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单toolbar详情-%@ 释放", [self class]);
}

#pragma mark - Public Functions
- (void)setupButtonListWithInfo : (JHRecycleOrderButtonInfo *)buttonInfo {
    [self.toolbarViewModel setupButtonListWithInfo:buttonInfo];
}
- (void)bindData {
    
    @weakify(self)
    [self.toolbarViewModel.clickEvent
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
         [self.clickEvent sendNext:x];
     }];
}
#pragma mark - Private Functions

- (void)setupData {
    
}
#pragma mark - Action functions
#pragma mark - Lazy
- (RACSubject *)clickEvent {
    if (!_clickEvent) {
        _clickEvent = [RACSubject subject];
    }
    return _clickEvent;
}
- (JHRecycleOrderToolbarViewModel *)toolbarViewModel {
    if (!_toolbarViewModel) {
        _toolbarViewModel = [[JHRecycleOrderToolbarViewModel alloc] init];
    }
    return _toolbarViewModel;
}
@end
