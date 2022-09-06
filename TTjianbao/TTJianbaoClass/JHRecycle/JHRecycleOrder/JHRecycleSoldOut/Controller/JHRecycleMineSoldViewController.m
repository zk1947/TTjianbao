//
//  JHRecycleMineSoldViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleMineSoldViewController.h"
#import "JHEmptyTableViewCell.h"
#import "JHRecycleSoldCell.h"
#import "JHRecycleSoldModel.h"
#import "JHRefreshGifHeader.h"
#import "JHRecycleSoldViewModel.h"
#import "SVProgressHUD.h"
#import "YDRefreshFooter.h"
#import "JHRecycleOrderDetailViewController.h"
//#import "JHRecycleUploadTypeSeleteViewController.h"
//#import "JHRecycleHomeViewController.h"
#import "JHRootNotification.h"

@interface JHRecycleMineSoldViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <JHRecycleSoldModel *>*listArray;
/** 计时器*/
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@end


@implementation JHRecycleMineSoldViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    //    加入运行循环
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
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
    for (JHRecycleSoldCell *cell in cellArray) {
        [cell refreshTimerUI];
    }
}
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
    params[@"imageType"] = @"s";
    [JHRecycleSoldViewModel getSoldList:params Completion:^(NSError * _Nullable error, NSArray<JHRecycleSoldModel *> * _Nullable array) {
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

/// 刷新单条数据
- (void)loadSingleDataWithOrderId:(NSString *)orderId indexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = orderId;
    params[@"imageType"] = @"s";
    [SVProgressHUD show];
    [JHRecycleSoldViewModel getSoldList:params Completion:^(NSError * _Nullable error, NSArray<JHRecycleSoldModel *> * _Nullable array) {
        [SVProgressHUD dismiss];
        if (!error) {
            if (array.count > 0) {
                JHRecycleSoldModel *model = array.firstObject;
                JHRecycleSoldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.model = model;
                self.listArray[indexPath.row] = model;
            }
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
        cell.emptyLabel.text = @"抱歉,暂无相关回收订单";
        [cell.emptyButton setTitle:@"我想卖" forState:UIControlStateNormal];
        cell.emptyButton.hidden = NO;
        @weakify(self);
        cell.buttonClickActionBlock = ^{
            @strongify(self);
            //点击去发布按钮
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSDictionary *dic = @{
                @"selectedIndex":@"3",
                @"item_type":@"1"
            };
            [JHNotificationCenter postNotificationName:@"POST_JHHOMETABCONTROLLER" object:dic];
            [JHNotificationCenter postNotificationName:JHHomePageIndexChangedNotification object:dic];
        };
        return cell;
    }
    JHRecycleSoldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleSoldCell"];
    JHRecycleSoldModel *model = self.listArray[indexPath.row];
    cell.model = model;
    @weakify(self);
    cell.reloadCellDataBlock = ^(BOOL iSdelete) {
        @strongify(self);
        if (iSdelete) {
            [self.listArray removeObjectAtIndex:indexPath.row];
            NSMutableArray *indexPathArray = [NSMutableArray arrayWithObject:indexPath];
            if (self.listArray.count > 0) {
                [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            [self loadSingleDataWithOrderId:model.orderId indexPath:indexPath];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        return;
    }
    JHRecycleSoldModel *model = self.listArray[indexPath.row];
    JHRecycleOrderDetailViewController *orderDetailView = [[JHRecycleOrderDetailViewController alloc] init];
    orderDetailView.orderId = model.orderId;
    @weakify(self);
    orderDetailView.reloadData = ^(BOOL isDelete) {   //订单状态改变,刷新UI
        @strongify(self);
        if (!isDelete) {
            [self.listArray removeObjectAtIndex:indexPath.row];
            NSMutableArray *indexPathArray = [NSMutableArray arrayWithObject:indexPath];
            if (self.listArray.count > 0) {
                [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            [self loadSingleDataWithOrderId:model.orderId indexPath:indexPath];
        }
    };
    [self.navigationController pushViewController:orderDetailView animated:YES];
    
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
        [_tableView registerClass:[JHRecycleSoldCell class] forCellReuseIdentifier:@"JHRecycleSoldCell"];
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

- (NSMutableArray<JHRecycleSoldModel *> *)listArray {
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
