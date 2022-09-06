//
//  JHRecycleOrderCancelViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailBaseViewModel.h"
#import "JHRecycleOrderCancelCellViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderCancelViewModel : NSObject
@property (nonatomic, strong) NSMutableArray<JHRecycleOrderCancelCellViewModel *> *cellViewModels;
/// 取消选择视图的高度
@property (nonatomic, assign) CGFloat cancelViewHeight;

/// 订单ID
@property (nonatomic, copy) NSString *orderId;
/// 判断接口调用哪个
@property (nonatomic, assign) NSInteger requestType;
/// 直接使用外部数据
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSString *selectedMsg;
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

@property (nonatomic, strong) NSArray *dataSource;
@end

NS_ASSUME_NONNULL_END
