//
//  JHNewShopDetailViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#define CategoryTitleViewHeight  45.0
#define NewShopDetailHeaderHeight  238 + UI.topSafeAreaHeight

#import "JHNewShopDetailViewController.h"
#import "JHNewShopDetailHeaderView.h"
#import <JXPagingView/JXPagerView.h>
#import <JXCategoryView.h>
#import "JHBaseOperationView.h"
#import "JHNewShopHotSellViewController.h"
#import "JHNewShopUserCommentViewController.h"
#import "JHMarketFloatLowerLeftView.h"
#import "JHNewShopDetailHeaderViewModel.h"
#import "JHNewShopDetailTabBarView.h"
#import "JHNewShopDetailClassView.h"
#import "JHIMEntranceManager.h"
#import "JHNewShopDetailInfoViewController.h"

@interface JHNewShopDetailViewController ()<JXPagerViewDelegate, JXCategoryViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic, strong) JHNewShopDetailHeaderView *headerView;
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, assign) CGFloat alphaValue;//记录导航栏的透明度
@property (nonatomic, strong) UILabel *userCommentLabel;//用户评论
@property (nonatomic, strong) UIView *shopCloseView;
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;//收藏返回顶部view
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, strong) JHNewShopDetailHeaderViewModel *shopHeaderViewModel;
@property (nonatomic, assign) BOOL isRequestUpdate;
@property (nonatomic, assign) BOOL isContinueRequest;//是否可以继续请求
@property (nonatomic, strong) JHNewShopDetailTabBarView *tabBarView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) JHNewShopDetailInfoModel *shopInfoModel;
@property (nonatomic, strong) JHNewShopDetailClassView *classView;
@property (nonatomic, strong) NSMutableArray *subVCArray;
@property (nonatomic, assign) NSInteger tagIndex;
@end

@implementation JHNewShopDetailViewController

- (void)dealloc{
    [JHNotificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.jhStatusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"商城店铺主页",
        @"store_name":self.shopInfoModel.shopName,
        @"store_id":self.shopInfoModel.shopId,
    } type:JHStatisticsTypeSensors];
    
    //收藏等数据刷新
    [self.floatView loadData];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.jhStatusBarStyle = UIStatusBarStyleDefault;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerViewHeight = NewShopDetailHeaderHeight-42-12;
    [self setupNavBarView];
    self.tagIndex = 0;
    [self setupListViewController];
    
    [self setupTabBarView];

    [self loadShopInfoData];
    [self configData];
    //登陆成功后刷新店铺信息
    [JHNotificationCenter addObserver:self selector:@selector(loadShopInfoData) name:@"kNewShopLoginSuccess" object:nil];
        
}

#pragma mark - UI
///顶部导航
- (void)setupNavBarView{
    //返回
    [self.jhLeftButton setImage:JHImageNamed(@"navi_icon_back_white") forState:UIControlStateSelected];
    //分享
    [self initRightButtonWithImageName:@"newStore_share_black_icon" action:@selector(clickShareActionButton:)];
    [self.jhRightButton setImage:JHImageNamed(@"newStore_share_white_icon") forState:UIControlStateSelected];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.jhNavView).offset(UI.statusBarHeight/2);
        make.right.equalTo(self.jhNavView).offset(-15);
    }];
    
    self.jhNavView.backgroundColor = UIColor.clearColor;
}
///subView
- (void)setupListViewController{
    
    [self changeNavStatusHidden:YES];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    
    //右下角浮窗按钮
    [self.view addSubview:self.floatView];

}


//店铺关闭提示
- (void)setupShopCloseView{
    UIView *shopCloseView = [UIView jh_viewWithColor:RGBA(25, 25, 25, 0.9) addToSuperview:self.view];
    self.shopCloseView = shopCloseView;
    [shopCloseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(UI.bottomSafeAreaHeight + 50));
        make.height.mas_offset(50);
    }];
    UILabel *closeLabel = [[UILabel alloc] init];
    closeLabel.textColor = HEXCOLOR(0xFFFFFF);
    closeLabel.textAlignment = NSTextAlignmentCenter;
    closeLabel.font = [UIFont fontWithName:kFontMedium size:16];
    closeLabel.text = @"本店已关闭";
    [shopCloseView addSubview:closeLabel];
    [closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(shopCloseView);
    }];
}
///底部导航
- (void)setupTabBarView{
    [self.view addSubview:self.tabBarView];
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_offset(UI.bottomSafeAreaHeight + 50);
    }];
    @weakify(self)
    self.tabBarView.tabBarSelectedBlock = ^(id obj) {
        @strongify(self)
        NSNumber *tagIndex = (NSNumber*)obj;
        //首页
        if ([tagIndex intValue] == 0) {
            self.headerView.couponView.hidden = NO;
            [self.classView removeFromSuperview];
            //店铺优惠券
            self.pagingView.mainTableView.scrollEnabled = YES;
        }
        //分类
        else if ([tagIndex intValue] == 1) {
            //店铺优惠券
            self.headerView.couponView.hidden = YES;
            //先返回顶部
            if (self.tagIndex < self.titleArray.count-1) {
                JHNewShopHotSellViewController *hotSellVC = self.subVCArray[self.tagIndex];
                [hotSellVC.collectionView setContentOffset:CGPointMake(0, 0)];
            } else {
                JHNewShopUserCommentViewController *commentVC = self.subVCArray[self.tagIndex];
                [commentVC.tableView setContentOffset:CGPointMake(0, 0)];
            }
            [self.pagingView.mainTableView setContentOffset:CGPointMake(0, 0)];
            //再添加分类显示
            self.pagingView.mainTableView.scrollEnabled = NO;
            [self.view addSubview:self.classView];
            [self.classView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(174+UI.topSafeAreaHeight);
                make.left.right.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-(UI.bottomSafeAreaHeight+50));
            }];
            self.classView.shopInfoModel = self.shopInfoModel;
        }
        //客服
        else if ([tagIndex intValue] == 2) {
            [self clickServicePhoneAction];
        }
    };
}


#pragma mark - LoadData

- (void)loadShopInfoData {
    NSString *loadId = self.shopId.length > 0 ? self.shopId :self.customerId;
    NSString *keyId = self.shopId.length > 0 ? @"id" : @"customerId";
    NSDictionary *dicData = @{keyId: @([loadId longValue])};
    [self.shopHeaderViewModel.shopDetailInfoCommand execute:dicData];
}

- (void)configData{
    //更新数据
    @weakify(self)
    [self.shopHeaderViewModel.updateShopInfoSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.shopInfoModel = self.shopHeaderViewModel.shopDetailInfoModel;
        self.isContinueRequest = YES;
        if (self.shopHeaderViewModel.shopDetailInfoModel.couponList.count > 0) {
            self.headerViewHeight = NewShopDetailHeaderHeight;
        }else{
            self.headerViewHeight = NewShopDetailHeaderHeight-42-12;
        }
        self.headerView.frame = CGRectMake(0, 0, ScreenW, self.headerViewHeight);

        self.headerView.shopHeaderInfoModel = self.shopHeaderViewModel.shopDetailInfoModel;
        self.title = self.shopHeaderViewModel.shopDetailInfoModel.shopName;
        self.jhTitleLabel.font = [UIFont systemFontOfSize:18];

        //店铺是否关闭
        if (![self.shopHeaderViewModel.shopDetailInfoModel.enabled boolValue]) {
            [self setupShopCloseView];
        }
        
        //subListView的数量
        self.subVCArray = [NSMutableArray arrayWithCapacity:3];
        if (self.shopHeaderViewModel.shopDetailInfoModel.productTypeTag == 0 || self.shopHeaderViewModel.shopDetailInfoModel.productTypeTag == 1) {//店铺商品只有拍卖商品或者一口价商品
            self.titleArray = @[@"全部",@"用户评价"];
            [self.userCommentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_categoryView.mas_left).offset(125);
                make.centerY.equalTo(_categoryView).offset(-2);
            }];
        } else {
            self.titleArray = @[@"全部",@"拍卖",@"一口价",@"用户评价"];
            [self.userCommentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_categoryView.mas_left).offset(240);
                make.centerY.equalTo(_categoryView).offset(-2);
            }];
        }
        
        for (int i = 0; i < self.titleArray.count; i++) {
            if (i < self.titleArray.count-1) {
                JHNewShopHotSellViewController *hotSellVC = [[JHNewShopHotSellViewController alloc] init];
                [self.subVCArray addObject:hotSellVC];
            } else {
                JHNewShopUserCommentViewController *commentVC = [[JHNewShopUserCommentViewController alloc] init];
                [self.subVCArray addObject:commentVC];
            }
        }
        [self.pagingView reloadData];
        self.categoryView.titles = self.titleArray;
        [self.categoryView reloadData];

        //跳转到指定页面-用户评论
        if (self.defaultSelectedIndex == 1) {
            [self.categoryView selectItemAtIndex:self.titleArray.count-1];
        }
        
        //用户评论数
        if ([self.shopHeaderViewModel.shopDetailInfoModel.commentNum integerValue] > 0) {
            self.userCommentLabel.text = [self.shopHeaderViewModel.shopDetailInfoModel.commentNum integerValue] > 999 ? @"999+" : self.shopHeaderViewModel.shopDetailInfoModel.commentNum;
        }else{
            self.userCommentLabel.text = @"";
        }
        
    }];
    
    //请求出错
    [self.shopHeaderViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.isContinueRequest = YES;
    }];
    
}
#pragma mark - Action
///分享
- (void)clickShareActionButton:(UIButton *)sender{
    [JHAllStatistics jh_allStatisticsWithEventId:@"shareClick" params:@{
        @"store_from":@"店铺首页"
    } type:JHStatisticsTypeSensors];
    
    JHShareInfo* info = [JHShareInfo new];
    info.title = self.shopHeaderViewModel.shopDetailInfoModel.shareInfo.title;
    info.desc  = self.shopHeaderViewModel.shopDetailInfoModel.shareInfo.desc;
    info.shareType = ShareObjectTypeCustomizeNormal;
    info.url = self.shopHeaderViewModel.shopDetailInfoModel.shareInfo.url;
    info.img = self.shopHeaderViewModel.shopDetailInfoModel.shareInfo.img;
    [JHBaseOperationView showShareView:info objectFlag:nil];
    
}
///平台客服
- (void)clickServicePhoneAction{
    [JHAllStatistics jh_allStatisticsWithEventId:@"storeOperate" params:@{@"operation_type":@"客服"} type:JHStatisticsTypeSensors];
    if (![JHRootController isLogin]) {
        @weakify(self);
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
            @strongify(self);
            if (result) {
                [self loadShopInfoData];
            }
        }];
    }else{
        NSString *userID = self.shopHeaderViewModel.shopDetailInfoModel.customerId;
        [JHIMEntranceManager pushSessionWithUserId:userID sourceType:JHIMSourceTypeShop];
    }
}

#pragma mark - Delegate
#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.headerViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return CategoryTitleViewHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titleArray.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index < self.titleArray.count-1) {
        JHNewShopHotSellViewController *hotVC = self.subVCArray[index];
        hotVC.shopInfoModel = self.shopHeaderViewModel.shopDetailInfoModel;
        hotVC.selectedTitleIndex = index;
        return hotVC;
    } else {
        JHNewShopUserCommentViewController *commentVC = self.subVCArray[index];
        commentVC.shopInfoModel = self.shopHeaderViewModel.shopDetailInfoModel;
        return commentVC;
    }
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat thresholdDistance = self.headerViewHeight - UI.statusAndNavBarHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    _alphaValue = offsetY / thresholdDistance;
    _alphaValue = MAX(0, MIN(1, _alphaValue));
    [self changeNavStatusHidden:_alphaValue < 0.7];
    self.jhStatusBarStyle = (_alphaValue < 0.7 ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
    self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:_alphaValue];
    if(offsetY < 0){
        [self.headerView updateImageHeight:fabs(offsetY)];
    }
    
    //下拉刷新
    if(offsetY < -80){
        [self.headerView showLoading];
        self.isRequestUpdate = YES;
    }
    if(offsetY == 0 && self.isRequestUpdate && self.isContinueRequest){
        self.isRequestUpdate = NO;
        self.isContinueRequest = NO;
        [self.headerView dismissLoading];
        
        //刷新顶部信息
        [self loadShopInfoData];
        
    }
    
    // 设置顶部返回按钮是否隐藏
    BOOL goTopHidden = offsetY <= 100;
    self.floatView.topButton.hidden = goTopHidden;
    

}
#pragma mark - JXCategoryViewDelegate
//滚动/点击 都会走该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.tagIndex = index;
}

#pragma mark - JXPagerMainTableViewGestureDelegate
//防止手势冲突
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"UITableView")] || [otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"UICollectionView")]) {
        UITableView *tableView = (UITableView*)otherGestureRecognizer.delegate;
        UICollectionView *collectionView = (UICollectionView*)otherGestureRecognizer.delegate;
        if([collectionView.dataSource isKindOfClass:NSClassFromString(@"JHNewShopHotSellViewController")] || [tableView.dataSource isKindOfClass:NSClassFromString(@"JHNewShopUserCommentViewController")]){
            return YES;
        }
    }
    return NO;
    
}


#pragma mark - method
///处理navBar上按钮图标随着互动显示的颜色
-(void)changeNavStatusHidden:(BOOL)isHidden{
    self.jhLeftButton.selected = isHidden;
    self.jhRightButton.selected = isHidden;
    self.jhTitleLabel.textColor = isHidden ? UIColor.clearColor : UIColor.blackColor;
}

#pragma mark - Lazy

- (JHNewShopDetailHeaderViewModel *)shopHeaderViewModel{
    if (!_shopHeaderViewModel) {
        _shopHeaderViewModel = [[JHNewShopDetailHeaderViewModel alloc] init];
    }
    return _shopHeaderViewModel;
}
- (JHNewShopDetailHeaderView *)headerView{
    if (!_headerView) {
        @weakify(self)
        _headerView = [[JHNewShopDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.headerViewHeight)];
        //关注按钮点击回调
        _headerView.followSuccessBlock = ^(id obj) {
            @strongify(self)
            self.isFollow = [obj boolValue]? YES : NO;
        };
        //店铺信息点击回调
        _headerView.clickShopInfoBlock = ^{
            @strongify(self)
            JHNewShopDetailInfoViewController *vc = [[JHNewShopDetailInfoViewController alloc] init];
            vc.shopHeaderInfoModel = self.shopHeaderViewModel.shopDetailInfoModel;
            vc.followSuccessBlock = ^(id obj) {
                @strongify(self)
                self.isFollow = [obj boolValue]? YES : NO;
                self.headerView.isFollowed = self.isFollow;
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headerView;
}

- (JXCategoryTitleView *)categoryView{
    if(!_categoryView){
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CategoryTitleViewHeight)];
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleSelectedColor = UIColor.blackColor;
        _categoryView.titleColor = kColor999;
        _categoryView.titleSelectedFont = JHBoldFont(15);
        _categoryView.titleFont = [UIFont fontWithName:kFontMedium size:15];
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.cellSpacing = 20;
        _categoryView.contentEdgeInsetLeft = 12;
        _categoryView.contentEdgeInsetRight = 12;
        _categoryView.titleLabelVerticalOffset = -5;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = [CommHelp toUIColorByStr:@"#FFD70F"];
        lineView.indicatorWidth = 28;
        lineView.indicatorHeight = 3;
        lineView.verticalMargin = 10;
        _categoryView.indicators = @[lineView];
        
        //用户评论数
        UILabel *userCommentLabel = [UILabel jh_labelWithText:@"" font:10 textColor:kColor999 textAlignment:NSTextAlignmentLeft addToSuperView:_categoryView];
        userCommentLabel.font = [UIFont fontWithName:kFontNormal size:10];
        self.userCommentLabel = userCommentLabel;
        [userCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_categoryView.mas_left).offset(240);
            make.centerY.equalTo(_categoryView).offset(-2);
        }];
        
    }
    return _categoryView;
}

- (JXPagerView *)pagingView{
    if(!_pagingView){
        _pagingView = [[JXPagerView alloc] initWithDelegate:self];
        _pagingView.backgroundColor = UIColor.whiteColor;
        _pagingView.mainTableView.backgroundColor = UIColor.whiteColor;
        _pagingView.pinSectionHeaderVerticalOffset = UI.statusAndNavBarHeight;
        _pagingView.mainTableView.showsVerticalScrollIndicator = NO;
        _pagingView.listContainerView.scrollView.backgroundColor = UIColor.whiteColor;
        _pagingView.listContainerView.categoryNestPagingEnabled = YES;
        _pagingView.mainTableView.gestureDelegate = self;
        _pagingView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - UI.bottomSafeAreaHeight - 50);
        [self.view addSubview:_pagingView];
        [self jhBringSubviewToFront];
    }
    return _pagingView;
}

- (JHMarketFloatLowerLeftView *)floatView{
    if (!_floatView) {
        _floatView = [[JHMarketFloatLowerLeftView alloc] initWithShowType:JHMarketFloatShowTypeBackTop];
        _floatView.isHaveTabBar = NO;
        @weakify(self)
        //收藏
        _floatView.collectGoodsBlock = ^{
            [JHAllStatistics jh_allStatisticsWithEventId:@"scClick" params:@{
                @"store_from":@"店铺首页",
                @"zc_name":@"",
                @"zc_id":@""
            } type:JHStatisticsTypeSensors];
        };
        //返回顶部
        _floatView.backTopViewBlock = ^{
            @strongify(self)
            [JHAllStatistics jh_allStatisticsWithEventId:@"backTopClick" params:@{@"store_from":@"店铺首页"} type:JHStatisticsTypeSensors];
            if (self.tagIndex < self.titleArray.count-1) {
                JHNewShopHotSellViewController *hotSellVC = self.subVCArray[self.tagIndex];
                [hotSellVC.collectionView setContentOffset:CGPointMake(0, 0)];
            } else {
                JHNewShopUserCommentViewController *commentVC = self.subVCArray[self.tagIndex];
                [commentVC.tableView setContentOffset:CGPointMake(0, 0)];
            }
            [UIView animateWithDuration:0.25 animations:^{
                [self.pagingView.mainTableView setContentOffset:CGPointMake(0, 0)];
            }];

        };
    }
    return _floatView;
}
- (JHNewShopDetailTabBarView *)tabBarView{
    if (!_tabBarView) {
        _tabBarView = [[JHNewShopDetailTabBarView alloc] init];
    }
    return _tabBarView;
}

- (JHNewShopDetailClassView *)classView{
    if (!_classView) {
        _classView = [[JHNewShopDetailClassView alloc] init];
    }
    return _classView;
}
@end
