//
//  JHRecycleOrderBusinessImageViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessImageViewModel.h"

@implementation JHRecycleOrderBusinessImageViewModel
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
#pragma mark - Public Functions
- (void)setupDataWithImageUrl : (NSString *)imageUrl
                        scale : (CGFloat)scale {
    
    self.imageUrl = imageUrl;
    CGFloat width = ScreenW - ContentLeftSpace * 2;
    self.height = width * scale;
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = RecycleOrderBusinessCellTypeImage;
}
#pragma mark - Action functions
#pragma mark - Lazy
@end
