//
//  JHRecycleOrderCancelViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderCancelViewModel.h"
#import "JHRecycleOrderDetailBusiness.h"
#import "JHAppraisalResultlModel.h"

@interface JHRecycleOrderCancelViewModel()
@property (nonatomic, strong) NSArray<JHRecycleCancelModel *> *list;
@end
@implementation JHRecycleOrderCancelViewModel

#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {

        self.cancelViewHeight = 140.f;
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}

#pragma mark - Private Functions
- (void)setupData {
    if (self.list == nil) return;
    
    for (JHRecycleCancelModel *model in self.list) {
        JHRecycleOrderCancelCellViewModel *viewModel = [[JHRecycleOrderCancelCellViewModel alloc] init];
        viewModel.titleText = model.reasonTypeDesc;
        viewModel.code = model.reasonType;
        [self.cellViewModels appendObject:viewModel];
        self.cancelViewHeight += viewModel.height;
        
    }
   
    [self.endRefreshing sendNext:nil];
    
    [self.refreshTableView sendNext:nil];
}

- (void)setupAppData {
    if (self.list == nil) return;
   
    for (JHRecycleCancelModel *model in self.list) {
        JHRecycleOrderCancelCellViewModel *viewModel = [[JHRecycleOrderCancelCellViewModel alloc] init];
        viewModel.titleText = model.reasonTypeDesc;
        viewModel.code = model.reasonType;
        [self.cellViewModels appendObject:viewModel];
        self.cancelViewHeight += viewModel.height;
    }
   
    [self.endRefreshing sendNext:nil];
    
    [self.refreshTableView sendNext:nil];
}

- (void)setupLocalAppData {
    if (self.dataSource == nil) return;
    
    for (NSDictionary *dics in self.dataSource) {
        JHRecycleOrderCancelCellViewModel *viewModel = [[JHRecycleOrderCancelCellViewModel alloc] init];
        viewModel.titleText = [dics valueForKey:@"name"];
        viewModel.code = [dics valueForKey:@"code"];
        [self.cellViewModels appendObject:viewModel];
        self.cancelViewHeight += viewModel.height;
    }
   
    [self.endRefreshing sendNext:nil];
    
    [self.refreshTableView sendNext:nil];
}

#pragma mark - Action functions

#pragma mark - 网络请求
- (void)getCancelInfo {
    @weakify(self)
    [JHRecycleOrderDetailBusiness getOrderCancelListSuccessBlock:^(NSArray<JHRecycleCancelModel *> * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.list = respondObject;
        [self setupData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        
    }];
}

- (void)getCancelInfoWithRequest:(NSInteger)requestType {
    switch (requestType) {
        case 1:
        case 2:
        {
            @weakify(self)
            [JHRecycleOrderDetailBusiness getOrderCancelListWithRequestType:requestType SuccessBlock:^(NSArray<JHRecycleCancelModel *> * _Nullable respondObject) {
                @strongify(self)
                [self.endRefreshing sendNext:nil];
                self.list = respondObject;
                [self setupAppData];
            } failureBlock:^(RequestModel * _Nullable respondObject) {
                @strongify(self)
                [self.endRefreshing sendNext:nil];
            }];
        }
            
            
            break;
            
        case 3:
        {
            @weakify(self)
            [JHRecycleOrderDetailBusiness getAppraisalOrderCancelListWithRequestSuccessBlock:^(NSArray<JHRecycleCancelModel *> * _Nullable respondObject) {
                @strongify(self)
                [self.endRefreshing sendNext:nil];
                self.list = respondObject;
                [self setupAppData];
            } failureBlock:^(RequestModel * _Nullable respondObject) {
                @strongify(self)
                [self.endRefreshing sendNext:nil];
            }];
        }
            break;
           
        case 4:
        {
            [self setupLocalAppData];
        }
            break;
        case 5:
        {
            @weakify(self)
            [JHRecycleOrderDetailBusiness  getrefuseReasonListWithRequestSuccessBlock:^(NSArray<JHRecycleCancelModel *> * _Nullable respondObject) {
                @strongify(self)
                [self.endRefreshing sendNext:nil];
                self.list = respondObject;
                [self setupData];
            } failureBlock:^(RequestModel * _Nullable respondObject) {
                @strongify(self)
                [self.endRefreshing sendNext:nil];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)getCancelInfoWithArray:(NSArray *)reasonsArray {
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        @strongify(self);
        NSArray *list = [JHRecycleCancelModel mj_objectArrayWithKeyValuesArray:reasonsArray];
        [self.endRefreshing sendNext:nil];
        self.list = list;
        [self setupAppData];
    });
}
#pragma mark - Lazy
- (void)setOrderId:(NSString *)orderId {
    _orderId = orderId;
    [self getCancelInfo];
}

- (void)setRequestType:(NSInteger)requestType {
    _requestType = requestType;
    [self getCancelInfoWithRequest:requestType];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self getCancelInfoWithArray:dataArray];
}
- (RACSubject<NSDictionary *> *)pushvc {
    if (!_pushvc) {
        _pushvc = [RACSubject subject];
    }
    return _pushvc;
}
- (RACSubject *)endRefreshing {
    if (!_endRefreshing) {
        _endRefreshing = [RACSubject subject];
    }
    return _endRefreshing;
}
- (RACSubject *)refreshTableView {
    if (!_refreshTableView) {
        _refreshTableView = [RACSubject subject];
    }
    return _refreshTableView;
}

- (NSMutableArray<JHRecycleOrderCancelCellViewModel *> *)cellViewModels {
    if (!_cellViewModels) {
        _cellViewModels = [[NSMutableArray alloc] init];
        
    }
    return _cellViewModels;
}
@end
