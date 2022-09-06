//
//  JHStoreDetailCouponListViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 优惠券列表

#import <Foundation/Foundation.h>
#import "JHStoreDetailCouponListCellViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCouponListViewModel : NSObject
/// 商家ID
@property (nonatomic, copy) NSString *sellerId;
/// toast
@property (nonatomic, copy) NSString *toastMsg;
/// 显示菊花
@property (nonatomic, strong) RACSubject *showProgress;
/// 隐藏菊花
@property (nonatomic, strong) RACSubject *hideProgress;
/// 结束加载
@property (nonatomic, strong) RACSubject *endRefreshing;
/// 刷新上层页面-当关注、优惠券领取状态改变时触发。
@property (nonatomic, strong) RACSubject *refreshUpper;
/// 刷新列表
@property (nonatomic, strong) RACReplaySubject *refreshTableView;
/// 跳转
@property (nonatomic, strong) RACSubject<NSDictionary *> *pushvc;
/// 优惠券 cells
@property (nonatomic, strong) NSMutableArray<JHStoreDetailCouponListCellViewModel *> *cellList;

/// 获取优惠券列表
- (void)getCouponList;
@end

NS_ASSUME_NONNULL_END
