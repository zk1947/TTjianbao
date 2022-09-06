//
//  JHStoreDetailCycleItemViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCycleItemViewModel.h"

@implementation JHStoreDetailCycleItemViewModel
#pragma mark - Life Cycle Functions
- (instancetype)initWithType : (CycleType)type url : (NSString *)url {
    self = [super init];
    if (self) {
        [self setupDataWithType:type url:url];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Private Functions
- (void)setupDataWithType : (CycleType)type url : (NSString *)url {
    self.type = type;
    self.width = ScreenW;
    self.height = ScreenW;
    self.imageUrl = url;
}
#pragma mark - Action functions
#pragma mark - Lazy

@end
