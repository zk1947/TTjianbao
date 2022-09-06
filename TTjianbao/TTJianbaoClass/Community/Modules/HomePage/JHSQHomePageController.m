//
//  JHSQHomePageController.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQHomePageController.h"
#import "JHSQHotListController.h"
#import "JHSQPlateListController.h"
#import "JHSQHelper.h"
#import "JHSQApiManager.h"
#import "JHSQUploadView.h"
#import "ZQSearchViewController.h"
#import "JHSearchResultViewController.h"
#import "JHSQMessageShowView.h"
#import "JHAppAlertViewManger.h"
#import "JHSQPublishSheetView.h"
#import "JHAudioPlayerManager.h"
#import "JHArbitramentEvidenceController.h"
#import "JHMarketHomeDataReport.h"
#import "JHMarketGoodsListViewController.h"

typedef NS_ENUM(NSInteger, JHCommunityTabType)
{
    JHCommunityTabTypeRecommend = 0, // 推荐
    JHCommunityTabTypeHot = 1, //热帖
    JHCommunityTabTypePlate = 2, //板块
};

@interface JHSQHomePageController () <ZQSearchViewDelegate>
{
//    UIButton *_messageButton; //消息按钮
    NSInteger _clickTitleIndex; //记录点击的标签项，用于点击回到顶部，只在点击tab时用
    JHCommunityTabType selectedTab; //推荐、热帖、板块
}

///** 头部背景 */
//@property (nonatomic, strong) UIImageView *searchBgView1;

//搜索框
//@property (nonatomic, strong) JHEasyPollSearchBar *searchBar;
//vc
@property (nonatomic, strong) JHSQRcmdListController *rcmdListVC;
@property (nonatomic, strong) JHSQHotListController *hotListVC;
@property (nonatomic, strong) JHSQPlateListController *plateListVC;
//当前选中的频道id
@property (nonatomic, assign) NSInteger curChannelId;

///推荐的状态，用于刷新标识
@property (nonatomic, assign) BOOL isOpenRecommend;

@property (nonatomic, assign) BOOL isViewVisable;

@end

@implementation JHSQHomePageController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //首次启动切换到发现页
    if ([JHSQManager isFirstLaunch]) {
        [JHSQManager setMute:YES];
    }
    
    [self configPageTitleView];
    [self addObserver];
    
    _isOpenRecommend = IS_OPEN_RECOMMEND;
    
    //发布信息按钮
    [JHSQPublishSheetView showPublishSheetViewWithType:0 topic:nil plate:nil addSuperView:self.view];
    
//    UIButton *btn = [UIButton jh_buttonWithTarget:self action:@selector(btnClick) addToSuperView:self.view];
//    btn.frame = CGRectMake(100, 100, 100, 100);
//    btn.backgroundColor = [UIColor redColor];
}

- (void)btnClick {
    JHMarketGoodsListViewController *vc = [[JHMarketGoodsListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isViewVisable = YES;
    //页面埋点
    [JHMarketHomeDataReport marketCommunityPageReport];
    
    //更新搜索词
//    if (self.searchBar.placeholderArray.count == 0) {
//        @weakify(self);
//        [JHSQApiManager getHotWords:^(NSArray<JHHotWordModel *> * _Nullable respObj, BOOL hasError) {
//            @strongify(self);
//            self.searchBar.placeholderArray = respObj.mutableCopy;
//        }];
//    }
    
    //红点数
//    [self getAllUnreadMsgCount:^(NSString *count) {
//        [self->_messageButton jh_moveBadgeWithX:-16 Y:10];
//        [self->_messageButton jh_setBadgeFlexMode:JHBadgeFlexModeLeft];
////        [self->_messageButton jh_addBadgeNumber:count.integerValue];
//        if([count isKindOfClass:[NSString class]] && [count intValue] > 0)
//            [self->_messageButton jh_addBadgeText:[self numberString:count]];
//        else
//            [self->_messageButton jh_hideBadge];
//    }];
    
    //检查是否正在上传帖子
    if ([JHSQUploadView show]) {
        [self.rcmdListVC showUploadProgress];
//        [self.titleCategoryView selectItemAtIndex:0];
    }
    
    if(_isOpenRecommend != IS_OPEN_RECOMMEND)
    {
        _isOpenRecommend = IS_OPEN_RECOMMEND;
        self.titles = @[IS_OPEN_RECOMMEND ? @"推荐" : @"精选", @"热帖", @"版块"];
        self.titleCategoryView.titles = self.titles;
        [self.titleCategoryView reloadData];
    }
    [JHAppAlertViewManger showSuperRedPacketEnterWithSuperView:self.view];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithTop:ScreenH - 354];//SQRedPacketToBottom
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"bensound-creativeminds.mp3" withExtension:nil];
    [[JHAudioPlayerManager shareManger] createAudioWithAudioUrl:url];
    [[JHAudioPlayerManager shareManger] play];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isViewVisable = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [JHSQManager checkSQChannelNeedToSelectCompleteBlock:^{
    }];
}

- (NSString*)numberString:(NSString*)count
{
    NSInteger num = count.integerValue;

    if (num < 100)
    {
        return count;
    }

    return @"99+";
}

#pragma mark - Observer
- (void)addObserver {
    @weakify(self);
    
    //tabBar点击
    [[[JHNotificationCenter rac_addObserverForName:TableBarSelectNotifaction object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notification)
    {
        @strongify(self);
        BaseTabBarController * tabBarVC = (BaseTabBarController*)notification.object;
        if (tabBarVC.selectedIndex == 0) {
            if (self.titleCategoryView.selectedIndex == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.rcmdListVC handleTabBarClick];
                });
            } else if (self.titleCategoryView.selectedIndex == 2) {
                [self.plateListVC handleTabBarClick];
            }
        }
    }];

    [[[JHNotificationCenter rac_addObserverForName:kSQNeedSwitchToRcmdTabNotication object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notification) {
        @strongify(self); 
        [self.titleCategoryView selectItemAtIndex:0];
    }];
    
    [[[JHNotificationCenter rac_addObserverForName:kSQNeedSwitchToHotPostTabNotication object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notification) {
        @strongify(self);
        [self.titleCategoryView selectItemAtIndex:1];
    }];
    
    [[[JHNotificationCenter rac_addObserverForName:kSQNeedSwitchToPlateTabNotication object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notification) {
//        if (1) {
//            UIViewController *vc = [[NSClassFromString(@"JHLotteryPageController") alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
        @strongify(self);
        [self.titleCategoryView selectItemAtIndex:2];
    }];
    
    [[[JHNotificationCenter rac_addObserverForName:NotificationNameSocilHomeMessageChange object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notification)
    {
        @strongify(self);
        NSDictionary *dic = notification.object;
        NSInteger type = [[dic valueForKey:@"type"] integerValue];
        NSInteger total = [[dic valueForKey:@"total"] integerValue];
        [JHSQMessageShowView showType:type changeNum:total addToSuperView:self.view];
    }];
    
    
    //进入前台
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        //如果进入前台时当前页面在窗口
        if (self.isViewVisable) {
            //曝光埋点
            [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
                @"page_name":@"宝友社区首页"
            } type:JHStatisticsTypeSensors];
        }
    }];
    
}


#pragma mark -
#pragma mark - UI Methods

//导航标签
- (void)configPageTitleView {
    
    //标签栏
    self.titles = @[IS_OPEN_RECOMMEND ? @"推荐" : @"精选", @"热帖", @"版块"];
    self.titleCategoryView.titles = self.titles;
    
    /// 配置分类栏
    [JHSQHelper configPageTitleView:self.titleCategoryView indicator:nil];
    self.titleCategoryView.titleLabelVerticalOffset = 0;
    [self configMyTitleView];
    
    //布局
    self.titleCategoryView.sd_layout.topSpaceToView(self.view, 0);
    self.titleCategoryView.sd_layout.heightIs([self preferredCategoryViewHeight]);//kSearchBgHeight
    
//    searchBgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake([self preferredCategoryViewHeight], 0, 0, 0));
    
//    _messageButton.sd_layout
//    .rightSpaceToView(self.titleCategoryView, 0)
//    .centerYEqualToView(self.titleCategoryView).offset(-(kSearchBgHeight/2))
//    .widthIs(40).heightIs([self preferredCategoryViewHeight]);
    
//    _searchBar.sd_layout
//    .leftSpaceToView(searchBgView, 10)
//    .rightSpaceToView(searchBgView, 10)
//    .centerYEqualToView(searchBgView)
//    .heightIs(kSearchBarHeight);
    
    //禁止横向滚动
    self.listContainerView.scrollView.scrollEnabled = NO;
    
}

- (void)configMyTitleView{
    self.titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:17];
    self.titleCategoryView.titleLabelZoomEnabled = NO;
    self.titleCategoryView.titleLabelZoomScale = 1.0;
    self.titleCategoryView.cellWidthZoomEnabled = NO;
    self.titleCategoryView.cellWidthZoomScale = 1.0;
    self.titleCategoryView.indicators = @[];
}

- (void)showSearchVC {
    JHSearchResultViewController *resultController = [JHSearchResultViewController new];
    ZQSearchViewController *vc = [[ZQSearchViewController alloc] initSearchViewWithFrom:ZQSearchFromCommunity resultController:resultController];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - ZQSearchViewDelegate

- (void)searchFuzzyResultWithKeyString:(NSString *)keyString Data:(id<ZQSearchData>)data resultController:(UIViewController *)resultController From:(ZQSearchFrom)from{
    JHSearchResultViewController *vc = (JHSearchResultViewController *)resultController;
    [vc refreshSearchResult:keyString from:from keywordSource:data];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

- (void)trackUserProfilePage:(BOOL)isBegin
{
    if(isBegin)
    {
        //用户画像浏览时长:begin
        [JHUserStatistics noteEventType:[self trackEventFromIndex:selectedTab] params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
    }
    else
    {
        //用户画像浏览时长:end
        [JHUserStatistics noteEventType:[self trackEventFromIndex:selectedTab] params:@{JHUPBrowseKey:JHUPBrowseEnd} resumeBrowse:YES];
    }
}

- (NSString*)trackEventFromIndex:(NSInteger)index
{
    NSString *eventType;
    switch (index)
    {
        case JHCommunityTabTypeRecommend:
        default:
            eventType = kUPEventTypeCommunityRecommendBrowse;
            break;
            
        case JHCommunityTabTypeHot:
            eventType = kUPEventTypeCommunityHotBrowse;
            break;
            
        case JHCommunityTabTypePlate:
            eventType = kUPEventTypeCommunityPlateBrowse;
            break;
    }
    return eventType;
}

- (void)trackUserProfile:(NSInteger)index
{
    NSString *eventType, *lastEventType;
    
    if(selectedTab != index)
    {
        //用户画像浏览时长:end
        lastEventType = [self trackEventFromIndex:selectedTab];
        [JHUserStatistics noteEventType:lastEventType params:@{JHUPBrowseKey:JHUPBrowseEnd} resumeBrowse:YES];
        
        //用户画像浏览时长:begin
        eventType = [self trackEventFromIndex:index];
        [JHUserStatistics noteEventType:eventType params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
    }
    
    selectedTab = index;
}

#pragma mark - JXCategoryViewDelegate

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
    [JHGrowingIO trackEventId:JHTrackSQHomeSwitchTab]; //切换标签
    [self trackUserProfile:index];
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    if (index == 0 && _clickTitleIndex == index) {
//        [self.rcmdListVC scrollToTop];
    }
    _clickTitleIndex = index;
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    if (index == 0) {
        return self.rcmdListVC;
    } else if (index == 1) {
        return self.hotListVC;
    } else {
        return self.plateListVC;
    }
}


#pragma mark - Lazy load Methods：标签页

- (JHSQRcmdListController *)rcmdListVC {
    if (!_rcmdListVC) {
        _rcmdListVC = [[JHSQRcmdListController alloc] init];
        _rcmdListVC.pageType = JHPageTypeSQHome;
        @weakify(self);
        _rcmdListVC.headScrollBlock = ^(BOOL isUp) {
            @strongify(self);
            if (self.headScrollBlock) {
                self.headScrollBlock(isUp);
                [self setTitleColor:isUp];
                [[NSUserDefaults standardUserDefaults] setBool:isUp forKey:@"HeadSearchStatus"];
            }
        };
    }
    return _rcmdListVC;
}

- (JHSQHotListController *)hotListVC {
    if(!_hotListVC) {
        _hotListVC = [[JHSQHotListController alloc] init];
        @weakify(self);
        _hotListVC.headScrollBlock = ^(BOOL isUp) {
            @strongify(self);
            if (self.headScrollBlock) {
                self.headScrollBlock(isUp);
                [self setTitleColor:isUp];
                [[NSUserDefaults standardUserDefaults] setBool:isUp forKey:@"HeadSearchStatus"];
            }
        };
    }
    return _hotListVC;
}

- (JHSQPlateListController *)plateListVC {
    if(!_plateListVC) {
        _plateListVC = [[JHSQPlateListController alloc] init];
        _plateListVC.pageType = JHPageTypeSQHome;
        @weakify(self);
        _plateListVC.headScrollBlock = ^(BOOL isUp) {
            @strongify(self);
            if (self.headScrollBlock) {
                self.headScrollBlock(isUp);
                [self setTitleColor:isUp];
                [[NSUserDefaults standardUserDefaults] setBool:isUp forKey:@"HeadSearchStatus"];
            }
        };
    }
    return _plateListVC;
}

- (void)setTitleColor:(BOOL)isUp{
    NSMutableArray *visiableCells = [[self.titleCategoryView.collectionView visibleCells] mutableCopy];
    if (visiableCells.count > 2) {
        [visiableCells exchangeObjectAtIndex:1 withObjectAtIndex:0];
    }
    for (NSInteger index = 0; index < visiableCells.count; index ++) {
        JXCategoryTitleCell *cell = visiableCells[index];
        if (index == _clickTitleIndex) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cell.titleLabel.textColor = kColor333;
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cell.titleLabel.textColor = isUp ? kColor999 : kColor666;
            });
        }
    }
//    if (visiableCells.count > 2) {
//        [visiableCells exchangeObjectAtIndex:0 withObjectAtIndex:1];
//    }
}
@end
