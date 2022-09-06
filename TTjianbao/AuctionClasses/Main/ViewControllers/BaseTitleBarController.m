//
//  BaseTitleBarController.m
//  TTjianbao
//
//  Created by wuyd on 2019/12/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "BaseTitleBarController.h"

@interface BaseTitleBarController () <UIGestureRecognizerDelegate>

@end

@implementation BaseTitleBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeNavView]; //默认不显示navbar
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.categoryView];
    self.categoryView.delegate = self;
    
    [self.view addSubview:self.listContainerView];
    self.categoryView.listContainer = self.listContainerView;
    
    self.categoryView.sd_layout
    .topSpaceToView(self.view, UI.statusAndNavBarHeight)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs([self preferredCategoryViewHeight]);
    
    self.listContainerView.sd_layout
    .topSpaceToView(self.categoryView, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 解决右滑返回失效的问题
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //处于第一个item的时候，才允许屏幕边缘手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    //防止侧滑过程导航栏下方透明问题
    [self.categoryView.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

// 允许多个手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryBaseView alloc] init];
}

- (CGFloat)preferredCategoryViewHeight {
    return 44.0;
}

- (JXCategoryBaseView *)categoryView {
    if (!_categoryView) {
        _categoryView = [self preferredCategoryView];
        //点击cell进行contentScrollView切换时是否需要动画。默认为YES
        _categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    }
    return _categoryView;
}

- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = (JXCategoryTitleView *)self.categoryView;
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontMedium size:14];
        _titleCategoryView.titleColor = kColor999;
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldPingFang size:14];
        _titleCategoryView.titleSelectedColor = kColor333;
        _titleCategoryView.cellSpacing = 20;
    }
    return _titleCategoryView;
}

- (UITitleBarBackgroundView *)titleCategoryBgView {
    if (!_titleCategoryBgView) {
        //基础属性
        _titleCategoryBgView = (UITitleBarBackgroundView *)self.categoryView;
        _titleCategoryBgView.titleFont = [UIFont fontWithName:kFontMedium size:14];
        _titleCategoryBgView.titleColor = kColor999;
        _titleCategoryBgView.titleSelectedFont = [UIFont fontWithName:kFontBoldPingFang size:14];
        _titleCategoryBgView.titleSelectedColor = kColor333;
        _titleCategoryBgView.cellSpacing = 10;
        _titleCategoryBgView.cellWidthIncrement = 26;
        //cell背景属性
        _titleCategoryBgView.normalBgColor = kColorEEE;
        _titleCategoryBgView.selectedBgColor = kColorMain;
    }
    return _titleCategoryBgView;
}

- (JXCategoryIndicatorLineView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[JXCategoryIndicatorLineView alloc] init];
        _indicatorView.indicatorWidth = JXCategoryViewAutomaticDimension; //LineView与Cell同宽
        _indicatorView.indicatorHeight = 3;
        _indicatorView.verticalMargin = 6;
        _indicatorView.indicatorColor = kColorMain;
    }
    return _indicatorView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}


#pragma mark -
#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}


#pragma mark -
#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return nil;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

@end
