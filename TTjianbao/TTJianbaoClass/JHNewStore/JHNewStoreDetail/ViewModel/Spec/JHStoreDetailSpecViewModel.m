//
//  JHStoreDetailSpecViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailSpecViewModel.h"
@interface JHStoreDetailSpecViewModel()

@end
@implementation JHStoreDetailSpecViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellType = SpecCell;
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}

@end
