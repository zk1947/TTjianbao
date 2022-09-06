//
//  JHStoreListViewController.m
//  TTjianbao
//
//  Created by zk on 2021/10/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreListViewController.h"
#import "JHStoreListCell.h"
#import "JHStoreListModel.h"
#import "YDRefreshFooter.h"
#import "JHNewShopDetailViewController.h"
#import "JHStoreListBusiness.h"
#import "JHMarketFloatLowerLeftView.h"

static CGFloat const NullDataViewHeight = 44.f;
@interface JHStoreListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray  *dataSourceArray;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic,   copy) NSString *isMallProduct;//是否有数据
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;//收藏返回顶部view

@end

@implementation JHStoreListViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //收藏等数据刷新
    [self.floatView loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isMallProduct = @"1";
    
    [self setupView];

    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadData{
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSDictionary *param = @{
        @"pageNo":@(self.pageIndex),
        @"pageSize":@(20),
        @"searchType":@"3",
        @"isMallProduct":self.isMallProduct,
        @"customerId":@([user.customerId integerValue]),
        @"searchWord":self.keyword,
        @"cateId":@(self.cateId),//关键词分类id
        @"tagWord":self.searchTextfield.recommendTagsArray.count > 0 ? self.self.searchTextfield.recommendTagsArray : @[],//关键词
    };
    @weakify(self);
    [JHStoreListBusiness loadData:param completion:^(NSError * _Nullable error, NSArray * _Nullable resourceArr, NSString *_Nullable isHaveData) {
        @strongify(self);
        [self endRefresh];
        if (!error) {
            if (self.pageIndex == 0) {
                [self.dataSourceArray removeAllObjects];
                //无数据文案
                self.isMallProduct = isHaveData;
                if ([isHaveData boolValue]) {
                    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view);
                    }];
                } else {
                    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view).offset(NullDataViewHeight);
                    }];
                }
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
///重写父类方法
- (void)reloadSubViewData{
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupView{
    //无数据说明文案
    [self.view addSubview:self.nullDataLabel];
    [self.nullDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(NullDataViewHeight);
    }];
    
    //列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //右下角浮窗按钮
    [self.view addSubview:self.floatView];
    
    @weakify(self);
    self.tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pageIndex = 0;
        self.isMallProduct = @"1";
        [self loadData];
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 69;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXCOLOR(0xF8F8F8);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
            _tableView.scrollIndicatorInsets =_tableView.contentInset;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }

        [_tableView registerClass:[JHStoreListCell class] forCellReuseIdentifier:NSStringFromClass([JHStoreListCell class])];
        _tableView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _tableView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    BOOL goTopHidden = offsetY <= 100;
    self.floatView.topButton.hidden = goTopHidden;
}

#pragma mark - Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHStoreListModel *model = self.dataSourceArray[indexPath.row];
    return model.productList.count > 0 ? 186 : 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHStoreListCell class])];
    if (!cell) {
        cell = [[JHStoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHStoreListCell class])];
    }
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreListModel *model = self.dataSourceArray[indexPath.row];
    JHNewShopDetailViewController *detailVc = [[JHNewShopDetailViewController alloc] init];
    detailVc.shopId = [NSString stringWithFormat:@"%ld",model.ID];
    [self.navigationController pushViewController:detailVc animated:YES];
    
    //埋点
    NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
    sensorsDic[@"store_seller_id"] = [NSString stringWithFormat:@"%ld",model.ID];
    sensorsDic[@"store_name"] = model.shopName;
    sensorsDic[@"tab_name"] = self.titleArray[self.titleTagIndex];
    if (self.fromSource == JHSearchFromStore) {
        sensorsDic[@"page_position"] = @"商城搜索结果页";
    } else if (self.fromSource == JHSearchFromLive) {
        sensorsDic[@"page_position"] = @"直播搜索结果页";
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickStoreFeeds" params:sensorsDic type:JHStatisticsTypeSensors];
    
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (JHMarketFloatLowerLeftView *)floatView{
    if (!_floatView) {
        _floatView = [[JHMarketFloatLowerLeftView alloc] initWithShowType:JHMarketFloatShowTypeBackTop];
        _floatView.isHaveTabBar = NO;
        @weakify(self)
        //返回顶部
        _floatView.backTopViewBlock = ^{
            @strongify(self)
            if (self.dataSourceArray.count > 0) {
                NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        };
    }
    return _floatView;
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
