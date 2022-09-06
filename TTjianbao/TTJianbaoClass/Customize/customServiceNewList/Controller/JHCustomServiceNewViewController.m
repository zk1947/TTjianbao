//
//  JHCustomServiceNewViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomServiceNewViewController.h"
#import "JXPagerView/JXPagerView.h"
#import "JXCategoryBaseView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"
#import "JHCustomServiceNewHeaderView.h"
#import "JHCustomizedPeopleViewController.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "PanNavigationController.h"
#import "SVProgressHUD.h"
#import "TTjianbaoHeader.h"
#import "JHCustomWorksViewController.h"
#import "JHGrowingIO.h"

static const CGFloat JHheightForHeaderInSection = 50;

@interface JHCustomServiceNewViewController ()<JXPagerViewDelegate, JXCategoryViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) JXPagerView *pagingView;
/** 表头部分*/
@property (nonatomic, strong) JHCustomServiceNewHeaderView * customHeaderView;
/** 菜单栏*/
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
/** 定制师页面*/
@property (nonatomic, strong) JHCustomizedPeopleViewController *customPeopleVC;
/** 定制作品页面*/
@property (nonatomic, strong) JHCustomWorksViewController *customWorksVC;

@end

@implementation JHCustomServiceNewViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.customHeaderView reloadLastOrderData];
    [self.customHeaderView viewAppear];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.customHeaderView viewDismiss];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [JHHomeTabController changeStatusWithMainScrollView:self.pagingView.mainTableView index:1 hasSubScrollView:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"天天定制";
    self.jhNavBottomLine.hidden = NO;
    self.titles = @[@"定制师", @"定制作品"];
    self.categoryView.titles = self.titles;
//    JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
//    indicatorImgView.indicatorImageView.image = [UIImage imageNamed:@"sq_category_Indicator_img_normal"];
//    indicatorImgView.indicatorImageViewSize = CGSizeMake(15, 4);
//    indicatorImgView.verticalMargin = 4;
//    self.categoryView.indicators = @[indicatorImgView];
    
    [self.view addSubview:self.pagingView];

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    ///第一次加载 需要展示刷新的动效
    [self.pagingView.mainTableView.mj_header beginRefreshing];
}

/** 点击搜索跳转事件*/
-(void)rightActionButton:(UIButton *)sender
{
    [SVProgressHUD showInfoWithStatus:@"点击了我的订单"];
}

#pragma mark - JXPagingViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.customHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.customHeaderView.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return JHheightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        return self.customPeopleVC;
    }else{
        return self.customWorksVC;
    }
    return nil;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    [JHHomeTabController changeStatusWithMainScrollView:self.pagingView.mainTableView index:1 hasSubScrollView:YES];
}
#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
//    if(index == 0) {
//        [JHHomeTabController setSubScrollView:self.customPeopleVC.collectionView];
//    }
//    else {
//        [JHHomeTabController setSubScrollView:self.customWorksVC.collectionView];
//    }
    [JHGrowingIO trackEventId:JHTrackCustomizelive_sy_type_in]; //切换标签
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
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

#pragma mark - JXPagingViewListViewDelegate

- (UIScrollView *)listScrollView {
    return self.pagingView.mainTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}


#pragma mark - JXPagerMainTableViewGestureDelegate
//解决左右滑动冲突
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIView* view = gestureRecognizer.view;
    CGPoint loc = [gestureRecognizer locationInView:view];
    if (loc.y < self.customHeaderView.height + JHheightForHeaderInSection) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
#pragma  mark -UI绘制
- (JHCustomServiceNewHeaderView *)customHeaderView{
    if (_customHeaderView == nil) {
        _customHeaderView = [[JHCustomServiceNewHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
        JH_WEAK(self);
        _customHeaderView.changeHeightBlock = ^(CGFloat viewHeight) {
            JH_STRONG(self);
            self.customHeaderView.height = viewHeight;
            [self.pagingView reloadData];
        };
        _customHeaderView.completeBlock = ^{
            JH_STRONG(self);
            [self.pagingView.mainTableView.mj_header endRefreshing];
        };
    }
    return _customHeaderView;
}

- (JXCategoryTitleView *)categoryView{
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, JHheightForHeaderInSection)];
        _categoryView.backgroundColor = [UIColor clearColor];
        _categoryView.titleColor = HEXCOLOR(0x999999);
        _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:14];
        _categoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:14];
        _categoryView.titleSelectedColor = HEXCOLOR(0x222222);
        _categoryView.cellSpacing = 80;
        _categoryView.delegate = self;
    }
    return _categoryView;
}

- (JXPagerView *)pagingView{
    if (_pagingView == nil) {
        _pagingView = [[JXPagerView alloc] initWithDelegate:self];
        _pagingView.mainTableView.gestureDelegate = self;
        _pagingView.frame = CGRectMake(0, UI.statusAndNavBarHeight, kScreenWidth, ScreenHeight - UI.statusAndNavBarHeight);
        
        JH_WEAK(self);
        _pagingView.mainTableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            JH_STRONG(self);
            [self.customHeaderView reloadData];
            [self.customPeopleVC reloadNewData];
            [self.customWorksVC reloadNewData];
        }];
    }
    return _pagingView;
}

- (JHCustomizedPeopleViewController *)customPeopleVC{
    if (_customPeopleVC == nil) {
        _customPeopleVC = [[JHCustomizedPeopleViewController alloc] init];
    }
    return _customPeopleVC;
}

- (JHCustomWorksViewController *)customWorksVC{
    if (_customWorksVC == nil) {
        _customWorksVC = [[JHCustomWorksViewController alloc] init];
    }
    return _customWorksVC;
}
@end
