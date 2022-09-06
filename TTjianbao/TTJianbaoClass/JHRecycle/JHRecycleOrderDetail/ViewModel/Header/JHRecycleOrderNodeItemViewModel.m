//
//  JHRecycleOrderNodeItemViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderNodeItemViewModel.h"

@implementation JHRecycleOrderNodeItemViewModel
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
    self.width = (ScreenW - LeftSpace * 2) / 7 + 6;
    self.nodeType = RecycleOrderNodeTypeNomal;
}
#pragma mark - Action functions
#pragma mark - Lazy
@end
