//
//  JHImageTextWaitAuthListViewController.m
//  TTjianbao
//
//  Created by zk on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageTextWaitAuthListViewController.h"
#import "JHImageTextWaitAuthTableViewCell.h"
#import "JHImageTextAuthDetailViewController.h"

#import "JHImageTextWaitAuthBusiness.h"
#import "YDRefreshFooter.h"
#import "CommAlertView.h"

@interface JHImageTextWaitAuthListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UITableView *tableView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray  *dataSourceArray;

@property (nonatomic, assign) NSInteger requestPageIndex;

@property (nonatomic, assign) BOOL hasMore;
/** 弹窗 */
@property (nonatomic, strong) CommAlertView *sendAlert;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation JHImageTextWaitAuthListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didFinishIdentifyNotification:) name:IdentifyFinishedNotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirst) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self loadData];
    }
    _isFirst = YES;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
// 完成鉴定后，刷新列表
- (void)didFinishIdentifyNotification : (NSNotification *)notification {
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadData{
    self.requestPageIndex = 1;
    @weakify(self);
    [JHImageTextWaitAuthBusiness getImageTextAuthListData:1 pageSize:20 Completion:^(NSError * _Nullable error, JHImageTextWaitAuthListModel * _Nullable model) {
        @strongify(self);
        [self endRefresh];
        self.hasMore = model.hasMore;
        [self.dataSourceArray removeAllObjects];
        if (!model.resultList || model.resultList.count == 0) {
            NSLog(@"错误页面");
            [self.gradientLayer removeFromSuperlayer];
            self.gradientLayer = nil;
            [self.tableView jh_reloadDataWithEmputyView];
            [self.tableView jh_footerStatusWithNoMoreData:YES];
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        [self addGradualColor:self.backView];
        [self.dataSourceArray addObjectsFromArray:model.resultList];
        self.requestPageIndex ++;
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData{
    if (!self.hasMore) {
        [self.tableView jh_footerStatusWithNoMoreData:YES];
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    @weakify(self);
    [JHImageTextWaitAuthBusiness getImageTextAuthListData:self.requestPageIndex pageSize:20 Completion:^(NSError * _Nullable error, JHImageTextWaitAuthListModel * _Nullable model) {
        @strongify(self);
        [self endRefresh];
        self.hasMore = model.hasMore;
        if (!model.resultList || model.resultList.count == 0) {
            NSLog(@"错误页面");
            [self.tableView jh_footerStatusWithNoMoreData:YES];
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        
        [self.dataSourceArray addObjectsFromArray:model.resultList];
        self.requestPageIndex ++;
        if (model.resultList.count == 0) {
            [self.tableView jh_footerStatusWithNoMoreData:YES];
        } else {
            [self.tableView jh_footerStatusWithNoMoreData:NO];
        }
        [self.tableView reloadData];
    }];
}

- (void)setupView{
    //导航配置
    self.jhTitleLabel.text = @"待鉴定";
    self.jhNavView.backgroundColor = [UIColor clearColor];
    //背景图
    self.backView = [[UIView alloc]init];
    [self.view addSubview:self.backView];
    [self.view insertSubview:self.backView atIndex:0];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
//    [self addGradualColor:self.backView];
    
    //列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(self.jhNavView.bottom, 0, 0, 0));
    }];
    @weakify(self);
    self.tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
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
        
        [_tableView registerClass:[JHImageTextWaitAuthTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHImageTextWaitAuthTableViewCell class])];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        _tableView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        ((YDRefreshFooter *)_tableView.mj_footer).showNoMoreString = YES;
        
    }
    return _tableView;
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
    JHImageTextWaitAuthListItemModel *model = self.dataSourceArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHImageTextWaitAuthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHImageTextWaitAuthTableViewCell class])];
    if (!cell) {
        cell = [[JHImageTextWaitAuthTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHImageTextWaitAuthTableViewCell class])];
    }
    cell.authDelegate = self;
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 去鉴定
- (void)gotoAuth:(JHImageTextWaitAuthListItemModel *)model{
    @weakify(self);
    [JHImageTextWaitAuthBusiness getAuthStatus:model.taskId Completion:^(BOOL canAuth) {
        @strongify(self);
        if (canAuth) {
            [self gotoAuthDetailPage:model];
        }else{
            [self.sendAlert show];
        }
    }];
}

- (void)gotoAuthDetailPage:(JHImageTextWaitAuthListItemModel *)model{
    JHImageTextAuthDetailViewController *vc = [JHImageTextAuthDetailViewController new];
    vc.taskId = model.taskId;
    vc.recordInfoId = model.recordInfoId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addGradualColor:(UIView *)view{
    if (!self.gradientLayer) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFEECB6).CGColor, (__bridge id)HEXCOLOR(0xF5F5F8).CGColor];
        self.gradientLayer.locations = @[@0.2, @0.3];
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(0, 1.0);
        self.gradientLayer.frame = view.bounds;
        [view.layer addSublayer:self.gradientLayer];
    }
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (CommAlertView *)sendAlert{
    if (!_sendAlert) {
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"该鉴定服务单已取消！" cancleBtnTitle:@"确定"];
        _sendAlert = alert;
    }
    return _sendAlert;
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
