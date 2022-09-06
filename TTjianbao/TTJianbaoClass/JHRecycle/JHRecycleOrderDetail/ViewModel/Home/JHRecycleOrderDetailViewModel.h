//
//  JHRecycleOrderDetailViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-ViewModel

#import <Foundation/Foundation.h>
#import "JHRecycleOrderDetailHeaderViewModel.h"
#import "JHRecycleOrderDetailSectionViewModel.h"
#import "JHRecycleOrderDetailToolbarViewModel.h"
#import "JHRecycleOrderDetailBusiness.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailViewModel : NSObject
/// 订单ID
@property (nonatomic, copy) NSString *orderId;

/// toast
@property (nonatomic, copy) NSString *toastMsg;
/// 开始加载
@property (nonatomic, strong) RACSubject *startRefreshing;
/// 加载完成
@property (nonatomic, strong) RACSubject *endRefreshing;
/// 跳转
@property (nonatomic, strong) RACSubject<NSDictionary *> *pushvc;
/// 刷新tableview
@property (nonatomic, strong) RACSubject *refreshTableView;
/// 刷新cell
@property (nonatomic, strong) RACReplaySubject<RACTuple*> *refreshCell;
/// 刷新上层数据
@property (nonatomic, strong) RACSubject *reloadUPData;
/// header ViewModel
@property (nonatomic, strong) JHRecycleOrderDetailHeaderViewModel *headerViewModel;
///
@property (nonatomic, strong) JHRecycleOrderDetailToolbarViewModel *toolbarViewModel;
/// cell 集合- 存储类表所需所有  cellViewModel
@property (nonatomic, strong) NSMutableArray<JHRecycleOrderDetailSectionViewModel *> *cellViewModelList;

@property (nonatomic, copy) NSString *selectedCancelMsg;

- (void)getOrderDetailInfo;
@end

NS_ASSUME_NONNULL_END
