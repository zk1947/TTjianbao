//
//  JHStoreDetailEducationViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailEducationViewModel.h"
@interface JHStoreDetailEducationViewModel()

@end
@implementation JHStoreDetailEducationViewModel
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
    self.cellType = EducationCell;
    self.height = ScreenW * 36 / 375;
}
#pragma mark - Action functions
#pragma mark - Lazy
@end
