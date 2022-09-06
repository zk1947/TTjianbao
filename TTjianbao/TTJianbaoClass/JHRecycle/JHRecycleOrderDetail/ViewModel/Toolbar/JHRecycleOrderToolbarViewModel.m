//
//  JHRecycleOrderToolbarViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderToolbarViewModel.h"

@implementation JHRecycleOrderToolbarViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}

#pragma mark - Public Functions
- (void)didClickWithType : (RecycleOrderButtonType) type {
    [self.clickEvent sendNext:@(type)];
}
- (void)setupButtonListWithInfo : (JHRecycleOrderButtonInfo *)buttonInfo {
    if (buttonInfo == nil) return;
    NSMutableArray *list = [[NSMutableArray alloc] init];
    // 删除
    if (buttonInfo.deleteOrderBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeDelete)];
    }
    // 取消
    if (buttonInfo.cancelOrderBtnFlag) {
        [list appendObject: @(RecycleOrderButtonTypeCancel)];
    }
    // 查看仲裁
    if (buttonInfo.seeArbitrationBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeCheckArbitration)];
    }
    // 申请仲裁
    if (buttonInfo.applyArbitrationBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeArbitration)];
    }
    // 申请销毁
    if (buttonInfo.applyDestroyBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeDestruction)];
    }
    // 申请返回
    if (buttonInfo.applyRefundBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeReturn)];
    }
    // 关闭交易
    if (buttonInfo.closeOrderBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeClose)];
    }
    // 订单追踪
    if (buttonInfo.traceOrderBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypePursue)];
    }
    // 预约上门取件
    if (buttonInfo.callDoorBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeAppointment)];
    }
    // 查看取件预约
    if (buttonInfo.seeCallDoorBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeCheckAppointment)];
    }
    // 查看物流
    if (buttonInfo.seeExpressBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeLogistics)];
    }
    // 确认交易
    if (buttonInfo.confirmDealBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeEnsure)];
    }
    // 确认收货
    if (buttonInfo.confirmRecieptBtnFlag) {
        [list appendObject:@(RecycleOrderButtonTypeReceived)];
    }
//    // 填写物流单号
//    if (buttonInfo.confirmRecieptBtnFlag) {
//        [list appendObject:@(RecycleOrderButtonTypeFillLogistics)];
//    }
    
    self.buttonList = list;
}
#pragma mark - Private Functions

- (void)setupData {
    
}
#pragma mark - Action functions
#pragma mark - Lazy
- (RACSubject *)clickEvent {
    if (!_clickEvent) {
        _clickEvent = [RACSubject subject];
    }
    return _clickEvent;
}

@end
