//
//  YDBaseTitleBarController.m
//  TTjianbao
//
//  Created by wuyd on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "YDBaseTitleBarController.h"

@interface YDBaseTitleBarController ()

@end

@implementation YDBaseTitleBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.categoryView];
    self.categoryView.delegate = self;
    
    [self.view addSubview:self.listContainerView];
    self.categoryView.listContainer = self.listContainerView;
    
    self.categoryView.sd_layout
    .topSpaceToView(self.view, UI.statusBarHeight)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs([self preferredCategoryViewHeight]);
    
    self.listContainerView.sd_layout
    .topSpaceToView(self.categoryView, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
}

#pragma mark -
#pragma mark - JXCategoryView Methods
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
        _titleCategoryView.backgroundColor = [UIColor clearColor];
        _titleCategoryView.titleColor = kColor999;
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontMedium size:14];
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldPingFang size:14];
        _titleCategoryView.titleSelectedColor = kColor333;
        _titleCategoryView.cellSpacing = 20;
    }
    return _titleCategoryView;
}

- (JXCategoryIndicatorLineView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[JXCategoryIndicatorLineView alloc] init];
        _indicatorView.indicatorWidth = JXCategoryViewAutomaticDimension; //LineView与Cell同宽
        _indicatorView.indicatorHeight = 3;
        _indicatorView.verticalMargin = 6;
        _indicatorView.layer.cornerRadius = 1.5;
        _indicatorView.indicatorColor = HEXCOLOR(0xFEE100);
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

//点击选中或者滚动选中都会调用该方法。
//- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    //NSLog(@"<点击选中或者滚动选中>%@", NSStringFromSelector(_cmd));
//    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
//}
//
////点击选中的情况才会调用该方法
//- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
//    //NSLog(@"<点击选中>%@", NSStringFromSelector(_cmd));
//}
//
////滚动选中的情况才会调用该方法
//- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
//    //NSLog(@"<滚动选中>%@", NSStringFromSelector(_cmd));
//}

#pragma mark -
#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return nil;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

@end
