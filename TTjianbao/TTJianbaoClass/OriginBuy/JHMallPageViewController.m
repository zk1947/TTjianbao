//
//  JHMallPageViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHNewUserRedPacketAlertView.h"
#import "JHAppAlertViewManger.h"
#import "JHMallPageViewController.h"
#import "JXCategoryBaseView.h"
#import "JHMallRecommendViewController.h"
#import "SourceMallApiManager.h"
#import "JHMallCateModel.h"
#import "JHPersistData.h"
#import "JHMallSelectMoreController.h"
#import "JH99FreeViewController.h"
#import "JH99FreeModel.h"

///首页改版新增

#import "JHMallHelper.h"
#import "JHMallRecommendBannarView.h"
#import "SourceMallApiManager.h"
#import "JHMallOperationModel.h"
#import "JHMallLivingListView.h"
#import "NTESAudienceLiveViewController.h"
#import "JHTMallGranduateeTableCell.h"
#import "JHMallOpreationTableCell.h"
#import "JHMallCategoryTableCell.h"
#import "JHWebViewController.h"
#import "JHMallModel.h"
#import "JHMallTrackView.h"
#import "JHMallListView.h"
///七鱼相关
#import "JHQiYuVIPCustomerServiceManager.h"
#import "JHSkinManager.h"
#import "JHSkinSceneManager.h"
#import "JHNewUserRedPacketAlertView.h"
#import "JHMallNewPeopleGiftTableViewCell.h"
#import "JHMallHomeLoginTipsView.h"

#import "JHRecycleDetailNoticeManager.h"
#import "JHSkinSceneManager.h"
#import "JHStoreHomeTopBar.h"
#import "JHStoreHomePageController.h"

#define kOrignBuyPageDataPath  @"kOrignBuyPageDataPath"
#define SECTION_MAX        6
#define kCycleHeaderHeight 138.5f
#define kTableBgHeight  500.

static NSString *const kTrackViewId = @"50";
static NSString *const kRecommendViewId = @"0";

@interface JHMallPageViewController ()
<JXPageListViewDelegate,
JXPageListMainTableViewGestureDelegate,
UITableViewDataSource, UITableViewDelegate
>
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, copy) NSArray <JHMallCateModel *>*channelArray;
@property (nonatomic, assign) NSInteger lastSelectIndex;
@property (nonatomic, assign) BOOL viewAppear;
@property (nonatomic, strong) NSMutableArray *listViews;

///首页改版新增
//左右滑动切换相关


///轮播header
@property (nonatomic, strong) JHMallRecommendBannarView *cycleHeader;

///头部直播间轮播图高度
@property(nonatomic,assign) CGFloat cycleViewH;
@property (nonatomic, strong) JHRefreshGifHeader *refreshHeader;
///关注足迹的view
@property (nonatomic, strong) JHMallTrackView *trackView;
///推荐的页面
@property (nonatomic, strong) JHMallLivingListView *recommendView;
///记录最后选择的view
@property (nonatomic, strong) JHMallListView *lastListView;
///查看更多分类按钮
@property (nonatomic, strong) UIButton *moreButton;


@property (nonatomic, strong) JHMallModel *mallModel;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, assign) CGFloat bgImageViewHeight;
@property (nonatomic, assign) BOOL addHideOpreate,addSubOperate,addOperation, addRedPacket;

/// 新人礼包
@property (nonatomic, strong) JHNewUserRedPacketAlertViewSubModel *redPacketModel;
/// 登录提示框
@property (nonatomic, strong) JHMallHomeLoginTipsView *loginTipsView;

@end

@implementation JHMallPageViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"---- %s被释放了🔥🔥🔥🔥 ------", __func__);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cycleViewH = 0.f;
        _addHideOpreate= NO;
        _addSubOperate = NO;
        _addOperation = NO;
        _addRedPacket = NO;
        if (![UserInfoRequestManager sharedInstance].hiddenHomeSaleTips) {
            _bgImageViewHeight = [JHTMallGranduateeTableCell viewHeight]+12.f;
        }
        else {
            _bgImageViewHeight = 0;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self configPageListView];
    
    [self.pageListView.mainTableView.mj_header beginRefreshing];
    
    [self addObserver];
    //用户画像浏览时长:begin
    if(![JHUserStatistics hasResumeBrowseEvent]) {
        [JHUserStatistics noteEventType:kUPEventTypeLiveShopHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
    }
    [JHNewUserRedPacketAlertView getNewUserRedPacketAlertView];
}

- (void)setPushLastSelectIndex:(NSInteger)index {
    if (self.channelArray.count >0) {
        self.lastSelectIndex = index;
        [self.pageListView.pinCategoryView selectItemAtIndex:index];
    } else {
        self.lastSelectIndex = index;
    }
}


- (void)loadQiYuInfo {
    [[JHQiYuVIPCustomerServiceManager shared] loadQiYuInfo:NO];
}

- (void)loadRecycle {
    [[JHRecycleDetailNoticeManager shared] loadRecycleDetailNotice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.viewAppear = YES;
    /// 七鱼VIP客服相关
    [self loadQiYuInfo];
    [self loadRecycle];
    [self loadLoginTipsView];
    [self reportPageView];
}

- (void)loadLoginTipsView {
    if (!self.loginTipsView) {
        self.loginTipsView = [[JHMallHomeLoginTipsView alloc] init];
        [_vc.view addSubview:self.loginTipsView];
//        [self.view addSubview:self.loginTipsView];
        [self.loginTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(49.f);
        }];
    }
    if (![JHRootController isLogin]) {
        [JHGrowingIO trackEventId:@"dlyd_show"];
        self.loginTipsView.hidden = NO;
    } else {
        self.loginTipsView.hidden = YES;
    }
}

- (void)addScrollAnimation:(CGFloat)scrollY{
//    self.view.top = UI.statusAndNavBarHeight + StoreHomeTopBarHeight + ceilf(scrollY);// UI.statusAndNavBarHeight + 50 + scrollY;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshTrackVCData];
    ///通知直播间拉流
    [self.lastListView beginPullSteam];
        
    BOOL isShowAd = [JHUserDefaults boolForKey:kShowAdversePage];
    if (isShowAd) {  ///99红包的展示
        [JH99FreeViewController get99FreeInfo];
    }
    
    [JHHomeTabController changeStatusWithMainScrollView:self.pageListView.mainTableView index:1];
    [JHAppAlertViewManger appCurrentLocalHomePage:JHAppAlertLocalTypeMallPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.lastListView changeCategaryUpLoad];
    [super viewWillDisappear:animated];
     self.viewAppear = NO;
    [JHAppAlertViewManger appCurrentLocalHomePage:JHAppAlertLocalTypeNone];
}

///刷新关注/足迹的数据
-(void)refreshTrackVCData {
    if (self.lastListView.pageIndex == 0) {
        [self.lastListView refreshData];
    }
}

///360 暂时注释 --- TODO lihui
- (void)tableBarSelect:(NSInteger)currentIndex {
//    if ([self.lastVC isRefreshing]) {
//        return;
//    }
//    [self.lastVC refreshData:currentIndex];
}

#pragma mark - 进入前后台Observer
- (void)addObserver {
    //进程被杀死
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillTerminateNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        NSLog(@"qiqianqianqian__22");
        [JHUserDefaults removeObjectForKey:k99FreeEnterForeGroundShow];
        [JHUserDefaults removeObjectForKey:kShowAdversePage];
    }];
    ///99包邮 广告页完成后需要触发一次弹窗
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kMallPage99FreeNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        [JH99FreeViewController get99FreeInfo];
    }];
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:NotificationNameGotoUsedAppraiseRedPacket object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self selectedRecommendList];
    }];
}

-(void)selectedRecommendList {
    [self.pageListView.pinCategoryView selectItemAtIndex:1];
    [self.recommendView scrollViewToListTop];
}

///首页改版
#pragma mark -
#pragma mark - UITableViewDelegate、UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JHMallPageSectionOperate) {
        return self.mallModel.operationPosition.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JHMallPageSectionChannel) {  ///商品分类列表
        //Tips:最后一个section（即listContainerCell所在的section）返回listContainerCell的高度
//        return [self.pageListView listContainerCellHeight];
        return self.view.bounds.size.height + ScrollHeadBarHeight;
    }
    if (indexPath.section == JHMallPageSectionGraduatee &&
        ![UserInfoRequestManager sharedInstance].hiddenHomeSaleTips) {
        return [JHTMallGranduateeTableCell viewHeight];
    }
    if (indexPath.section == JHMallPageSectionHideOperate) { ///隐藏运营位
        JHMallOperateModel *model = self.mallModel.hidePperationPosition;
        if (model && model.width > 0 && model.height > 0) {
            return (ScreenW - 24.f)*model.height/model.width+(model.interSpace ? 10 : 0);
        }
        return CGFLOAT_MIN;
    }
    if (indexPath.section == JHMallPageSectionCategory) {
        NSArray *cateInfos = self.mallModel.operationSubjectList;
        NSInteger cateLine = ceil((double)cateInfos.count / 5);
        return cateLine*[JHMallCategoryTableCell viewHeight];
    }
    if (indexPath.section == JHMallPageSectionOperate) {
        ///金刚位和分类导航中间的运营位
        JHMallOperateModel *model = self.mallModel.operationPosition[indexPath.row];
        if (model && model.width > 0 && model.height > 0) {
            return (ScreenW - 24.f)*model.height/model.width+(model.interSpace ? 10 : 0);
        }
        return CGFLOAT_MIN;
    }
    if(indexPath.section == JHMallPageSectionNewUserPacket && self.redPacketModel) {
        /// 新人活动入口
        return [JHMallNewPeopleGiftTableViewCell cellHeight];
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JHMallPageSectionChannel) {
        //Tips:最后一个section（即listContainerCell所在的section）配置listContainerCell
        return [self.pageListView listContainerCellForRowAtIndexPath:indexPath];
    }
    if (indexPath.section == JHMallPageSectionGraduatee &&
        ![UserInfoRequestManager sharedInstance].hiddenHomeSaleTips) { ///保障栏
        JHTMallGranduateeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHTMallGranduateeTableCell"];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    if (indexPath.section == JHMallPageSectionCategory) { ///金刚位
        JHMallCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMallCategoryTableCell"];
        cell.categoryInfos = self.mallModel.operationSubjectList;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    if (indexPath.section == JHMallPageSectionHideOperate ||
        indexPath.section == JHMallPageSectionOperate) { ///运营位
        JHMallOpreationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMallOpreationTableCell"];
        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.section == JHMallPageSectionHideOperate) {  ///隐藏运营位
            cell.operateModel = self.mallModel.hidePperationPosition;
        }
        else {
            cell.operateModel = self.mallModel.operationPosition[indexPath.row];
        }
        return cell;
    }
    
    if(indexPath.section == JHMallPageSectionNewUserPacket && self.redPacketModel) {
        /// 新人活动入口
        JHMallNewPeopleGiftTableViewCell *cell = [JHMallNewPeopleGiftTableViewCell dequeueReusableCellWithTableView:tableView];
        cell.model =self.redPacketModel;
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JHMallPageSectionGraduatee) {  /// 保障栏
        /// v3.8.4 修改为跳转到购物鉴定
        [JHDispatch after:0.2f execute:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JHMallPageSectionGraduateeDidClicked" object:nil];
        }];
        JHHomeTabController *tabVC = (JHHomeTabController *)self.tabBarController;
        [tabVC setTableSelectIndex:3];
        //处理点击运营位跳转VC后tabBar不切换问题
        NSDictionary *dict = @{
            @"selectedIndex":@"3"
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"POST_JHHOMETABCONTROLLER" object:dict];
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickUserGuarantee" params:@{
            @"page_position":@"直播购物首页"
        } type:JHStatisticsTypeSensors];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == JHMallPageSectionGraduatee &&
        ![UserInfoRequestManager sharedInstance].hiddenHomeSaleTips) {
        return 6.f;
    }
    if (section == JHMallPageSectionHideOperate && self.mallModel.hidePperationPosition != nil) {
        return 12.f;
    }
    if (section == JHMallPageSectionOperate &&
        self.mallModel.operationPosition.count > 0) {
        return 12.f;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ((section == JHMallPageSectionGraduatee &&
        ![UserInfoRequestManager sharedInstance].hiddenHomeSaleTips) ||
        section == JHMallPageSectionCategory) {
        UIView *view = [[UIView alloc] init];
        
        return view;
    }
    return [UIView new];
}

#pragma mark -
#pragma mark - JXPageListViewDelegate
//Tips:实现代理方法
- (NSArray<UIView<JXPageListViewListDelegate> *> *)listViewsInPageListView:(JXPageListView *)pageListView {
    return _listViews;
}

//选中某个index的回调
- (void)pinCategoryView:(JXCategoryBaseView *)pinCategoryView didSelectedItemAtIndex:(NSInteger)index {
    [self.lastListView shutdownPlayStream];
    [self.lastListView changeCategaryUpLoad];
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    JHMallLivingListView *currentView = self.listViews[index];
    if (self.lastListView == currentView) {
        ///如果当前选择的是之前选择过的页面 不做处理 没有刷新操作
        if (currentView.needRequestData) {
            [currentView refreshData];
        }
        return;
    }
//    else if ([currentView.channelModel.Id isEqualToString:kTrackViewId]) {
    else if (index == 0) {
        //保证关注足迹页每次切换能触发刷新
        [currentView refreshData];
    }
    else if (currentView.needRequestData) {
        ///当前页面如果数据为0的时候需要重新请求数据
        [currentView refreshData];
    }

    self.lastListView = currentView;
    [JHHomeTabController setSubScrollView:currentView.collectionView];
    self.lastSelectIndex = index;
    ///通知直播间拉流
    [self.lastListView beginPullSteam];

    //用户画像埋点
    [self trackEventAtIndex:index];

    for (JHMallCateModel *model in self.channelArray) {
        model.isDefault = NO;
    }

    JHMallCateModel *model = self.channelArray[index];
    model.isDefault = YES;
    
    //埋点
    NSDictionary *param = @{
        @"tag_name":model.name,
        @"page_position":@"源头直购首页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickTag" params:param type:JHStatisticsTypeSensors];
    
    ///360埋点：直播间分类标签
//    [JHGrowingIO trackEventId:JHTrackMallLivingTabClick variables:@{@"tabname":model.name, @"tabId":model.Id}];
}

///点击了更多按钮的点击事件
- (void)pageListView:(JXPageListView *)pageListView didClickMore:(id)sender {
    [self.pageListView.mainTableView scrollToRow:0 inSection:JHMallPageSectionChannel atScrollPosition:UITableViewScrollPositionNone animated:YES];
    JHMallSelectMoreController *vc = [[JHMallSelectMoreController alloc] init];
    vc.channelArray = self.channelArray;
    self.definesPresentationContext = YES;
    vc.edgesForExtendedLayout = UIRectEdgeAll;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    @weakify(self);
    vc.selectBlock = ^(JHMallCateModel * _Nonnull cateModel, NSInteger selectIndex) {
        if (selectIndex != _lastSelectIndex) {
            @strongify(self);
            self.lastSelectIndex = selectIndex;
            JHMallLivingListView *listView = self.listViews[selectIndex];
            JHMallCateModel *model = self.channelArray[selectIndex];
            model.isDefault = YES;
//            [listView refreshData];
            [self.pageListView.pinCategoryView selectItemAtIndex:selectIndex];
        }
    };
    [self presentViewController:vc animated:NO completion:^{
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Tips:需要传入mainTableView的scrollViewDidScroll事件
    [self.pageListView mainTableViewDidScroll:scrollView];
    if(scrollView.contentOffset.y > 10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
    }
    [JHHomeTabController changeStatusWithMainScrollView:self.pageListView.mainTableView index:1];
    CGFloat offsetY = self.pageListView.mainTableView.contentOffset.y;
    if (offsetY < 0) {
        self.lastListView.isRefresh = YES;
    }else{
        self.lastListView.isRefresh = NO;
    }
    if (offsetY < _bgImageViewHeight) {
        _bgImageView.hidden = NO;
        ///需要根据tableView滑动的offSetY值改变背景的frame
        CGRect bgRect = _bgImageView.frame;
        bgRect.origin.y = - offsetY;
        _bgImageView.frame = bgRect;
    }
    else {
        _bgImageView.hidden = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
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
#pragma mark - JXPageListMainTableViewGestureDelegate
//Tip：必须实现，不然滑动会有冲突！！！！！
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isMemberOfClass:[UICollectionView class]]) {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)trackEventAtIndex:(NSInteger)index {
    if(index >= 0 && index < self.channelArray.count) {
        ///不确定要不要 暂时注释掉！！！ --- TODO lihui
//        [JHGrowingIO trackEventId:JHMarketSecondTabSwitch variables: @{@"second_tabname":self.channelArray[index].name ? : @""}];
        //用户画像埋点
        [JHUserStatistics noteEventType:kUPEventTypeLiveLabelTabClick params:@{@"group1_id" : self.channelArray[index].Id ? : @""}];
    }
}

#pragma mark -
#pragma mark - Data Method

- (void)loadCategoryData:(dispatch_block_t)block {
    [SourceMallApiManager getSourceMallCate:@"" Completion:^(NSArray *channels, BOOL hasError) {
        if (channels == nil) {
            channels = [JHPersistData persistDataByPath:kOrignBuyPageDataPath];
        }
        else {
            [JHPersistData savePersistData:channels savePath:kOrignBuyPageDataPath];
        }
        self.channelArray = channels;
        [self resolveChannelData];
        if (block) {
            block();
        }
    }];
}

- (void)resolveChannelData {
    NSMutableArray *channelTitles = [NSMutableArray new]; //所有分类标签
    _listViews = [NSMutableArray array];
    for (NSInteger i = 0; i < self.channelArray.count; i++) {
        JHMallCateModel *model = self.channelArray[i];
        [channelTitles addObject:model.name];
        if (model.isDefault) {
            _lastSelectIndex = i;
        }
//        if ([[self.channelArray[i] Id] isEqualToString:kTrackViewId] ) { ///足迹
//            _trackView = [self addTrackView:self.channelArray[i]];
//            [_listViews addObject:_trackView];
//        }
//        else  if ([[self.channelArray[i] Id] isEqualToString:kRecommendViewId])  {
//            ///推荐
//            _recommendView = [self addRecommendView:self.channelArray[i]];
//            [_listViews addObject:_recommendView];
//        }
        if (i == 0) { ///足迹
            _trackView = [self addTrackView:self.channelArray[i]];
            [_listViews addObject:_trackView];
        }
        else if (i == 1)  {
            ///推荐
            _recommendView = [self addRecommendView:self.channelArray[i]];
            [_listViews addObject:_recommendView];
        }
        else{
            JHMallLivingListView *listView = [[JHMallLivingListView alloc] initWithChannelInfo:model];
            [_listViews addObject:listView];
        }
    }
    
    self.pageListView.titles = channelTitles;
    self.lastListView = self.listViews[_lastSelectIndex];
    NSLog(@"======== loadCategoryData");
}

-(void)requestSpecianAreaInfo:(dispatch_block_t)block {
    @weakify(self);
    [SourceMallApiManager getMallCustomSpecialAreaCompletion:^(RequestModel *respondObject, NSError *error) {
        @strongify(self);
        self.mallModel = [JHMallModel mj_objectWithKeyValues:respondObject.data];
        NSLog(@"======== requestSpecianAreaInfo");
        if (block) {
            block();
        }
    }];
}

- (void)caculateBgImageViewHeight {
    if (self.mallModel.operationSubjectList.count > 0 && !self.addSubOperate) {
        self.addSubOperate = YES;
        NSArray *cateInfos = self.mallModel.operationSubjectList;
        NSInteger cateLine = ceil((double)cateInfos.count / 5);
        self.bgImageViewHeight += cateLine*[JHMallCategoryTableCell viewHeight];
    }
    if (self.mallModel.hidePperationPosition != nil && !self.addHideOpreate) {
        self.addHideOpreate = YES;
        JHMallOperateModel *model = self.mallModel.hidePperationPosition;
        if (model && model.width > 0 && model.height > 0) {
            self.bgImageViewHeight += (ScreenW - 24.f)*model.height/model.width+(model.interSpace ? 10 : 0)+12.;
        }
        else {
            self.bgImageViewHeight += (model.interSpace ? 10 : 0) + 12.;
        }
    }
    if (self.mallModel.operationPosition.count > 0 && !self.addOperation) {
        self.addOperation = YES;
        for (JHMallOperateModel *model in self.mallModel.operationPosition) {
            if (model && model.width > 0 && model.height > 0) {
                self.bgImageViewHeight += (ScreenW - 24.f)*model.height/model.width+(model.interSpace ? 10 : 0);
            }
        }
        self.bgImageViewHeight += 12.;
    }
    
    if(self.redPacketModel && !_addRedPacket) {
        self.bgImageViewHeight += [JHMallNewPeopleGiftTableViewCell cellHeight];
        _addRedPacket = YES;
    }
}

- (void)updateCycleHeaderInfos {
    self.cycleHeader.bannarArray = self.mallModel.slideShow;
    BOOL hideHeader = (self.cycleHeader.bannarArray.count <= 1);
    self.cycleHeader.hidden = hideHeader;
    CGSize size = [JHMallRecommendBannarView viewSize];
    CGFloat bannerHeight = !hideHeader ?  size.height : 0;
    if (self.cycleViewH == 0) {
        _bgImageViewHeight += bannerHeight;
    }
    self.cycleViewH = !hideHeader ? size.height : 0;
    CGRect rect = self.cycleHeader.frame;
    rect.size.height = self.cycleViewH;
    self.cycleHeader.frame = rect;
    
    CGRect bgRect = self.bgImageView.frame;
    bgRect.size.height = _bgImageViewHeight;//_bgImageViewHeight;
    self.bgImageView.frame = bgRect;
}

///刷新数据
- (void)refresh {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    [JHNewUserRedPacketAlertView getNewUserRedPacketEntranceWithLocation:1 complete:^(JHNewUserRedPacketAlertViewModel * _Nullable model) {
        self.redPacketModel = model.banner;
        dispatch_group_leave(group);
    }];
    
    [self loadCategoryData:^{
        dispatch_group_leave(group);
    }];
    [self requestSpecianAreaInfo:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"数据请求完毕！！！！！");
        [self caculateBgImageViewHeight];
        [self endRefresh];
        [self updateCycleHeaderInfos];
        [self.pageListView reloadData];
        [self.pageListView.mainTableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pageListView.pinCategoryView selectItemAtIndex:_lastSelectIndex];
        });
    });
    [[JHSkinSceneManager shareManager] loadData];
}

- (void)endRefresh {
    [self.pageListView.mainTableView.mj_header endRefreshing];
    [self.pageListView.mainTableView.mj_footer endRefreshing];
}

//导航标签视图
- (void)configPageListView {
    if (!_pageListView) {
        _pageListView = [JHMallHelper pageListWithDelegate:self];
        _pageListView.pinCategoryViewHeight = 45.f;
        _pageListView.mainTableView.tableHeaderView = self.cycleHeader;
        _pageListView.pinCategoryView.backgroundColor = [UIColor clearColor];
        self.cycleHeader.backgroundColor = [UIColor clearColor];
        //_pageListView.mainTableView.backgroundColor = [UIColor redColor];
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:_pageListView.mainTableView.frame];
        backImageView.backgroundColor = [UIColor orangeColor];
        [_pageListView.mainTableView addSubview:backImageView];
        
        _pageListView.mainTableView.mj_header = self.refreshHeader;
        _pageListView.showMoreButton = YES;
        [self.view addSubview:_pageListView];
        _pageListView.pinCategoryView.backgroundColor = [UIColor whiteColor];
        [_pageListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        ///修改刷新状态的监听
        [self.refreshHeader addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        //UIImage *bgImage = [UIImage imageNamed:@"icon_shop_header_default.jpeg"];
        //UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        UIImageView *bgImageView = [[UIImageView alloc] init];
        
//        JHSkinModel *model = [JHSkinManager entiretyBody];
//        if (model.isChange)
//        {
//            if ([model.type intValue] == 0)
//            {
//                bgImageView.image = [JHSkinManager getEntiretyBodyImage];
//            }
//            else if ([model.type intValue] == 1)
//            {
//                UIColor *color = [UIColor colorWithHexStr:model.name];
//                bgImageView.backgroundColor = color;
//            }
//        }
        bgImageView.frame = CGRectMake(0, 0, ScreenW, _bgImageViewHeight);//
        [self.view insertSubview:bgImageView belowSubview:_pageListView];
        _bgImageView = bgImageView;
        
        JHSkinSceneManager *manager = [JHSkinSceneManager shareManager];
        
        @weakify(self)
        [RACObserve(manager, sceneBGModel) subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            JHSkinSceneModel *scene = x;
            if (scene == nil) return;
            self.bgImageView.image = scene.imageNor;
            self.bgImageView.backgroundColor = scene.colorBGNor;
        }];
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

- (JHMallTrackView *)addTrackView:(JHMallCateModel *)model {
    if (!_trackView) {
        _trackView = [[JHMallTrackView alloc] initWithChannelInfo:model];
        _trackView.pageIndex = 0;
        
    }
    return _trackView;
}

- (JHMallLivingListView *)addRecommendView:(JHMallCateModel *)model {
//    if (!_recommendView) {
        _recommendView = [[JHMallLivingListView alloc] initWithChannelInfo:model];
        _recommendView.pageIndex = 1;
//    }
    return _recommendView;
}

///直播间轮播header
- (JHMallRecommendBannarView *)cycleHeader {
    if (!_cycleHeader) {
        CGSize size = [JHMallRecommendBannarView viewSize];
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        _cycleHeader = [[JHMallRecommendBannarView alloc] initWithFrame:rect];
        _cycleHeader.backgroundColor = [UIColor clearColor];
     }
    return _cycleHeader;
}

- (JHRefreshGifHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _refreshHeader.automaticallyChangeAlpha = NO;
    }
    return _refreshHeader;
}

#pragma mark - 埋点
- (void)reportPageView {
    NSDictionary *par = @{
        @"page_name" : @"源头直购首页",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
@end
