//
//  JHStealTowerViewController.m
//  TTjianbao
//
//  Created by zk on 2021/7/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStealTowerViewController.h"
#import "JHStealTowerHeadView.h"
#import "JHStealTowerListCell.h"
#import "JHStealTowerRequestModel.h"
#import "JHBaseOperationView.h"
#import "JHMarketFloatLowerLeftView.h"
#import "JHNewStoreSpecialDetailViewController.h"
#import "JHNewStoreHomeReport.h"

#define KHeadH  285
#define KMyTopH (200 - UI.statusAndNavBarHeight)

@implementation JHStealTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    //指定UICollectionView部分支持多手势
    if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"UICollectionView")]) {
        return YES;
    }
    return NO;
}
@end

@interface JHStealTowerViewController ()<UITableViewDelegate,UITableViewDataSource,JHStealTowerListCellDelegate>

@property (nonatomic, strong) JHStealTowerHeadView *headView;

@property (nonatomic, strong) JHStealTowerListCell *lastCell;

@property (nonatomic, assign) BOOL noData;

@property (nonatomic, assign) BOOL goTop;

@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;//收藏返回顶部view

@end

@implementation JHStealTowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [JHTracking trackEvent:@"appPageView" property:@{@"page_name":@"商城偷塔页"}];
}

- (void)setupView{
    //列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    //刷新数据
    @weakify(self);
    self.tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.lastCell loadData:nil completion:^(BOOL finished) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    //头部
    self.tableView.tableHeaderView =  self.headView;
    self.headView.headChooseBlock = ^(JHStealTowerRequestModel * _Nonnull model) {
        @strongify(self);
        [self.lastCell loadData:model completion:nil];
    };
    //三级分类刷新UI
    self.headView.reloadUIBlock = ^(BOOL showTag) {
        @strongify(self);
        if (showTag) {
            self.headView.frame = CGRectMake(0, 0, kScreenWidth, KHeadH + 40);
        }else{
            self.headView.frame = CGRectMake(0, 0, kScreenWidth, KHeadH);
        }
        [self.tableView reloadData];
    };
    
    //配置导航
    self.jhNavView.backgroundColor = UIColor.clearColor;
    [self initLeftButtonWithImageName:@"newStore_icon_back_white" action:@selector(backActionButton:)];
    [self.jhLeftButton setImage:[UIImage imageNamed:@"newStore_icon_back_black"] forState:UIControlStateSelected];
    [self initRightButtonWithImageName:@"newStore_detail_share_white_icon" action:@selector((didClickShare:))];
    [self.jhRightButton setImage:[UIImage imageNamed:@"newStore_share_black_icon"] forState:UIControlStateSelected];
    [self.view bringSubviewToFront:self.jhNavView];
    
    //右下角浮窗按钮
    [self.view addSubview:self.floatView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //收藏等数据刷新
    [self.floatView loadData];
}

#pragma mark  - 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (!self.goTop){
        if (offsetY >= KMyTopH) {//大于等于悬停位
            self.cannotScroll = YES;
            //头部悬停
            self.tableView.contentOffset = CGPointMake(0, KMyTopH);
            //底部列表可滑动
            [self.lastCell makeDeatilDescModuleScroll:YES];
        }else{
            //当底部滑动没到顶时依然保持悬停 && !self.noData
            if (self.cannotScroll && !self.noData) {
                self.tableView.contentOffset = CGPointMake(0, KMyTopH);
            }
        }
    }
    
    //导航状态调整
    CGFloat tabOffsetY = self.tableView.contentOffset.y;
    CGFloat alphaValue = tabOffsetY / KMyTopH;
    BOOL bottomLineHidden = (tabOffsetY < KMyTopH);
    self.jhNavBottomLine.hidden = bottomLineHidden;
    self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:alphaValue];
    self.jhLeftButton.selected = bottomLineHidden ? false : true;
    self.jhRightButton.selected = bottomLineHidden ? false : true;
    self.jhTitleLabel.text = bottomLineHidden ? @"" : self.headView.headModel.stealingTowerConfigResponse.title;
    self.floatView.topButton.hidden = bottomLineHidden;
}

#pragma mark - cellDelegate
- (void)JHStealTowerListCellLeaveTopd{
    self.cannotScroll = NO;
}

/// 分享
- (void)didClickShare : (UIButton *)sender {
    JHShareInfo *shareInfo = self.headView.headModel.shareInfoBean;
    if (shareInfo == nil) { return; }
    [JHBaseOperationView showShareView:shareInfo objectFlag:nil];
//    [self.homeView.viewModel reportShareEvent];
}

#pragma mark - Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHStealTowerListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHStealTowerListCell class])];
    cell.delegate = self;
    @weakify(self);
    cell.haveDataBlock = ^(BOOL noData, JHStealTowerModel * _Nonnull listModel) {
        @strongify(self);
        self.noData = noData;
        self.headView.headModel = listModel;
    };
    
    cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        @strongify(self);
        if (!isH5) {
            JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
            vc.fromPage = @"商品推荐列表";
            vc.showId = showId;
            [self.navigationController pushViewController:vc animated:YES];
//                [JHNewStoreHomeReport jhNewStoreHomeBoutiqueClickReport:boutiqueName zc_type:2 zc_id:showId store_from:@"商品推荐列表"];
        } else {
            [JHNewStoreHomeReport jhNewStoreHomeNewPeopleClickReport:@"商品推荐列表"];
        }
    };
    self.lastCell = cell;
    if (!cell) {
        cell = [[JHStealTowerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHStealTowerListCell class])];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Lazy load Methods：
- (JHStealTableView *)tableView {
    if (!_tableView) {
        _tableView = [[JHStealTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource                     = self;
        _tableView.delegate                       = self;
        _tableView.backgroundColor                = kColorFFF;
        _tableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight              = 200;
        _tableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight   = 0.1f;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        [_tableView registerClass:[JHStealTowerListCell class] forCellReuseIdentifier:NSStringFromClass([JHStealTowerListCell class])];
    }
    return _tableView;
}

- (JHStealTowerHeadView *)headView{
    if (!_headView) {
        JHStealTowerHeadView *view = [[JHStealTowerHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KHeadH)];
        view.vc = self;
        _headView = view;
    }
    return _headView;
}

#pragma mark -回滚到顶部
- (void)dealTouchScrollToTop{
    self.goTop = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setContentOffset:CGPointZero];
    } completion:^(BOOL finished) {
        [self.lastCell makeDeatilDescModuleScroll:NO];
        self.goTop = NO;
        self.cannotScroll = NO;
    }];
}

- (JHMarketFloatLowerLeftView *)floatView{
    if (!_floatView) {
        _floatView = [[JHMarketFloatLowerLeftView alloc] initWithShowType:JHMarketFloatShowTypeBackTop];
        _floatView.isHaveTabBar = NO;
        @weakify(self)
        NSString *store_from = @"商品分类列表页";
//        if (self.keyword.length > 0) {
//            store_from = @"商品搜索列表页";
//        }
        //收藏
        _floatView.collectGoodsBlock = ^{
            [JHAllStatistics jh_allStatisticsWithEventId:@"scClick" params:@{
                @"store_from":store_from,
                @"zc_name":@"",
                @"zc_id":@""
            } type:JHStatisticsTypeSensors];
        };
        //返回顶部
        _floatView.backTopViewBlock = ^{
            @strongify(self)
            [JHAllStatistics jh_allStatisticsWithEventId:@"backTopClick" params:@{@"store_from":store_from} type:JHStatisticsTypeSensors];
            [self dealTouchScrollToTop];
//            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        };
    }
    return _floatView;
}

//- (void)dealloc{
//    NSLog(@"挂了~~~~");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
