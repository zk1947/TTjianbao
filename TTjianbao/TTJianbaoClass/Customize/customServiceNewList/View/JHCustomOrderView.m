//
//  JHCustomOrderView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomOrderView.h"
#import "JXPagerView/JXPagerView.h"
#import "JXCategoryBaseView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "JHLivingCustomOrderView.h"
#import "UIView+CornerRadius.h"
#import "JHOrderDetailMode.h"
#import "JHCustomizeOrderModel.h"
#import "JHCustomizeOrderDetailController.h"
@interface JHCustomOrderView()<JXPagerViewDelegate, JXCategoryViewDelegate>
/** 标题集合*/
@property (nonatomic, strong) NSArray <NSString *> *titles;
/** 菜单栏*/
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
/** 滑动范围*/
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSMutableArray <JHOrderCateMode*>*cateArr;
@property (nonatomic, strong) NSMutableArray <JHLivingCustomOrderView*>*vcArr;
@end
@implementation JHCustomOrderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = HEXCOLORA(0x000000, 0.5);
        self.cateArr = [[JHCustomizeOrderModel getCustomizeOrderListCateArry:YES] mutableCopy];
        self.vcArr = [NSMutableArray array];
        for (JHOrderCateMode *mode in self.cateArr) {
            JHLivingCustomOrderView *listView = [[JHLivingCustomOrderView alloc] initWithFrame:CGRectMake(0, 50, self.pagingView.width, self.pagingView.height - 50)];
            MJWeakSelf;
            listView.selectBlock = ^(NSString * _Nonnull orderId) {
                [weakSelf removeFromSuperview];
                JHCustomizeOrderDetailController * detail=[[JHCustomizeOrderDetailController alloc]init];
                detail.orderId = orderId;
                detail.isSeller = YES;
                UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                UIViewController *currentViewController = [weakSelf getCurrentViewControllerWithRootViewController:rootViewController];
                [currentViewController.navigationController pushViewController:detail animated:YES];
            };
            listView.status = mode.status;
            [self.vcArr addObject:listView];
        }
        [self configUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.pagingView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH / 2);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)configUI{
    
    [self addSubview:self.pagingView];
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.pagingView.frame = CGRectMake(0, ScreenH / 2, ScreenW, ScreenH / 2);
    }];
}

- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        _topView.layer.shadowOffset = CGSizeMake(0, 3);//偏移距离
        _topView.layer.shadowOpacity = 0.1;//不透明度
        _topView.layer.shadowRadius = 3.0;//半径
        [_topView addSubview:self.categoryView];
    }
    return _topView;
}

- (JXCategoryTitleView *)categoryView{
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _categoryView.backgroundColor = [UIColor clearColor];
        _categoryView.titleColor = RGB(102, 102, 102);
        _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
        _categoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
        _categoryView.titleSelectedColor = RGB(51, 51, 51);
        _categoryView.cellSpacing = 15;
        
        NSMutableArray * arr = [NSMutableArray array];
        for (JHOrderCateMode *mode in self.cateArr) {
            [arr addObject:mode.title];
        }
        self.titles = arr;
        _categoryView.titles = self.titles;
        JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImgView.indicatorImageView.image = [UIImage imageNamed:@"sq_category_Indicator_img_normal"];
        indicatorImgView.indicatorImageViewSize = CGSizeMake(15, 4);
        indicatorImgView.verticalMargin = 4;
        _categoryView.indicators = @[indicatorImgView];
    }
    return _categoryView;
}

- (JXPagerView *)pagingView{
    if (_pagingView == nil) {
        _pagingView = [[JXPagerView alloc] initWithDelegate:self];
        _pagingView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH / 2);
        _pagingView.mainTableView.bounces = NO;
        [_pagingView yd_setCornerRadius:12 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
        _pagingView.clipsToBounds = YES;
    }
    return _pagingView;
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return [UIView new];
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 0;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 50;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.topView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    return self.vcArr[index];
}

/** 获取当前控制器*/
- (UIViewController *)getCurrentViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self getCurrentViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self getCurrentViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self getCurrentViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
