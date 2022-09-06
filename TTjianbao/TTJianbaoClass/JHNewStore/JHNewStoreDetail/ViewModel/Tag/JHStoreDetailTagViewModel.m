//
//  JHStoreDetailTagViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailTagViewModel.h"

@implementation JHStoreDetailTagViewModel
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
    self.cellType = TagCell;
    self.height = 0;
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setItemList:(NSMutableArray<JHStoreDetailTagItemViewModel *> *)itemList {
    _itemList = itemList;
    CGFloat height = TagTtemHeight;
    CGFloat contentWidth = ScreenW - LeftSpace * 2;
    NSUInteger count = 1;
    CGFloat width = 0;
    NSUInteger hCount = 0;
    for (JHStoreDetailTagItemViewModel *model in itemList) {
            width += model.width;
        if (((width + TagItemSpace * hCount) - TagItemSpace) > contentWidth) {
            count += 1;
            hCount = 0;
            width = TagItemSpace + model.width;
        }else{
            hCount += 1;
        }
    }
    self.height = (height + TagItemSpace) * count + TagTopSpace;
}

@end
