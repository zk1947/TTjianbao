//
//  JHLuckyBagRewardListView.m
//  TTjianbao
//
//  Created by zk on 2021/11/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagRewardListView.h"
#import "JHLuckyBagRewardModel.h"
#import "JHLuckyBagRewardCell.h"
#import "JHLuckyBagBusiniss.h"
#import "YDRefreshFooter.h"

@interface JHLuckyBagRewardListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray  *dataSourceArray;/** 数据源 */

@end

@implementation JHLuckyBagRewardListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageIndex = 1;
        [self setupView];
//        [self loadData];
    }
    return self;
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(self.pageIndex) forKey:@"pageNo"];
    [param setObject:@(20) forKey:@"pageSize"];
    @weakify(self);
    [JHLuckyBagBusiniss loadRewardData:param completion:^(NSError * _Nullable error, NSArray * _Nullable resourceArr) {
        @strongify(self);
        [self endRefresh];
        if (!error) {
            if (self.pageIndex == 1) {
                [self.dataSourceArray removeAllObjects];
            }
            [self.dataSourceArray addObjectsFromArray:resourceArr];
            //当数据超过一屏后才显示“已经到底”文案
            if (resourceArr.count > 10) {
                ((YDRefreshFooter *)_tableView.mj_footer).showNoMoreString = YES;
            }
            if (resourceArr.count > 0) {
                self.pageIndex += 1;
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView jh_reloadDataWithEmputyView];
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)setupView{
    self.backgroundColor = HEXCOLOR(0xF7F7F7);
    //列表
    [self addSubview:self.tableView];
    [self.tableView jh_cornerRadius:8];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    @weakify(self);
    self.tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pageIndex = 1;
        [self loadData];
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView                               = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource                     = self;
        _tableView.delegate                       = self;
        _tableView.backgroundColor                 = [UIColor whiteColor];
        _tableView.separatorStyle                  = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight   = 0.1f;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
//            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
#ifdef __IPHONE_15_0
        if(@available(iOS 15.0,*)){
            _tableView.sectionHeaderTopPadding=0;
        }
#endif
        [_tableView registerClass:[JHLuckyBagRewardCell class] forCellReuseIdentifier:NSStringFromClass([JHLuckyBagRewardCell class])];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        _tableView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _tableView;
}

#pragma mark - Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.isOnAlert ? 57 : 63;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHLuckyBagRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHLuckyBagRewardCell class])];
    if (!cell) {
        cell = [[JHLuckyBagRewardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHLuckyBagRewardCell class])];
    }
    cell.isOnAlert = self.isOnAlert;
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)setIsOnAlert:(BOOL)isOnAlert{
    _isOnAlert = isOnAlert;
    if (_isOnAlert) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.tableView reloadData];
    }
}

@end
