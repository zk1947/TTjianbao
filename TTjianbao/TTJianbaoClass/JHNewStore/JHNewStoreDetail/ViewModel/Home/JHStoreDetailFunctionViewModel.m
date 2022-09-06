//
//  JHStoreDetailFunctionViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailFunctionViewModel.h"
@interface JHStoreDetailFunctionViewModel()

@end
@implementation JHStoreDetailFunctionViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions


#pragma mark - Private Functions

#pragma mark - Action functions
#pragma mark - Lazy
- (RACSubject *)shopAction {
    if (!_shopAction) {
        _shopAction = [RACSubject subject];
    }
    return _shopAction;
}
- (RACSubject *)serviceAction {
    if (!_serviceAction) {
        _serviceAction = [RACSubject subject];
    }
    return _serviceAction;
}
- (RACSubject *)collectAction {
    if (!_collectAction) {
        _collectAction = [RACSubject subject];
    }
    return _collectAction;
}
- (RACSubject *)buyAction {
    if (!_buyAction) {
        _buyAction = [RACSubject subject];
    }
    return _buyAction;
}

- (RACSubject *)agentSetAction {
    if (!_agentSetAction) {
        _agentSetAction = [RACSubject subject];
    }
    return _agentSetAction;
}
- (RACSubject *)buyPriceAction {
    if (!_buyPriceAction) {
        _buyPriceAction = [RACSubject subject];
    }
    return _buyPriceAction;
}

@end
