//
//  JHUserInfoViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserInfoViewController.h"
#import "JHEasyPollSearchBar.h"
#import "JHUserHomePageHeader.h"
#import "JHSQHelper.h"
#import "JHHotWordModel.h"
#import "JHSQApiManager.h"
#import "JHUserInfoApiManager.h"
#import "JHUserInfoModel.h"
#import <JXPagingView/JXPagerView.h>
#import "JHUserInfoCommentListController.h"
#import "JHRouterManager.h"
#import "JHWebViewController.h"
#import "JHZanHUD.h"
#import "JHPersonalViewController.h"
#import "JHUserInfoPostController.h"
#import "JHSQSearchViewController.h"
#import "JHUserInfoGoodsController.h"
#import "JHUserInfoEvaluateController.h"

#define kLeftSpace 40
#define kRightSpace 15
#define kSearchBarWidth  (ScreenW - kLeftSpace - kRightSpace)

static const CGFloat kCategoryTitleHeight = 48.f;

static NSString *const kOtherPlaceholder = @"搜索TA的内容";
static NSString *const kMinePlaceholder = @"搜索我的内容";

@interface JHUserInfoViewController () <JXPagerViewDelegate, JXCategoryViewDelegate, JXPagerMainTableViewGestureDelegate>
{
    ///记录导航栏的透明度
    CGFloat _alphaValue;
}

@property (nonatomic, strong) JHEasyPollSearchBar *searchBar;
///头部信息
@property (nonatomic, strong) JHUserHomePageHeader *header;
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) JHUserInfoModel *userInfoModel;
///喜欢的个数
@property (nonatomic, assign) NSInteger likeNum;
///评论个数
@property (nonatomic, assign) NSInteger commentNum;
///发布个数
@property (nonatomic, assign) NSInteger publishNum;
///顶部header高度
@property (nonatomic, assign) NSInteger headerHeight;
///宝贝数
@property (nonatomic, assign) NSInteger product_num;
///评价数
@property (nonatomic, assign) NSInteger evaluation_num;

@property (nonatomic, strong) JHUserInfoCommentListController *commentVC;
@property (nonatomic, strong) JHUserInfoPostController *publishVC;
@property (nonatomic, strong) JHUserInfoPostController *likeVC;
@property (nonatomic, strong) JHUserInfoGoodsController *goodsVC;
@property (nonatomic, strong) JHUserInfoEvaluateController *evaluateVC;

@property (nonatomic, assign) BOOL popPan;

@end

@implementation JHUserInfoViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@*************被释放",[self class])
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _alphaValue = 0;
        _headerHeight = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCategoryView];
    [self setupNav];
    [self getHistoryStasticsInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLikeValue:) name:kUpdateUserCenterInfoNotification object:nil];
    ///个人页停留时长：开始
    [JHUserStatistics noteEventType:kUPEventTypeCommunityProfileBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin}];
}

- (void)updateLikeValue:(NSNotification *)noti {
    NSDictionary *info = noti.object;
    ///如果当前个人主页不是用户本人个人主页 点赞不执行下面的方法
    if ([JHSQManager isAccount:self.userId]) {
        NSInteger likeValue = [info[@"likeNum"] integerValue];
        self.likeNum += likeValue;
        NSString *likeStr = [NSString stringWithFormat:@"赞过 %@", [self transfomNumber:self.likeNum]];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.titles];
        [arr replaceObjectAtIndex:2 withObject:likeStr];
        self.titles = arr.copy;
        self.categoryView.titles = self.titles;
        [self.categoryView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadUserInfo];
    [JHSQHelper setKeyBoardEnable:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.jhStatusBarStyle = UIStatusBarStyleLightContent;
    _popPan = YES;
    self.pagingView.mainTableView.scrollEnabled = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.jhStatusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [JHSQHelper setKeyBoardEnable:YES];
    _popPan = NO;
    self.pagingView.mainTableView.scrollEnabled = NO;
    ///个人页停留时长：结束
    [JHUserStatistics noteEventType:kUPEventTypeCommunityProfileBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd}];
}

#pragma mark - NavigationBar

- (void)setupNav {
//    [self initToolsBar];
//    [self.navbar addBtn:nil withImage:kNavBackWhiteShadowImg withHImage:kNavBackWhiteShadowImg withFrame:CGRectMake(0, 0, 44, 44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self showNavView];
    self.jhNavView.backgroundColor = [UIColor clearColor];
//    self.navbar.ImageView.backgroundColor = [UIColor clearColor];
    
    ///搜索框
    _searchBar = [JHSQHelper searchBar];
    _searchBar.placeholder = kOtherPlaceholder;
    [self.jhNavView addSubview:_searchBar];
    _searchBar.frame = CGRectMake(kLeftSpace, 0, kSearchBarWidth, kSearchBarHeight);
    CGPoint point = _searchBar.center;
    point.y = UI.statusAndNavBarHeight - UI.navBarHeight/2.0;//self.jhLeftButton.centerY;
    _searchBar.center = point;
    @weakify(self);
    _searchBar.didSelectedBlock = ^(NSInteger selectedIndex, BOOL isLeft) {
        @strongify(self);
        [self enterSearchPage];
        [JHGrowingIO trackEventId:@"profile_serch"];
        ///369神策埋点:点击搜索栏-个人主页
        [JHTracking trackEvent:@"searchBarClick" property:@{@"page_position":@"个人主页"}];
    };
}

#pragma mark -
#pragma mark - CategoryView

- (void)configCategoryView {
    _titles = @[@"回帖 0", @"发帖 0", @"赞过 0", @"宝贝 0", @"评价 0"];
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kCategoryTitleHeight)];
    self.categoryView.titles = _titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kColor333;
    self.categoryView.titleColor = kColor666;
    self.categoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldDIN size:15];
    self.categoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
    self.categoryView.titleColorGradientEnabled = NO;
    self.categoryView.titleLabelZoomEnabled = NO;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = kColorMain;
    lineView.indicatorWidth = 15;
    lineView.verticalMargin = 6;
    self.categoryView.indicators = @[lineView];

    _pagingView = [[JXPagerView alloc] initWithDelegate:self];
    _pagingView.mainTableView.gestureDelegate = self;
    _pagingView.backgroundColor = kColorF5F6FA;
    _pagingView.mainTableView.backgroundColor = kColorF5F6FA;
    _pagingView.pinSectionHeaderVerticalOffset = UI.statusAndNavBarHeight;
    _pagingView.listContainerView.categoryNestPagingEnabled = YES;
    _pagingView.mainTableView.gestureDelegate = self;
    [self.view addSubview:_pagingView];

    //FIXME:如果和JXPagingView联动
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)_pagingView.listContainerView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagingView.frame = self.view.bounds;
}

- (JHUserHomePageHeader *)header {
    if (!_header) {
        _header = [[JHUserHomePageHeader alloc] init];
        @weakify(self);
        _header.followBlock = ^(BOOL isUser, BOOL isFollow) {
            @strongify(self);
            [self handleFollowClickEvent:isUser isFollow:isFollow];
        };
        _header.userDetailEventBlock = ^(JHDetailBlockType type) {
            @strongify(self);
            [self handleUserDetailAction:type];
        };
    }
    return _header;
}

- (void)handleUserDetailAction:(JHDetailBlockType)type {
    switch (type) {
        case JHDetailBlockTypeFans:
        case JHDetailBlockTypeFollow:
        {
            NSLog(@"点击粉丝数量");
            [self enterFriendVCWithCurIndex:type];
            [JHGrowingIO trackEventId:type == JHDetailBlockTypeFollow ? @"profile_follow_list_enter" : @"profile_fans_list_enter"];
        }
            break;
        case JHDetailBlockTypeLike:
        {
            NSLog(@"点击获赞数量");
            [JHZanHUD showText:[NSString stringWithFormat:@"\"%@\"共获得%@个赞", self.userInfoModel.user_name, self.userInfoModel.like_num]];
            [JHGrowingIO trackEventId:@"profile_like_list_click"];
        }
            break;
        case JHDetailBlockTypeExp:
        {
            NSLog(@"点击经验值数量");
            [self enterTaskCenterVC];
            [JHGrowingIO trackEventId:@"profile_experience_list_enter"];
        }
            break;
        default:
            break;
    }
}

- (void)enterFriendVCWithCurIndex:(NSInteger)curIndex {
    [JHRouterManager pushUserFriendWithController:self type:curIndex userId:[self.userInfoModel.user_id integerValue] name:self.userInfoModel.user_name];
}

//进入任务中心
- (void)enterTaskCenterVC {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.titleString = @"任务中心";
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/myTitle.html");
    [self.navigationController pushViewController:vc animated:YES];
}

///进入搜索界面
- (void)enterSearchPage {
    JHSQSearchViewController * vc =  [[JHSQSearchViewController alloc]init];
    vc.user_id = [self.userInfoModel.user_id integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - Data

- (void)loadUserInfo {
    [self requestUserInfo];
}

///请求用户个人信息
- (void)requestUserInfo {
    @weakify(self);
    [JHUserInfoApiManager homePageWithUserId:self.userId success:^(RequestModel * _Nonnull request) {
        @strongify(self);
        [self resolveUserInfo:request];
        
    } failure:^(RequestModel * _Nonnull request) {
        [SVProgressHUD dismiss];
//        [UITipView showTipStr:request.message];
    }];
}

- (void)getHistoryStasticsInfo {
    @weakify(self);
    [JHUserInfoApiManager getUserHistoryStasticsWithUserId:self.userId CompleteBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            RequestModel *model = (RequestModel *)respObj;
            [self updateCategoryValue:model];
        }
    }];
}

- (void)updateCategoryValue:(RequestModel *)respObj {
    NSDictionary *dic = respObj.data;
    self.commentNum = [dic[@"comment_num"] integerValue];
    self.publishNum = [dic[@"publish_num"] integerValue];
    self.likeNum = [dic[@"liked_num"] integerValue];
    self.product_num = [dic[@"product_num"] integerValue];
    self.evaluation_num = [dic[@"evaluation_num"] integerValue];
    NSInteger index = [self selectIndexForCategoryView];
    [self.categoryView selectItemAtIndex:index];

    NSString *comment = [NSString stringWithFormat:@"回帖 %@", [self transfomNumber:self.commentNum]];
    NSString *publish = [NSString stringWithFormat:@"发帖 %@", [self transfomNumber:self.publishNum]];
    NSString *like = [NSString stringWithFormat:@"赞过 %@", [self transfomNumber:self.likeNum]];
    NSString *goods = [NSString stringWithFormat:@"宝贝 %@", [self transfomNumber:self.product_num]];
    NSString *evaluate = [NSString stringWithFormat:@"评价 %@", [self transfomNumber:self.evaluation_num]];
    self.titles = @[comment, publish, like, goods, evaluate];
    self.categoryView.titles = self.titles;
    [self.categoryView reloadData];
}

- (NSInteger)selectIndexForCategoryView {
    
    if(_index > 0 && _index <= 3) {
        /// 创作中心进入的
        return (_index - 1);
    }
    
    if (self.publishNum != 0) {
        ///发过不为空
        return 1;
    }
    if (self.publishNum == 0 && self.commentNum != 0) {
        return 0;
    }
    
    if (self.commentNum == 0 && self.publishNum == 0 && self.likeNum != 0) {
        return 2;
    }
    if (self.commentNum == 0 && self.publishNum == 0 && self.likeNum == 0) {
        ///三项都为0 进入发过
        return 1;
    }
    return 1;
}

///处理用户信息
- (void)resolveUserInfo:(RequestModel *)request {
    JHUserInfoModel *model = [JHUserInfoModel mj_objectWithKeyValues:request.data];
    self.userInfoModel = model;
    NSString *placeholder = [self isSelf] ? kMinePlaceholder : kOtherPlaceholder;
    self.searchBar.placeholder = placeholder;
    self.header.userInfo = model;
    [self.pagingView reloadData];
}

- (BOOL)isSelf {
    if ([self.userInfoModel.user_id isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
        return YES;
    }
    return NO;
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.header;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    NSArray *arr = [JHSQManager getUserMedalInfo:self.userInfoModel];
    CGFloat medalHeight = (arr.count > 0) ? 0 : -22;
    if (self.userInfoModel.storeInfo) {
        return kSpecialHeaderHeight + medalHeight;
    }
    return kCommonHeaderHeight+medalHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return kCategoryTitleHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        [JHGrowingIO trackEventId:@"profile_comment_click"];
        return self.commentVC;
    }
    if (index == 1) {
        [JHGrowingIO trackEventId:@"profile_write_click"];
        return self.publishVC;
    }
    if (index == 2) {
        [JHGrowingIO trackEventId:@"profile_like_click"];
        return self.likeVC;
    }
    if (index == 3) {
        return self.goodsVC;

    }
    return self.evaluateVC;

}

- (JHUserInfoCommentListController *)commentVC {
    if (!_commentVC) {
        _commentVC = [[JHUserInfoCommentListController alloc] init];
        _commentVC.userId = self.userId;
        @weakify(self);
        _commentVC.refreshBlock = ^{
            @strongify(self);
            [self getHistoryStasticsInfo];
        };
    }
    return _commentVC;
}

- (JHUserInfoPostController *)publishVC {
    if (!_publishVC) {
        _publishVC = [[JHUserInfoPostController alloc] init];
        _publishVC.userId = self.userId;
        _publishVC.infoType = JHPersonalInfoTypePublish;
    }
    return _publishVC;
}

- (JHUserInfoPostController *)likeVC {
    if (!_likeVC) {
        _likeVC = [[JHUserInfoPostController alloc] init];
        _likeVC.userId = self.userId;
        _likeVC.infoType = JHPersonalInfoTypeLike;
    }
    return _likeVC;
}

- (JHUserInfoGoodsController *)goodsVC{
    if (!_goodsVC) {
        _goodsVC = [[JHUserInfoGoodsController alloc] init];
        _goodsVC.userId = self.userId;

    }
    return _goodsVC;
}

- (JHUserInfoEvaluateController *)evaluateVC{
    if (!_evaluateVC) {
        _evaluateVC = [[JHUserInfoEvaluateController alloc] init];
        _evaluateVC.userId = self.userId;

    }
    return _evaluateVC;
}
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.header scrollViewDidScroll:scrollView.contentOffset.y];
    ///改变导航栏透明度
    CGFloat thresholdDistance = 100;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat ignoreOffsetY = 30.0; //忽略滑动的偏移量
    _alphaValue = (offsetY - ignoreOffsetY) / thresholdDistance;
    _alphaValue = MAX(0, MIN(1, _alphaValue));
    self.jhStatusBarStyle = (_alphaValue < 0.6 ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
    [self updateNaviBar];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
}

#pragma mark -
#pragma mark - private method

- (void)updateNaviBar {
    BOOL isHidden = _alphaValue <= 0.5;
    [UIView animateWithDuration:0.25 animations:^{
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:_alphaValue];
        [self.jhLeftButton setImage:(isHidden ? kNavBackWhiteShadowImg : kNavBackBlackImg) forState:UIControlStateNormal];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

///关注按钮点击事件
- (void)handleFollowClickEvent:(BOOL)isUser isFollow:(BOOL)isFollow {
    if (isUser) {
        ///作者本人
        [self enterPersonalPage];
        return;
    }
    if (isFollow) {
        ///已关注 需要取消关注
        [self toCancelFollow];
    }
    else {
        [self toFollow];
    }
    //埋点
    [Growing track:@"follow" withVariable:@{@"value":@"个人页"}];
}

///进入个人信息界面
- (void)enterPersonalPage {
    JHPersonalViewController *vc = [[JHPersonalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

///关注用户
- (void)toFollow {
    @weakify(self);
    [JHUserInfoApiManager followUserAction:_userInfoModel.user_id fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:@"关注成功"];
            [self updateFansInfo:respObj isFollow:YES];
            if (self.followStatusChangedBlock) {
                self.followStatusChangedBlock(self.userId, YES);
            }
        }
    }];
}

///取消关注
- (void)toCancelFollow {
    @weakify(self);
    [JHUserInfoApiManager cancelFollowUserAction:_userInfoModel.user_id fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            [self updateFansInfo:respObj isFollow:NO];
        }
        if (self.followStatusChangedBlock) {
            self.followStatusChangedBlock(self.userId, NO);
        }
    }];
}

///点击关注按钮后修改关注状态
- (void)updateFansInfo:(id)respObj isFollow:(BOOL)isFollow {
    RequestModel *responseObject = (RequestModel *)respObj;
    self.userInfoModel.fans_num = responseObject.data[@"fans_num"];
    self.userInfoModel.fans_num_int = [responseObject.data[@"fans_num_int"] integerValue];
    self.userInfoModel.is_follow = @(isFollow).integerValue;
    self.header.userInfo = self.userInfoModel;
    ///这个是处理在线鉴定固定用户关注状态的
    [JHUserDefaults setBool:@(self.userInfoModel.is_follow).boolValue forKey:@"kOperateFollowStatusKey"];
    [JHUserDefaults synchronize];
}

- (NSString *)transfomNumber:(NSInteger)number {
    if (number >= 100) {
        return @"99+";
    }
    return @(number).stringValue;
}

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.popPan;
}

    
@end

