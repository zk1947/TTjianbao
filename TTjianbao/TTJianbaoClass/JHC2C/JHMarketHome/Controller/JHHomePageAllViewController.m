//
//  JHHomePageAllViewController.m
//  TTjianbao
//
//  Created by zk on 2021/5/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHHomePageAllViewController.h"
#import "JHSQHelper.h"
#import "JHMarketHomeViewController.h"
#import "JHSQHomePageController.h"
#import "ZQSearchViewController.h"
#import "JHSearchResultViewController.h"
#import "JHC2CSearchResultViewController.h"
#import "JHMarketHomeBusiness.h"
#import "JHMarketHomeDataReport.h"
#import "JHC2CClassViewController.h"
#import "JHSQApiManager.h"
#import "JHMyCenterDotNumView.h"

NSString *const JHHomePageAllViewControllerNotification = @"JHHomePageAllViewControllerNotification";

typedef NS_ENUM(NSInteger, JHHomeTabType)
{
    JHHomeTabTypeMarket = 0, // 集市
    JHHomeTabTypeCommunity = 1, //社区
};

@interface JHHomePageAllViewController ()<ZQSearchViewDelegate,CAAnimationDelegate>
{
    UIButton *_messageButton; //消息按钮
    NSInteger _clickTitleIndex; //记录点击的标签项，用于点击回到顶部，只在点击tab时用
    JHHomeTabType selectedTab; //集市、社区
}

/** 顶部背景图 */
@property (nonatomic, strong) UIImageView *topBgImageView;

/** 子vc */
@property (nonatomic, strong) JHMarketHomeViewController *marketListVC;
@property (nonatomic, strong) JHSQHomePageController *communityListVC;

/** 头部背景 */
@property (nonatomic, strong) UIImageView *searchBgView;

@property (nonatomic, strong) UIView *searchBackView;

@property (nonatomic, strong) JHMyCenterDotNumView *msgNumLab;

/** 搜索框 */
@property (nonatomic, strong) JHEasyPollSearchBar *searchBar;
/** 分类按钮 */
@property (nonatomic, strong) UIButton *classButton;

@property (nonatomic, assign) CGFloat bgAlpha;

@property (nonatomic, assign) CGFloat contentViewTop;

@property (nonatomic, assign) CGFloat searchTop;

@property (nonatomic, assign) CGFloat contentViewTop2;

@property (nonatomic, assign) BOOL upOnce;

@property (nonatomic, assign) BOOL downOnce;

@property (nonatomic, strong) NSArray *searchHotWordArr1;//集市热词

@property (nonatomic, strong) NSArray *searchHotWordArr2;//社区热词

@property (nonatomic, strong) UIView *spaceView;

@property (nonatomic, assign) CGFloat topScrollH;

@property (nonatomic, assign) BOOL isAllUp;

@end

@implementation JHHomePageAllViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _searchTop = 0;
    _contentViewTop = 0;
    _contentViewTop2 = 40;
    //首次启动切换到发现页
    if ([JHSQManager isFirstLaunch]) {
        [JHSQManager setMute:YES];
    }
    [self configPageTitleView];
    [self addObserver];
}

-(void)addObserver{
    @weakify(self);
    [[[JHNotificationCenter rac_addObserverForName:JHHomePageAllViewControllerNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        NSDictionary *params = notification.object;
        NSInteger  indexNum = [params[@"item_type"] integerValue];
        _clickTitleIndex = indexNum;
        [self.titleCategoryView selectItemAtIndex:indexNum];
        [self initUISatatus:indexNum];
        [self restoreHeadView];
    }];
}

- (void)restoreHeadView{
    _downOnce = NO;
    [self dealTabTop:NO];
    [self dealTabAlphaAnimation:0];
//    [self dealZoomAnimation:0];
    [self dealTranslationAnimation:40];
    self.spaceView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //更新消息数
    @weakify(self);
    [self getAllUnreadMsgCount:^(id obj) {
        @strongify(self);
        if (!isEmpty(obj) && [obj integerValue] >0) {
            self.msgNumLab.hidden = NO;
            self.msgNumLab.number = [obj integerValue];
        } else {
            self.msgNumLab.hidden = YES;
        }
    }];
    
    //更新搜索词
    if (self.searchBar.placeholderArray.count == 0) {
        @weakify(self);
        [JHMarketHomeBusiness getSearchWordListData:^(NSError * _Nullable error, NSArray<JHHotWordModel *> * _Nullable respObj) {
            @strongify(self);
            if (respObj) {
                self.searchHotWordArr1 = respObj;
                self.searchBar.placeholderArray = respObj.mutableCopy;
                [self getCommunitySearchHotWord];
            }
        }];
    }
}

- (void)getCommunitySearchHotWord{
    @weakify(self);
    [JHSQApiManager getHotWords:^(NSArray<JHHotWordModel *> * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        self.searchHotWordArr2 = respObj;
    }];
}

- (void)showSearchVC {
    if (_clickTitleIndex == 0) {
        JHC2CSearchResultViewController *resultController = [JHC2CSearchResultViewController new];
        ZQSearchViewController *vc = [[ZQSearchViewController alloc] initSearchViewWithFrom:ZQSearchFromC2C resultController:resultController];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        JHSearchResultViewController *resultController = [JHSearchResultViewController new];
        ZQSearchViewController *vc = [[ZQSearchViewController alloc] initSearchViewWithFrom:ZQSearchFromCommunity resultController:resultController];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - ZQSearchViewDelegate
- (void)searchFuzzyResultWithKeyString:(NSString *)keyString Data:(id<ZQSearchData>)data resultController:(UIViewController *)resultController From:(ZQSearchFrom)from{
    if (_clickTitleIndex == 0) {
        JHC2CSearchResultViewController *vc = (JHC2CSearchResultViewController *)resultController;
        [vc refreshSearchResult:keyString from:from keywordSource:data];
    }else{
        JHSearchResultViewController *vc = (JHSearchResultViewController *)resultController;
        [vc refreshSearchResult:keyString from:from keywordSource:data];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //处理tabbar效果
    [JHHomeTabController changeStatusWithMainScrollView:self.marketListVC.marketTableView index:0];
    [JHHomeTabController setSubScrollView:[self.marketListVC.lastCell getSubScrollViewFromSelf]];
}

- (void)setCannotScroll:(BOOL)cannotScroll{
    self.marketListVC.cannotScroll = cannotScroll;
}

#pragma mark - UI Methods
- (void)configPageTitleView {
    //标签栏
    self.titles = @[@"宝友集市", @"宝友社区"];
    self.titleCategoryView.titles = self.titles;
    // 配置标签栏样式
    [self configMyPageTitleView];
    
    //背景图
    [self.view addSubview:self.topBgImageView];
    [self.view insertSubview:self.topBgImageView atIndex:0];
    [self.topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.width.mas_equalTo((UI.statusBarHeight + 44)*3.79);
        make.height.mas_equalTo(UI.statusBarHeight + 44);
    }];
    
    //消息按钮
    _messageButton = [JHSQHelper messageButton];
    [self.view addSubview:_messageButton];
    [_messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.titleCategoryView);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.msgNumLab];
    [self.msgNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_messageButton).offset(-8);
        make.top.equalTo(_messageButton.mas_centerY).offset(-20);
    }];
    
    [self setupSearchView];

}

-(void)setupSearchView {
    //搜索背景图
    [self.view addSubview:self.searchBackView];
    [self.searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UI.statusBarHeight + 44);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(40);
    }];
    //搜索框
    [self.view addSubview:self.searchBgView];
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UI.statusBarHeight + 44);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo((44 + UI.statusBarHeight)*3.79);
        make.height.mas_equalTo((44 + UI.statusBarHeight)*0.3);
    }];
    _searchBar = [JHSQHelper searchBar];
    _searchBar.frame = CGRectMake(10, UI.statusBarHeight + 51, kScreenWidth-52, 30);
    _searchBar.backgroundColor = kColorFFF;
    _searchBar.layer.borderColor = HEXCOLOR(0xFFD70F).CGColor;
    _searchBar.layer.borderWidth = 1.5;
    _searchBar.searchBarShowFrom = JHSearchBarShowFromSoureHome;
    [self.view addSubview:_searchBar];
    @weakify(self);
    _searchBar.didSelectedBlock = ^(NSInteger selectedIndex, BOOL isLeft) {
        @strongify(self);
        NSLog(@"点击搜索框");
        ///369神策埋点:点击搜索栏
        [JHMarketHomeDataReport searchTouchReport];
        [self showSearchVC];
    };
    //分类按钮
    self.classButton.frame = CGRectMake(kScreenWidth-35, UI.statusBarHeight+51, 30, 30);
    [self.view addSubview:self.classButton];
}

-(void)configMyPageTitleView{
    self.titleCategoryView.titleColor = HEXCOLOR(0x666666);
    self.titleCategoryView.titleFont = [UIFont fontWithName:kFontMedium size:16];
    self.titleCategoryView.titleSelectedColor = HEXCOLOR(0x222222);
    self.titleCategoryView.contentEdgeInsetLeft = 15;
    self.titleCategoryView.cellSpacing = 26.f;
    self.titleCategoryView.averageCellSpacingEnabled = NO;
    self.titleCategoryView.titleLabelZoomEnabled = YES;
    self.titleCategoryView.titleLabelZoomScale = 1.375;
    self.titleCategoryView.titleColorGradientEnabled = YES;
    self.titleCategoryView.titleLabelZoomEnabled = YES;
    self.titleCategoryView.cellWidthZoomEnabled = YES;
    self.titleCategoryView.selectedAnimationEnabled = YES;
    self.titleCategoryView.delegate = self;
    
    JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
    indicatorImgView.backgroundColor = HEXCOLOR(0xffd70f);
    indicatorImgView.layer.cornerRadius = 2.f;
    indicatorImgView.clipsToBounds = YES;
    indicatorImgView.indicatorImageViewSize = CGSizeMake(28., 4.);
    indicatorImgView.verticalMargin = 2.;
    self.titleCategoryView.indicators = @[indicatorImgView];
    
    //禁止横向滚动
    self.listContainerView.scrollView.scrollEnabled = NO;
}

#pragma mark - JXCategoryViewDelegate

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [JHGrowingIO trackEventId:JHTrackSQHomeSwitchTab]; //切换标签
    selectedTab = index;
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    _clickTitleIndex = index;
    [self initUISatatus:index];
}

//正在滚动中的回调 ratio 从左往右计算的百分比
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio{
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return self.marketListVC;
    } else {
        return self.communityListVC;
    }
}

#pragma mark - 切换标签
- (void)initUISatatus:(NSInteger)index{
    [self.marketListVC.marketTableView setContentOffset:CGPointZero];
    //分类按钮
    if (index == 0) {
        _searchBar.width = kScreenWidth - 52;
        self.classButton.hidden = NO;
        //切换搜索框热词
        self.searchBar.placeholderArray = self.searchHotWordArr1;
    }else{
        _searchBar.width = kScreenWidth - 22;
        self.classButton.hidden = YES;
        //切换搜索框热词
        self.searchBar.placeholderArray = self.searchHotWordArr2;
    }
}

#pragma mark - Lazy load Methods：标签页

- (JHMarketHomeViewController *)marketListVC {
    if (!_marketListVC) {
        _marketListVC = [[JHMarketHomeViewController alloc] init];
        @weakify(self);
        [RACObserve(_marketListVC.marketTableView, contentOffset) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if (_clickTitleIndex != 0) {
                return;
            }
            
            //tab到上方间距判断
            CGFloat topH = [_marketListVC mainTableViewMaxContentOffsetY];
            _topScrollH = topH >= 100 ? 100.f : topH;
            
            CGPoint offset = [x CGPointValue];
            CGFloat scrollY = offset.y;
            /**
             临界点1 发生向上偏移 改变tableview的top
             偏移量0-100内tab以及背景透明度变化
             偏移量0-40内搜索框缩放
             偏移量40-100内搜索框上下平移
             */
            if (scrollY > 0 && scrollY <= _topScrollH) {//透明度
                if (!_downOnce) {
                    [self dealTabTop:YES];
                    _downOnce = YES;
                }
                [self dealTabAlphaAnimation:scrollY];
//                if (scrollY < 40) {//缩放
//                    [self dealZoomAnimation:scrollY];
//                }else{//平移
//                    [self dealZoomAnimation:40];
                    [self dealTranslationAnimation:scrollY];
//                }
                _upOnce = NO;
                self.spaceView.hidden = YES;
            }
            /**
             临界点问题处理
             偏移量为0时，透明度置为1、缩放效果置为0、平移效果置为0
             偏移量为100时，透明度置为0、缩放效果置为1、平移效果置为1
             */
            if (scrollY <= 0 && _downOnce) {//0
                _downOnce = NO;
                [self dealTabTop:NO];
                [self dealTabAlphaAnimation:0];
//                [self dealZoomAnimation:0];
                [self dealTranslationAnimation:0];
                self.spaceView.hidden = YES;
            }
            if (scrollY > _topScrollH && !_upOnce) {//100
                _upOnce = YES;
//                self.marketListVC.lastCell.addH = 44;
                [self dealTabAlphaAnimation:_topScrollH];
                [self dealTranslationAnimation:_topScrollH];
                self.spaceView.hidden = _topScrollH > 100 ? NO:YES;
            }
        }];
    }
    return _marketListVC;
}

#pragma mark - 处理头部滑动效果

- (void)dealTabTop:(BOOL)isUp{
    _contentViewTop = isUp ? 40 : 0;
}

///缩放效果
- (void)dealZoomAnimation:(CGFloat)offsetY{
    CGFloat rightW = _clickTitleIndex == 0 ? 30:0;
    _searchBar.width = kScreenWidth - 19 - rightW - offsetY;
    self.classButton.left = _searchBar.right + 6;
}

///上下移效果
- (void)dealTranslationAnimation:(CGFloat)offsetY{
//    _searchTop = (offsetY-40)*44/((_topScrollH -40));
    _searchTop = offsetY*44/_topScrollH;
    _searchBar.top = UI.statusBarHeight + 51-_searchTop;
    self.classButton.top = _searchBar.top; //- 5;
}

///更改tab以及背景图的透明度
- (void)dealTabAlphaAnimation:(CGFloat)offsetY{
    //更改背景图透明度
    self.topBgImageView.alpha = 1- offsetY/_topScrollH;
    self.searchBgView.alpha = 1- offsetY/_topScrollH;
    _messageButton.alpha = 1- offsetY/_topScrollH;
    _msgNumLab.alpha = 1- offsetY/_topScrollH;
    //更改tab透明度
    NSArray *cellsArr = [self.titleCategoryView.collectionView visibleCells];
    for (JXCategoryTitleCell *cell in cellsArr) {
        cell.titleLabel.alpha = 1- offsetY/_topScrollH;
    }
    //更新指示器透明度
    for (UIView *view in self.titleCategoryView.indicators) {
        view.alpha = 1- offsetY/_topScrollH;
    }
    //更新搜索背景
    self.searchBackView.alpha = 1- (offsetY-40)/(_topScrollH -40);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_clickTitleIndex == 0) {
        self.categoryView.frame = CGRectMake(0, UI.statusBarHeight, self.view.bounds.size.width, 44);
        self.listContainerView.frame = CGRectMake(0, self.categoryView.bottom + 40 - _contentViewTop, self.view.bounds.size.width, self.view.bounds.size.height - UI.statusBarHeight - 44 - 40 + _contentViewTop);
    }else{
        self.categoryView.frame = CGRectMake(0, UI.statusBarHeight, self.view.bounds.size.width, 44);
        self.listContainerView.frame = CGRectMake(0, self.categoryView.bottom + _contentViewTop2, self.view.bounds.size.width, self.view.bounds.size.height - UI.statusBarHeight - 44 - _contentViewTop2);
    }
}

- (UIImageView *)topBgImageView{
    if (!_topBgImageView) {
        _topBgImageView = [[UIImageView alloc] init];
        _topBgImageView.image = JHImageNamed(@"c2c_market_head_bg1");
    }
    return _topBgImageView;
}

- (JHSQHomePageController *)communityListVC {
    if (!_communityListVC) {
        _communityListVC = [[JHSQHomePageController alloc] init];
        @weakify(self);
        _communityListVC.headScrollBlock = ^(BOOL isUp) {
            @strongify(self);
            if (_clickTitleIndex != 1) {
            }else{
                [self upScrollAnimation:isUp];
            }
        };
    }
    return _communityListVC;
}

- (void)upScrollAnimation:(BOOL)isUp{
    if (isUp) {
        //透明度
        [self dealTabAlphaAnimation:100];
        //缩放、平移
        [UIView animateWithDuration:0.3 animations:^{
            _searchBar.top = UI.statusBarHeight + 7;
        }];
//        _searchBar.width = kScreenWidth - 52;
        //下方内容上移
        _contentViewTop2 = 0;
        self.listContainerView.top = self.categoryView.bottom;
        self.listContainerView.height = self.view.bounds.size.height - UI.statusBarHeight - 44;
    }else{
        //透明度
        [self dealTabAlphaAnimation:0];
        //缩放、平移
        [UIView animateWithDuration:0.3 animations:^{
            _searchBar.top = UI.statusBarHeight + 51;
        }];
//        _searchBar.width = kScreenWidth - 22;
        //下方内容上移
        _contentViewTop2 = 40;
        self.listContainerView.top = self.categoryView.bottom+_contentViewTop2;
        self.listContainerView.height = self.view.bounds.size.height - UI.statusBarHeight - 44 - _contentViewTop2;
    }
}

- (UIImageView *)searchBgView{
    if (!_searchBgView) {
        _searchBgView = [[UIImageView alloc] init];
        _searchBgView.userInteractionEnabled = YES;
        _searchBgView.image = JHImageNamed(@"c2c_market_head_bg2");
    }
    return _searchBgView;
}

- (UIButton *)classButton {
    if (!_classButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"search_class_icon"] forState:UIControlStateNormal];//c2c_market_class_icon
        [btn addTarget:self action:@selector(classButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _classButton = btn;
    }
    return _classButton;
}

- (JHMyCenterDotNumView *)msgNumLab {
    if (!_msgNumLab) {
        JHMyCenterDotNumView *lab = [JHMyCenterDotNumView new];
        lab.backgroundColor = HEXCOLOR(0xF03D37);
        lab.textColor = kColorFFF;
        lab.font = JHFont(10);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.layer.cornerRadius  = 7.5f;
        lab.layer.masksToBounds = YES;
        lab.hidden = YES;
        _msgNumLab = lab;
    }
    return _msgNumLab;
}

-(void)classButtonAction:(UIButton *)btn{
    JHC2CClassViewController *vc = [JHC2CClassViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setBgAlpha:(CGFloat)bgAlpha{
    _bgAlpha = bgAlpha;
    self.searchBgView.alpha = _bgAlpha;
}

- (void)trackUserProfilePage:(BOOL)isBegin{
    
}

- (UIView *)spaceView{
    if (!_spaceView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, UI.statusBarHeight+37, kScreenWidth, 12)];
        view.backgroundColor = kColorFFF;
        view.hidden = YES;
        [self.view addSubview:view];
        _spaceView = view;
    }
    return _spaceView;
}

- (UIView *)searchBackView{
    if (!_searchBackView) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = kColorFFF;
        _searchBackView = view;
    }
    return _searchBackView;
}


@end
