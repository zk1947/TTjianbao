//
//  JHStoreDetailTagItemViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailTagItemViewModel.h"

@implementation JHStoreDetailTagItemViewModel
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
    self.height = TagTtemHeight;
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.width = [self.titleText widthForFont:[UIFont systemFontOfSize:TagItemTitleTextFontSize]] + TagItemTitleLeftSpace * 2 + 2;;
}
@end
