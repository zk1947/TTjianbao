//
//  JHStoreDetailGoodsDesViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailGoodsDesViewModel.h"

@implementation JHStoreDetailGoodsDesViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
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
    self.cellType = GoodsDesCell;
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    CGFloat width = ScreenW -(LeftSpace * 2);
    self.height = [titleText heightForFont:[UIFont systemFontOfSize:GoodsDesTitleFontSize] width:width] + GoodsDesTitleTopSpace + 1;
}
@end
