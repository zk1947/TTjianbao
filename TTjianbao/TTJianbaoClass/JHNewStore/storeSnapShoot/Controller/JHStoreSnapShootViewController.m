//
//  JHStoreSnapShootViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreSnapShootViewController.h"
#import "JHStoreSnapShootDetailView.h"
#import "JHStoreDetailCouponViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorImageView.h"
#import "JHPlayerViewController.h"
#import "JHNormalControlView.h"
#import "JHPlayerVerticalBigView.h"
#import "JHSettingAutoPlayController.h"
#import "JHShareInfo.h"
#import "JHBaseOperationView.h"
#import "JHNewShopDetailViewController.h"
#import "JHSQCollectViewController.h"
#import "JHOrderConfirmViewController.h"
#import "JHNewStoreSpecialDetailViewController.h"


@interface JHStoreSnapShootViewController ()<JXCategoryViewDelegate, JXCategoryTitleViewDataSource>

@property (nonatomic, strong) JHStoreSnapShootDetailView *homeView;
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryIndicatorImageView *indicatorImgView;
@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, strong) JHNormalControlView *normalPlayerControlView;
@property (nonatomic, strong) JHPlayerVerticalBigView *verticalPlayerControlView;
@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isScrollPause;

@end

@implementation JHStoreSnapShootViewController

#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindData];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![self isAutoPlay]) {
        [self.playerController pause];
    }else{
//        self.isPlaying = true;
    }
    [self.homeView viewDidAppear];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.jhNavView];
    [self layoutViews];
}
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    // 跳转
    [self.homeView.viewModel.pushvc subscribeNext:^(NSDictionary * _Nullable x) {
        @strongify(self)
        NSDictionary *dic = (NSDictionary *)x;
        [self pushWithDic:dic];
    }];
    // 滚动监听
    [self.homeView.scrollSubject subscribeNext:^(id _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        [self updateScroll:x];
    }];
    // toast弹框
    [RACObserve(self.homeView.viewModel, toastMsg) subscribeNext:^(NSDictionary * _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        NSString *str = [NSString stringWithFormat:@"%@", x];
        if (str.length <= 0) { return; }
        [self.view makeToast:str duration:1.0 position:CSToastPositionCenter];
    }];
    // 分类选择
    [RACObserve(self.homeView.viewModel, categoryTitleIndex) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSUInteger index = [x unsignedIntegerValue];
        [self.titleCategoryView selectItemAtIndex:index];
    }];
    [RACObserve(self.homeView.viewModel, productSellStatusDesc) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.sellStatusDesc = x;
    }];
    // 监听视频view
    [RACObserve(self.homeView.headerView.cycleView, displayIndex) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSUInteger index = [x unsignedIntegerValue];
        if (self.playerController.urlString <= 0) { return; }
        if (index == 0) {
            [self playerPause:false];
        }else {
            [self playerPause:true];
        }
    }];
    // 监听视频view 和 视频地址
    RACSignal *combin = [RACObserve(self.homeView.viewModel, videoUrl) combineLatestWith:RACObserve(self.homeView.headerView.cycleView, videoView)];
    
    [combin subscribeNext:^(id  _Nullable x) {
        if (x == nil) { return; }
        if (x[0] == nil) { return;}
        if (x[1] == nil) { return;}
        
        [self setPlayerUrl];
        [self setPlayerViews];
    }];
    
}
#pragma mark - Private Functions
- (void)playerPause : (BOOL)isPause {
    if (isPause) {
        if (self.playerController.isPLaying) {
            self.isScrollPause = true;
            [self.playerController pause];
        }
    }else {
        // 同步安卓-滚动返回不重新播放
//        if (!self.playerController.isPLaying) {
//            self.isScrollPause = false;
//            if (self.isPlaying) {
//                [self.playerController play];
//            }
//        }
    }
}
- (void)setPlayerUrl {
    if ([self isAutoPlay]) {
        [self.homeView.headerView.cycleView.videoView.playSubject sendNext:nil];
    }
}
- (void)setPlayerViews {
    JHStoreDetailCycleVideoItem *videoView = self.homeView.headerView.cycleView.videoView;
    if (videoView == nil || self.homeView.viewModel.videoUrl == nil) { return; }
    [videoView insertSubview:self.playerController.view belowSubview:videoView.imageView];
    self.playerController.view.frame = CGRectMake(0, 0, ScreenW, ScreenW);
    [self.playerController setSubviewsFrame];
    [self.playerController setControlView:self.normalPlayerControlView];
    @weakify(self)
    [self.homeView.headerView.cycleView.videoView.playSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.playerController.urlString = self.homeView.viewModel.videoUrl;
    }];
}

- (BOOL)isAutoPlay {
    BOOL isWiFi = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
    JHAutoPlayStatus type = [JHSettingAutoPlayController getAutoPlayStatus];
    
    switch (type) {
        case JHAutoPlayStatusWIFIAnd4G:
            return YES;
            break;
        case JHAutoPlayStatusWIFI:
            return isWiFi;
            break;
        default:
            return NO;
            break;
    }
}

- (void)setupViews {
    self.jhNavView.backgroundColor = UIColor.clearColor;
    
    [self initLeftButtonWithImageName:@"newStore_icon_back_white" action:@selector(backActionButton:)];
//    [self initRightButtonWithImageName:@"newStore_share_white_icon" action:@selector((didClickShare:))];
    [self.jhLeftButton setImage:[UIImage imageNamed:@"newStore_icon_back_black"] forState:UIControlStateSelected];
//    [self.jhRightButton setImage:[UIImage imageNamed:@"newStore_share_black_icon"] forState:UIControlStateSelected];

    [self.jhNavView addSubview:self.maskView];
    [self.jhNavView addSubview:self.titleCategoryView];
    [self.view addSubview:self.homeView];

}
- (void)layoutViews {
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jhLeftButton.mas_centerY).offset(-5);
        make.centerX.equalTo(self.jhNavView);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.jhNavView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
#pragma mark - Action functions
- (void)didClickShare : (UIButton *)sender {
    JHShareInfo *shareInfo = self.homeView.viewModel.shareInfo;
    if (shareInfo == nil) { return; }
    [JHBaseOperationView showShareView:shareInfo objectFlag:nil];
}
- (void)updateScroll:(UIScrollView *)scrollView {
    CGFloat headerHeight = self.homeView.viewModel.headerViewModel.height;
    CGFloat offsetY = scrollView.contentOffset.y ;
    
    CGFloat alphaValue = offsetY / headerHeight;
    if (alphaValue >= 1) {
        alphaValue = 1;
    }
    BOOL bottomLineHidden = (offsetY < headerHeight);
    self.jhTitleLabel.alpha = alphaValue;
    self.jhNavBottomLine.hidden = bottomLineHidden;
    self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:alphaValue];
    self.jhLeftButton.selected = bottomLineHidden ? false : true;
    self.jhRightButton.selected = bottomLineHidden ? false : true;
    self.titleCategoryView.hidden = bottomLineHidden;
    self.maskView.hidden = !bottomLineHidden;
    
    if (offsetY >= ScreenW) {
        [self playerPause:true];
    }else {
        [self playerPause:false];
    }
}
#pragma mark - --Push--
- (void)pushWithDic : (NSDictionary *)dic {
    NSString *type = dic[@"type"];
    NSDictionary *par = dic[@"parameter"];
    // 优惠券
    if ([type isEqualToString:@"Coupon"]) {
        JHStoreDetailCouponViewController *vc = [[JHStoreDetailCouponViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vc.parameter = par;
        [self presentViewController:vc animated:true completion:nil];
    }else if ([type isEqualToString:@"SpecialShow"]) { // 专场
        JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
        [self pushWithVC:vc];
    }else if ([type isEqualToString:@"Order"]) { // 订单
        JHOrderConfirmViewController * order = [[JHOrderConfirmViewController alloc]init];
        order.goodsId = par[@"productId"];
        order.orderCategory = @"mallOrder";;
        order.orderType = JHOrderTypeMall;
//        order.source = self.entry_type;
        order.activeConfirmOrder = true;
        order.fromString = JHConfirmFromGoodsDetail;
        [self pushWithVC:order];
    }else if ([type isEqualToString:@"Payment"]) { // 支付
        
    }else if ([type isEqualToString:@"Shop"]) { // 店铺
        JHNewShopDetailViewController *vc = [[JHNewShopDetailViewController alloc]init];
        vc.shopId = par[@"shopId"];
        [self pushWithVC:vc];
    }else if ([type isEqualToString:@"Serice"]) { // 客服
        [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
    }else if ([type isEqualToString:@"Education"]) { // 用户教育
        [self pushWebVCWithUrl:par[@"url"]];
    }else if ([type isEqualToString:@"Collect"]) { // 收藏
        JHSQCollectViewController *vc = [[JHSQCollectViewController alloc]init];
        [self pushWithVC:vc];
    }else if ([type isEqualToString:@"NewUserActivities"]) { // 新人福利
        [self pushWebVCWithUrl:par[@"url"]];
    }else if ([type isEqualToString:@"Login"]) { // 登录
        [JHRootController presentLoginVC];
    }
}
- (void)pushWithVC : (UIViewController *)vc  {
    [self.navigationController pushViewController:vc animated:true];
}
- (void)pushWebVCWithUrl : (NSString *)url{
    
}
#pragma mark - CategoryView
- (CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    return 60;
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (index == 1) {
        [self.homeView scrollToSpec];
    }else{
        [self.homeView scrollToTop];
    }
}
#pragma mark - Lazy
- (void)setProductId:(NSString *)productId {
    _productId = productId;
    
    self.homeView.productId = productId;
}
- (JHStoreSnapShootDetailView *)homeView {
    if (!_homeView) {
        _homeView = [[JHStoreSnapShootDetailView alloc] init];
        _homeView.productId = self.productId;
        
    }
    return _homeView;
}
- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _titleCategoryView.backgroundColor = [UIColor clearColor];
        _titleCategoryView.hidden = true;
        _titleCategoryView.titles = @[@"商品",@"详情"];
        _titleCategoryView.titleColor = kColor666;
        _titleCategoryView.delegate = self;
        _titleCategoryView.titleDataSource = self;
        _titleCategoryView.defaultSelectedIndex = 0;
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontMedium size:14];
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldPingFang size:14];
        _titleCategoryView.titleSelectedColor = kColor222;
        _titleCategoryView.cellSpacing = 20;
        _titleCategoryView.selectedAnimationEnabled = true;
        _titleCategoryView.indicators = @[self.indicatorImgView];
        _titleCategoryView.separatorLineColor = [UIColor colorWithHexString:@"FFD70F"];
        _titleCategoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
    }
    return _titleCategoryView;
}
- (JXCategoryIndicatorImageView *)indicatorImgView {
    if (!_indicatorImgView) {
        _indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
        _indicatorImgView.indicatorImageView.backgroundColor = HEXCOLOR(0xFFD70F);
        _indicatorImgView.indicatorImageView.layer.cornerRadius = 2.0f;
        _indicatorImgView.indicatorImageView.layer.masksToBounds = YES;
        _indicatorImgView.indicatorImageViewSize = CGSizeMake(28.0, 4.0);
        _indicatorImgView.verticalMargin = 2.0;
    }
    return _indicatorImgView;
}
- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.looping = true;
        _playerController.alwaysPlay = YES;
        _playerController.fullScreenView = self.verticalPlayerControlView;
        [self addChildViewController:_playerController];
        @weakify(self);
        _playerController.playbackStateDidChangedBlock = ^(TTVideoEnginePlaybackState playbackState) {
            @strongify(self);
            if (self.isScrollPause) { return; }
            self.isPlaying = (playbackState == TTVideoEnginePlaybackStatePlaying);
        };
    }
    return _playerController;
}
- (JHNormalControlView *)normalPlayerControlView {
    if (_normalPlayerControlView == nil) {
        _normalPlayerControlView = [[JHNormalControlView alloc] initWithFrame:self.playerController.view.bounds];
    }
    return _normalPlayerControlView;
}

- (JHPlayerVerticalBigView *)verticalPlayerControlView {
    if (_verticalPlayerControlView == nil) {
        _verticalPlayerControlView = [[JHPlayerVerticalBigView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        @weakify(self);
//        _verticalPlayerControlView.actionBlock = ^(JHFullScreenControlActionType actionType) {
//            @strongify(self);
//            [self handleFullScreenControlAction:actionType];
//        };
    }
    return _verticalPlayerControlView;
}
- (UIImageView *)maskView {
    if (!_maskView) {
        _maskView = [[UIImageView alloc]init];
        _maskView.image = [UIImage imageNamed:@"newStore_header_mask_bg"];
    }
    return _maskView;
}
@end
