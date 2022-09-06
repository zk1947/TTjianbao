//
//  JHStoreDetailSecurityViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailSecurityViewModel.h"
@interface JHStoreDetailSecurityViewModel()

@end

@implementation JHStoreDetailSecurityViewModel
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
    self.cellType = SecurityCell;
    self.height = ScreenW * 758 / 750;
}

- (void)setDirectDelivery:(BOOL)directDelivery{
    _directDelivery = directDelivery;
    self.height = directDelivery ? (ScreenW * 562 / 750) : (ScreenW * 758 / 750);
}
#pragma mark - Action functions
#pragma mark - Lazy

@end
