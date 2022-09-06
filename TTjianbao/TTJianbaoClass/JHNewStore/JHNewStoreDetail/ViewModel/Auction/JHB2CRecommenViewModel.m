//
//  JHB2CRecommenViewModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CRecommenViewModel.h"
#import "JHStoreDetailBusiness.h"


@interface JHB2CRecommenViewModel()

@end

@implementation JHB2CRecommenViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellType = RecommentCell;
        self.height = kScreenHeight;
    }
    return self;
}

- (void)setProductId:(NSString *)productId{
    _productId = productId;
}

- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}

@end
