//
//  JHStoreDetailViewController.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailViewController.h"
#import "JHStoreDetailView.h"
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
#import "JHWebViewController.h"
#import "MBProgressHUD.h"
#import "JHC2CProductDetailPaiMaiListController.h"
#import "JHStoreDetailBusiness.h"
#import "JHB2CShowProductIntruductView.h"
#import "JHC2CSetPriceAlertView.h"
#import "JHC2CPaySureMoneyView.h"
#import "JHOrderPayViewController.h"
#import "JHIMEntranceManager.h"
#import "JHAuctionOrderDetailViewController.h"
#import "JHMarketOrderViewModel.h"
#import "JHOrderViewModel.h"
#import "JHRushPurChaseViewController.h"


@interface JHStoreDetailViewController ()<JXCategoryViewDelegate, JXCategoryTitleViewDataSource>

@property (nonatomic, strong) JHStoreDetailView *homeView;
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryIndicatorImageView *indicatorImgView;
@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, strong) JHNormalControlView *normalPlayerControlView;
@property (nonatomic, strong) JHPlayerVerticalBigView *verticalPlayerControlView;
@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isScrollPause;
@property(nonatomic, assign) BOOL  jumpPaySureMoneyVC;

@property(nonatomic, strong) NSArray<NSString*> * navItemArr;

@end

@implementation JHStoreDetailViewController

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
    }
    if (self.jumpPaySureMoneyVC) {
        self.jumpPaySureMoneyVC = NO;
        [self.homeView.viewModel checkSureMoney];
    }
    [self.homeView viewDidAppear];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.jhNavView];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
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
    
    [self.homeView.viewModel.refreshNav subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        BOOL hasComment = [x[0] boolValue];
        BOOL hasReComment  = [x[1] boolValue];
        [self refreshNavWithComment:hasComment andRecomment:hasReComment];
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
        if (index != self.titleCategoryView.selectedIndex) {
            [self.titleCategoryView selectItemAtIndex:index];
        }
    }];
    [RACObserve(self.homeView.viewModel, productSellStatusDesc) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.sellStatusDesc = x;
    }];
    [self.homeView.viewModel.refreshUpper subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.refreshUpper sendNext:x];
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
        @strongify(self)
        if (x == nil) { return; }
        if (x[0] == nil) { return;}
        if (x[1] == nil) { return;}
        [self setPlayerUrl];
        [self setPlayerViews];
    }];
    
}


- (void)refreshNavWithComment:(BOOL)hasComment andRecomment:(BOOL)hasRecomment{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"商品",@"详情"]];
    if (hasComment) {
        [arr addObject:@"评价"];
    }
    if (hasRecomment) {
        [arr addObject:@"推荐"];
    }
    if (self.navItemArr.count == arr.count) {
        return;
    }
    self.navItemArr = arr.copy;
    [self.titleCategoryView removeFromSuperview];
    self.titleCategoryView = nil;
    [self.jhNavView addSubview:self.titleCategoryView];
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jhLeftButton.mas_centerY).offset(-5);
        make.centerX.equalTo(self.jhNavView);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
}



#pragma mark - Private Functions
// 设置滚动暂停播放
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
    [self initRightButtonWithImageName:@"newStore_detail_share_white_icon" action:@selector((didClickShare:))];
    [self.jhLeftButton setImage:[UIImage imageNamed:@"newStore_icon_back_black"] forState:UIControlStateSelected];
    [self.jhRightButton setImage:[UIImage imageNamed:@"newStore_share_black_icon"] forState:UIControlStateSelected];

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
/// 分享
- (void)didClickShare : (UIButton *)sender {
    JHShareInfo *shareInfo = self.homeView.viewModel.shareInfo;
    if (shareInfo == nil) { return; }
    [JHBaseOperationView showShareView:shareInfo objectFlag:nil];
    [self.homeView.viewModel reportShareEvent];
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
        @weakify(self)
        [vc.refreshUpper subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.refreshUpper sendNext:nil];
        }];
    }
    // 专场
    else if ([type isEqualToString:@"SpecialShow"]) {
        JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
        vc.showId = par[@"showId"];
        vc.fromPage = @"商品详情页";
        [self pushWithVC:vc];
    }
    // 订单
    else if ([type isEqualToString:@"Order"]) {
        //拍卖商品订单
        if ([self.homeView.viewModel.dataModel.productType isEqualToString:@"1"]) {
            //下面是支付页面
            [self getOrderDetail];
        }else{
            JHOrderConfirmViewController * order = [[JHOrderConfirmViewController alloc] init];
            order.goodsId = par[@"productId"];
            order.orderCategory = @"mallOrder";;
            order.orderType = JHOrderTypeNewStore;
            order.activeConfirmOrder = true;
            order.showId = par[@"showId"];
            order.fromString = JHConfirmFromGoodsDetail;
            [self pushWithVC:order];
        }
    }
    // 支付
    else if ([type isEqualToString:@"Payment"]) {
        
    }
    // 店铺
    else if ([type isEqualToString:@"Shop"]) {
        JHNewShopDetailViewController *vc = [[JHNewShopDetailViewController alloc]init];
        vc.shopId = par[@"shopId"];
        @weakify(self)
        [[RACObserve(vc, isFollow) skip:1] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            BOOL type = [x boolValue];
            self.homeView.viewModel.focusStatus = type;
        }];
        [self pushWithVC:vc];
    }
    // 客服
    else if ([type isEqualToString:@"Serice"]) {
        JHChatGoodsInfoModel *goodsInfo = (JHChatGoodsInfoModel *)par[@"JHChatGoodsInfoModel"];
        
        [JHIMEntranceManager pushSessionWithUserId:self.homeView.viewModel.businessId
                                       sourceType : JHIMSourceTypeGoodsDetail
                                         goodsInfo:goodsInfo];
//        [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
    }
    // 用户教育
    else if ([type isEqualToString:@"Education"]) {
        [self pushWebVCWithUrl:par[@"url"]];
    }
    // 收藏
    else if ([type isEqualToString:@"Collect"]) {
        JHSQCollectViewController *vc = [[JHSQCollectViewController alloc]init];
        [self pushWithVC:vc];
    }
    // 新人福利
    else if ([type isEqualToString:@"NewUserActivities"]) {
        [self pushWebVCWithUrl:par[@"url"]];
    }
    
    // 拍卖列表
    else if ([type isEqualToString:@"Auction"]) {
        
        JHC2CProductDetailPaiMaiListController *vc = [[JHC2CProductDetailPaiMaiListController alloc] init];
        vc.formB2C = YES;
        vc.ansID = par[@"ansId"];
        [self.navigationController presentViewController:vc animated:NO completion:nil];
    }
    
    // 评论列表
    else if ([type isEqualToString:@"comment"]) {
        JHNewShopDetailViewController *vc = [[JHNewShopDetailViewController alloc]init];
        vc.defaultSelectedIndex = 1;
        vc.shopId = par[@"shopId"];
        @weakify(self)
        [[RACObserve(vc, isFollow) skip:1] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            BOOL type = [x boolValue];
            self.homeView.viewModel.focusStatus = type;
        }];
        [self pushWithVC:vc];
    }
    // 说明
    else if ([type isEqualToString:@"Introduct"]) {
        NSString *prID = par[@"proID"];
        NSString *attTitle = par[@"attTitle"];
        JHB2CShowProductIntruductView *view = [JHB2CShowProductIntruductView new];
        view.productID = prID;
        view.attTitle = attTitle;
        [self.view addSubview:view];
    }

    // 支付保证金弹框
    else if ([type isEqualToString:@"paySurePrice"]) {
        JHC2CPaySureMoneyView *alertView = [JHC2CPaySureMoneyView new];
        alertView.productID = self.productId;
        alertView.modelB2C = self.homeView.viewModel.dataModel.auctionFlow;
        @weakify(self);
        [alertView setPayBlock:^ {
            @strongify(self);
            [self showPayViewOrderID:par[@"OrderID"]];
        }];
        [self.view addSubview:alertView];
    }
    
    // 设置代理 和 出价弹框
    else if ([type isEqualToString:@"setAgentAndPrice"]) {
        BOOL isAgent = [par[@"isAgent"] isEqualToString:@"1"];
        JHC2CSetPriceAlertView *alertView = [JHC2CSetPriceAlertView new];
        alertView.fromB2C = YES;
        alertView.isAgent = isAgent ? 1 : 0;
        alertView.productID = self.productId;
        JHC2CSetPriceAlertViewType type = JHC2CSetPriceAlertView_First;
        if (isAgent) {
            if (self.homeView.viewModel.auctionModel.isAgent) {
                type = JHC2CSetPriceAlertView_SetDelegate;
            }
        }else{
            type = JHC2CSetPriceAlertView_ChuJia;
        }
        [alertView refresWithType:type];
        alertView.productSnB2C = self.homeView.viewModel.dataModel.productSn;
        alertView.auModelB2C = self.homeView.viewModel.auctionModel;
        [self.view addSubview:alertView];
    }

    // 其他商品详情
    else if ([type isEqualToString:@"JHStoreDetailViewController"]) {
        NSString *prID = par[@"productId"];
        JHStoreDetailViewController *vc = [JHStoreDetailViewController new];
        vc.productId = prID;
        [self pushWithVC:vc];
    }

    
    // 秒杀跳转
    else if ([type isEqualToString:@"JHRushPurChaseViewController"]) {
        NSString *prID = par[@"productId"];
        JHRushPurChaseViewController *vc = [JHRushPurChaseViewController new];
//        vc.productId = prID;
        [self pushWithVC:vc];
    }
    
    // 登录
    else if ([type isEqualToString:@"Login"]) {
        @weakify(self)
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            @strongify(self);
            [self.homeView.viewModel getDetailInfo];
        }];
    }
}

///支付保证金
- (void)showPayViewOrderID:(NSString*)orderID{
    JHOrderPayViewController * order = [[JHOrderPayViewController alloc]init];
    order.orderCategory = @"marketAuctionOrder";
    order.goodsId = self.productId;
    order.orderId = orderID;
    order.isAuction = YES;
    [self.navigationController pushViewController:order animated:YES];
    self.jumpPaySureMoneyVC = YES;
}


#pragma mark -- 获取订单详情
- (void)getOrderDetail {
    [SVProgressHUD show];
    NSString *orderId = self.homeView.viewModel.dataModel.auctionFlow.orderId;
    if (self.homeView.viewModel.auctionModel.orderId.length) {
        orderId = self.homeView.viewModel.auctionModel.orderId;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = orderId;
    
    [JHOrderViewModel requestOrderDetail:orderId isSeller:NO completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        NSString *orderStatus = respondObject.data[@"orderStatus"];
        if (!error && orderStatus) {
            if ([orderStatus isEqualToString:@"waitpay"]) {
                [self pushOrderPay:orderId];
            }else if ([orderStatus isEqualToString:@"waitack"]){
                [self pushOrderConfirm:orderId];
            }
        } else {
            JHTOAST(error.localizedDescription);
        }

    }];
}
- (void)pushOrderConfirm:(NSString*)orderId{
    JHAuctionOrderDetailViewController * order=[[JHAuctionOrderDetailViewController alloc]init];
    order.orderId = orderId;
    order.orderCategory = @"marketAuctionOrder";
    [self.navigationController pushViewController:order animated:YES];
}
- (void)pushOrderPay:(NSString*)orderId{
    //下面是支付页面
    JHOrderPayViewController *order =[[JHOrderPayViewController alloc]init];
    order.orderId = orderId;
    order.goodsId = self.productId;
    order.isMarket = YES;
    [self.navigationController pushViewController:order animated:YES];
}


- (void)pushWithVC : (UIViewController *)vc  {
    [self.navigationController pushViewController:vc animated:true];
}
- (void)pushWebVCWithUrl : (NSString *)url{
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = url;
    [self pushWithVC:webView];
}
- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.view animated:true];
}
#pragma mark - CategoryView
- (CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    return 60;
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    NSString* title = @"";
    if (self.navItemArr.count > index) {
        title = self.navItemArr[index];
    }
    [self.homeView scrollToIndex:index andTitle:title];
}
#pragma mark - Lazy
- (void)setProductId:(NSString *)productId {
    _productId = productId;
    self.homeView.productId = productId;
//    _productId = @"10243376";
//    self.homeView.productId = @"10243376";
}
- (void)setFromPage:(NSString *)fromPage {
    _fromPage = fromPage;
    self.homeView.viewModel.fromPage = fromPage;
}
- (JHStoreDetailView *)homeView {
    if (!_homeView) {
        _homeView = [[JHStoreDetailView alloc] initWithFrame:CGRectZero];
//        _homeView.productId = @"23";
    }
    return _homeView;
}
- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _titleCategoryView.backgroundColor = [UIColor clearColor];
        _titleCategoryView.hidden = true;
        _titleCategoryView.titles = self.navItemArr;
        _titleCategoryView.titleColor = kColor666;
        _titleCategoryView.delegate = self;
        _titleCategoryView.titleDataSource = self;
        _titleCategoryView.defaultSelectedIndex = 0;
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontMedium size:16];
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldPingFang size:16];
        _titleCategoryView.titleSelectedColor = kColor222;
        _titleCategoryView.cellSpacing = 5;
        _titleCategoryView.cellWidth = 40;
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
        _playerController.alwaysPlay = true;
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
- (RACSubject *)refreshUpper {
    if (!_refreshUpper) {
        _refreshUpper = [RACSubject subject];
    }
    return _refreshUpper;
}

- (NSArray<NSString*> *)navItemArr{
    if (!_navItemArr) {
        _navItemArr = @[@"商品",@"详情"];
    }
    return _navItemArr;
}

- (void)setShotScreen:(BOOL)shotScreen{
    _shotScreen = shotScreen;
    self.jhRightButton.hidden = shotScreen;
    self.homeView.shotScreen = shotScreen;
}
@end
