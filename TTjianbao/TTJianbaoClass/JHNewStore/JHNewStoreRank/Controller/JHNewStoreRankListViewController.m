//
//  JHNewStoreRankListViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreRankListViewController.h"
#import "JHStoreRankListCell.h"
#import "UIView+JHGradient.h"
#import "JHRefreshGifHeader.h"
#import "JHRefreshNormalFooter.h"
#import "JHStoreRankListModel.h"
#import "JHStoreRankListViewModel.h"
#import "SVProgressHUD.h"
#import "JHEmptyTableViewCell.h"
#import "JHNewShopDetailViewController.h"

@interface JHNewStoreRankListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <JHStoreRankListModel *>*listArray;
@end

@implementation JHNewStoreRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhNavView.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(12);
        make.right.mas_equalTo(self.view).offset(-12);
    }];
    [self loadNewData];
    
}

- (void)loadNewData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tagId"] = self.tagId;
    [SVProgressHUD show];
    [JHStoreRankListViewModel getRankStoreList:params Completion:^(NSError * _Nullable error, NSArray<JHStoreRankListModel *> * _Nullable array) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if (!error) {
            self.listArray = array;
            [self.tableView reloadData];
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
    JHStoreRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreRankListCell"];
    cell.model = self.listArray[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        return;
    }
    JHStoreRankListModel *model = self.listArray[indexPath.row];
    JHNewShopDetailViewController *detailVc = [[JHNewShopDetailViewController alloc] init];
    detailVc.shopId = model.storeId;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[JHStoreRankListCell class] forCellReuseIdentifier:@"JHStoreRankListCell"];
        [_tableView registerClass:[JHEmptyTableViewCell class] forCellReuseIdentifier:@"JHEmptyTableViewCell"];
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadNewData];
        }];
    }
    return _tableView;
}

#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}
@end
