//
//  JHAppraiseViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHomeViewController.h"
#import "JHOnlineAppraiseViewController.h"
#import "JHBuyAppraiseViewController.h"
#import "JXPagerView/JXPagerView.h"
#import "JXCategoryBaseView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "JHSQHelper.h"
#import "JHMessageCenterData.h"
#import "JHRecycleHomeViewController.h"

NSString *const JHHomePageIndexChangedNotification = @"JHHomePageIndexChangedNotification";

@interface JHHomeViewController ()<JXPagerViewDelegate, JXCategoryViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic, strong) JXPagerView *pagingView;
/** 消息按钮*/
@property (nonatomic, strong) UIButton *messageButton;
/** 菜单栏*/
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) UIImageView *redHotImgView;
@end

@implementation JHHomeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHomePageActivityBtn) name:HomePageActivityABtnNotifaction object:nil];
    }
    return self;
}
- (void)showHomePageActivityBtn {
    User *user = [UserInfoRequestManager sharedInstance].user;
    if (user.type != 1 &&user.type != 2) {
        [self showActivityImage];
         [self.activityImage setImageWithURL:[NSURL URLWithString:[UserInfoRequestManager sharedInstance].homeActivityMode.homeActivityIcon.imgUrl] placeholder:nil];
    }
}
- (void)trackUserProfilePage:(BOOL)isBegin
{
    if(isBegin)
    {
        //用户画像浏览时长:begin
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
    }
    else
    {
        //用户画像浏览时长:end
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd} resumeBrowse:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMessageData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"在线鉴定",@"天天回收", @"购物鉴定"];
    self.categoryView.titles = self.titles;
    JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
    indicatorImgView.layer.cornerRadius = 2.f;
    indicatorImgView.clipsToBounds = YES;
    indicatorImgView.indicatorImageViewSize = CGSizeMake(28., 4.);
    indicatorImgView.backgroundColor = HEXCOLOR(0xffd70f);
    indicatorImgView.verticalMargin = 2.;
    self.categoryView.indicators = @[indicatorImgView];
    
    [self.view addSubview:self.pagingView];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    [self.view addSubview:self.messageButton];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(UI.statusBarHeight);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.redHotImgView];
    [self.redHotImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(180);
        make.top.mas_equalTo(self.view.mas_top).offset(UI.statusBarHeight+3);
        make.width.mas_equalTo(CGSizeMake(26, 14));
    }];
    [self addObserver];
    
}
- (void)addObserver {
    @weakify(self);
    [[[JHNotificationCenter rac_addObserverForName:JHHomePageIndexChangedNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        NSDictionary *params = notification.object;
        NSInteger  indexNum = [params[@"item_type"] integerValue];
        [self.categoryView selectItemAtIndex:indexNum];
    }];
    [[[JHNotificationCenter rac_addObserverForName:@"JHMallPageSectionGraduateeDidClicked" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self.categoryView selectItemAtIndex:2];
    }];
    
    //监听是否重新进入程序程序.（回到程序)
        [[[JHNotificationCenter rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
            @strongify(self);
            if (self.categoryView.selectedIndex == 0) {
                [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{@"page_name":@"在线鉴定首页"} type:JHStatisticsTypeSensors];
            }
            if (self.categoryView.selectedIndex == 1) {
                [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{@"page_name":@"天天回收首页"} type:JHStatisticsTypeSensors];
            }
            if (self.categoryView.selectedIndex == 2) {
                [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{@"page_name":@"购物鉴定首页"} type:JHStatisticsTypeSensors];
            }
        }];
}
- (void)getMessageData{
    @weakify(self);
    [JHMessageCenterData requestUnreadMessage:^(id obj, id data) {
        JHMsgCenterUnreadModel* noreadModel = (JHMsgCenterUnreadModel*)obj;
        NSInteger count = [JHQYChatManage unreadMessage];
        NSInteger total = noreadModel.total + count;
        @strongify(self);
        [self.messageButton jh_moveBadgeWithX:-16 Y:10];
        [self.messageButton jh_setBadgeFlexMode:JHBadgeFlexModeLeft];
        if(total > 0){
            [self.messageButton jh_addBadgeText:[self numberString:@(total).stringValue]];
        }else{
            [self.messageButton jh_hideBadge];
        }
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

#pragma mark - JXPagingViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return [UIView new];
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return UI.statusBarHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 44;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (index == 1) {
        self.redHotImgView.hidden = YES;
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickTab" params:@{
            @"tab_name":@"recycle",
            @"page_position":@"identifyService"
        } type:JHStatisticsTypeSensors];
    }else{
        self.redHotImgView.hidden = NO;
        if (index == 2) {
            [self.redHotImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view).offset(167);
            }];
        }else{
            [self.redHotImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view).offset(180);
            }];
        }
    }
    
    if (index == 0){
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickTab" params:@{@"tab_name":@"在线鉴定"} type:JHStatisticsTypeSensors];
    }
    if (index == 1){
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickTab" params:@{@"tab_name":@"天天回收"} type:JHStatisticsTypeSensors];
    }
    if (index == 2){
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickTab" params:@{@"tab_name":@"购物鉴定"} type:JHStatisticsTypeSensors];
    }
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        JHOnlineAppraiseViewController *onlineAppraiseViewController = [[JHOnlineAppraiseViewController alloc] init];
        return onlineAppraiseViewController;
    }else if(index == 1){
        JHRecycleHomeViewController *recycleVC = [[JHRecycleHomeViewController alloc] init];
        return recycleVC;
    }
    JHBuyAppraiseViewController *buyAppraiseViewController = [[JHBuyAppraiseViewController alloc] init];
    return buyAppraiseViewController;
}

#pragma mark - JXPagerMainTableViewGestureDelegate
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (JXCategoryTitleView *)categoryView{
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.titleColor = HEXCOLOR(0x666666);
        _categoryView.titleFont = [UIFont fontWithName:kFontMedium size:16];
        _categoryView.titleSelectedColor = HEXCOLOR(0x222222);
        _categoryView.contentEdgeInsetLeft = 22.f;
        _categoryView.cellSpacing = 26.f;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.titleLabelZoomScale = 1.375;
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.cellWidthZoomEnabled = YES;
        _categoryView.selectedAnimationEnabled = YES;
        _categoryView.delegate = self;
    }
    return _categoryView;
}

- (JXPagerView *)pagingView{
    if (_pagingView == nil) {
        _pagingView = [[JXPagerView alloc] initWithDelegate:self];
        _pagingView.mainTableView.gestureDelegate = self;
        _pagingView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        _pagingView.pinSectionHeaderVerticalOffset = UI.statusBarHeight;
//        _pagingView.mainTableView.scrollEnabled = NO;
    }
    return _pagingView;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"1");
}

/// 右上角消息按钮
- (UIButton *)messageButton{
    if (_messageButton == nil) {
        _messageButton = [JHSQHelper messageButton];
    }
    return _messageButton;
}
- (UIImageView *)redHotImgView{
    if (!_redHotImgView) {
        _redHotImgView = [[UIImageView alloc] init];
        _redHotImgView.image = JHImageNamed(@"recycle_home_redHot_icon");
    }
    return _redHotImgView;
}
@end
