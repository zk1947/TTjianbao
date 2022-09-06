//
//  JHRecycleMinePublishedViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleMinePublishedViewController.h"
#import "JHEmptyTableViewCell.h"
#import "JHRecyclePublishedCell.h"
#import "JHRecyclePublishedModel.h"
#import "JHRefreshGifHeader.h"
#import "JHRecyclePublishedViewModel.h"
#import "SVProgressHUD.h"
#import "YDRefreshFooter.h"
#import "JHRecycleUploadTypeSeleteViewController.h"
#import "JHRecycleDetailViewController.h"

@interface JHRecycleMinePublishedViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <JHRecyclePublishedModel *>*listArray;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
/** 计时器*/
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation JHRecycleMinePublishedViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    //    加入运行循环
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    [self refreshData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
// 计时器跳动 刷新cellUI
- (void)timeFireMethod {
    NSArray *cellArray = [self.tableView visibleCells];
    if (cellArray.count > 0) {
        if ([cellArray.firstObject isKindOfClass:[JHEmptyTableViewCell class]]) {
            return;
        }
    }
    for (JHRecyclePublishedCell *cell in cellArray) {
        [cell refreshTimerUI];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.pageSize = 10;
    self.jhNavView.hidden = YES;
    self.view.backgroundColor = HEXCOLOR(0xf5f5f8);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
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
    params[@"listType"] = self.listType;
    params[@"imageType"] = @"s";
    [JHRecyclePublishedViewModel getPublishedList:params Completion:^(NSError * _Nullable error, NSArray<JHRecyclePublishedModel *> * _Nullable array) {
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
        cell.emptyLabel.text = @"抱歉,暂无相关回收商品";
        [cell.emptyButton setTitle:@"去发布" forState:UIControlStateNormal];
        cell.emptyButton.hidden = NO;
        @weakify(self);
        cell.buttonClickActionBlock = ^{
            @strongify(self); //点击去发布按钮
            JHRecycleUploadTypeSeleteViewController *uploadVc = [[JHRecycleUploadTypeSeleteViewController alloc] init];
            [self.navigationController pushViewController:uploadVc animated:YES];
        };
        return cell;
    }
    JHRecyclePublishedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecyclePublishedCell"];
    cell.model = self.listArray[indexPath.row];
    @weakify(self);
    cell.reloadDataBlock = ^{
        @strongify(self);
        [self.listArray removeObjectAtIndex:indexPath.row];
        NSMutableArray *indexPathArray = [NSMutableArray arrayWithObject:indexPath];
        if (self.listArray.count > 0) {
            [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        return;
    }
    
    JHRecyclePublishedModel *model = self.listArray[indexPath.row];
    JHRecycleDetailViewController *detailVc = [[JHRecycleDetailViewController alloc] init];
    detailVc.productId = model.productId;
    detailVc.identityType = 2;
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
        [_tableView registerClass:[JHRecyclePublishedCell class] forCellReuseIdentifier:@"JHRecyclePublishedCell"];
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

- (NSMutableArray<JHRecyclePublishedModel *> *)listArray {
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
