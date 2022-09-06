//
//  JHRecycleOrderDetailViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailInfoViewModel.h"

@implementation JHRecycleOrderDetailInfoViewModel
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
    
    self.height = 32;
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setIsTopCell:(BOOL)isTopCell {
    _isTopCell = isTopCell;
    if (isTopCell == true) {
        self.cellType = RecycleOrderDetailInfoTopCell;
    }else {
        self.cellType = RecycleOrderDetailInfoCell;
    }
}
- (void)setIsBottomCell:(BOOL)isBottomCell {
    _isBottomCell = isBottomCell;
    if (isBottomCell == true) {
        self.cellType = RecycleOrderDetailInfoBottomCell;
    }else {
        self.cellType = RecycleOrderDetailInfoCell;
    }
}
- (void)setTitleText:(NSString *)titleText {
    _titleText = [titleText stringByAppendingString:@":"];
}
- (void)setDetailText:(NSString *)detailText {
    _detailText = detailText;
}
@end
