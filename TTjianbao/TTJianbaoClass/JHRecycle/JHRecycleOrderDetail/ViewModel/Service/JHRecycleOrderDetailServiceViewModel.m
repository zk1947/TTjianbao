//
//  JHRecycleOrderDetailServiceViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailServiceViewModel.h"

@implementation JHRecycleOrderDetailServiceViewModel
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
    self.cellType = RecycleOrderDetailServiceCell;
    self.height = 37;
}
#pragma mark - Action functions
#pragma mark - Lazy
@end
