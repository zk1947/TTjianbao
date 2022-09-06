//
//  JHUserInfoEvaluateController.m
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserInfoEvaluateController.h"
#import "JHUserInfoEvaluateTableViewCell.h"
#import "YDRefreshFooter.h"
#import <MJRefresh.h>
#import "JHUserInfoEvaluatViewModel.h"
#import "JHUserInfoEvaluateModel.h"
#import "JHUserInfoViewController.h"

@interface JHUserInfoEvaluateController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHUserInfoEvaluatViewModel *evaluatViewModel;
@end

@implementation JHUserInfoEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //加载数据
    [self updateLoadData:YES];
    [self configData];
}

#pragma mark - UI

#pragma mark - LoadData
- (void)updateLoadData:(BOOL)isRefresh {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"imageType"] = @"s,m,b,o";
    dicData[@"isRefresh"] = @(isRefresh);
    dicData[@"customerId"] = self.userId;
    [self.evaluatViewModel.userInfoEvaluatCommand execute:dicData];
}

- (void)loadMoreData{
    [self updateLoadData:NO];
}

- (void)configData{
    @weakify(self)
    //刷新数据
    [self.evaluatViewModel.updateEvaluatListSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        //刷新数据，判断空页面
        [self.tableView jh_reloadDataWithEmputyView];
        //当数据超过一屏后才显示“已经到底”文案
        if (self.evaluatViewModel.evaluatListDataArray.count > 5) {
            ((YDRefreshFooter *)_tableView.mj_footer).showNoMoreString = YES;
        }

    }];
    //更多数据
    [self.evaluatViewModel.moreEvaluatListSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
    //没有更多数据
    [self.evaluatViewModel.noMoreDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    //请求出错
    [self.evaluatViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - Action

#pragma mark - Delegate
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.evaluatViewModel.evaluatListDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHUserInfoEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHUserInfoEvaluateTableViewCell class]) forIndexPath:indexPath];
    JHEvaluateresultListModel *dataModel = self.evaluatViewModel.evaluatListDataArray[indexPath.row];
    [cell bindViewModel:dataModel params:nil];
    @weakify(self)
    cell.userInfoClick = ^{
        @strongify(self)
        JHUserInfoViewController *userInfoVC = [[JHUserInfoViewController alloc] init];
        userInfoVC.userId = dataModel.customerId;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    };
    cell.openClickBlock = ^{  //展开
        @strongify(self)
        JHEvaluateresultListModel *dataModel = self.evaluatViewModel.evaluatListDataArray[indexPath.row];
        dataModel.isOpen = YES;
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];

        
    };
    return cell;
}

#pragma mark - 分页逻辑
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}
#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark - Lazy

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.backgroundColor = kColorF5F6FA;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JHUserInfoEvaluateTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHUserInfoEvaluateTableViewCell class])];

        _tableView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
            _tableView.scrollIndicatorInsets =_tableView.contentInset;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }

    }
    return  _tableView;
}
- (JHUserInfoEvaluatViewModel *)evaluatViewModel{
    if (!_evaluatViewModel) {
        _evaluatViewModel = [[JHUserInfoEvaluatViewModel alloc] init];
    }
    return _evaluatViewModel;
}
@end
