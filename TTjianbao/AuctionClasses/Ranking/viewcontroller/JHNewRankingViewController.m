//
//  JHNewRankingViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/3/5.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHNewRankingViewController.h"
#import "JHOrderSortTableViewCell.h"
#import "JHRankingModel.h"
#import "JHNewRankingHeaderView.h"
#import "JHWebViewController.h"
#import "BannerMode.h"

@interface JHNewRankingViewController ()<UITableViewDelegate, UITableViewDataSource,JHNewRankingHeaderViewDelegate>
@property (nonatomic, strong) NSMutableArray<JHRankingDataModel *> *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) JHNewRankingHeaderView *headerView;
@end

@implementation JHNewRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xffffff);
    [self makeUI];
}
- (void)viewDidLayoutSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0,49+UI.bottomSafeAreaHeight, 0));
    }];
}
- (void)setHeaderView
{
    _headerView=[[JHNewRankingHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    _headerView.delegate=self;
    [_headerView layoutIfNeeded];
    _headerView.frame=CGRectMake(0, 0, ScreenW,_headerView.contentView.height);
}
- (void)makeUI {
    
    [self setHeaderView];
    [self.view addSubview:self.tableView];
//    [self  initToolsBar];
    //此类未用到
//    [self.navbar addNavImage:[UIImage imageNamed:@"rank_title_image"]];
    //[self.navbar setTitle:@"排行榜"];
//    [self showDefaultImageWithView:self.tableView];
    // [self setNavImage];
}

#pragma mark - GET

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHOrderSortTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"JHOrderSortTableViewCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 120;
        
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _tableView.mj_header = header;
        
        [_tableView.mj_header beginRefreshing];
        _tableView.tableHeaderView = self.headerView;
        header.automaticallyChangeAlpha = YES;

    }
    return _tableView;
}

#pragma mark - JHNewRankingHeaderViewDelegate
-(void)bannerTap:(BannerMode*)banner{
   
    if ([banner.picLink length]!=0) {
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.titleString = @"";
        vc.urlString = banner.picLink;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].reportRankingList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHOrderSortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHOrderSortTableViewCell"];
    cell.tag = indexPath.row;
    cell.model = self.dataArray[indexPath.section].reportRankingList[indexPath.row];
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return self.dataArray[section].rankingTitle;
//
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 50)];
    label.textColor = HEXCOLOR(0x000000);
    label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:22];
    [view addSubview:label];
    label.text = self.dataArray[section].rankingTitle;
    view.backgroundColor = self.view.backgroundColor;
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHRankingNewModel *model = self.dataArray[indexPath.section].reportRankingList[indexPath.row];

    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), model.Id];
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
}
#pragma mark - 请求数据
- (void)loadOneData {
    _pageNo = 0;
    _pageSize = 20;
    [self requestData];
    [self requestBanners];
}

- (void)loadMoreData {
    _pageNo ++;
    _pageSize = 20;
    [self requestData];
}
- (void)requestBanners{
    
    [HttpRequestTool getWithURL: FILE_BASE_STRING(@"/index/bannerData?bannerType=ranking") Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSMutableArray *bannerModes=[NSMutableArray arrayWithCapacity:10];
        bannerModes = [BannerMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.headerView setBanners:bannerModes];
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
    }];
}
- (void)requestData {
    NSDictionary *parameters = @{@"pageNo":@(_pageNo),@"pageSize":@(_pageSize),@"unit":@"week"};
    NSString *url = FILE_BASE_STRING(@"/report/authoptional/reportRanking");
    
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel *respondObject) {
        [self dealDataWithDic:respondObject.data];
        [self endRefresh];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self endRefresh];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
}
- (void)endRefresh {
    
    if (self.dataArray.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.tableView];
    }
    
}
- (void)dealDataWithDic:(NSArray *)array {
    
    NSArray *arr = [JHRankingDataModel mj_objectArrayWithKeyValuesArray:array];
    if (arr.count) {
        if (self.pageNo == 0) {
            self.dataArray = [NSMutableArray arrayWithArray:arr];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
        }else {
            [self.dataArray addObjectsFromArray:arr];
            [_tableView.mj_footer endRefreshing];
        }
        
    }else {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    CGFloat contentH = self.tableView.tableHeaderView.mj_h+120*self.dataArray.count;
    CGFloat fH = self.tableView.mj_h-contentH;
    self.tableView.tableFooterView.mj_h = fH>0?fH:0;
    [self.tableView reloadData];
}

@end
