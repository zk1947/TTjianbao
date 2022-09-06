//
//  JHSQPlateListController.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPlateListController.h"
#import "JHWebViewController.h"
#import "JHPlateListTableViewCell.h"
#import "JHSQApiManager.h"
#import "JHPlateListModel.h"
#import "JHSQManager.h"
#import "UIScrollView+JHEmpty.h"

@interface JHSQPlateListController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

///存放版块信息的数组
@property (nonatomic, strong) NSMutableArray <JHPlateListData *> *dataArray;

/// 当前头部状态
@property (nonatomic, assign) BOOL upOnce;
@end

@implementation JHSQPlateListController

#pragma mark - Life Cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [JHHomeTabController changeStatusWithMainScrollView:self.tableView index:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.upOnce = [[NSUserDefaults standardUserDefaults] boolForKey:@"HeadSearchStatus"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(F5F6FA);
    [self loadData];
    [self addTableViewScrollObserver];
}

- (void)addTableViewScrollObserver{
    @weakify(self);
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        CGPoint offset = [x CGPointValue];
        CGFloat scrollY = offset.y;
        //向上临界一次
        if (!self.upOnce && scrollY>30) {
            self.upOnce = YES;
            if (self.headScrollBlock) {
                self.headScrollBlock(YES);
            }
        }
        //向下临界一次
        if (self.upOnce && scrollY<0) {
            self.upOnce = NO;
            if (self.headScrollBlock) {
                self.headScrollBlock(NO);
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JHPlateListTableViewCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHPlateListTableViewCell *cell = [JHPlateListTableViewCell dequeueReusableCellWithTableView:tableView];
    cell.model = SAFE_OBJECTATINDEX(self.dataArray, indexPath.row);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHPlateListData *data = SAFE_OBJECTATINDEX(self.dataArray, indexPath.row);
    if(data)
    {
        [JHRouterManager pushPlateDetailWithPlateId:data.channel_id pageType:self.pageType];
        [JHAllStatistics jh_allStatisticsWithEventId:@"channellist_enter" params:data.mj_keyValues type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
    }
}

-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine target:self addToSuperView:self.view];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorColor = APP_BACKGROUND_COLOR;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        @weakify(self);
        [_tableView jh_headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadData];
        } footerWithRefreshingBlock:nil];
    }
    return _tableView;
}

- (NSMutableArray<JHPlateListData *> *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)loadData {
    @weakify(self);
    [JHSQApiManager getPlateList:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self.tableView jh_endRefreshing];
        if (!hasError && IS_ARRAY(respObj)) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:respObj];
            [self.tableView reloadData];
        }
    }];
}

///tabBar点击
- (void)handleTabBarClick {
    
    if(self.tableView.mj_header.state == MJRefreshStateIdle)
    {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}


@end
