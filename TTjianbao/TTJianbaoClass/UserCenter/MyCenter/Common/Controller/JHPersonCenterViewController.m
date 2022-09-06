//
//  JHPersonCenterViewController.m
//  TTjianbao
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPersonCenterViewController.h"
#import "JHSQManager.h"
#import "JHMyCenterApiManager.h"
///3.1.6新增
#import "JHCommonUserView.h"
#import "JHMyCenterMerchantView.h"
#import "JHMyCenterAssisstantView.h"
#import "JHSelectContractViewController.h"  ///选择签约
#import "JHMyCenterAppraiserView.h"
#import "JHMyCenterViewModel.h"
#import "JHSetViewController.h"
#import "JHPublishSelectTopicController.h"
#import "JHMyCenterDotModel.h"
#import "JHUnionSignShowHomeController.h"
#import "UIButton+JHMyCenterCancleHighLightButton.h"
#import "JHMyCenterMerchantCellModel.h"
#import "JHMainLiveRoomTabView.h"
#import "JHUnionSignView.h"
#import "JHAnchorActionView.h"
#import "TTjianbaoMarcoKeyword.h"
#import "JHAppAlertViewManger.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHMyCenterImageAppraiserView.h"
#import "UIView+JHGestureAnimation.h"
#define kChangeNavAlphaHeight   88


@interface JHPersonCenterViewController ()

@property (nonatomic, assign) BOOL statusBarLight;

@property (nonatomic, assign) BOOL isHiddenNavgationBar;

///滑动Y距离
@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, strong) UIView *line;

///标记是否已经push到认证签约页面
@property (nonatomic, assign) BOOL hasPushedSignPage;

@property (nonatomic, strong) JHRefreshNormalFooter *footer;

@property (nonatomic, weak) UIButton *avatorButton;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UIButton *switchButton;
@property (nonatomic, weak) UIButton *switchBuyerButton;

@property (nonatomic, weak) UIButton *settingButton;

@property (nonatomic, weak) UIButton *scanButton;

@property (nonatomic, weak) UIButton *messageButton;

///买家
@property (nonatomic, strong) JHCommonUserView *commonUserView;

///鉴定师
@property (nonatomic, strong) JHMyCenterAppraiserView *appraiserView;
///图文鉴定师
@property (nonatomic, strong) JHMyCenterImageAppraiserView *imageAppraiserView;

///商家 + 主播
@property (nonatomic, strong) JHMyCenterMerchantView *merchantView;

///助理
@property (nonatomic, strong) JHMyCenterAssisstantView *assistantView;

@property (nonatomic, strong) JHMyCenterViewModel *viewModel;

/// 显示买家UI
@property (nonatomic, assign) BOOL showBuyerUI;

///推荐的状态，用于刷新标识
@property (nonatomic, assign) BOOL isOpenRecommend;

///开店入口
@property (nonatomic, strong) UIButton *openShopButton;
@property (nonatomic, assign) NSInteger bussId;

///当前view是否显示在窗口
@property (nonatomic, assign) BOOL isViewVisable;

@end

@implementation JHPersonCenterViewController

- (instancetype)init{
    if (self = [super init]) {
        _statusBarLight = YES;
        _isHiddenNavgationBar = YES;
        _offsetY = 0;
        _isOpenRecommend = IS_OPEN_RECOMMEND;
    }
    return self;
}
- (void)addObserver {
    [JHNotificationCenter addObserver:self selector:@selector(updateOrderCoundInfo:) name:@"jh_changeMyCenterTabNotification" object:nil];

    @weakify(self)
    //进入前台
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        //如果进入前台时当前页面在窗口
        if (self.isViewVisable) {
            //曝光埋点
            [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
                @"page_name":@"个人中心首页"
            } type:JHStatisticsTypeSensors];
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhLeftButton.hidden = YES;
    [self creatNavgationBar];
    [self bindMethod];
    _bussId = 2;
    
    [self addObserver];
}

- (void)updateOrderCoundInfo:(NSNotification *)noti {
    NSDictionary *info = (NSDictionary *)noti.object;
    _bussId = [info[@"bussId"] integerValue];
    [JHMyCenterDotModel requestDataWithType:@1 contentType:_bussId block:^{
        [self.merchantView updateOrderInfo:_bussId - 1];
    }];
    
    NSString *businessType = [NSString stringWithFormat:@"%ld",_bussId];
    [JHMyCenterDotModel shopDataRequest:[UserInfoRequestManager sharedInstance].user.customerId businessType:businessType statisticsDays:@"1" statisticsType:@"1" block:^{
        [self.merchantView updateOrderInfo:_bussId - 1];
    }];
}

- (void)dealloc {
    [JHNotificationCenter removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //当前页面离开
    self.isViewVisable = NO;
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //当前页面进入
    self.isViewVisable = YES;

    [self switchMethod];
    User *user = [UserInfoRequestManager sharedInstance].user;
    BOOL buyer = self.showBuyerUI;
    if(user.blRole_default){
        buyer = YES;
    }
    if (buyer) {
        [JHMyCenterDotModel requestDataWithType:@0 block:^{
            [self afterGetUserInfoSuccess];
        }];
    }
    else if (user.blRole_recycleAssistant ||
             user.blRole_restoreAssistant ||
             user.blRole_customizeAssistant ||
             user.blRole_saleAnchorAssistant) {
        [JHMyCenterDotModel requestDataWithType:@1 block:^{
            [self afterGetUserInfoSuccess];
        }];
    }
    else {
        ///商家主播专用的请求 因为
        [JHMyCenterDotModel requestDataWithType:@1 contentType:_bussId block:^{
            [self afterGetUserInfoSuccess];
        }];
        [JHMyCenterDotModel shopDataRequest:[UserInfoRequestManager sharedInstance].user.customerId businessType:@"2" statisticsDays:@"1" statisticsType:@"1" block:^{
            [self afterGetUserInfoSuccess];
        }];
    }
    
    [JHMyCenterDotModel requestCustomizeDataWithType:buyer ? @0 : @1 block:^{
        [self afterGetUserInfoSuccess];
    }];
    ///查询签约状态
    [JHUnionSignView getUnionSignStatusWithCustomerId:nil statusBlock:^(JHUnionSignStatus status) {
        if(_commonUserView){
            [_commonUserView refreshPersonCenterData];
        }
        
        if(_appraiserView){
            [_appraiserView reload];
        }
        
        if(_merchantView){
            [_merchantView reload];
        }
        if (_assistantView) {
            [_assistantView reload];
        }
    }];

    BOOL tmp = IS_OPEN_RECOMMEND;
    if(_isOpenRecommend != tmp)
    {
        _isOpenRecommend = tmp;
        if(_commonUserView)
        {
            [_commonUserView refreshPersonCenterData];
        }
    }
    [JHAppAlertViewManger showSuperRedPacketEnterWithSuperView:self.view];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithTop:ScreenH - 250];
}

- (void)viewDidAppear:(BOOL)animated {
    [JHHomeTabController changeStatusWithMainScrollView:nil index:-1];
    //曝光埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"个人中心首页"
    } type:JHStatisticsTypeSensors];
}

#pragma mark --------------- method ---------------
- (void)bindMethod{
    RAC(self.line,hidden) = RACObserve(self, isHiddenNavgationBar);
    RAC(self.avatorButton,hidden) = RACObserve(self, isHiddenNavgationBar);
    RAC(self.nameLabel,hidden) = RACObserve(self, isHiddenNavgationBar);
    RAC(self.messageButton,selected) = RACObserve(self, statusBarLight);
    RAC(self.settingButton,selected) = RACObserve(self, statusBarLight);
    RAC(self.switchButton,selected) = RACObserve(self, statusBarLight);
    
    [RACObserve(self, isHiddenNavgationBar) subscribeNext:^(id  _Nullable x) {
        [self changeSwitchTitleHiddenNavgationBar:[x boolValue]];
    }];
    @weakify(self);
    [JHMyCenterDotModel shareInstance].block = ^{
        @strongify(self);
        [self afterGetUserInfoSuccess];
    };
    
}

-(void)changeSwitchTitleHiddenNavgationBar:(BOOL)hiddenNavgationBar{
    User *user = [UserInfoRequestManager sharedInstance].user;
    BOOL isCommonUser = ((user.blRole_maJia) || (user.blRole_default));
    if (!JHRootController.isLogin || isCommonUser) {
        ///未登录或者普通账号 不显示切换按钮
        self.switchButton.hidden = YES;
        self.switchBuyerButton.hidden = YES;
    }
    else {
        self.switchButton.hidden = !self.switchBuyerButton.hidden;
        if (hiddenNavgationBar) {
            ///显示切换买家
            [self.switchButton setTitle:@"切换买家" forState:UIControlStateSelected];
        }
        else {
            NSString *sellerStr = (user.blRole_appraiseAnchor || user.blRole_imageAppraise) ? @"切换鉴定师" : @"切换商家";
            [self.switchButton setTitle:sellerStr forState:UIControlStateSelected];
        }
    }
}

- (void)creatNavgationBar {
    
//    [self initToolsBar];
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, self.jhNavView.height, ScreenW, 1)];
    self.line.backgroundColor = HEXCOLOR(0xe7e7e7);
    self.line.hidden = YES;
    [self.jhNavView addSubview:self.line];
    
    _messageButton = [self createAddMsgBtn];
    [self.jhNavView addSubview:_messageButton];
    [_messageButton setImage:JHImageNamed(@"navi_icon_message") forState:UIControlStateSelected];
    
    _avatorButton = [UIButton jh_buttonWithTarget:self action:@selector(userInfoAction) addToSuperView:self.jhNavView];
    [_avatorButton jh_cornerRadius:16];
    [_avatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jhNavView).offset(15.f);
        make.bottom.equalTo(self.jhNavView).offset(-5.f);
        make.width.height.mas_equalTo(32);
    }];
    
    _nameLabel = [UILabel jh_labelWithFont:15 textColor:UIColor.blackColor addToSuperView:self.jhNavView];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatorButton);
        make.left.equalTo(self.avatorButton.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(75, 21));
    }];
    CGSize buttonSize = CGSizeMake(44, 44);
    _scanButton = [UIButton jh_buttonWithImage:JHImageNamed(@"my_center_scan") target:self.viewModel action:@selector(scanAction) addToSuperView:self.jhNavView];
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageButton.mas_left);
        make.size.mas_equalTo(buttonSize);
        make.bottom.equalTo(self.jhNavView);
    }];
    
    _settingButton = [UIButton jh_buttonWithImage:@"my_center_setting_black" target:self action:@selector(settingAction) addToSuperView:self.jhNavView];
    [_settingButton setImage:JHImageNamed(@"my_center_setting_black") forState:UIControlStateSelected];
    [_settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scanButton);
        make.size.mas_equalTo(buttonSize);
        make.right.equalTo(self.scanButton.mas_left);
    }];
    
    _switchButton = [UIButton jh_buttonWithImage:@"icon_mycenter_switch_merchant" target:self action:@selector(switchAction) addToSuperView:self.jhNavView];
    [_switchButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_switchButton setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
    [_switchButton setTitle:@"" forState:UIControlStateNormal];
    _switchButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.settingButton.mas_left);
        make.bottom.equalTo(self.scanButton);
        make.height.mas_equalTo(buttonSize.height);
        make.width.mas_greaterThanOrEqualTo(buttonSize.width);
    }];
    
    _switchBuyerButton = [UIButton jh_buttonWithImage:@"icon_merchant_switch" target:self action:@selector(switchAction) addToSuperView:self.jhNavView];
//    [_switchBuyerButton setImage:JHImageNamed(@"icon_merchant_switch") forState:UIControlStateSelected];
    [_switchBuyerButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_switchBuyerButton setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
    [_switchBuyerButton setTitle:@"切换买家" forState:UIControlStateNormal];
    _switchBuyerButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _switchBuyerButton.layer.cornerRadius = 23/2.f;
    _switchBuyerButton.layer.masksToBounds = YES;
    _switchBuyerButton.layer.borderColor = kColor333.CGColor;
    _switchBuyerButton.layer.borderWidth = .5f;
    [_switchBuyerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.settingButton.mas_left);
        make.centerY.equalTo(self.scanButton);
        make.size.mas_equalTo(CGSizeMake(72, 23.));
    }];
    [_switchBuyerButton layoutIfNeeded];
    [_switchBuyerButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:4];
    
    [self updateNavgationBar:self.offsetY];
}

/// 设置导航栏的style
- (void)updateNavgationBar:(CGFloat)offsetY {
    
    self.offsetY = offsetY;
    
    self.isHiddenNavgationBar = (self.offsetY < kChangeNavAlphaHeight);
    if(_commonUserView){
        self.statusBarLight = NO;
        User *user = [UserInfoRequestManager sharedInstance].user;
        NSString *sellerStr = (user.blRole_appraiseAnchor || user.blRole_imageAppraise) ? @"切换鉴定师" : @"切换商家";
        [_switchButton setTitle:self.isHiddenNavgationBar ? sellerStr : @"" forState:UIControlStateNormal];
    }
    else{
        self.statusBarLight = (self.offsetY < kChangeNavAlphaHeight);
    }
    self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:MIN(self.offsetY / kChangeNavAlphaHeight, 1.0)];
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark --------------- action ---------------
- (void)userInfoAction{
    [JHRouterManager pushMyUserInfoController];
}

- (void)settingAction{
    JHSetViewController *vc = [[JHSetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)switchAction{
    [self changeShowBuyerUI:!self.showBuyerUI];
    [self switchMethod];
    
    [self hiddenLiveButton];
    
    [self updateNavgationBar:0];
}
- (void)switchMethod{
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    BOOL isCommonUser = ((user.blRole_maJia) || (user.blRole_default));

    [self.openShopButton removeFromSuperview];
    CGFloat scanWidth = 0;
    if((self.showBuyerUI) || (![JHRootController isLogin]) || user.blRole_maJia || user.blRole_default)
    {
        [[NSUserDefaults standardUserDefaults] setValue: @"notBusiness" forKey:@"UserIsBusiness"];
        scanWidth = 44;
        if(_appraiserView){
            [_appraiserView removeFromSuperview];
            _appraiserView = nil;
        }
        if (_imageAppraiserView) {
            [_imageAppraiserView removeFromSuperview];
            _imageAppraiserView = nil;
        }
        if(_merchantView){
            [_merchantView removeAllSubviews];
            _merchantView = nil;
        }
        
        if(_assistantView){
            [_assistantView removeAllSubviews];
            _assistantView = nil;
        }
        
        [self commonUserView];
        self.statusBarLight = NO;
        //我要开店入口
        if ([JHRootController isLogin] && user.blRole_default) {
            [_commonUserView addSubview:self.openShopButton];
            [self.openShopButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(10);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(55);
                make.bottom.mas_equalTo(-(90));
            }];
        }
    }
    else{
        [[NSUserDefaults standardUserDefaults] setValue: @"business" forKey:@"UserIsBusiness"];
        if(_commonUserView)
        {
            [_commonUserView removeFromSuperview];
            _commonUserView = nil;
        }
        scanWidth = 0;
        if(user.blRole_appraiseAnchor)
        {
            [self appraiserView];
            self.statusBarLight = YES;
        }else if(user.blRole_imageAppraise){
            //图文鉴定师
            [self imageAppraiserView];
            self.statusBarLight = YES;
            [[NSUserDefaults standardUserDefaults] setValue: @"notBusiness" forKey:@"UserIsBusiness"];
        }
        else if(user.type != isCommonUser)
        {
            self.statusBarLight = NO;
            if (user.blRole_saleAnchorAssistant ||
                user.blRole_restoreAssistant ||
                user.blRole_customizeAssistant ||
                user.blRole_recycleAssistant) {
                [self assistantView];
            }
            else {
                [self merchantView];
            }
        }else if(user.blRole_imageAppraise){
            //图文鉴定师
            [self imageAppraiserView];
            self.statusBarLight = YES;
            [[NSUserDefaults standardUserDefaults] setValue: @"notBusiness" forKey:@"UserIsBusiness"];
        }
    }
    
    [self.scanButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(scanWidth);
    }];
    [self.view bringSubviewToFront:self.jhNavView];
    [self updateNavgationBar:self.offsetY];
    [self requestData];
}
///我要开店
- (void)clickOpenShopButtonAction {
    [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/app/recycle/applyOpenShop.html") title:@"" controller:JHRootController];
}

#pragma mark --------------- method ---------------
-(void)requestData{
    
    if (![JHRootController isLogin]){
        [_commonUserView refreshPersonCenterData];
    }
    else{
        
        @weakify(self);
        [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel *respondObject) {
            @strongify(self);
            [self afterGetUserInfoSuccess];
        }];
    }
    if(_commonUserView){
        @weakify(self);
        [JHMyCenterApiManager isAllowCustomerCheck:^(JHAllowSignModel *respObj, BOOL hasError) {
            if (!hasError) {
                @strongify(self);
                [self.commonUserView reloadData];
            }
        }];
    }
}

-(void)afterGetUserInfoSuccess{

    if(_commonUserView){
        [_commonUserView refreshPersonCenterData];
    }
    
    if(_appraiserView){
        [_appraiserView reload];
    }
    
    if(_merchantView){
        [_merchantView reload];
    }
    if(_assistantView){
        [_assistantView reload];
    }
    if (_imageAppraiserView) {
        [_imageAppraiserView reload];
    }
    User *user = [UserInfoRequestManager sharedInstance].user;
    [self.avatorButton jh_setAvatorWithUrl:user.icon];
    self.nameLabel.text = user.name;
}
#pragma mark --------------- 我要开店 ---------------
// 缩小开店按钮
- (void)openShopNarrow {
    if (self.openShopButton.superview == nil) return;
    [UIView animateWithDuration:0.3 animations:^{
        [self.openShopButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(70);
        }];
        [self.commonUserView layoutIfNeeded];
    }];
}
// 放大开店按钮
- (void)openShopEnlarge {
    if (self.openShopButton.superview == nil) return;
    [UIView animateWithDuration:0.3 animations:^{
        [self.openShopButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(10);
        }];
        [self.commonUserView layoutIfNeeded];
    }];
}
#pragma mark --------------- 设置状态栏 ---------------
- (UIStatusBarStyle)preferredStatusBarStyle {
    return (_statusBarLight ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
}

#pragma mark --------------- get ---------------
/// 鉴定师
-(JHMyCenterAppraiserView *)appraiserView {
    if(!_appraiserView){
        JHMyCenterAppraiserView *appraiserView = [[JHMyCenterAppraiserView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:appraiserView];
        _appraiserView = appraiserView;
        [_switchButton setTitle:@"" forState:UIControlStateNormal];
        self.offsetY = 0;
        self.isHiddenNavgationBar = YES;
        _switchButton.hidden = NO;
        _switchBuyerButton.hidden = YES;
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _appraiserView;
}

/// 图文鉴定师
-(JHMyCenterImageAppraiserView *)imageAppraiserView {
    if(!_imageAppraiserView){
        JHMyCenterImageAppraiserView *imageAppraiserView = [[JHMyCenterImageAppraiserView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:imageAppraiserView];
        _imageAppraiserView = imageAppraiserView;
        [_switchButton setTitle:@"11111" forState:UIControlStateNormal];
        self.offsetY = 0;
        self.isHiddenNavgationBar = YES;
        _switchButton.hidden = YES;
        _switchBuyerButton.hidden = NO;
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _imageAppraiserView;
}
/// 买家
- (JHCommonUserView *)commonUserView {
    if(!_commonUserView){
        self.statusBarLight = NO;
        JHCommonUserView *userView = [[JHCommonUserView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:userView];
        _commonUserView = userView;
        _commonUserView.backgroundColor = UIColor.blackColor;
        @weakify(self);
        _commonUserView.scrollBlock = ^(CGFloat offSet) {
            @strongify(self);
            [self updateNavgationBar:offSet];
            [self openShopNarrow];
        };
        _commonUserView.scrollEndBlock = ^(CGFloat offSet) {
            @strongify(self);
            [self openShopEnlarge];
        };
        User *user = [UserInfoRequestManager sharedInstance].user;
        NSString *sellerStr = (user.blRole_appraiseAnchor || user.blRole_imageAppraise) ? @"切换鉴定师" : @"切换商家";
        [_switchButton setTitle:sellerStr forState:UIControlStateNormal];
        _switchButton.hidden = NO;
        _switchBuyerButton.hidden = YES;
        self.offsetY = 0;
        self.isHiddenNavgationBar = YES;
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];

        if (JHRootController.isLogin) {
            ///登录后才需要请求气泡的数据
            [JHMyCenterDotModel requestDataWithType:@0 block:^{
                [self afterGetUserInfoSuccess];
            }];
            [JHMyCenterDotModel requestCustomizeDataWithType:@0 block:^{
                [self afterGetUserInfoSuccess];
            }];
        }
    }
    return _commonUserView;
}

/// 商家
-(JHMyCenterMerchantView *)merchantView {
    if(!_merchantView){
        _merchantView = [[JHMyCenterMerchantView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_merchantView];
        @weakify(self);
        _merchantView.scrollBlock = ^(CGFloat offSet) {
            @strongify(self);
            [self updateNavgationBar:offSet];
        };
        _switchButton.hidden = YES;
        _switchBuyerButton.hidden = NO;
        self.offsetY = 0;
        self.isHiddenNavgationBar = YES;
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
//        [_switchButton setTitle:@"" forState:UIControlStateNormal];
        if (JHRootController.isLogin) {
            [JHMyCenterDotModel requestDataWithType:@1 contentType:_bussId block:^{
                [self afterGetUserInfoSuccess];
            }];
            [JHMyCenterDotModel requestCustomizeDataWithType:@1 block:^{
                [self afterGetUserInfoSuccess];
            }];
            [JHMyCenterDotModel shopDataRequest:[UserInfoRequestManager sharedInstance].user.customerId businessType:@"2" statisticsDays:@"1" statisticsType:@"1" block:^{
                [self afterGetUserInfoSuccess];
            }];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JHMyCenterMerchantCellButtonModel pushSocialAuthViewController];
        });
    }
    return _merchantView;
}
- (JHMyCenterAssisstantView *)assistantView {
    if(!_assistantView){
        _assistantView = [[JHMyCenterAssisstantView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_assistantView];
        @weakify(self);
        _assistantView.scrollBlock = ^(CGFloat offSet) {
            @strongify(self);
            [self updateNavgationBar:offSet];
        };
        [_switchButton setTitle:@"" forState:UIControlStateNormal];
        _switchButton.hidden = NO;
        _switchBuyerButton.hidden = YES;
        self.offsetY = 0;
        self.isHiddenNavgationBar = YES;
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        if (JHRootController.isLogin) {
            [JHMyCenterDotModel requestDataWithType:@1 block:^{
                [self afterGetUserInfoSuccess];
            }];
            [JHMyCenterDotModel requestCustomizeDataWithType:@1 block:^{
                [self afterGetUserInfoSuccess];
            }];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JHMyCenterMerchantCellButtonModel pushSocialAuthViewController];
        });
        
    }
    return _assistantView;
}



- (JHMyCenterViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [JHMyCenterViewModel new];
    }
    return _viewModel;
}

- (UIButton *)openShopButton{
    if (!_openShopButton) {
        _openShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openShopButton.frame = CGRectMake(ScreenW - 64 - 10, ScreenH-180 - UI.bottomSafeAreaHeight, 64, 64);
        [_openShopButton setImage:[UIImage imageNamed:@"my_openShop_icon_enlarge"] forState:UIControlStateNormal];
        [_openShopButton addTarget:self action:@selector(clickOpenShopButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_openShopButton addPanGestureWithType:DraggingTypeRight];
    }
    return _openShopButton;
}

#pragma mark --------------- 持久化数据 ---------------
- (BOOL)showBuyerUI {
    return [JHUserDefaults boolForKey:JHUSERDEFAULT_SWITCH_KEY];
}

- (void)changeShowBuyerUI:(BOOL)sender{
    [JHUserDefaults setBool:sender forKey:JHUSERDEFAULT_SWITCH_KEY];
    [JHUserDefaults synchronize];
}

-(void)hiddenLiveButton{
   [JHRootController.serviceCenter checkStartLiveButton];
}


@end
