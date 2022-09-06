//
//  JHRecycleInfoViewController.m
//  TTjianbao
//
//  Created by user on 2021/4/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleInfoViewController.h"
#import "JHAnchorCommentListController.h"
#import "JHUserInfoPostController.h"
#import "JHCustomerOpusViewController.h"
#import "JHHonnerCerDetailViewController.h"
#import "JHMasterpieceDetailViewController.h"

#import "JHSQHelper.h"
#import "JHLiveRoomApiManger.h"
#import "JHUserInfoModel.h"
#import <JXPagingView/JXPagerView.h>
#import "JHRouterManager.h"
#import "JHZanHUD.h"
#import "JHRecycleInfoHeader.h"
#import "JHLiveRoomModel.h"
#import "NSObject+Cast.h"
#import "JHPersonalViewController.h"
#import "JHBaseOperationView.h"
#import "JHLivePlaySMallView.h"
#import "UIView+Toast.h"


static const CGFloat kCategoryTitleHeight = 48.f;

@interface JHRecycleInfoViewController ()<
JXPagerViewDelegate,
JXCategoryViewDelegate,
JXPagerMainTableViewGestureDelegate>
{
    ///记录导航栏的透明度
    CGFloat _alphaValue;
    NSString *_dynamicTitle, *_commentTitle;
}

///头部信息
@property (nonatomic, strong) JHRecycleInfoHeader           *header;
@property (nonatomic, strong) JXPagerView                   *pagingView;
@property (nonatomic, strong) JXCategoryTitleView           *categoryView;
@property (nonatomic, strong) NSArray <NSString*>           *titles;
@property (nonatomic, strong) JHUserInfoModel               *userInfoModel;
@property (nonatomic, strong) JHUserInfoPostController      *postVC;
@property (nonatomic, strong) JHAnchorCommentListController *commentVC;
@property (nonatomic, assign) CGFloat                        customerHeaderHeight;
@end

@implementation JHRecycleInfoViewController
- (void)dealloc {
    NSLog(@"JHRecycleInfoViewController释放了🔥🔥🔥🔥 ---- ");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _alphaValue   = 0;
        _dynamicTitle = @"动态 0";
        _commentTitle = @"买家评价 0";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self requestRoomInfo];
}

- (void)creatUI {
    [self configCategoryView];
    [self getdynamicCount];
    _customerHeaderHeight = kHeightOfCommonHeader;
    [self jhBringSubviewToFront];
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kChangeRecycleHeaderHeightNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self changeHeaderHeight:notification];
    }];
}


- (void)initLiveSmallView {
    [[JHLivePlaySMallView sharedInstance] close];
    JHLivePlaySMallView * view=[JHLivePlaySMallView sharedInstance];
    ChannelMode *channel = [ChannelMode new];
    channel.channelLocalId = self.header.roomInfo.channelLocalId;
    view.channelMode=channel;
     view.closeButton.hidden = YES;
    [JHKeyWindow addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(JHKeyWindow).offset(-200);
        make.right.equalTo(JHKeyWindow.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(120, 190));
    }];
    [[JHLivePlayer sharedInstance] startPlay:self.header.roomInfo.rtmpPullUrl inView:view.playView];
    [JHLivePlayer sharedInstance].didPlayBlock = ^{
        view.closeButton.hidden = NO;
    };
}
- (void)changeHeaderHeight:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    _customerHeaderHeight = [dic[@"tableHeight"] floatValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pagingView reloadData];
    });
}

#pragma mark -
#pragma mark - NavigationBar

- (void)setupNav {
    [self.jhLeftButton setImage:kNavBackWhiteShadowImg forState:UIControlStateNormal];
    [self initRightButtonWithImageName:@"customize_share_white" action:@selector(rightActionButton)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(37, 37));
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    self.jhNavView.backgroundColor = UIColor.clearColor;
    [self jhBringSubviewToFront];
}

- (void)backActionEvent {
    
}

- (void)rightActionButton {
    /// 分享
    [JHTracking trackEvent:@"clickShare" property:@{
        @"channel_local_id":NONNULL_STR(self.channelLocalId),
        @"page_position":@"anchorPersonalHomepage"
    }];
        
    JHCustomerInfoShareDataModel *shareModel = self.header.roomInfo.shareData;
    JHShareInfo* info = [JHShareInfo new];
    info.title = shareModel.title;
    info.desc  = shareModel.desc;
    info.shareType = ShareObjectTypeCustomizeNormal;
    info.url = shareModel.url;
    info.img = shareModel.img;
    [JHBaseOperationView showShareView:info objectFlag:nil];
}


#pragma mark -
#pragma mark - CategoryView

- (void)configCategoryView {
    _titles = @[_dynamicTitle, _commentTitle];
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kCategoryTitleHeight)];
    self.categoryView.titles                    = _titles;
    self.categoryView.backgroundColor           = [UIColor whiteColor];
    self.categoryView.delegate                  = self;
    self.categoryView.titleSelectedColor        = kColor333;
    self.categoryView.titleColor                = kColor666;
    self.categoryView.titleSelectedFont         = [UIFont fontWithName:kFontBoldDIN size:15];
    self.categoryView.titleFont                 = [UIFont fontWithName:kFontNormal size:15];
    self.categoryView.titleColorGradientEnabled = NO;
    self.categoryView.titleLabelZoomEnabled     = NO;

    JXCategoryIndicatorLineView *lineView       = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor                     = kColorMain;
    lineView.indicatorWidth                     = 15;
    lineView.verticalMargin                     = 6;
    self.categoryView.indicators                = @[lineView];

    _pagingView = [[JXPagerView alloc] initWithDelegate:self];
    _pagingView.mainTableView.gestureDelegate = self;
    _pagingView.mainTableView.backgroundColor = kColorF5F6FA;
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

- (JHRecycleInfoHeader *)header {
    if (!_header) {
        _header = [[JHRecycleInfoHeader alloc] init];
        @weakify(self);
        _header.followBlock = ^(BOOL isFollow) {
            @strongify(self);
            if (self.header.roomInfo.showButton) {
                /// 跳转资料编辑页面
                JHPersonalViewController *vc = [[JHPersonalViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self handleFollowClickEvent:isFollow];
            }
        };
        _header.updateBlock = ^{
            @strongify(self);
            [self requestRoomInfo];
        };
        
        _header.iconActionBlock = ^{
            @strongify(self);
            if ([self.anchorId isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [JHRootController EnterLiveRoom:self.header.roomInfo.channelLocalId fromString:@"dz_teacher_in" isStoneDetail:NO isApplyConnectMic:NO];
            }
        };
    }
    return _header;
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.header;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return _customerHeaderHeight;
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
    if (index == 1) {
        return self.commentVC;
    }
    return nil;
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (index == 0) {
        /// 点击动态
        [JHTracking trackEvent:@"clickDynamic" property:@{
            @"channel_local_id":NONNULL_STR(self.channelLocalId),
            @"page_position":@"anchorPersonalHomepage"
        }];
    }
    if (index == 1) {
        /// 点击评价
        [JHTracking trackEvent:@"clickComment" property:@{
            @"channel_local_id":NONNULL_STR(self.channelLocalId),
            @"page_position":@"anchorPersonalHomepage"
        }];
    }
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

- (JHUserInfoPostController *)postVC {
    if (!_postVC) {
        _postVC = [[JHUserInfoPostController alloc] init];
        _postVC.userId = isEmpty(self.anchorId)?NONNULL_STR(self.header.roomInfo.anchorId):self.anchorId;
        _postVC.infoType = JHPersonalInfoTypePublish;
    }
    return _postVC;
}

- (JHAnchorCommentListController *)commentVC {
    if (!_commentVC) {
        _commentVC = [[JHAnchorCommentListController alloc] init];
        _commentVC.anchorId = isEmpty(self.anchorId)?NONNULL_STR(self.header.roomInfo.anchorId):self.anchorId;
        _commentVC.roomId = isEmpty(self.roomId)?NONNULL_STR(self.header.roomInfo.channelLocalId):self.roomId;
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
    self.jhNavBottomLine.hidden = isHidden;
    [UIView animateWithDuration:0.25 animations:^{
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:_alphaValue];
        [self.jhLeftButton setImage:(isHidden ? kNavBackWhiteShadowImg : kNavBackBlackImg) forState:UIControlStateNormal];
        [self.jhRightButton setImage:(isHidden ? [UIImage imageNamed:@"customize_share_white"] : [UIImage imageNamed:@"navi_icon_share_black"]) forState:UIControlStateNormal];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma mark -
#pragma mark - Data

///请求用户个人信息
- (void)requestRoomInfo {
    @weakify(self);
    [JHLiveRoomApiManger getLiveRoomInfo:self.channelLocalId completeBlock:^(JHLiveRoomModel *model, BOOL hasError) {
        if (!hasError) {
            @strongify(self);
            model.showAllInfo = NO;
            _commentTitle = [NSString stringWithFormat:@"买家评价 %ld",(long)model.commentNum];
            [self configCategoryTitle];
            self.header.roomInfo = model;
            [self creatUI];
            [self.pagingView reloadData];
        } else {
            RequestModel *respondObject = [RequestModel cast:model];
            NSString *str = isEmpty(respondObject.message)?@"请求失败，请稍后重试":respondObject.message;
            [self.view makeToast:str duration:1.0 position:CSToastPositionCenter];
        }
    }];
}
- (void)getdynamicCount {
    NSString *str = isEmpty(self.anchorId)?NONNULL_STR(self.header.roomInfo.anchorId):self.anchorId;
    [JHUserInfoApiManager getUserHistoryStasticsWithUserId:str CompleteBlock:^(RequestModel *respObj, BOOL hasError) {
        NSLog(@"respObj:---- %@", respObj);
        if (!hasError) {
            _dynamicTitle = [NSString stringWithFormat:@"动态 %ld",(long)[respObj.data[@"publish_num"] integerValue]];
            [self configCategoryTitle];
        }
    }];
}

- (void)configCategoryTitle {
    self.titles = @[_dynamicTitle, _commentTitle];
    self.categoryView.titles = self.titles;
    [self.categoryView reloadData];
}

///关注按钮点击事件
- (void)handleFollowClickEvent:(BOOL)isFollow {
    NSString *isFocus = !isFollow ? @"true" : @"false";
    [JHTracking trackEvent:@"clickFocus" property:@{
        @"channel_local_id":NONNULL_STR(self.channelLocalId),
        @"is_focus":isFocus,
        @"page_position":@"anchorPersonalHomepage"
    }];
    
    if (isFollow) {//已关注 并且开通粉丝团
        if (self.header.roomInfo.isJoin) { //
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
            [JHTracking trackEvent:@"qxgztcEnter" property:@{@"from":@"主播个人主页",@"anchor_id":self.anchorId,@"channel_local_id":self.channelLocalId}];
        }else{
            [self requestFollow:isFollow];
        }
        
    } else {
        [self requestFollow:isFollow];
    }
}

- (void)requestFollow:(BOOL)isFollow{
    @weakify(self);
    NSString *anId = isEmpty(self.anchorId)?NONNULL_STR(self.header.roomInfo.anchorId):self.anchorId;
    [JHLiveRoomApiManger follow:anId currentStatus:!isFollow completeBlock:^(id  _Nullable respObj, BOOL hasError) {
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
}

//解决左右滑动冲突
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIView* view = gestureRecognizer.view;
    CGPoint loc = [gestureRecognizer locationInView:view];
    if (loc.y < self.header.height + kCategoryTitleHeight) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


@end
