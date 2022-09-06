//
//  JHStoreDetailSpecialViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailSpecialViewModel.h"
@interface JHStoreDetailSpecialViewModel()


@end

@implementation JHStoreDetailSpecialViewModel

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
    self.cellType = SpecialCell;
    self.height = 30;// ScreenW * 30 / 375;
}
#pragma mark - Action functions
#pragma mark - Lazy
//- (RACSubject *)specialAction {
//    if (!_specialAction) {
//        _specialAction = [RACSubject subject];
//    }
//    return _specialAction;
//}
@end
