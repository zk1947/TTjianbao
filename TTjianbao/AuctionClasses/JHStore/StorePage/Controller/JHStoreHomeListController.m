//
//  JHStoreHomeListController.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/19.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeListController.h"
#import "JHShopWindowPageController.h"
#import "JHStoreApiManager.h"
#import "CStoreHomeListModel.h"
#import "CSearchKeyModel.h"
#import "JHHotWordModel.h"
#import "CStoreChannelModel.h"
#import "JHStoreHomeBannerView.h"
#import "YDBaseCollectionView.h"
#import "JHStoreHomeListCell.h"
#import "JHStoreHomeRcmdCell.h"
#import "YDCountDownManager.h"
#import "JHMessageViewController.h"
#import "GrowingManager.h"
#import "UIView+Blank.h"
#import "JHCateViewController.h" //分类
#import "JHGoodsSearchController.h" //搜索页
#import "JHEasyPollSearchBar.h" //搜索框
#import "JHSeckillPageViewController.h"
#import "JHAppAlertViewManger.h"
//左右滑动切换相关
#import "JHStoreHelp.h"
#import "JHStoreHomeListView.h"
//埋点
#import "GrowingManager.h"

///2.5新增
#import "JHGuaranteeTableViewCell.h"
#import "JHStoreHomeSeckillCell.h"
#import "JHStoreHomeWindowCell.h"
#import "JHStoreHomeActivityTableCell.h"
#import "JHStoreHomeCardModel.h"
#import "JHStoreHomeTopBar.h"
#import "ZQSearchViewController.h"
#import "JHSearchResultViewController.h"
#import "JHNewUserRedPacketAlertView.h"
#import "JHStoreHomeNewPeopleGiftTableViewCell.h"
#import "JHWebViewController.h"
#import "JHNewStoreTypeVC.h"
#import "JHSkinSceneManager.h"
@interface JHStoreHomeListController ()<
JXPageListViewDelegate,
JXPageListMainTableViewGestureDelegate,
UITableViewDataSource,
UITableViewDelegate,
ZQSearchViewDelegate>
@property (nonatomic, strong) NSArray* bannerList;
@property (nonatomic, strong) JHStoreHomeBannerView *bannerView;
@property (nonatomic, strong) NSMutableArray <JHStoreHomeCardModel*>*homeListArray;
//搜索相关
@property (nonatomic, strong) CSearchKeyModel *searchModel;
@property (nonatomic, strong) UIView *searchPanel;
@property (nonatomic, strong) JHEasyPollSearchBar *searchBar;
@property (nonatomic, strong) UIButton *channelBtn;
//分类标签
@property (nonatomic, strong) CStoreChannelModel *channelModel;
//左右滑动切换相关
@property (nonatomic, strong) JXPageListView *pageListView;
@property (nonatomic, strong) NSMutableArray <JHStoreHomeListView *> *listViews;

@property (nonatomic, assign) BOOL isFirstSelect; ///分类标签是否第一次选中
@property (nonatomic, assign) BOOL isHaveSeckillList; ///记录是否有秒杀专题
@property (nonatomic, strong) JHStoreHomeTopBar *topBar;

@property (nonatomic, strong) JHNewUserRedPacketAlertViewSubModel *anewPeopleBannerModel; /// 新人专区入口model
@end


@implementation JHStoreHomeListController {
    NSInteger _prePageIndex; //记录上一次选中标签
}

#pragma mark -
#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _prePageIndex = -1;
        _isFirstSelect = YES;
        _isHaveSeckillList = NO;
        _bannerList = [NSArray new];
        _listViews = [NSMutableArray new];
        _searchModel = [[CSearchKeyModel alloc] init];
        _channelModel = [[CStoreChannelModel alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHomePageActivityBtn) name:HomePageActivityABtnNotifaction object:nil];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    JHStoreHomeListView *listView = self.listViews[_prePageIndex];
    [listView uploadDataBeforePageLeave];
    
    [JHAppAlertViewManger showSuperRedPacketEnterWithSuperView:self.view];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithTop:ScreenH - 250];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    @weakify(self)
    [self getAllUnreadMsgCount:^(id obj) {
        @strongify(self)
        [self.topBar refreshMsgCount:obj];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [JHHomeTabController changeStatusWithMainScrollView:self.pageListView.mainTableView index:2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
    [self addSearchBar];
    [self configPageListView];
    
    ///第一次加载是需要展示加载菊花动效  -  刷新UI
    [self.pageListView.mainTableView.mj_header beginRefreshing];
    self.topBar.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = [UILabel jh_labelWithBoldText:@"天天商城" font:22 textColor:kColor333 textAlignment:0 addToSuperView:self.topBar];
    label.font = [UIFont fontWithName:kFontMedium size:22];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBar);
        make.left.equalTo(self.topBar).offset(15);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark -
#pragma mark - UI Methods

- (void)addSearchBar {
    _searchPanel = [UIView new];
    _searchPanel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchPanel];
    
    __weak typeof(self) weakSelf = self;
    //搜索框
    _searchBar = [JHEasyPollSearchBar new];
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
    _searchBar.layer.cornerRadius = 15.0;
    _searchBar.layer.masksToBounds = YES;
    [_searchBar addTapBlock:^(id obj) {
        //NSLog(@"点击搜索框");
        ///369神策埋点: 点击搜索框
        [JHTracking trackEvent:@"searchBarClick" property:@{@"page_position":@"天天商城"}];
        [weakSelf enterSearchVC];
    }];
    [_searchPanel addSubview:_searchBar];
    
    //分类按钮
    _channelBtn = [UIButton buttonWithTitle:@"分类" titleColor:kColor666];
    _channelBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:10];
    [_channelBtn setImage:[UIImage imageNamed:@"store_icon_channel"] forState:UIControlStateNormal];
    _channelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _channelBtn.adjustsImageWhenHighlighted = NO;
    [_channelBtn setImageInsetStyle:MRImageInsetStyleTop spacing:2];
    [[_channelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf enterChannelVC];
    }];
    [_searchPanel addSubview:_channelBtn];
    
    //布局
    _searchPanel.sd_layout
    .topSpaceToView(self.view, UI.statusAndNavBarHeight)
    .leftEqualToView(self.view).rightEqualToView(self.view)
    .heightIs(42);
    
    _searchBar.sd_layout
    .leftSpaceToView(_searchPanel, 10)
    .rightSpaceToView(_searchPanel, 44)
    .bottomSpaceToView(_searchPanel, 8)
    .heightIs(kEasyPollSearchBarHeight);
    
    _channelBtn.sd_layout
    .rightEqualToView(_searchPanel)
    .centerYEqualToView(_searchBar)
    .widthIs(44).heightIs(38);
}

- (JHStoreHomeBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [JHStoreHomeBannerView bannerWithClickBlock:^(BannerCustomerModel * _Nonnull bannerData, NSInteger index) {
            NSLog(@"点击banner");
            [JHRootController toNativeVC:bannerData.target.componentName withParam:bannerData.target.params from:JHTrackMarketSaleClickSaleBanner];
            ///特卖商城首页 banner被点击埋点 ---- 
            [JHGrowingIO trackEventId:JHTrackMarketSaleBannerItemClick from:JHTrackMarketSaleClickSaleBanner];
            
            NSMutableDictionary *params2 = [NSMutableDictionary new];
            [params2 setValue:@"天天商城" forKey:@"page_position"];
            [params2 setValue:@(index) forKey:@"position_sort"];
            [params2 setValue:bannerData.target.componentName forKey:@"content_url"];
            [JHAllStatistics jh_allStatisticsWithEventId:@"bannerClick" params:params2 type:JHStatisticsTypeSensors];
        }];
    }
    return _bannerView;
}

//导航标签视图
- (void)configPageListView {
    if (!_pageListView) {
        _pageListView = [JHStoreHelp pageListWithDelegate:self];
        _pageListView.pinCategoryViewHeight = 52.f;
        _pageListView.mainTableView.tableHeaderView = self.bannerView;
        _pageListView.mainTableView.mj_header = self.refreshHeader;
        [self.view addSubview:_pageListView];

        ///修改刷新状态的监听
        [self.refreshHeader addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        _pageListView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(UI.statusAndNavBarHeight +_searchPanel.height, 0, 0, 0));
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        if (self.refreshHeader.state == MJRefreshStateIdle) {
            self.pageListView.isRefresh = NO;
        }
        else {
            self.pageListView.isRefresh = YES;
        }
    }
}

//刷新导航标签视图
- (void)__reloadPageListView {
    NSMutableArray *channelTitles = [NSMutableArray new]; //所有分类标签
    [_listViews removeAllObjects];
    
    NSInteger defaultIndex = 0;
    
    for (NSInteger i = 0; i < _channelModel.list.count; i++) {
        CStoreChannelData *data = _channelModel.list[i];
        if (data.is_default) {
            defaultIndex = i;
        }
        JHStoreHomeListView *listView = [[JHStoreHomeListView alloc] init];
        listView.curChannelData = data;
        [_listViews addObject:listView];
        [channelTitles addObject:data.channel_name];
    }
    
    //_pageListView.pinCategoryView.titles = channelTitles;
    _pageListView.titles = channelTitles;
    _pageListView.pinCategoryView.defaultSelectedIndex = defaultIndex;
    [_pageListView reloadData];
    [_pageListView.pinCategoryView selectItemAtIndex:defaultIndex];
    
    //用户画像埋点 特卖商城首页进入事件
    [JHUserStatistics noteEventType:kUPEventTypeMallHomeEntrance params:nil];
}

#pragma mark -
#pragma mark - 今日推荐样式，所有数据倒计时结束通知
- (void)addObserver {
    @weakify(self);
    [[[JHNotificationCenter rac_addObserverForName:JHStoreHomeRcmdListAllCountDownEndNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        NSLog(@"今日推荐样式，所有数据倒计时已结束");
        [self refresh];
    }];
}

#pragma mark -
#pragma mark - TabBar点击事件
- (void)tableBarSelect:(NSInteger)currentIndex {
    if (currentIndex == 1) {  //特卖商城
        if ([self isRefreshing]) {
            return;
        }
        [_pageListView.mainTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [_pageListView.mainTableView.mj_header beginRefreshing];
    }
}

#pragma mark -
#pragma mark - 页面跳转
//进入搜索页
- (void)enterSearchVC {
    JHSearchResultViewController *resultController = [JHSearchResultViewController new];
    ZQSearchFrom from = ZQSearchFromStore;
    ZQSearchViewController *vc = [[ZQSearchViewController alloc] initSearchViewWithFrom:from resultController:resultController];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - ZQSearchViewDelegate

- (void)searchFuzzyResultWithKeyString:(NSString *)keyString Data:(id<ZQSearchData>)data resultController:(UIViewController *)resultController From:(ZQSearchFrom)from{
    JHSearchResultViewController *vc = (JHSearchResultViewController *)resultController;
    [vc refreshSearchResult:keyString from:from keywordSource:data];
}

//进入分类检索页
- (void)enterChannelVC {
//    JHCateViewController *vc = [JHCateViewController new];
    JHNewStoreTypeVC *vc = [JHNewStoreTypeVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)isRefreshing {
    if([_pageListView.mainTableView.mj_header isRefreshing] ||
       [_pageListView.mainTableView.mj_footer isRefreshing]) {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - Api Request

- (void)refresh {
    [self.homeListArray removeAllObjects];
    self.anewPeopleBannerModel = nil;
    [self getSearchHotWordsList]; //热词列表
    [self getBannerList]; //广告
    [self getHomeDataList]; //主列表数据（标签栏以上）
    [self getChannelList]; //标签栏-频道数据
    [self getNewPeopleGiftInfo]; /// 获取新人福利信息
    
}

- (void)endRefresh {
    [_pageListView.mainTableView.mj_header endRefreshing];
}

//获取广告数据
- (void)getBannerList {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/ad/6");
    @weakify(self);
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        NSLog(@"resObj = %@", respondObject);
        @strongify(self);
        self.bannerList = [NSArray modelArrayWithClass:[BannerCustomerModel class] json:respondObject.data];
        if (self.bannerList && self.bannerList.count > 0) {
            self.bannerView.hidden = NO;
            self.bannerView.bannerList = _bannerList;
            self.pageListView.mainTableView.tableHeaderView.height = [JHStoreHomeBannerView bannerHeight];
        } else {
            self.bannerView.hidden = YES;
            self.pageListView.mainTableView.tableHeaderView.height = 0.1;
        }
        [self.pageListView.mainTableView reloadData];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        //[UITipView showTipStr:respondObject.message];
        if (_bannerList.count == 0) {
            self.bannerView.hidden = YES;
            self.pageListView.mainTableView.tableHeaderView.height = 0.1;
            [self.pageListView.mainTableView reloadData];
        }
    }];
}

//获取首页主列表数据
- (void)getHomeDataList {
    @weakify(self);   ////接口代码 待放开
    [JHStoreApiManager getHomeDataListWithCompleteblock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self.view endLoading];
        [self endRefresh];
        RequestModel *respData = (RequestModel *)respObj;
        NSArray *dataList = [JHStoreHomeCardModel mj_objectArrayWithKeyValuesArray:respData.data];
        [self.homeListArray addObjectsFromArray:dataList];
        [self cofigNewPeopleGiftModelAndReloadData];
        [self.pageListView.mainTableView reloadData];
    }];
}

//获取热搜热词列表
- (void)getSearchHotWordsList {
    @weakify(self);
    [JHStoreApiManager getHotKeywords:^(NSArray *respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            self.searchModel.hotList = [NSMutableArray arrayWithArray:respObj];
            self.searchBar.placeholderArray = self.searchModel.hotList.mutableCopy;
        }
    }];
}

//获取分类标签列表
- (void)getChannelList {
    @weakify(self);
    [JHStoreApiManager getChannelList:_channelModel block:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            CStoreChannelModel *aModel = (CStoreChannelModel *)respObj;
            if (aModel.list.count > 0) {
                [self.channelModel configModel:respObj];
                [self __reloadPageListView];
            }
        }
    }];
}

/// 获取新人福利信息
- (void)getNewPeopleGiftInfo {
    @weakify(self);
    [JHNewUserRedPacketAlertView getNewUserRedPacketEntranceWithLocation:2 complete:^(JHNewUserRedPacketAlertViewModel * _Nullable model) {
        @strongify(self);
        NSLog(@"model = %@,%@",self.homeListArray,model);
        self.anewPeopleBannerModel = model.banner;
        [self cofigNewPeopleGiftModelAndReloadData];
        [self.pageListView.mainTableView reloadData];
    }];
}

- (void)cofigNewPeopleGiftModelAndReloadData {
    if (self.homeListArray.count > 0 && self.anewPeopleBannerModel) {
        BOOL hasChange = NO;
        for (JHStoreHomeCardModel *model in self.homeListArray) {
            if ([model.card_type isEqualToString:JHWindowTypeNewUserOlder]) {
                /// 原有新人专区替换
                NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.homeListArray];
                JHStoreHomeCardModel *newModel = [[JHStoreHomeCardModel alloc] init];
                newModel.card_type = JHWindowTypeNewUser;
                JHStoreHomeNewPeopleModel *subModel = [[JHStoreHomeNewPeopleModel alloc] init];
                subModel.img = self.anewPeopleBannerModel.img;
                subModel.url = self.anewPeopleBannerModel.url;
                newModel.anewPeopleModel = subModel;
                NSInteger index = [self.homeListArray indexOfObject:model];
                [newArray replaceObjectAtIndex:index withObject:newModel];
                self.homeListArray = newArray;
                hasChange = YES;
                break;
            }
        }
        
        if (!hasChange) {
            /// 如果原有专区新人位置没下发，则放到banner 下面
            JHStoreHomeCardModel *newModel = [[JHStoreHomeCardModel alloc] init];
            newModel.card_type = JHWindowTypeNewUser;
            JHStoreHomeNewPeopleModel *subModel = [[JHStoreHomeNewPeopleModel alloc] init];
            subModel.img = self.anewPeopleBannerModel.img;
            subModel.url = self.anewPeopleBannerModel.url;
            newModel.anewPeopleModel = subModel;
            [self.homeListArray insertObject:newModel atIndex:0];
        }
    }
}

#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

#pragma mark -
#pragma mark - JXPageListViewDelegate
//Tips:实现代理方法
- (NSArray<UIView<JXPageListViewListDelegate> *> *)listViewsInPageListView:(JXPageListView *)pageListView {
    return _listViews;
}

//选中某个index的回调
- (void)pinCategoryView:(JXCategoryBaseView *)pinCategoryView didSelectedItemAtIndex:(NSInteger)index {
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    if (_prePageIndex != index) {
        ///离开页面前统计满足条件的数据上报
        JHStoreHomeListView *listView = self.listViews[_prePageIndex];
        [listView uploadDataBeforePageLeave];
        [listView setSubScrollView];
        ///用户画像埋点- 商城首页导航分组停留时长 - 结束
        [self endEventStastics:_prePageIndex];
        
        _prePageIndex = index;
        //3.1.0埋点-点击分类标签
        
        CStoreChannelData *data = _channelModel.list[index];
        [GrowingManager clickStoreHomeListCategory:@{@"cate" : data.channel_name}];
        ///用户画像埋点- 商城首页导航分组停留时长 - 开始
        [self beginEventStastics:index];
    }
}

#pragma mark -
#pragma mark - JXPageListMainTableViewGestureDelegate
//Tip：必须实现，不然滑动会有冲突！！！！！
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isMemberOfClass:[YDBaseCollectionView class]]) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark - UITableViewDelegate、UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //底部的分类滚动视图需要作为最后一个section
    return self.homeListArray.count+2;  ///2是保障栏和底部分类列表的section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 0) {
        JHStoreHomeCardModel *model = self.homeListArray[section-1];
        if ([model.card_type isEqualToString:JHWindowTypeActivity] ) { ///活动专题
            return model.cardInfo.showcaseList.count;
        }
        if ([model.card_type isEqualToString:JHWindowTypeNewUser]) { /// 新人专区
            return 1;
        }
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.homeListArray.count+1) {  ///商品分类列表
        //Tips:最后一个section（即listContainerCell所在的section）返回listContainerCell的高度
        return [self.pageListView listContainerCellHeight];
    }
    
    if (indexPath.section == 0) { ///第一个section是保障栏 固定显示
        return [JHGuaranteeTableViewCell cellHeight];
    }
    
    JHStoreHomeCardModel *model = self.homeListArray[indexPath.section - 1];
    if ([model.card_type isEqualToString:JHWindowTypeActivity]) {
        /// 活动专题
        if (model.cardInfo && model.cardInfo.showcaseList.count != 0) {
            return (ScreenW - 20)*100/355.0+10;
        }
        return 0;
    }
    if ([model.card_type isEqualToString:JHWindowTypeNewUser]) {
        /// 新人专区
        if (model.anewPeopleModel) {
            return (ScreenW - 20)*4.f/9.f+10;
        }
        return 0;
    }
    
    if ([model.card_type isEqualToString:JHWindowTypeSeckill]) {  ///秒杀专题
        ///不用区分数据 只要返回这个字段都显示
        _isHaveSeckillList = YES;
        return [JHStoreHomeSeckillCell cellHeight];
    }
    if ([model.card_type isEqualToString:JHWindowTypeCommon]) {  ///普通专题
        if (model.cardInfo && model.cardInfo.showcaseList.count > 0) {
            return [JHStoreHomeWindowCell cellHeight];
        }
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.homeListArray.count+1) {
    //Tips:最后一个section（即listContainerCell所在的section）配置listContainerCell
        return [self.pageListView listContainerCellForRowAtIndexPath:indexPath];
    }
    if (indexPath.section == 0) {  ///第一个section固定显示保障栏
        JHGuaranteeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId_JHStoreHomeGuaranteeId forIndexPath:indexPath];
        return cell;
    }

    ///修改的时候上面两个不用动
    JHStoreHomeCardModel *model = self.homeListArray[indexPath.section-1];
    
    if ([model.card_type isEqualToString:JHWindowTypeActivity]) {
        /// 活动专题
        JHStoreHomeShowcaseModel *caseModel = model.cardInfo.showcaseList[indexPath.row];
        JHStoreHomeActivityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId_JHStoreHomeActivityTableId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showcaseModel = caseModel;
        return cell;
    }

    if ([model.card_type isEqualToString:JHWindowTypeNewUser]) {
        /// 新人专区
        JHStoreHomeNewPeopleGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHStoreHomeNewPeopleGiftTableViewCell class])];
        if (!cell) {
            cell = [[JHStoreHomeNewPeopleGiftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHStoreHomeNewPeopleGiftTableViewCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.anewPeopleModel = model.anewPeopleModel;
        return cell;
    }

    if ([model.card_type isEqualToString:JHWindowTypeSeckill]) {  ///秒杀专题
        JHStoreHomeSeckillCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId_JHStoreHomeTableSeckillId];
        cell.cardInfoModel = model.cardInfo;
        return cell;
    }
    if ([model.card_type isEqualToString:JHWindowTypeCommon]) {  ///普通专题
        JHStoreHomeWindowCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId_JHStoreHomeWindowTableId];
        cell.cardInfoModel = model.cardInfo;
        cell.isClipAllCorners = !_isHaveSeckillList;  ///有秒杀不需要全切 否则全切
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    JHStoreHomeCardModel *model = self.homeListArray[indexPath.section-1];
    /// 活动专区
    if ([model.card_type isEqualToString:JHWindowTypeActivity]) {
        if (model.cardInfo.showcaseList.count == 0) {
            return;
        }
        JHShopWindowPageController *vc = [[JHShopWindowPageController alloc] init];
        JHStoreHomeShowcaseModel *caseModel = model.cardInfo.showcaseList[indexPath.row];
        vc.showcaseId = caseModel.sc_id;
        if ([model.card_type isEqualToString:JHWindowTypeActivity]) {
            vc.fromSource = JHTrackMarketSaleTopicFromActive;
        }
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    /// 新人专区
    if ([model.card_type isEqualToString:JHWindowTypeNewUser]) {
        if (model.anewPeopleModel) {
            
            [JHGrowingIO trackEventId:@"xr_xq_click" from:@"2"];
            [JHRouterManager pushWebViewWithUrl:model.anewPeopleModel.url title:@"" controller:self];
            [JHAllStatistics jh_allStatisticsWithEventId:@"operationClick" params:@{@"op_name" : @"新人专享"} type:JHStatisticsTypeSensors];
        }
    }
    if ([model.card_type isEqualToString:JHWindowTypeSeckill]) {
        JHSeckillPageViewController *vc = [[JHSeckillPageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"operationClick" params:@{@"op_name" : @"今日秒杀"} type:JHStatisticsTypeSensors];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Tips:需要传入mainTableView的scrollViewDidScroll事件
    [self.pageListView mainTableViewDidScroll:scrollView];
    if(scrollView.contentOffset.y > 10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
    }
    [JHHomeTabController changeStatusWithMainScrollView:self.pageListView.mainTableView index:2];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!scrollView.decelerating) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}

- (void)scrollViewDidEndScroll {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
}

#pragma mark -
#pragma mark - 埋点统计参数
//点击橱窗列表项
- (NSDictionary *)growingParamsWithData:(CStoreHomeListData *)data {
    NSDictionary *params = @{@"sc_id" : @(data.sc_id),
                             @"name" : data.name,
                             @"layout" : @(data.layout)
    };
    return params;
}

#pragma mark -
#pragma mark - lazy loading

- (NSMutableArray<JHStoreHomeCardModel *> *)homeListArray {
    if (!_homeListArray) {
        _homeListArray = [NSMutableArray array];
    }
    return _homeListArray;
}

#pragma mark -
#pragma mark - 用户画像埋点相关

///切换分组 当前页面浏览开始
- (void)beginEventStastics:(NSInteger)index {
    CStoreChannelData *data = _channelModel.list[_prePageIndex];
    [JHUserStatistics noteEventType:kUPEventTypeMallCategoryListBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin,
                                                                                @"category_id":@(data.channel_id),
                                                                                @"category_name":data.channel_name
    }];
}
///切换分组 当前页面浏览结束
- (void)endEventStastics:(NSInteger)index {
    CStoreChannelData *data = _channelModel.list[_prePageIndex];
    [JHUserStatistics noteEventType:kUPEventTypeMallCategoryListBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd,
                                                                                @"category_id":@(data.channel_id),
                                                                                @"category_name":data.channel_name
    }];
}

- (JHStoreHomeTopBar *)topBar {
    if(!_topBar) {
        @weakify(self);
        _topBar = [JHStoreHomeTopBar topBarWithMsgClickBlock:^{
            @strongify(self);
            [self enterMessageVC];
        } withSearchClickBlock:^{
            @strongify(self);
            ///369神策埋点: 点击搜索框
            [JHTracking trackEvent:@"searchBarClick" property:@{@"page_position":@"天天商城"}];
            [self enterSearchVC];
        }];
        [self.view addSubview:_topBar];
        [_topBar refreshTheme:NO index:1];
    }
    return _topBar;
}

//进入消息中心
- (void)enterMessageVC {
    if (IS_LOGIN) {
        JHMessageViewController *vc = [[JHMessageViewController alloc] init];
        vc.from = JHFromHomeSourceBuy;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showHomePageActivityBtn {
    User *user = [UserInfoRequestManager sharedInstance].user;
    if (user.type != 1 &&user.type != 2) {
        [self showActivityImage];
         [self.activityImage setImageWithURL:[NSURL URLWithString:[UserInfoRequestManager sharedInstance].homeActivityMode.homeActivityIcon.imgUrl] placeholder:nil];
    }
}

@end
