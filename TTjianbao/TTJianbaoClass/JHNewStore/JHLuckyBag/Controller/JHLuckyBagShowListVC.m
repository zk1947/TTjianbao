//
//  JHLuckyBagShowListVC.m
//  TTjianbao
//
//  Created by zk on 2021/11/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagShowListVC.h"
#import "JHLuckyBagShowModel.h"
#import "JHLuckyBagShowListCell.h"
#import "JHLuckyBagBusiniss.h"
#import "YDRefreshFooter.h"

@interface JHLuckyBagShowListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray  *dataSourceArray;/** 数据源 */

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation JHLuckyBagShowListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageIndex = 1;
    [self setupView];
    [self loadData];
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(self.pageIndex) forKey:@"pageNo"];
    [param setObject:@(20) forKey:@"pageSize"];
    @weakify(self);
    [JHLuckyBagBusiniss loadShowListData:param completion:^(NSError * _Nullable error, NSArray * _Nullable resourceArr) {
        @strongify(self);
        [self endRefresh];
        if (!error) {
            if (self.pageIndex == 1) {
                [self.dataSourceArray removeAllObjects];
            }
            [self.dataSourceArray addObjectsFromArray:resourceArr];
            //当数据超过一屏后才显示“已经到底”文案
            if (resourceArr.count > 4) {
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
    [self removeNavView];
    self.view.backgroundColor = HEXCOLOR(0xF7F7F7);
    //列表
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headView;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
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
        _tableView.backgroundColor                 = [UIColor clearColor];
        _tableView.separatorStyle                  = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight   = 0.1f;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_tableView registerClass:[JHLuckyBagShowListCell class] forCellReuseIdentifier:NSStringFromClass([JHLuckyBagShowListCell class])];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
#ifdef __IPHONE_15_0
        if(@available(iOS 15.0,*)){
            _tableView.sectionHeaderTopPadding=0;
        }
#endif
        _tableView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _tableView;
}

#pragma mark - Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHLuckyBagShowListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHLuckyBagShowListCell class])];
    if (!cell) {
        cell = [[JHLuckyBagShowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHLuckyBagShowListCell class])];
    }
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

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
