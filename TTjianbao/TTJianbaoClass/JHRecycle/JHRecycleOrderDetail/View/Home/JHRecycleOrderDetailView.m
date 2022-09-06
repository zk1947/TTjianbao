//
//  JHRecycleOrderDetailView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailView.h"
#import "MJRefreshHeader.h"
#import "JHRecycleOrderDetailHeaderView.h"
#import "JHRecycleOrderDetailToolbar.h"
#import "JHRecycleOrderDetailStatusDescribeCell.h"
#import "JHRecycleOrderDetailCheckCell.h"
#import "JHRecycleOrderDetailArbitrationCell.h"
#import "JHRecycleOrderDetailAddressCell.h"
#import "JHRecycleOrderDetailProductCell.h"
#import "JHRecycleOrderDetailCell.h"
#import "JHRecycleOrderDetailServiceCell.h"
#import "JHRecycleOrderDetailBaseViewModel.h"
#import "JHRecycleOrderDetailModel.h"
#import "MBProgressHUD.h"
#import "JHRefreshGifHeader.h"
#import "JHRecycleOrderDetailStatusTitleCell.h"




@interface JHRecycleOrderDetailView()<UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 表头
@property (nonatomic, strong) JHRecycleOrderDetailHeaderView *headerView;
/// 底部工具栏
@property (nonatomic, strong) JHRecycleOrderDetailToolbar *toolBar;
/// model
@property (nonatomic, strong) JHRecycleOrderDetailModel *model;

@end

@implementation JHRecycleOrderDetailView

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self bindData];
        [self registerCells];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Action functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderDetailSectionViewModel *sectionViewModel = self.viewModel.cellViewModelList[indexPath.section];
     
    JHRecycleOrderDetailBaseViewModel *cellViewModel = sectionViewModel.cellViewModelList[indexPath.row];
    
    [cellViewModel.clickEvent sendNext:nil];
}
#pragma mark - Private Functions
- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self animated:true];
}
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.viewModel.refreshTableView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView jh_reloadDataWithEmputyView];
    }];
    [self.viewModel.startRefreshing subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self showProgressHUD];
    }];
    [self.viewModel.endRefreshing subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self hideProgressHUD];
    }];
    [self.viewModel.refreshCell subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        NSUInteger section = [x[0] integerValue];
        NSUInteger row = [x[1] integerValue];
        [self.tableView beginUpdates];
        [self.tableView reloadRow:row inSection:section
                 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.tableView];
    [self addSubview:self.toolBar];
}
- (void)layoutViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self).offset(0);
        make.bottom.equalTo(self.toolBar.mas_top).offset(0);
    }];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self).offset(0);
        make.height.mas_equalTo(44);
    }];
}

- (void)registerCells {
    [self.tableView registerClass:[JHRecycleOrderDetailStatusTitleCell class]
           forCellReuseIdentifier:@"JHRecycleOrderDetailStatusTitleCell"];
    [self.tableView registerClass:[JHRecycleOrderDetailStatusDescribeCell class]
           forCellReuseIdentifier:@"JHRecycleOrderDetailStatusDescribeCell"];
    [self.tableView registerClass:[JHRecycleOrderDetailCheckCell class]
           forCellReuseIdentifier:@"JHRecycleOrderDetailCheckCell"];
    [self.tableView registerClass:[JHRecycleOrderDetailArbitrationCell class]
           forCellReuseIdentifier:@"JHRecycleOrderDetailArbitrationCell"];
    [self.tableView registerClass:[JHRecycleOrderDetailAddressCell class]
           forCellReuseIdentifier:@"JHRecycleOrderDetailAddressCell"];
    [self.tableView registerClass:[JHRecycleOrderDetailProductCell class]
           forCellReuseIdentifier:@"JHRecycleOrderDetailProductCell"];
    [self.tableView registerClass:[JHRecycleOrderDetailServiceCell class]
           forCellReuseIdentifier:@"JHRecycleOrderDetailServiceCell"];
    [self.tableView registerClass:[JHRecycleOrderDetailCell class]
           forCellReuseIdentifier:@"JHRecycleOrderDetailCell"];
}
#pragma mark - Tableview Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.cellViewModelList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JHRecycleOrderDetailSectionViewModel *viewModel = self.viewModel.cellViewModelList[section];
    return viewModel.cellViewModelList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderDetailSectionViewModel *sectionViewModel = self.viewModel.cellViewModelList[indexPath.section];
     
    JHRecycleOrderDetailBaseViewModel *cellViewModel = sectionViewModel.cellViewModelList[indexPath.row];
    
    if (cellViewModel.cellType == RecycleOrderDetailStatusTitleCell) {
        JHRecycleOrderDetailStatusTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderDetailStatusTitleCell"
                                                                               forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHRecycleOrderDetailStatusTitleViewModel class]]) {
            cell.viewModel = (JHRecycleOrderDetailStatusTitleViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == RecycleOrderDetailStatusDescribeCell) {
        JHRecycleOrderDetailStatusDescribeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderDetailStatusDescribeCell"
                                                                               forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHRecycleOrderDetailStatusDescribeViewModel class]]) {
            cell.viewModel = (JHRecycleOrderDetailStatusDescribeViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == RecycleOrderDetailCheckCell) {
        JHRecycleOrderDetailCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderDetailCheckCell"
                                                                              forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHRecycleOrderDetailCheckViewModel class]]) {
            cell.viewModel = (JHRecycleOrderDetailCheckViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == RecycleOrderDetailArbitrationCell) {
        JHRecycleOrderDetailArbitrationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderDetailArbitrationCell"
                                                                                    forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHRecycleOrderDetailArbitrationViewModel class]]) {
            cell.viewModel = (JHRecycleOrderDetailArbitrationViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == RecycleOrderDetailAddressCell) {
        JHRecycleOrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderDetailAddressCell"
                                                                                forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHRecycleOrderDetailAddressViewModel class]]) {
            cell.viewModel = (JHRecycleOrderDetailAddressViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == RecycleOrderDetailProductCell) {
        JHRecycleOrderDetailProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderDetailProductCell"
                                                                                forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHRecycleOrderDetailProductViewModel class]]) {
            cell.viewModel = (JHRecycleOrderDetailProductViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == RecycleOrderDetailServiceCell) {
        JHRecycleOrderDetailServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderDetailServiceCell"
                                                                                forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHRecycleOrderDetailServiceViewModel class]]) {
            cell.viewModel = (JHRecycleOrderDetailServiceViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == RecycleOrderDetailInfoCell) {
        JHRecycleOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderDetailCell"
                                                                         forIndexPath: indexPath];
        [cell setupCornerRadiusWithRect:RecycleOrderDetailCornerNo];
        if ([cellViewModel isKindOfClass:[JHRecycleOrderDetailInfoViewModel class]]) {
            cell.viewModel = (JHRecycleOrderDetailInfoViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == RecycleOrderDetailInfoTopCell) {
        JHRecycleOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderDetailCell"
                                                                            forIndexPath: indexPath];
        [cell setupCornerRadiusWithRect:RecycleOrderDetailCornerTop];
        if ([cellViewModel isKindOfClass:[JHRecycleOrderDetailInfoViewModel class]]) {
            cell.viewModel = (JHRecycleOrderDetailInfoViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == RecycleOrderDetailInfoBottomCell) {
        JHRecycleOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderDetailCell"
                                                                               forIndexPath: indexPath];
        [cell setupCornerRadiusWithRect:RecycleOrderDetailCornerBottom];
        if ([cellViewModel isKindOfClass:[JHRecycleOrderDetailInfoViewModel class]]) {
            cell.viewModel = (JHRecycleOrderDetailInfoViewModel *)cellViewModel;
        }
        return cell;
    }
    

    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderDetailSectionViewModel *sectionViewModel = self.viewModel.cellViewModelList[indexPath.section];
     
    JHRecycleOrderDetailBaseViewModel *cellViewModel = sectionViewModel.cellViewModelList[indexPath.row];
    return cellViewModel.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.viewModel.cellViewModelList.count - 1 == section) {
        return 0.1f;
    }
    return 10.0f;
}
#pragma mark - Lazy

- (void)setOrderId:(NSString *)orderId {
    _orderId = orderId;
    self.viewModel.orderId = orderId;
    [self.viewModel getOrderDetailInfo];
}
- (JHRecycleOrderDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHRecycleOrderDetailViewModel alloc] init];
        
    }
    return _viewModel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F8"];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel getOrderDetailInfo];
        }];
    }
    return _tableView;
}
- (JHRecycleOrderDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JHRecycleOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 108)];
        _headerView.viewModel = self.viewModel.headerViewModel;
    }
    return _headerView;
}
- (JHRecycleOrderDetailToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[JHRecycleOrderDetailToolbar alloc] initWithFrame:CGRectZero];
        _toolBar.viewModel = self.viewModel.toolbarViewModel;
    }
    return _toolBar;
}
@end
