//
//  JHB2CSameShopCellViewModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CSameShopCellViewModel.h"


@interface JHB2CSameShopCellViewModel()

@end

@implementation JHB2CSameShopCellViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellType = SameShopCell;
        self.height = kScreenHeight;
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}


@end
