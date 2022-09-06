//
//  JHShopWindowPageController.m
//  TTjianbao
//
//  Created by wuyd on 2020/5/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShopWindowPageController.h"
#import "JXPagerView.h"
#import "JXCategoryView.h"
#import "JHShopWindowReusableView.h"
#import "JHBaseOperationView.h"
#import "JHShopWindowController.h"
#import "JHShopWindowModel.h"
#import "JHStoreApiManager.h"
#import "JHSortMenuView.h"
#import "JHStoreHelp.h"
#import "PanNavigationController.h"

#define kTitleCategoryHeight (44)
#define kSortMenuHeight (44)

@interface JHShopWindowPageController ()
<
JXCategoryViewDelegate,
JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,
JHSortMenuViewDelegate
>
{
    CGFloat _alphaValue; //导航栏透明度动态值
    BOOL    _isRefresh; //是否是下拉刷新
    BOOL    _hasMargin; //解决indicatorView位置错误问题
    BOOL    _hasGrowing; //已经埋点
}

@property (nonatomic, strong) JHShopWindowModel *curModel;

@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryIndicatorBackgroundView *indicatorView;
@property (nonatomic, strong) JHShopWindowReusableView *customHeaderView;
@property (nonatomic, strong) JHSortMenuView *sortView; //排序工具栏

@property (nonatomic, strong) PanNavigationController *navi;

@property (nonatomic, strong) JHShopWindowController *singleListVC; //没有标签栏时使用
@property (nonatomic, strong) NSMutableDictionary <NSString *, id<JXPagerViewListViewDelegate>> *listCache;
 
@end


@implementation JHShopWindowPageController

- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
}

#pragma mark - 设置状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return (_alphaValue <= 0.5 ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
    self.navigationController.navigationBar.translucent = false;
    
    _listCache = [NSMutableDictionary dictionary];
    
    _navi = (PanNavigationController *)self.navigationController;
    
    _curModel = [[JHShopWindowModel alloc] init];
    _curModel.sc_id = _showcaseId;
    
    [self addCategoryView];
    [self addSortMenu];
    
    //必须放到创建categoryView之后！！！
    [self configNaviBar];
    
    [self sendRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _navi.isForbidDragBack = YES; //禁止全屏侧滑
    [self beginEventStastics];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _navi.isForbidDragBack = NO; //开启右滑返回功能
    [self endEventStastics];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self growingSetParamDict:@{ @"from": self.fromSource ? : @"", @"title" : _curModel.windowInfo.name ? : @""}];
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagerView.frame = self.view.bounds;
}

#pragma mark -
#pragma mark - UI Methods

- (void)configNaviBar {
    [self showNaviBar];
    self.naviBar.title = @"";
    self.naviBar.titleLabel.alpha = 0;
    self.naviBar.leftImage = kNavBackWhiteImg;
    self.naviBar.rightImage = kNavShareWhiteImg;
    [self.view addSubview:self.naviBar];
}

- (void)updateNaviBar {
    BOOL isHidden = _alphaValue <= 0.5;
    [self.naviBar setTitle:!isHidden ? _curModel.windowInfo.name : @""];
    [UIView animateWithDuration:0.25 animations:^{
        self.naviBar.backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:_alphaValue];
        self.naviBar.titleLabel.alpha = _alphaValue;
        self.naviBar.leftImage = isHidden ? kNavBackWhiteImg : kNavBackBlackImg;
        self.naviBar.rightImage = isHidden ? kNavShareWhiteImg : kNavShareBlackImg;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma mark - button action
- (void)rightBtnClicked {
    NSLog(@"分享");

    NSString *objectStr = @(_curModel.windowInfo.sc_id).stringValue;
    JHShareInfo* info = _curModel.shareInfo;
    info.shareType = ShareObjectTypeStoreSpecialTopic;
    [JHBaseOperationView showShareView:info objectFlag:objectStr]; //TODO:Umeng share
//    [[UMengManager shareInstance] showCustomShareTitle:titleStr
//                                                  text:descStr
//                                              thumbUrl:imgStr
//                                                webURL:urlStr
//                                                  type:ShareObjectTypeStoreSpecialTopic
//                                                object:@(_curModel.windowInfo.sc_id).stringValue
//                                            isShowMore:NO
//                                                  isMe:NO];
}

- (void)addCategoryView {
    __weak typeof(self) weakSelf = self;
    _customHeaderView = [[JHShopWindowReusableView alloc] init];
    _customHeaderView.timerBlock = ^{
        //倒计时结束后需要更新数据
        [weakSelf sendRequest];
    };
    
    _categoryView = [JHStoreHelp titleCategoryViewWithDelegate:self];
    _categoryView.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
    _categoryView.titleLabelVerticalOffset = -(kSortMenuHeight/2); //偏移量
    
    //cell指示器样式
    _indicatorView = [[JXCategoryIndicatorBackgroundView alloc] init];
    _indicatorView.indicatorWidthIncrement = 28; //背景色块的额外宽度
    _indicatorView.indicatorHeight = 28;
    _indicatorView.indicatorCornerRadius = 14;
    _indicatorView.indicatorColor = kColorMain;
    //_indicatorView.scrollEnabled = NO; //禁止指示器滚动
    _categoryView.indicators = @[_indicatorView];
    
    //分页
    _pagerView = [[JXPagerView alloc] initWithDelegate:self];
    _pagerView.listContainerView.scrollView.backgroundColor = kColorF5F6FA; //TMD必须设置！！不然黑屏！！
    _pagerView.mainTableView.gestureDelegate = self;
    _pagerView.pinSectionHeaderVerticalOffset = UI.statusAndNavBarHeight;
    [self.view addSubview:_pagerView];
    
    _categoryView.listContainer = (id<JXCategoryViewListContainer>)_pagerView.listContainerView;
    
    _pagerView.mainTableView.mj_header = self.refreshHeader;
}

- (void)addSortMenu {
    JHMenuMode *normalMode = [[JHMenuMode alloc] init];
    normalMode.title = @"推荐";
    normalMode.isShowImg = NO;
    
    JHMenuMode *timeMode = [[JHMenuMode alloc] init];
    timeMode.title = @"新品";
    timeMode.isShowImg = NO;
    
    JHMenuMode *priceMode = [[JHMenuMode alloc] init];
    priceMode.title = @"价格";
    priceMode.isShowImg = YES;
    
    _sortView = [[JHSortMenuView alloc] initWithFrame:CGRectZero menuArray:@[normalMode, timeMode, priceMode]];
    _sortView.backgroundColor = [UIColor clearColor];
    _sortView.delegate = self;
    _sortView.selectIndex = 0;
    [_categoryView addSubview:_sortView];
    
    _sortView.sd_layout
    .bottomEqualToView(_categoryView)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(kSortMenuHeight);
}

#pragma mark -
#pragma mark - 网络请求

- (void)refresh {
    if (!_hasMargin) {
        _hasMargin = YES;
        _indicatorView.verticalMargin = kSortMenuHeight/2; //偏移量
    }
    _isRefresh = YES;
    //_sortView.selectIndex = 0;
    [self sendRequest];
}

- (void)endRefresh {
    [self.refreshHeader endRefreshing];
}

//获取专题数据
- (void)sendRequest {
    @weakify(self);
    [JHStoreApiManager getWindowInfo:_curModel block:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self endRefresh];
        
        if (!hasError) {
            [self.curModel configModel:(JHShopWindowModel *)respObj];
        }
        [self reloadPageData];
        [self growingPoint];
    }];
}

- (void)reloadPageData {
    _customHeaderView.headerInfo = _curModel.windowInfo;
    
    //_categoryView.defaultSelectedIndex = 0;
    _categoryView.titles = _curModel.tagTitles.mutableCopy;
    [_categoryView reloadData];
    [_pagerView reloadData];
    
    NSLog(@"indicatorView.verticalMargin = %.2f", _indicatorView.verticalMargin);
}


#pragma mark -
#pragma mark - JHSortMenuViewDelegate

- (void)menuViewDidSelect:(JHMenuSortType)sortType {
    
    [self refreshListWithSort:sortType];
}

- (void)refreshListWithSort:(NSInteger)sort {
    
    if (_categoryView.titles.count > 0) {
        NSInteger curIndex = _categoryView.selectedIndex;
        JHShopWindowController *curVC = (JHShopWindowController *)_listCache[_categoryView.titles[curIndex]];
        [curVC refreshWithSort:sort];
        
    } else {
        [self.singleListVC refreshWithSort:sort];
    }
}

#pragma mark -
#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
    //切换页面后重置筛选项
    _sortView.selectIndex = 0;
    [self refreshListWithSort:0];
    JXCategoryTitleView* titleView = (JXCategoryTitleView*)categoryView;
    NSString* cate = @"";
    if(index >= 0 && index < [titleView.titles count])
    {
        cate = titleView.titles[index];
    }
    [JHGrowingIO trackEventId:JHTrackMarketSaleTopicTabSwitch variables:@{@"cate":cate}];
    //侧滑手势处理
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    _navi.isForbidDragBack = YES;
}

//- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    //侧滑手势处理
//    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
//}


#pragma mark -
#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.customHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return [JHShopWindowReusableView headerHeight];
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    if (_categoryView.titles.count > 0) {
        return kTitleCategoryHeight + kSortMenuHeight;
    } else {
        return kSortMenuHeight;
    }
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return _categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    if (_categoryView.titles.count > 0) {
        return _categoryView.titles.count;
    } else {
        return 1;
    }
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (_categoryView.titles.count > 0) {
        //id<JXPagerViewListViewDelegate> listInCache = self.listCache[_categoryView.titles[index]];
        JHShopWindowController *cacheVC = (JHShopWindowController *)self.listCache[_categoryView.titles[index]];
        
        if (cacheVC != nil) { //使用缓存页面
            if (_isRefresh) {
                [cacheVC refreshWithSort:_sortView.selectIndex];
            }
            return cacheVC;
            
        } else { //缓存页面
            JHShopWindowController *listVC = [JHShopWindowController new];
            listVC.showcaseId = self.showcaseId;
            listVC.fromSource = self.fromSource;
            listVC.topicName = self.curModel.windowInfo.name; //TODO？？？专题名称
            if (_curModel.tagList.count > 0) {
                listVC.tagId = _curModel.tagList[index].tag_id;
            }
            self.listCache[_categoryView.titles[index]] = listVC;
            
            return listVC;
        }
        
    } else {
        if (_curModel.tagList.count > 0) {
            self.singleListVC.tagId = _curModel.tagList[index].tag_id;
        }
        if (_isRefresh) {
            [self.singleListVC refreshWithSort:_sortView.selectIndex];
        }
        return self.singleListVC;
    }
}

- (JHShopWindowController *)singleListVC {
    if (!_singleListVC) {
        _singleListVC = [JHShopWindowController new];
        _singleListVC.showcaseId = self.showcaseId;
        _singleListVC.fromSource = self.fromSource;
        _singleListVC.topicName = self.curModel.windowInfo.name;
        _singleListVC.sortType = _sortView.selectIndex;
    }
    return _singleListVC;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    //导航栏渐变
    CGFloat thresholdDistance = 100;
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY = %.2f", offsetY);
    CGFloat ignoreOffsetY = 30.0; //忽略滑动的偏移量
    _alphaValue = (offsetY - ignoreOffsetY) / thresholdDistance;
    _alphaValue = MAX(0, MIN(1, _alphaValue));
    [self updateNaviBar];
    
    //分类标签栏背景色
    if (offsetY >= [JHShopWindowReusableView headerHeight] - UI.statusAndNavBarHeight - 5) {
        _categoryView.backgroundColor = [UIColor whiteColor];
    } else {
        _categoryView.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
    }
    
    //header背景图拉伸
    //[self.customHeaderView scrollViewDidScroll:offsetY];
}


#pragma mark -
#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)growingPoint {
    if (!_hasGrowing) {
        _hasGrowing = YES;
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        if(self.fromSource)
        {
            [dic setObject:self.fromSource forKey:@"from"];
        }
        if(_curModel.windowInfo.name)
        {
            [dic setObject:_curModel.windowInfo.name forKey:@"title"];
        }
        if([dic allKeys] > 0)
        {
            [JHGrowingIO trackEventId:JHTrackMarketSaleTopicListIn variables:dic];
        }
    }
}

#pragma - mark -
#pragma - mark - 用户画像埋点相关

///用户画像埋点 - 开始
- (void)beginEventStastics {
    //新人专享位停留时长
    if ([self.fromSource isEqualToString:JHTrackMarketSaleTopicFromNewcomer]) {
        [JHUserStatistics noteEventType:kUPEventTypeMallNewUserBannerBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin}];
    }
    //活动位列表页停留时长
    if ([self.fromSource isEqualToString:JHTrackMarketSaleTopicFromZone]) {
        [JHUserStatistics noteEventType:kUPEventTypeMallActivityListBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin,
                                                                                    @"activity_name":self.showcaseName,
                                                                                    @"activity_position":@(self.showcaseId)
        }];
    }
}

///用户画像埋点 - 结束
- (void)endEventStastics {
    //新人专享位停留时长
    if ([self.fromSource isEqualToString:JHTrackMarketSaleTopicFromNewcomer]) {
        [JHUserStatistics noteEventType:kUPEventTypeMallNewUserBannerBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd}];
    }
    //活动位列表页停留时长
    if ([self.fromSource isEqualToString:JHTrackMarketSaleTopicFromZone]) {
        [JHUserStatistics noteEventType:kUPEventTypeMallActivityListBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd,
                                                                                    @"activity_name":self.showcaseName,
                                                                                    @"activity_position":@(self.showcaseId)
        }];
    }
}


@end
