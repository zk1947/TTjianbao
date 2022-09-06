//
//  JHMarketGoodsListViewController.m
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketGoodsListViewController.h"
#import "JXCategoryTimelineView.h"
#import "JHMarketGoodsInfoViewController.h"

@interface JHMarketGoodsListViewController () <JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,JHMarketGoodsInfoViewControllerDelegate>

@property (nonatomic, strong) JXCategoryTimelineView *myCategoryView;

@property (nonatomic, strong) JXCategoryTitleView *myTitleView;

@property (nonatomic, strong) NSArray <NSString *> *subTitles;

@property (nonatomic, strong) NSArray *titleTypes;

@property (nonatomic, strong) NSMutableArray<JHMarketGoodsInfoViewController *> *vcArr;

@property (nonatomic, assign) CGFloat tabHeight;


@end

@implementation JHMarketGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    
    [self setupView];
}

- (void)initDataSource{
    self.tabHeight = 54;
    self.titles = @[@"万千好物", @"0元起拍", @"低至冰点价"];
    self.subTitles = @[@"全部", @"拍卖", @"一口价"];
    self.titleTypes = @[@2,@1,@0];// 0一口价 1拍卖 2全部
    for (NSNumber *pageType in self.titleTypes) {
        JHMarketGoodsInfoViewController *vc = [JHMarketGoodsInfoViewController new];
        vc.pageType = [pageType integerValue];
        vc.delegate = self;
        [self.vcArr addObject:vc];
    }
}

- (void)setupView{
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    
    self.myCategoryView.backgroundColor = kColorFFF;
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.timeTitles = self.subTitles;
    self.myCategoryView.titleLabelVerticalOffset = 13;
    self.myCategoryView.titleColorGradientEnabled = YES;
    //设置底部状态
    self.myCategoryView.titleColor = kColor999;
    self.myCategoryView.titleSelectedColor = kColor222;
    self.myCategoryView.titleFont = [UIFont systemFontOfSize:12];
    self.myCategoryView.titleSelectedFont = [UIFont systemFontOfSize:12];
    //设置顶部时间
    self.myCategoryView.timeTitleFont = [UIFont boldSystemFontOfSize:16];
    self.myCategoryView.timeTitleSelectedFont = [UIFont boldSystemFontOfSize:16];
    self.myCategoryView.timeTitleNormalColor = kColor666;
    self.myCategoryView.timeTitleSelectedColor = kColor222;

    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 16;
    backgroundView.indicatorCornerRadius = 8;
    backgroundView.verticalMargin = -13;
    backgroundView.indicatorColor = HEXCOLOR(0xFFD70F);
    self.myCategoryView.indicators = @[backgroundView];
}

- (void)setTabAlpha:(CGFloat)tabAlpha{
    //更新tab高度(20)
    self.tabHeight = 41 + (13 * tabAlpha);
    self.categoryView.height = self.tabHeight;
    //更新下方lable透明度
//    self.myCategoryView.tabAlpha = tabAlpha;
//    self.myCategoryView.timeTitleNormalColor = tabAlpha <= 0.0 ? kColor999 : kColor666;
//    [self.myCategoryView reloadData];
//    [self.myCategoryView layoutIfNeeded];
    //更新指示器透明度
    for (UIView *view in self.myCategoryView.indicators) {
        view.alpha = tabAlpha;
        if (tabAlpha >= 1.0) {
            view.top = 32.5;
        }
    }
    
    //回归偏移量
    if (tabAlpha >= 1.0) {
        self.myCategoryView.tabAlpha = tabAlpha;
        [self dealAllScrollOffsetToZero];
    }
    
    if (tabAlpha <= 0.0) {
        self.myCategoryView.tabAlpha = tabAlpha;
    }
}

- (void)dealAllScrollOffsetToZero{
    for (JHMarketGoodsInfoViewController *vc in self.vcArr) {
        [vc makeDeatilDescModuleScrollToTop];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.categoryView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.tabHeight);
    self.listContainerView.frame = CGRectMake(0, self.tabHeight, self.view.bounds.size.width, self.view.bounds.size.height - self.tabHeight);
}

- (JXCategoryTimelineView *)myCategoryView {
    return (JXCategoryTimelineView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTimelineView alloc] init];
}

- (CGFloat)preferredCategoryViewHeight {
    return 50;
}

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll {
    JHMarketGoodsInfoViewController *vc = self.vcArr[self.categoryView.selectedIndex];
    [vc makeDeatilDescModuleScroll:canScroll];
}

- (void)makeDeatilDescModuleScrollToTop {
    JHMarketGoodsInfoViewController *vc = self.vcArr[self.categoryView.selectedIndex];
    [vc makeDeatilDescModuleScrollToTop];
}

- (void)JHMarketGoodsInfoViewControllerLeaveTop{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JHMarketGoodsListViewControllerLeaveTop)]) {
        [self.delegate JHMarketGoodsListViewControllerLeaveTop];
    }
}

#pragma mark - Custom Accessors

// 分页菜单视图
- (JXCategoryBaseView *)categoryView {
    if (!_categoryView) {
        _categoryView = [self preferredCategoryView];
        _categoryView.delegate = self;
        
        // !!!: 将列表容器视图关联到 categoryView
        _categoryView.listContainer = self.listContainerView;
    }
    return _categoryView;
}

// 列表容器视图
- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // 侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    
    //
    [self makeDeatilDescModuleScroll:YES];
}

// 滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - JXCategoryListContainerViewDelegate

// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

// 返回各个列表菜单下的实例，该实例需要遵守并实现 <JXCategoryListContentViewDelegate> 协议
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.vcArr[index];
}

- (NSMutableArray<JHMarketGoodsInfoViewController *> *)vcArr {
    if (!_vcArr) {
        _vcArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _vcArr;
}

#pragma mark - private
- (UIScrollView *)getSubScrollViewFromSelf {
    if (self.vcArr.count >0) {
        JHMarketGoodsInfoViewController *vc = self.vcArr[self.categoryView.selectedIndex];
        return vc.collectionView;
    }
    return nil;
}

- (JXCategoryTitleView *)myTitleView {
    if (!_myTitleView) {
        _myTitleView = (JXCategoryTitleView *)self.categoryView;
        _myTitleView.backgroundColor = [UIColor clearColor];
        _myTitleView.titleColor = kColor999;
        _myTitleView.titleFont = [UIFont fontWithName:kFontMedium size:14];
        _myTitleView.titleSelectedFont = [UIFont fontWithName:kFontBoldPingFang size:14];
        _myTitleView.titleSelectedColor = kColor333;
        _myTitleView.cellSpacing = 20;
    }
    return _myTitleView;
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
