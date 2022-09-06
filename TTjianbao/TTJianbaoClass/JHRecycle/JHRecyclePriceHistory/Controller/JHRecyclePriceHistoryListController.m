//
//  JHRecyclePriceListController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePriceHistoryListController.h"
#import "JHEmptyTableViewCell.h"
#import "JHRecyclePriceHistoryCell.h"
#import "JHRecyclePriceHistoryModel.h"
#import "SVProgressHUD.h"
#import "YDRefreshFooter.h"
#import "JHRefreshGifHeader.h"
#import "JHRecyclePriceHistoryViewModel.h"
#import "JHRecycleDetailViewController.h"

@interface JHRecyclePriceHistoryListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <JHRecyclePriceHistoryModel *>*listArray;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@end

@implementation JHRecyclePriceHistoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.pageSize = 10;
    self.jhNavView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    [self refreshData];
}

- (void)refreshData {
    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [SVProgressHUD show];
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNo"] = @(self.pageNo);
    params[@"pageSize"] = @(self.pageSize);
    params[@"bidStatus"] = self.bidStatus;
    params[@"imageType"] = @"s";
    [JHRecyclePriceHistoryViewModel getPriceHistoryList:params Completion:^(NSError * _Nullable error, NSArray<JHRecyclePriceHistoryModel *> * _Nullable array) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!error) {
            if (self.pageNo == 1) {
                self.listArray = [NSMutableArray arrayWithArray:array];
            } else {
                [self.listArray addObjectsFromArray:array];
            }
            if (array.count < self.pageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.pageNo += 1;
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        } else {
            
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count ? self.listArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.listArray.count ? UITableViewAutomaticDimension : self.tableView.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        JHEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHEmptyTableViewCell"];
        cell.backgroundColor = HEXCOLOR(0xf5f5f8);
        return cell;
    }
    JHRecyclePriceHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecyclePriceHistoryCell"];
    cell.model = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        return;
    }
    JHRecyclePriceHistoryModel *model = self.listArray[indexPath.row];
    JHRecycleDetailViewController *detailVc = [[JHRecycleDetailViewController alloc] init];
    detailVc.fromSource = @"JHRecyclePriceHistoryListController";
    detailVc.productId = model.productId;
    detailVc.identityType = 1;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f8);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[JHRecyclePriceHistoryCell class] forCellReuseIdentifier:@"JHRecyclePriceHistoryCell"];
        [_tableView registerClass:[JHEmptyTableViewCell class] forCellReuseIdentifier:@"JHEmptyTableViewCell"];
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refreshData];
        }];
        _tableView.mj_footer = [YDRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadData];
        }];
        ((YDRefreshFooter *)_tableView.mj_footer).showNoMoreString = YES;
    }
    return _tableView;
}

- (NSMutableArray<JHRecyclePriceHistoryModel *> *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end
