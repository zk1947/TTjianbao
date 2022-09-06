//
//  RankingViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2018/11/26.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "RankingViewController.h"
#import "JHRankingCell.h"
#import "JHRankingModel.h"
#import "JHReportViewController.h"
#import "JHWebViewController.h"

@interface RankingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) UIView *footer;
@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:@""];
//    [self.navbar setTitle:@"排行榜"];
    self.title = @"排行榜";
    [self makeUI];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)makeUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 50, 0));
    }];

    self.footer = [[UIView alloc] init];
    self.footer.backgroundColor = kGlobalThemeColor;
    self.tableView.tableFooterView = self.footer;

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEXCOLOR(0xFFFDF3);
    [self.footer addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.footer);
        make.leading.equalTo(self.footer).offset(15);
        make.trailing.equalTo(self.footer).offset(-15);

    }];
    self.tableView.tableFooterView.mj_h = ScreenH-50-self.tableView.tableHeaderView.mj_h;
    
}

#pragma mark - GET

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHRankingCell class]) bundle:nil] forCellReuseIdentifier:@"JHRankingCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 45;
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _tableView.mj_header = header;
        [_tableView.mj_header beginRefreshing];
        header.automaticallyChangeAlpha = YES;
        
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer = footer;
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_rank_top"]];
        view.backgroundColor = kGlobalThemeColor;

        _tableView.tableHeaderView = view;
        _tableView.tableHeaderView.mj_h = view.mj_h;
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRankingCell"];    
//    cell.model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenW-30, 120) byRoundingCorners: UIRectCornerTopLeft  | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        cell.backView.layer.mask = maskLayer;

    }else {
        cell.backView.layer.mask = nil;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHRankingModel *mode = self.dataArray[indexPath.row];
    DDLogDebug(@"%@", mode);
    
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), mode.appraiseId];
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
}

#pragma mark - 请求数据
- (void)loadOneData {
    _pageNo = 0;
    _pageSize = 20;
    [self requestData];
}

- (void)loadMoreData {
    _pageNo ++;
    _pageSize = 20;
    [self requestData];
}

- (void)requestData {
    NSDictionary *parameters = @{@"pageNo":@(_pageNo),@"pageSize":@(_pageSize),@"unit":@"week"};
    NSString *url = FILE_BASE_STRING(@"/appraiseRecord/ranking/");
    
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
    
    NSArray *arr = [JHRankingModel mj_objectArrayWithKeyValuesArray:array];
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
