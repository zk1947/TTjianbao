//
//  JHAnchorInfoViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/7/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnchorInfoViewController.h"
#import "JHAnchorCommentListController.h"
#import "JHUserInfoPostController.h"
#import "JHSQHelper.h"
#import "JHLiveRoomApiManger.h"
#import "JHUserInfoModel.h"
#import <JXPagingView/JXPagerView.h>
#import "JHRouterManager.h"
#import "JHZanHUD.h"
#import "JHAnchorInfoHeader.h"
#import "JHLiveRoomModel.h"
#import "JHUserAuthModel.h"
#import "CommAlertView.h"
#import "JHAuthorize.h"

static const CGFloat kCategoryTitleHeight = 48.f;

@interface JHAnchorInfoViewController () <JXPagerViewDelegate, JXCategoryViewDelegate, JXPagerMainTableViewGestureDelegate>
{
    ///记录导航栏的透明度
    CGFloat _alphaValue;
}

///头部信息
@property (nonatomic, strong) JHAnchorInfoHeader            *header;
@property (nonatomic, strong) JXPagerView                   *pagingView;
@property (nonatomic, strong) JXCategoryTitleView           *categoryView;
@property (nonatomic, strong) NSArray <NSString *>          *titles;
@property (nonatomic, strong) JHUserInfoModel               *userInfoModel;
@property (nonatomic, strong) JHUserInfoPostController      *postVC;
@property (nonatomic, strong) JHAnchorCommentListController *commentVC;
@property (nonatomic, assign) CGFloat                       anchorHeaderHeight;
///直播间信息
@property (nonatomic, strong) JHLiveRoomModel *roomInfo;
///认证信息
@property (nonatomic, strong) JHUserAuthModel *authInfo;
@end

@implementation JHAnchorInfoViewController

- (void)dealloc {
    NSLog(@"JHAnchorInfoViewController释放了🔥🔥🔥🔥 ---- ");
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _alphaValue = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCategoryView];
    [self setupNav];
    [self updateRoomInfo];
    
    _anchorHeaderHeight = kCommonHeaderHeight;
    
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kChangeAnchorHeaderHeightNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self changeHeaderHeight:notification];
    }];
    
    [JHGrowingIO trackEventId:JHAnchorPageEnter from:self.fromSource ? : @""];
}

- (void)changeHeaderHeight:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    _anchorHeaderHeight = [dic[@"tableHeight"] floatValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pagingView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JHSQHelper setKeyBoardEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [JHSQHelper setKeyBoardEnable:YES];
}

#pragma mark -
#pragma mark - NavigationBar

- (void)setupNav {
//    [self initToolsBar];
//    [self.navbar addBtn:nil withImage:kNavBackWhiteShadowImg withHImage:kNavBackWhiteShadowImg withFrame:CGRectMake(0, 0, 44, 44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self showNavView];
    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self.jhLeftButton setImage:kNavBackWhiteShadowImg forState:UIControlStateNormal];
    [self.jhLeftButton setImage:kNavBackWhiteShadowImg forState:UIControlStateHighlighted];
//    self.navbar.ImageView.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark - CategoryView

- (void)configCategoryView {
    _titles = @[@"动态", @"买家评价(0)"];
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
    _pagingView.pinSectionHeaderVerticalOffset = UI.statusAndNavBarHeight;
    [self.view addSubview:_pagingView];

    //FIXME:如果和JXPagingView联动
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)_pagingView.listContainerView;

    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagingView.frame = self.view.bounds;
}

- (JHAnchorInfoHeader *)header {
    if (!_header) {
        _header = [[JHAnchorInfoHeader alloc] init];
        @weakify(self);
        _header.followBlock = ^(BOOL isFollow) {
            @strongify(self);
            [self handleFollowClickEvent:isFollow];
        };
        _header.updateBlock = ^{
            @strongify(self);
            [self updateRoomInfo];
        };
    }
    return _header;
}

#pragma mark -
#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.header;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return _anchorHeaderHeight;
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
        return self.postVC;
    }
    return self.commentVC;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

- (JHUserInfoPostController *)postVC {
    if (!_postVC) {
        _postVC = [[JHUserInfoPostController alloc] init];
        _postVC.userId = self.channel.anchorId;
        _postVC.infoType = JHPersonalInfoTypePublish;
    }
    return _postVC;
}

- (JHAnchorCommentListController *)commentVC {
    if (!_commentVC) {
        _commentVC = [[JHAnchorCommentListController alloc] init];
        _commentVC.channel = self.channel;
    }
    return _commentVC;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.header scrollViewDidScroll:scrollView.contentOffset.y];
    ///改变导航栏透明度
    CGFloat thresholdDistance = 100;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat ignoreOffsetY = 30.0; //忽略滑动的偏移量
    _alphaValue = (offsetY - ignoreOffsetY) / thresholdDistance;
    _alphaValue = MAX(0, MIN(1, _alphaValue));
    [self updateNaviBar];
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

#pragma mark -
#pragma mark - Data

- (void)updateRoomInfo {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
//    dispatch_group_enter(group);
//    [self getUserAuthInfo:^(JHUserAuthModel *authInfo) {
//        self.authInfo = authInfo;
//        dispatch_group_leave(group);
//    }];
    [self requestRoomInfo:^(JHLiveRoomModel *roomInfo) {
        self.roomInfo = roomInfo;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        ///处理认证信息
//        self.roomInfo.authType = self.authInfo.authType;
//        self.roomInfo.authState = self.authInfo.authState;
        self.header.roomInfo = self.roomInfo;
        
        self.categoryView.titles = self.titles;
        [self.categoryView reloadData];
        [self.pagingView reloadData];
    });
}

///获取用户认证信息
- (void)getUserAuthInfo:(void(^)(JHUserAuthModel *authInfo))block {
    [JHUserAuthModel requestUserAuthInfo:^(JHUserAuthModel *authInfo, BOOL hasError) {
        if (block) {
            block(authInfo);
        }
    }];
}

///请求用户个人信息
- (void)requestRoomInfo:(void(^)(JHLiveRoomModel *roomInfo))block {
    NSString *localId = self.channel?self.channel.channelLocalId:self.channelLocalId;
    @weakify(self);
    [JHLiveRoomApiManger getLiveRoomInfo:localId completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            @strongify(self);
            JHLiveRoomModel *model = (JHLiveRoomModel *)respObj;
            model.placeholderString = @"暂无直播间介绍~";
            NSString *comment = [NSString stringWithFormat:@"买家评价(%ld)",(long)model.commentNum];
            self.titles = @[@"动态", comment];
            if (block) {
                block(model);
            }
        }
    }];
}

///关注按钮点击事件
- (void)handleFollowClickEvent:(BOOL)isFollow {
    if (isFollow) {//已关注 并且开通粉丝团
        if (self.header.roomInfo.isJoin) {
            CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"取消关注" andDesc:@"您将退出Ta的粉丝团，粉丝等级将为您保留30天，继续关注后恢复，确认取消关注么？" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                [self requestFollow:isFollow];
                [JHTracking trackEvent:@"qxgzczTpye" property:@{@"operation_type":@"确认按钮点击"}];
            };
            alert.cancleHandle = ^{
                [JHTracking trackEvent:@"qxgzczTpye" property:@{@"operation_type":@"取消按钮点击"}];
            };
            [self.view addSubview:alert];
            [JHTracking trackEvent:@"qxgztcEnter" property:@{@"from":@"主播个人主页",@"anchor_id":self.channel.anchorId,@"channel_local_id":self.channel?self.channel.channelLocalId:self.channelLocalId}];
        }else{
            [self requestFollow:isFollow];
        }
        
    }else{
        [self requestFollow:isFollow];
    }
    
}
- (void)requestFollow:(BOOL)isFollow{
    @weakify(self);
    [JHLiveRoomApiManger follow:self.channel.anchorId currentStatus:!isFollow completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            RequestModel *request = (RequestModel *)respObj;
            [self resolveAnchorFans:request follow:isFollow];
            
        }
    }];
}
- (void)resolveAnchorFans:(RequestModel *)request follow:(BOOL)isFollow {
    NSString *str = isFollow ? @"取消关注成功" : @"关注成功";
    [UITipView showTipStr:[request.message isNotBlank]?request.message:str];
    JHLiveRoomModel *model = self.header.roomInfo;
    model.fansNum = (isFollow ? model.fansNum - 1 : model.fansNum + 1);
    model.isFollow = !isFollow;
    self.header.roomInfo = model;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameFollowStatus object:@(model.isFollow)];
    if (isFollow == false) {
        [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypeAnchorFollow];
    }
}

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    UIView* view = gestureRecognizer.view;
    CGPoint loc = [gestureRecognizer locationInView:view];
    if (loc.y < self.header.height + kCategoryTitleHeight) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


@end
