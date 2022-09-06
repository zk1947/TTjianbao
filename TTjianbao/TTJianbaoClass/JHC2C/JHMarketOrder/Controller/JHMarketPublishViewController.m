//
//  JHMarketPublishViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketPublishViewController.h"
#import "JHMarketPublishCell.h"
#import "JHMarketPublishModel.h"
#import "JHEmptyTableViewCell.h"
#import "YDRefreshFooter.h"
#import "JHMarketAnimalView.h"
#import "JHMarketOrderViewModel.h"
#import "JHC2CSelectClassViewController.h"
#import "JHC2CProductDetailController.h"
#import "JHIssueGoodsEditModel.h"
#import "JHC2CUploadProductController.h"

@interface JHMarketPublishViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <JHMarketPublishModel *>*listArray;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
/** 仪表盘*/
@property (nonatomic, strong) JHMarketAnimalView *headerView;
/** 计时器*/
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JHMarketPublishViewController
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
    for (JHMarketPublishCell *cell in cellArray) {
        [cell refreshTimerUI];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(refreshData) name:@"JHMarketAnimalView_refersh" object:nil];
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
    
    if (self.productStatus == 0) {
        self.headerView.frame = CGRectMake(0, 0, ScreenW, 187);
        self.tableView.tableHeaderView = self.headerView;
    }
    
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
    params[@"productStatus"] = @(self.productStatus);
    params[@"imageType"] = @"s";
    [JHMarketOrderViewModel getPublishList:params Completion:^(NSError * _Nullable error, NSArray<JHMarketPublishModel *> * _Nullable array, NSInteger exposureNum, BOOL polished) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!error) {
            //擦亮视图
            self.headerView.scoreLabel.text = [NSString stringWithFormat:@"%ld", exposureNum];
            self.headerView.exposeButton.selected = polished;
            
            
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
            
            if (self.productStatus == 0) {
                if (self.listArray.count > 0) {
                    self.headerView.frame = CGRectMake(0, 0, ScreenW, 187);
                } else {
                    self.headerView.frame = CGRectMake(0, 0, ScreenW, 0);
                }
            }
            [self.tableView reloadData];
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

/// 刷新单条数据
- (void)loadSingleDataWithOrderId:(NSString *)productId indexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = productId;
    params[@"imageType"] = @"s";
    [SVProgressHUD show];
    [JHMarketOrderViewModel getSinglePublishList:params Completion:^(NSError * _Nullable error, NSArray<JHMarketPublishModel *> * _Nullable array) {
        [SVProgressHUD dismiss];
        if (!error) {
            if (array.count > 0) {
                JHMarketPublishModel *model = array.firstObject;
                JHMarketPublishCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.publishModel = model;
                self.listArray[indexPath.row] = model;
            }
        } else {
            JHTOAST(error.localizedDescription);
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
        cell.emptyLabel.text = @"抱歉,暂无相关商品";
        [cell.emptyButton setTitle:@"去发布" forState:UIControlStateNormal];
        cell.emptyButton.hidden = NO;
        @weakify(self);
        cell.buttonClickActionBlock = ^{
            @strongify(self); //点击去发布按钮
            JHC2CSelectClassViewController *uploadVc = [[JHC2CSelectClassViewController alloc] init];
            [self.navigationController pushViewController:uploadVc animated:YES];
        };
        return cell;
    }
    JHMarketPublishModel *model = self.listArray[indexPath.row];
    JHMarketPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMarketPublishCell"];
    cell.publishModel = model;
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
            [self loadSingleDataWithOrderId:model.productId indexPath:indexPath];
        }
    };
    
    cell.issueEditBlock = ^(JHIssueGoodsEditModel * _Nonnull model) {
        @strongify(self);
        [self gotoEditPage:model];
    };
    
    return cell;
}

- (void)gotoEditPage:(JHIssueGoodsEditModel *)model{
    JHC2CUploadProductController *uploadProductVC = [[JHC2CUploadProductController alloc] init];
    uploadProductVC.firstCategoryId = [NSString stringWithFormat:@"%d",model.firstCategoryId];
    uploadProductVC.firstCategoryName = model.firstCategoryName;
    uploadProductVC.secondCategoryId = [NSString stringWithFormat:@"%d",model.secondCategoryId];
    uploadProductVC.secondCategoryName = model.secondCategoryName;
    uploadProductVC.thirdCategoryId = [NSString stringWithFormat:@"%d",model.thirdCategoryId];
    uploadProductVC.thirdCategoryName = model.thirdCategoryName;
    uploadProductVC.editModel = model;
    [self.navigationController pushViewController:uploadProductVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        return;
    }
    JHMarketPublishModel *model = self.listArray[indexPath.row];
    JHC2CProductDetailController *productVc = [[JHC2CProductDetailController alloc] init];
    productVc.productId = model.productId;
    [self.navigationController pushViewController:productVc animated:YES];
}

- (JHMarketAnimalView *)headerView {
    if (_headerView == nil) {
        _headerView = [[JHMarketAnimalView alloc] init];
    }
    return _headerView;
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
        [_tableView registerClass:[JHMarketPublishCell class] forCellReuseIdentifier:@"JHMarketPublishCell"];
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

- (NSMutableArray<JHMarketPublishModel *> *)listArray {
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
