//
//  JHMarketHomeViewController.m
//  TTjianbao
//
//  Created by plz on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketHomeViewController.h"
#import "JHSQHelper.h"
#import "JHSQApiManager.h"
#import "JHMarketHomeViewModel.h"
#import "JHMarketSloganTableViewCell.h"
#import "JHMarketSpecialTableViewCell.h"
#import "JHMarketHomeBusiness.h"
#import "JHIdentificationDetailsVC.h"
#import "JHMarketHomeDataReport.h"
#import "JHAppAlertViewManger.h"
#import "JHContendRecordListAlert.h"
#import "JHTimeSelectPickerView.h"
#import "JHC2CProductDetailBusiness.h"
#import "JHMarketFloatLowerLeftView.h"

@implementation JHMarketTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    //指定UICollectionView部分支持多手势
    if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"UICollectionView")]) {
        UICollectionView *collection1 = (UICollectionView *)otherGestureRecognizer.delegate;
        if ([collection1.dataSource isKindOfClass:NSClassFromString(@"JHMarketGoodsInfoViewController")]) {
            return YES;
        }
    }
    return NO;
}
@end

@interface JHMarketHomeViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,JHMarketGoodsListTableViewCellDelegate>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray  *dataSourceArray;

@property (nonatomic, assign) BOOL hasData;

/** 浮层 */
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;


@property (nonatomic, assign) BOOL downOnce;

@property (nonatomic, assign) BOOL firstIn;//首次进入不重复加载

@property (nonatomic, assign) BOOL isViewVisable;

@property (nonatomic, strong) JHMarketCategoryTableViewCell *firstCell;

@property (nonatomic, strong) JHMarketSpecialTableViewCell *specialCell;

@end

@implementation JHMarketHomeViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self addObserver];
    [self.marketTableView.mj_header beginRefreshing];
        
}

- (void)addObserver{
    //进入前台
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        //如果进入前台时当前页面在窗口
        if (self.isViewVisable) {
            //曝光埋点
            [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
                @"page_name":@"宝友集市首页"
            } type:JHStatisticsTypeSensors];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isViewVisable = YES;
    //埋点
    [JHMarketHomeDataReport marketHomePageReport];
    
    //抢红包入口
    [JHAppAlertViewManger showSuperRedPacketEnterWithSuperView:self.view];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithTop:ScreenH - 354];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithLeft:10];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [JHHomeTabController changeStatusWithMainScrollView:self.marketTableView index:0 hasSubScrollView:YES];
    //收藏等数据刷新
    [self.floatView loadData];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isViewVisable = NO;
}

- (void)setupViews {
    [self.view addSubview:self.marketTableView];
    [self.marketTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(self.view.mas_left).offset(0.f);
        make.right.equalTo(self.view.mas_right).offset(0.f);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    @weakify(self);
    self.marketTableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadCategroyData];
    }];
    
    //右下角浮窗按钮
    [self.view addSubview:self.floatView];
}

- (BOOL)isLgoin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {}];
        return NO;
    }
    return YES;
}

#pragma mark -加载金刚位数据
- (void)loadCategroyData{
    @weakify(self);
    [JHMarketHomeBusiness getMarketCategroyListData:^(NSError * _Nullable error, JHMarketHomeViewModel * _Nullable viewModel) {
        @strongify(self);
        [self endRefresh];
        [self.dataSourceArray removeAllObjects];
        if (viewModel.kingKongViewModel.operationSubjectList.count >0) {
            [self.dataSourceArray addObject:viewModel.kingKongViewModel];
        }
        [self.dataSourceArray addObject:viewModel.bgAdViewModel];
        if (viewModel.specialViewModel.operationPosition.count >0) {
            [self.dataSourceArray addObject:viewModel.specialViewModel];
        }
        [self.marketTableView reloadData];
        [self.marketTableView layoutIfNeeded];
        [self getGoodsInfo];
    }];
}

/// 获取商品
- (void)getGoodsInfo {
    JHMarketHomeCellStyleGoodsViewModel *viewModel = [[JHMarketHomeCellStyleGoodsViewModel alloc] init];
    [self.dataSourceArray addObject:viewModel];
    [self.lastCell releaseGoodListVC];
    [self.marketTableView reloadData];
    [self.marketTableView layoutIfNeeded];
}


- (void)endRefresh {
    [self.marketTableView.mj_header endRefreshing];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id viewModel = self.dataSourceArray[indexPath.row];
    
    //运营位
    if ([JHMarketHomeCellStyleKingKongViewModel has:viewModel]) {
        JHMarketHomeCellStyleKingKongViewModel *kingKongViewModel = [JHMarketHomeCellStyleKingKongViewModel cast:viewModel];
        JHMarketCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHMarketCategoryTableViewCell class])];
        self.marketTableView.firstCell = cell;
        self.firstCell = cell;
        if (!cell) {
            cell = [[JHMarketCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHMarketCategoryTableViewCell class])];
        }
        cell.categoryInfos = kingKongViewModel.operationSubjectList;
        return cell;
    }
    
    //横幅广告
    if ([JHMarketHomeCellStyleBgAdViewModel has:viewModel]) {
        JHMarketSloganTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHMarketSloganTableViewCell class])];
        if (!cell) {
            cell = [[JHMarketSloganTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHMarketSloganTableViewCell class])];
        }
        return cell;
    }
    
    //专题
    if ([JHMarketHomeCellStyleSpecialViewModel has:viewModel]){
        JHMarketSpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHMarketSpecialTableViewCell class])];
        self.specialCell = cell;
        if (!cell) {
            cell = [[JHMarketSpecialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHMarketSpecialTableViewCell class])];
        }
        
        JHMarketHomeCellStyleSpecialViewModel *specialViewModel = (JHMarketHomeCellStyleSpecialViewModel *)viewModel;
        cell.categoryInfos = specialViewModel.operationPosition;
        return cell;
    }
    
    //商品
    if ([JHMarketHomeCellStyleGoodsViewModel has:viewModel]){
        self.lastCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHMarketGoodsListTableViewCell class])];
        if (!self.lastCell) {
            self.lastCell = [[JHMarketGoodsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHMarketGoodsListTableViewCell class])];
        }
        self.lastCell.delegate = self;
        
        return self.lastCell;
    }

    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //头部偏移量判断
//    CGFloat scrollY = self.marketTableView.contentOffset.y;
    CGFloat scrollY = scrollView.contentOffset.y;
    CGFloat maxContentOffsetY = [self mainTableViewMaxContentOffsetY];
    if (maxContentOffsetY < 40+UI.statusBarHeight) {
        maxContentOffsetY = 0;
    }
    if (scrollY >= maxContentOffsetY && maxContentOffsetY >= 0) {//大于等于悬停位
        //改变商品tab透明度为0
        if (!self.cannotScroll) {//向上临界一次
            self.lastCell.tabAlpha = 0.0;
        }
        self.cannotScroll = YES;
        self.downOnce = YES;
        //头部悬停
        self.marketTableView.contentOffset = CGPointMake(0, maxContentOffsetY);
        //底部列表可滑动
        [self.lastCell makeDeatilDescModuleScroll:YES];
    }else{
        //当底部滑动没到顶时依然保持悬停 && self.hasData
        if (self.cannotScroll) {
            self.marketTableView.contentOffset = CGPointMake(0, maxContentOffsetY);
        }
    }
    
    //商品tab吸顶渐变效果
    CGFloat topY = maxContentOffsetY > 50 ? 50 : maxContentOffsetY;
    if (scrollY >= maxContentOffsetY - topY && scrollY < maxContentOffsetY) {
        if (!self.cannotScroll) {
            CGFloat persent = (scrollY - (maxContentOffsetY - topY))/topY;
            self.lastCell.tabAlpha = 1.0 - persent;
        }
    }
    //商品tab向下临界一次
    if (self.downOnce && scrollY < maxContentOffsetY - topY && !self.cannotScroll) {
        self.downOnce = NO;
        self.lastCell.tabAlpha = 1.0;
    }
    
    [JHHomeTabController changeStatusWithMainScrollView:self.marketTableView index:0 hasSubScrollView:YES];
}

- (void)subScrollViewDidScrollToTop {
    [[self.lastCell getSubScrollViewFromSelf] setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (CGFloat)mainTableViewMaxContentOffsetY {
    //计算tab到顶部的距离 金刚位+提示语+运营位
    CGFloat firstCellH = 0;
    if (_firstCell.animationView.pageIndex == 0) {
        firstCellH = [_firstCell.animationView getScrollViewPageOneHeight];
        if (_firstCell.animationView.resourceArray.count <= 12) {
            firstCellH = firstCellH - 20;
        }
    }else if (_firstCell.animationView.pageIndex == 1){
        firstCellH = [_firstCell.animationView getScrollViewPageTowHeight];
    }
    if (firstCellH<0) {
        firstCellH = 0;
    }
    CGFloat topH = firstCellH + (kScreenWidth-24)/9.8 + [self.specialCell getCollectionH]+10;
//    NSLog(@"topH === %f",topH);
    
    return topH - 8;
//    return floor(self.marketTableView.contentSize.height) - self.lastCell.bounds.size.height;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self.lastCell makeDeatilDescModuleScrollToTop];
    return YES;
}

#pragma mark - cellDelegate
- (void)JHMarketGoodsListTableViewCellLeaveTopd {
    self.cannotScroll = NO;
}

#pragma mark - Lazy load Methods：

- (JHMarketTableView *)marketTableView {
    if (!_marketTableView) {
        _marketTableView                                = [[JHMarketTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _marketTableView.dataSource                     = self;
        _marketTableView.delegate                       = self;
        _marketTableView.backgroundColor                = kColorFFF;//HEXCOLOR(0xF5F5F8);
        _marketTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _marketTableView.estimatedRowHeight              = 200;
        _marketTableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _marketTableView.estimatedSectionHeaderHeight   = 0.1f;
            _marketTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        //运营位
        [_marketTableView registerClass:[JHMarketCategoryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHMarketCategoryTableViewCell class])];
        
        //标语
        [_marketTableView registerClass:[JHMarketSloganTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHMarketSloganTableViewCell class])];
        
        //专栏
        [_marketTableView registerClass:[JHMarketSpecialTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHMarketSpecialTableViewCell class])];
        
        //商品瀑布流
        [_marketTableView registerClass:[JHMarketGoodsListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHMarketGoodsListTableViewCell class])];

        if ([_marketTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_marketTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_marketTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_marketTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _marketTableView;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (JHMarketFloatLowerLeftView *)floatView{
    if (!_floatView) {
        _floatView = [[JHMarketFloatLowerLeftView alloc] initWithShowType:JHMarketFloatShowTypeSallGoods];
        _floatView.isHaveTabBar = YES;
    }
    return _floatView;
}


@end
