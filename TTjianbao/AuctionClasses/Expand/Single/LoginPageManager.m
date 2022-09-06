//
//  LoginPageManager.m
//  TaodangpuAuction
//
//  Created by jiangchao on 2018/12/7.
//  Copyright © 2018 Netease. All rights reserved.
//
#import "JHNormalLivePreviewController.h"
#import "NTESAnchorPreviewController.h"
#import "LoginPageManager.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "NTESRoleSelectViewController.h"
#import "NTESLoginViewController.h"
#import "NTESNavigationHandler.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESMediaCapture.h"
#import "NTESLiveManager.h"
#import "FileUtils.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "GoodAppraisalViewController.h"
#import "JHMallViewController.h"
#import "JHMallCouponViewController.h"
#import "JHAllowanceViewController.h"
#import "JHNewRankingViewController.h"
#import "MyViewController.h"
#import "BaseTabBarController.h"
#import "BaseNavViewController.h"
#import "JHHomeViewController.h"
#import "WXApi.h"
#import "NSString+NTES.h"
#import "NSDictionary+NTESJson.h"
#import "NTESAudienceLiveViewController.h"
#import "NTESAnchorLiveViewController.h"
#import "JHAnchorPageViewController.h"
#import "JHMyCouponViewController.h"
#import "JHOrderConfirmViewController.h"
#import "JHOrderDetailViewController.h"
#import "JHEvaluateReportViewController.h"
#import "JHWebViewController.h"
#import "HGBaseViewController.h"
#import "JHOnLineAppraisalViewController.h"
#import "JHDiscoverChannelViewModel.h"
#import "JHPublishAreaViewController.h"
#import "RXRotateButtonOverlayView.h"
#import "JHDiscoverDetailsVC.h"
#import "JHDiscoverVideoDetailViewController.h"
#import "JHUserInfoController.h"
#import "JHAppraiseVideoViewController.h"
#import "JSCoreObject.h"
#import "JHAnchorStyleViewController.h"
#import "JHPersonCenterViewController.h"
#import "JHMessageSubListController.h"
#import "JHOrderListViewController.h"
#import "JHTopicDetailController.h"
#import "JHTaskHUD.h"
#import "DBManager.h"
#import "JHDiscoverPageController.h"
#import "CommunityManager.h"
#import "JHSelectMerchantViewController.h"
#import "MBProgressHUD.h"
#import "NSString+Common.h"
#import "JHStoreHomePageController.h"
#import "JHShopWindowPageController.h"
#import "TaodangpuAuctionHeader.h"
#import "BYTimer.h"
#import "GrowingManager.h"
#import "JHWebView.h"
#import "LNLaunchVC.h"
#import "JHDiscoverChannelModel.h"
#import "JHUserCenterResaleViewController.h"
#import "JHStonePinMoneyViewController.h"
#import "JHMainLiveRoomWillSalePageViewController.h"
#import "JHMyPriceViewController.h"
#import "JHRedPacketDetailController.h"
#import "JHMaskingManager.h"
#import "JHGuestLoginNIMSDKManage.h"
#import "JHPersonalViewController.h"
#import "JHLiveAnimationView.h"
#import "MyLiveViewController.h"
#import "JHSeckillPageViewController.h"



static LoginPageManager *instance;

@interface LoginPageManager()<NIMLoginManagerDelegate,NIMChatroomManagerDelegate,UITabBarControllerDelegate,NIMSystemNotificationManagerDelegate, RXRotateButtonOverlayViewDelegate>
{
    UIViewController * publishPage;
    JHPersonCenterViewController* personCenterPage;
    JHHomeViewController* appraisePage;
    JHDiscoverPageController *discoverPage;
    JHStoreHomePageController *storePage;
    UIButton *publishButton;
    BYTimer *timer;
    BOOL willRefreshThemeTabbar;
}

@property (nonatomic, strong) RXRotateButtonOverlayView *overlayView;
@property (nonatomic,strong) NTESNavigationHandler *handler;
@property (nonatomic,strong) JHFinishBlock bindWxBlock;
@property(strong,nonatomic) UIButton *appraisalBtn;
@property (nonatomic, assign) NSInteger lastSelectIndex;
@property (nonatomic, strong) JHLiveAnimationView *animationView;
@property (nonatomic, strong) UIImageView* appraiseTagImg;

@end

@implementation LoginPageManager
@synthesize tabBarController, appraiseTagImg;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LoginPageManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
        //   [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
        self.lastSelectIndex = 0;
        self.tableSelectIndex=0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXBind:) name:WXBINDSUSSNotifaction object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceivreXGNotification:) name:XGNotifaction object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTabbar:) name:kCelebrateRunningOrNotNotification object:nil];
    }
    return self;
}

-(JHMicWaitMode*)micWaitMode{
    
    if (!_micWaitMode) {
        _micWaitMode=[[JHMicWaitMode alloc]init];
    }
    return _micWaitMode;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.frame = CGRectMake(0, 3, 9, 9);
        _tipLabel.layer.cornerRadius = 4.5;
        _tipLabel.layer.masksToBounds = YES;
        _tipLabel.backgroundColor = HEXCOLOR(0xfe4200);
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}
-(UIButton*)appraisalBtn{
    
    if (!_appraisalBtn) {
        _appraisalBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 15)];
        [_appraisalBtn setTitle:@"免费" forState:UIControlStateNormal];
        [_appraisalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _appraisalBtn.titleLabel.font=[UIFont systemFontOfSize:10];
        _appraisalBtn.backgroundColor=[CommHelp toUIColorByStr:@"#ff4200"];
        _appraisalBtn.layer.cornerRadius = 8;
    }
    return _appraisalBtn;
}
- (void)dealloc
{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    // [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
}

- (CGFloat)currentItemX:(NSInteger)index
{
    //当item有五个的时候，每一个item的宽度是屏幕的1/15
    CGFloat offsetRight = (3.0*(index+1)-2.0)*ScreenWidth/(tabBarController.tabBar.items.count*3);
    offsetRight += ScreenWidth/15.0;
    return offsetRight;
}

- (void)refreshTabbar:(NSNotification*)notify
{
    NSNumber* isActivityTheme =(NSNumber*)notify.object;
    BOOL activeTheme = [isActivityTheme boolValue];
    //不一致就刷新
    if(activeTheme != willRefreshThemeTabbar)
    {
        [self resetTabbarWithTheme:activeTheme];
    }
    willRefreshThemeTabbar = activeTheme;
}

- (void)resetTabbarWithTheme:(BOOL)isActivityTheme
{
    if(isActivityTheme)
    {
        [CommHelp setTabBarItem:discoverPage.tabBarItem
                          title:@"社区"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"celebrate_tabbar_discover_select"
                 withTitleColor:kColor222
                unselectedImage:@"celebrate_tabbar_discover_normal"
                 withTitleColor:kColor999];
        
        [CommHelp setTabBarItem:storePage.tabBarItem
                          title:@"源头直购"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"celebrate_tabbar_store_select"
                 withTitleColor:kColor222
                unselectedImage:@"celebrate_tabbar_store_normal"
                 withTitleColor:kColor999];
        
        [CommHelp setTabBarItem:appraisePage.tabBarItem
                          title:@"在线鉴定"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"celebrate_tabbar_appraise_select"
                 withTitleColor:kColor222
                unselectedImage:@"celebrate_tabbar_appraise_normal"
                 withTitleColor:kColor999];
        //角标
        [self.appraisalBtn setHidden:YES];//防止两个同时存在
        [[NSUserDefaults standardUserDefaults] setObject:[CommHelp getCurrentDate] forKey:SHOWFREEAPPRAISELASTTIME];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //新角标
        [self.appraiseTagImg removeFromSuperview];
        self.appraiseTagImg = [[UIImageView alloc] initWithFrame:CGRectMake([self currentItemX:3]-13, 0, 32, 15)];
        [appraiseTagImg setImage:[UIImage imageNamed:@"celebrate_tabbar_appraise_normal_tag"]];
        [tabBarController.tabBar addSubview:appraiseTagImg];
        
        [CommHelp setTabBarItem:personCenterPage.tabBarItem
                          title:@"个人中心"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"celebrate_tabbar_person_select"
                 withTitleColor:kColor222
                unselectedImage:@"celebrate_tabbar_person_normal"
                 withTitleColor:kColor999];
        
        [publishButton setImage:[UIImage imageNamed:@"celebrate_tabbar_publish_normal"] forState:UIControlStateNormal];
        [publishButton setImage:[UIImage imageNamed:@"celebrate_tabbar_publish_select"] forState:UIControlStateHighlighted];
        [publishButton setTitle:@"发布" forState:UIControlStateNormal];
        [publishButton setTitleEdgeInsets:UIEdgeInsetsMake(publishButton.imageView.height+2-publishButton.titleLabel.height, -publishButton.imageView.width, 0, 0)];
        [publishButton setImageEdgeInsets:UIEdgeInsetsMake(-publishButton.titleLabel.height, 0, 0, publishButton.titleLabel.width)];
    }
    else
    {
        [CommHelp setTabBarItem:discoverPage.tabBarItem
                          title:@"社区"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"home_newtable_select"
                 withTitleColor:kColor222
                unselectedImage:@"home_newtable_nomal"
                 withTitleColor:kColor999];
        
        [CommHelp setTabBarItem:storePage.tabBarItem
                          title:@"源头直购"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"mall_newtable_select"
                 withTitleColor:kColor222
                unselectedImage:@"mall_newtable_nomal"
                 withTitleColor:kColor999];
        
        [CommHelp setTabBarItem:appraisePage.tabBarItem
                          title:@"在线鉴定"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"appraisal_newtable_select"
                 withTitleColor:kColor222
                unselectedImage:@"appraisal_newtable_nomal"
                 withTitleColor:kColor999];
        //角标
        [self.appraiseTagImg removeFromSuperview];
        //首次显示(免费角标原来逻辑)
        if (![CommHelp checkTheDate:[[NSUserDefaults standardUserDefaults ] objectForKey:SHOWFREEAPPRAISELASTTIME]]) {
            [tabBarController.tabBar addSubview:self.appraisalBtn];
            self.appraisalBtn.left = ScreenW - (ScreenW/tabBarController.tabBar.items.count)*1.5+8;
            self.appraisalBtn.top = 3;
            [[NSUserDefaults standardUserDefaults] setObject:[CommHelp getCurrentDate] forKey:SHOWFREEAPPRAISELASTTIME];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        [CommHelp setTabBarItem:personCenterPage.tabBarItem
                          title:@"个人中心"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"my_newtable_select"
                 withTitleColor:kColor222
                unselectedImage:@"my_newtable_nomal"
                 withTitleColor:kColor999];
        
        [publishButton setImage:[UIImage imageNamed:@"tablebar_publish"] forState:UIControlStateNormal];
        [publishButton setImage:[UIImage imageNamed:@"tablebar_publish"] forState:UIControlStateHighlighted];
        [publishButton setTitle:@"" forState:UIControlStateNormal];
        [publishButton setImageEdgeInsets:UIEdgeInsetsZero];
        [publishButton setTitleEdgeInsets:UIEdgeInsetsZero];
    }
}

- (void)setupMainViewController
{
    NTESLoginData *data = [[NTESLoginManager sharedManager] currentNTESLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    if ([account length] && [token length])
    {
        [[[NIMSDK sharedSDK] loginManager] autoLogin:account
                                               token:token];
        [[JHGuestLoginNIMSDKManage sharedInstance] requestOpenApp];
    }
    [[NTESServiceManager sharedManager] start];
    
    discoverPage = [[JHDiscoverPageController alloc]init];
    //JHSourceMallViewController * mall = [[JHSourceMallViewController alloc]init];
    storePage = [[JHStoreHomePageController alloc] init];
    publishPage = [[UIViewController alloc]init];
    appraisePage = [[JHHomeViewController alloc] init];
    personCenterPage = [[JHPersonCenterViewController alloc] init];
    
    tabBarController = [[BaseTabBarController alloc]init];
    BaseNavViewController *tabNav = [[BaseNavViewController alloc] initWithRootViewController:tabBarController];
    tabBarController.navigationController.navigationBarHidden = YES;
    tabBarController.viewControllers = @[discoverPage, storePage, publishPage, appraisePage, personCenterPage];
    
    tabBarController.delegate=self;
    tabBarController.selectedIndex = self.tableSelectIndex;
    tabBarController.tabBar.translucent = NO;
   // tabBarController.tabBar.alpha = 1;
    [tabBarController.tabBar setBarTintColor:kColor222];
    [tabBarController.tabBar setBarStyle:UIBarStyleDefault];
    [tabBarController.tabBar setBackgroundImage: [[UIImage imageNamed:@"tablebar_image_new"]resizableImageWithCapInsets:UIEdgeInsetsMake(10,0,10,0)resizingMode:UIImageResizingModeStretch]];
    [UITabBar appearance].clipsToBounds = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    publishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
    [publishButton setImage:[UIImage imageNamed:@"tablebar_publish"] forState:UIControlStateNormal];
    publishButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [publishButton setTitleColor:kColor999 forState:UIControlStateNormal];
    publishButton.titleLabel.font = JHMediumFont(11);
    [tabBarController.view addSubview:publishButton];
    [publishButton addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    publishButton.centerX=tabBarController.view.centerX;
    publishButton.bottom=tabBarController.view.bottom-JHSafeAreaBottomHeight-3;
    
    [self resetTabbarWithTheme:NO];//设置tabbar

    [UIApplication sharedApplication].keyWindow.rootViewController = tabNav;
    self.tipLabel.right = ScreenW - (ScreenW/tabBarController.tabBar.items.count)/2.+15;
    [tabBarController.tabBar addSubview:self.tipLabel];
}

-(BOOL)isLogin{
    NSString* status=[[NSUserDefaults standardUserDefaults] objectForKey:LOGINSTATUS];
    if (![status isEqualToString:ONLINE]) {
        return NO;
    }
    return YES;
}

-(void)publish{
    
    [self.tabBarController.view addSubview:self.overlayView];
    [self.overlayView show];
    [self checkAppraiseRoom];
    
    [Growing track:@"release"];
    
    //埋点：点击发布加号
    NSUInteger index = self.tabBarController.selectedIndex;
    NSUInteger currentIndex = (index == 3 || index == 4) ? index - 1 : index;
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    
    NSString *indexStr = @"";
    if (currentIndex == 0) {
        indexStr = @"社区";
    } else if (currentIndex == 1) {
        indexStr = @"卖场";
    } else if (currentIndex == 2) {
        indexStr = @"鉴定";
    } else if (currentIndex == 3) {
        indexStr = @"个人中心";
    }
    [GrowingManager homePublishBtnClick:@{@"userId" : userId ? userId : @"",
                                          @"time" : @([[YDHelper get13TimeStamp] longLongValue]),
                                          @"index" : @(currentIndex),
                                          @"index_str" : indexStr}];
}

- (RXRotateButtonOverlayView *)overlayView
{
    if (_overlayView == nil) {
        _overlayView = [[RXRotateButtonOverlayView alloc] init];
        [_overlayView setTitles:@[@"图片鉴定",@"连线鉴定",@"发帖聊聊"]];
        [_overlayView setTitleImages:@[@"dis_picAppraise",@"dis_VideoAppraise",@"dis_showBaby"]];
        [_overlayView setDelegate:self];
        [_overlayView setFrame:self.tabBarController.view.bounds];
    }
    return _overlayView;
}

#pragma mark - RXRotateButtonOverlayViewDelegate
- (void)dismissDelegate {
    self.overlayView = nil;
}

- (void)didSelected:(NSUInteger)index
{
    NSLog(@"clicked %zd btn",index);
    if ([self isLogin]) {
        if (index == 1) {
            NSLog(@"点击视频连线鉴定");
            JHAnchorStyleViewController *vc = [[JHAnchorStyleViewController alloc] init];
            
            WEAKSELF
            vc.selectCellBlock = ^(NSString *roomId) {
                [weakSelf getLiveDetail:roomId isInLiveRoom:NO isStoneDetail:NO];
            };
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.overlayView dismiss];
            });
            
        } else {
            NSLog(@"点击图片鉴定或晒宝贝");
            
            if ([CommunityManager needAutoEnterMerchantVC] ) {
                [CommunityManager enterMerchantVC];
                return;
            }
            
            JHPublishAreaViewController * publish=[[JHPublishAreaViewController alloc]init];
            BaseNavViewController *publishNav = [[BaseNavViewController alloc]initWithRootViewController:publish];
            publish.isOpenAppraise = (index == 0); //isOpenAppraise=YES表示图片鉴定，index=0是图片鉴定
            publish.from = JHFromSQHomePage;
            [self.tabBarController presentViewController:publishNav animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.overlayView dismiss];
            });
            
            //【埋点】进入发布页
            [JHGrowingIO trackEventId:JHTrackSQIntoPublish from:@"1"];
        }
        
        //埋点
        [Growing track:@"publishtype" withVariable:@{@"value":@(index)}];
    } else {
        [self.overlayView dismiss];
        [self presentLoginVC];
    }
}


- (void)checkAppraiseRoom {
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/channel/recommendAppraise?channelType=") stringByAppendingString:@"appraise"] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSArray *arr = [ChannelMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNameAppraiseState" object:@(arr.count>0)];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
    }];
    
}

-(void)presentLoginVC{
    LoginViewController * loginVc=[[LoginViewController alloc]init];
    BaseNavViewController *loginNav=[[BaseNavViewController alloc]initWithRootViewController:loginVc];
    [loginNav setNavigationBarHidden:YES];
    [self.tabBarController presentViewController:loginNav animated:YES completion:^{
        
    }];
}

- (void)presentSignViewController {
    JHSelectMerchantViewController *signVC = [[JHSelectMerchantViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:signVC animated:YES];
}

-(void)presentLoginVC:(void (^)(BOOL result)) loginResult{
    
    LoginViewController * loginVc=[[LoginViewController alloc]init];
    [loginVc setLoginResult:loginResult];
    
    BaseNavViewController *loginNav=[[BaseNavViewController alloc]initWithRootViewController:loginVc];
    [loginNav setNavigationBarHidden:YES];
    [self.tabBarController presentViewController:loginNav animated:YES completion:^{
        
    }];
}

- (void)presentLoginVCWithTarget:(UIViewController *)vc complete:(void (^)(BOOL result))loginResult {
    
    LoginViewController * loginVc=[[LoginViewController alloc]init];
    [loginVc setLoginResult:loginResult];
    
    BaseNavViewController *loginNav=[[BaseNavViewController alloc]initWithRootViewController:loginVc];
    [loginNav setNavigationBarHidden:YES];
    [vc presentViewController:loginNav animated:YES completion:^{
        
    }];
}
#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if(viewController == appraisePage)
    {
        [appraiseTagImg setImage:[UIImage imageNamed:@"celebrate_tabbar_appraise_select_tag"]];
    }
    else
    {
        [appraiseTagImg setImage:[UIImage imageNamed:@"celebrate_tabbar_appraise_normal_tag"]];
    }
    if (viewController==publishPage){
        return  NO;
    }
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"selectIndex = %lu", (unsigned long)tabBarController.selectedIndex);
    
    ///首次进入app 切换到社区界面 弹出频道界面
    NSMutableArray *deviceChannelArr = [self getLocalChannelData:ChannelDeviceFileData];
    if (tabBarController.selectedIndex == 0 && deviceChannelArr.count == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LNLaunchVC" bundle:nil];
        LNLaunchVC *channelListVC = (LNLaunchVC *)[storyboard  instantiateViewControllerWithIdentifier:@"LNLaunchVC_ID"];
        channelListVC.hideBackBtn = YES;
        [self.tabBarController presentViewController:channelListVC  animated:NO completion:nil];
    }
    
    if (tabBarController.selectedIndex == self.lastSelectIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TableBarSelectNotifaction object:tabBarController];
    }
    self.lastSelectIndex = tabBarController.selectedIndex;
    
    NSUInteger index = tabBarController.selectedIndex;
    NSUInteger currentIndex = (index == 3 || index == 4) ? index - 1 : index;
    
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    
    //埋点：切换tab
    NSString *indexStr = @"";
    if (currentIndex == 0) {
        indexStr = @"社区";
    } else if (currentIndex == 1) {
        indexStr = @"卖场";
    } else if (currentIndex == 2) {
        indexStr = @"鉴定";
    } else if (currentIndex == 3) {
        indexStr = @"个人中心";
    }
    [GrowingManager homeSwitchTab:@{@"userId" : userId ? userId : @"",
                                    @"time" : @([[YDHelper get13TimeStamp] longLongValue]),
                                    @"index" : @(currentIndex),
                                    @"index_str" : indexStr}];
    
    if (viewController==appraisePage) {
        [self.appraisalBtn setHidden:YES];
        
    }
}

-(void)loginIM:(NSString*)Account token:(NSString*)Token  completion:(NIMLoginHandler)completion{
    
    if ([[NIMSDK sharedSDK] loginManager].isLogined) {
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
            [self loginIMAccount:Account token:Token completion:completion];
        }];
    } else {
        [self loginIMAccount:Account token:Token completion:completion];
    }
   
}

- (void)loginIMAccount:(NSString *)Account token:(NSString *)Token completion:(NIMLoginHandler)completion {
    [[[NIMSDK sharedSDK] loginManager] login:Account
                                          token:Token
                                     completion:^(NSError *error) {
           [SVProgressHUD dismiss];
           if (error == nil)
           {
               DDLogInfo(@"login success accid: %@",Account);
               NTESLoginData *sdkData = [[NTESLoginData alloc] init];
               sdkData.account   = Account;
               sdkData.token     = Token;
               [[NTESLoginManager sharedManager] setCurrentNTESLoginData:sdkData];
               
               // [[NTESServiceManager sharedManager] start];
               [[JHGuestLoginNIMSDKManage sharedInstance]addObserveNIMBroad];
           }
           else
           {
               DDLogInfo(@"login failed accid: %@ code: %zd",Account,error.code);
               NSString *toast = [NSString stringWithFormat:@"IM登录失败 code: %zd",error.code];
               
               [[UIApplication sharedApplication].keyWindow makeToast:toast duration:2.0 position:CSToastPositionCenter];
           }
           completion(error);
       }];
}

-(void)setTableSelectIndex:(int)tableSelectIndex{
    
    if (tableSelectIndex == 2) {
        _tableSelectIndex=tableSelectIndex-1;
    }
    else
    {
        _tableSelectIndex=tableSelectIndex;
    }
    self.tabBarController.selectedIndex=_tableSelectIndex;
}
#pragma mark - NIMLoginManagerDelegate
- (void)onAutoLoginFailed:(NSError *)error
{
    NSString *reason = @"登录失败";
    switch ([error code]) {
        case NIMRemoteErrorCodeExist:{
            reason = @"您的帐号已在另外一台设备登陆，请注意帐号信息安全";
            break;
        }
        case NIMRemoteErrorCodeInvalidPass:
            reason = @"密码错误";
            break;
        default:
            break;
    }
    ///通知取消上传
    [[NSNotificationCenter defaultCenter] postNotificationName:cancelUploadArticleIdnetifer object:nil];
    
    [self logoutAccountData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showAlertWithCompletionHandler:nil];
    });
}
- (void)onReceivreXGNotification:(NSNotification*)note{
    
    UNNotification *notification=[note object];
    NSDictionary * useInfo=notification.request.content.userInfo;
    //七鱼
    if([[useInfo allKeys] containsObject:@"nim"]){
        if ([[useInfo objectForKey:@"nim"] integerValue]==1) {
            [[JHQYChatManage shareInstance] showChatWithViewcontroller:self.tabBarController];}
    }
    //推送
    else if([[useInfo allKeys] containsObject:@"action"]){
        JHMessageTargetModel * pushMode = [JHMessageTargetModel mj_objectWithKeyValues:[useInfo objectForKey:@"action"]];
        id paramsObj = [[useInfo objectForKey:@"action"]objectForKey:@"intent"];
        pushMode.params=[JHMessageTargetParamsModel mj_objectWithKeyValues: paramsObj];
        pushMode.componentType=pushMode.params.componentType;
        
        if (pushMode.componentType == JHMessagePageTypePushMsg)
        {//透传拦截
            [self gotoPagesFromMessageRouter:paramsObj];
        }
        else if (pushMode.action_type==XGPushMessageTypeDefault)
        {
            NSLog(@"do nothing???XGPushMessageTypeDefault");
        }
       else
       {
            [self messageToNativeVC:pushMode from:JHLiveFrompush];
       }
    }
}

- (void)gotoPagesFromMessageRouter:(id)paramsObj
{
    JHRouterModel* router = [JHRouterModel mj_objectWithKeyValues:paramsObj];
    if([router.vc isEqualToString:@"UITabBarController"])
    {
        NSString* indexStr = [router.params objectForKey:@"selectedIndex"];
        NSInteger selectedIndex = [indexStr integerValue];
        [[LoginPageManager sharedInstance].tabBarController.navigationController popToRootViewControllerAnimated:YES];
        [LoginPageManager sharedInstance].tabBarController.selectedIndex = selectedIndex;
        
        if (selectedIndex == 1)
        { //源头直购
            if ([router.params.allKeys containsObject:@"item_type"])
            {
                [self changeStoreHomePage:router.params];
            }
        }
    }
    else
    {// 动态解析跳转既定页面
        [JHRouterManager gotoPageByModel:router];
    }
}

-(void)messageToNativeVC:(JHMessageTargetModel*)model from:(NSString *)from{
    
    if (model.action_type==XGPushMessageTypeWeb) {
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.urlString = model.params.url;
        [self.tabBarController.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (model.componentType==JHMessagePageTypeLiveRoom) {
        [self EnterLiveRoom:model.params.roomId fromString:from];
        return;
    }
    if (!self.isLogin) {
        [self presentLoginVC:nil];
        return;
    }
    switch (model.componentType) {
        case JHMessagePageTypeCopon:
        {
            JHMyCouponViewController * copon=[[JHMyCouponViewController alloc]init];
            copon.currentIndex=model.params.targetIndex;
            [self.tabBarController.navigationController pushViewController:copon animated:YES];
        }
            break;
        case JHMessagePageTypeMallCopon:
        {
            JHMallCouponViewController * mallCopon=[[JHMallCouponViewController alloc]init];
            mallCopon.currentIndex=model.params.targetIndex;
            [self.tabBarController.navigationController pushViewController:mallCopon animated:YES];
        }
            break;
            
            
        case JHMessagePageTypeOrderDetail:
        {
            JHOrderDetailViewController * order=[[JHOrderDetailViewController alloc]init];
            order.isSeller = model.params.isSeller;
            order.orderId=model.params.orderId;
            [self.tabBarController.navigationController pushViewController:order animated:YES];
        }
            break;
            
        case JHMessagePageTypeOrderSure:
        {
            JHOrderConfirmViewController  * order=[[JHOrderConfirmViewController alloc]init];
            order.orderId=model.params.orderId;
            [self.tabBarController.navigationController pushViewController:order animated:YES];
        }
            
            break;
        case JHMessagePageTypeReport:
        {
            JHEvaluateReportViewController  * report=[[JHEvaluateReportViewController alloc]init];
            if (model.params.type==1) {
                report.orderId=model.params.ID;
            }
            else {
                report.appraiseRecordId=model.params.ID;
            }
            [self.tabBarController.navigationController pushViewController:report animated:YES];
        }
            break;
        case JHMessagePageTypeCoverDetail:
        {
            @weakify(self);
            //校验内容有效性
            NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/content/detailBridge/%@/%@"),
                             model.params.item_type, model.params.item_id];
            [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
                CBridgeData *data = [CBridgeData modelWithJSON:respondObject.data];
                if ([CommunityManager isValid:data]) {
                    @strongify(self);
                    if (data.layout == JHSQLayoutTypeImageText) {//图片
                        NSLog(@"跳转图文详情。。。。");
                        JHDiscoverDetailsVC *vc = [JHDiscoverDetailsVC new];
                        vc.entry_type = JHEntryType_None;
                        vc.entry_id = @"0";
                        vc.commentId = model.params.comment_id;
                        vc.item_id = model.params.item_id;
                        vc.item_type = model.params.item_type;
                        [self.tabBarController.navigationController pushViewController:vc animated:YES];
                        
                    } else if(data.layout == JHSQLayoutTypeVideo) {//视频
                        NSLog(@"跳转视频详情。。。。");
                        JHDiscoverVideoDetailViewController *vc = [JHDiscoverVideoDetailViewController new];
                        vc.entry_type = JHEntryType_None;
                        vc.entry_id = @"0";
                        vc.item_id = model.params.item_id;
                        vc.item_type = model.params.item_type;
                        vc.commentId = model.params.comment_id;
                        [self.tabBarController.navigationController pushViewController:vc animated:YES];
                        
                    } else if (data.layout == JHSQLayoutTypeAppraisalVideo){//鉴定剪辑视频
                        JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
                        vc.cateId = [NSString stringWithFormat:@"%@",respondObject.data[@"item_type"]];
                        vc.appraiseId = respondObject.data[@"item_id"];
                        vc.commentId = model.params.comment_id;
                        vc.from = JHLiveFromInteractMessage;
                        [self.tabBarController.navigationController pushViewController:vc animated:YES];
                    }
                    
                } else {
                    [UITipView showTipStr:@"帖子不存在或已删除"];
                }
                
            } failureBlock:^(RequestModel *respondObject) {
                [UITipView showTipStr:@"帖子不存在或已删除"];
            }];
        }
            break;
        case JHMessagePageTypeUserMainPage:
        {
            JHUserInfoController *userInfoVC = [JHUserInfoController new];
            userInfoVC.userId = model.params.user_id;
            [self.tabBarController.navigationController pushViewController:userInfoVC animated:YES];
        }
            break;
        case JHMessagePageTypeHistoryMessageList:
        {
            JHMessageSubListController *vc = [[JHMessageSubListController alloc] initWithTitle:@"社区互动" pageType:kMsgSublistTypeForum];
//            vc.type=1;
//            vc.secondType=@"all";
//            vc.title=@"互动消息";
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeOrderList:
        {
            JHOrderListViewController *vc = [JHOrderListViewController new];
            vc.isSeller = model.params.isSeller;
            vc.currentIndex= model.params.targetIndex;
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeTopic:
        {
            //进入话题详情
            JHTopicDetailController *vc = [JHTopicDetailController new];
            [vc setTitle:@"" itemId:model.params.item_id];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
            //埋点 - 进入话题详情埋点
            [self buryPointWithTopicId:model.params.item_id];
        }
            break;
        case JHMessagePageTypeUserCenterResale:
        {//买家寄售原石页面
            JHUserCenterResaleViewController *vc = [JHUserCenterResaleViewController new];
            vc.selectedIndex=model.params.targetIndex;
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeStonePinMoney:
        {//卖家结算页面
            JHStonePinMoneyViewController *vc = [JHStonePinMoneyViewController new];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case JHMessagePageTypeStoneMyPrice:
        {//待出价
            JHMyPriceViewController *vc = [JHMyPriceViewController new];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeStoneMyWillSale:
        {//待上架原石
            JHMainLiveRoomWillSalePageViewController *vc = [JHMainLiveRoomWillSalePageViewController new];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeRedPacket:
        {//红包
            JHRedPacketDetailController *vc=[[JHRedPacketDetailController alloc]init];
            vc.redPacketId=model.params.redPacketId;
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeAllowance:
        {//津贴
            JHAllowanceViewController *vc=[[JHAllowanceViewController alloc]init];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHMessagePageTypeSeckillPageList:
        {
            JHSeckillPageViewController *vc = [[JHSeckillPageViewController alloc] init];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case JHMessagePageTypePersonCenter:
        {
            [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
            [LoginPageManager sharedInstance].tableSelectIndex = 4;
        }
           break;
            
        case JHMessagePageTypePersonalInfo:
        {
            JHPersonalViewController *vc = [[JHPersonalViewController alloc] init];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
           break;
          
        default:
            #if DEBUG
            {
                [UITipView showTipStr:[NSString stringWithFormat: @"落地页没有匹配类型:%zd", model.componentType]];
            }
            #endif
            break;
    }
}
- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
            reason = @"您的账号已在其他设备登录";
        case NIMKickReasonByClientManually:{
            reason = @"您已在其他设备将此账号踢出";//@"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"您的账号已被封禁";//@"你被服务器踢下线";
            break;
        default:
            break;
    }
    ///通知取消上传
    [[NSNotificationCenter defaultCenter] postNotificationName:cancelUploadArticleIdnetifer object:nil];
    
    [self logoutAccountData];
    // [[NTESServiceManager sharedManager] destory];
    //    [[NTESLoginManager sharedManager] setCurrentNTESLoginData:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showAlertWithCompletionHandler:nil];
    });
}
-(void)logoutAccountData{
    [Growing clearUserId];
    [[UserInfoRequestManager sharedInstance]unBindDeviceToken:nil];
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[DBManager getInstance] del_userTableInfo];
        [UserInfoRequestManager sharedInstance].user=nil;
        [UserInfoRequestManager sharedInstance].levelModel=nil;
        
        [[NTESLoginManager sharedManager] setCurrentNTESLoginData:nil];
        [[NSUserDefaults standardUserDefaults] setObject:OFFLINE forKey:LOGINSTATUS ];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:IDTOKEN ];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.micWaitMode=nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTSUSSNotifaction object:nil];//
        [[JHGuestLoginNIMSDKManage sharedInstance] requestGuestNimInfo];

        if (![self isLogin]) {
            [self presentLoginVC:^(BOOL result) {
                if (result) {
                    [self bindWx:^{
                    }];
                }
            }];
        }
    }];
}

-(void)bindWx:(JHFinishBlock)block{
    
    if ([UserInfoRequestManager sharedInstance].user.bindThird!=1 ) {
        
        self.bindWxBlock=block;
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"绑定微信登录" message:@"绑定微信并进行便捷登录" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self resoveLiveButton];  ///隐藏或显示直播浮窗
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self resoveLiveButton];  ///隐藏或显示直播浮窗
            [self sendAuthRequest];
        }]];
        [self.tabBarController presentViewController:alertVc animated:YES completion:nil];
        
    }
}

- (void)resoveLiveButton {
    if ([self isNeedShowLiveBtn]) {
        [self showLiveView];
    }
    else {
        [self hiddenLiveView];
    }
}

-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"bindwx";
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}
-(void)WXBind:(NSNotification*)note{
    
    NSString * code=[note object];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/customer/bindWx") Parameters:@{@"code":code} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication].keyWindow makeToast:@"绑定成功" duration:2.0 position:CSToastPositionCenter];
        self.bindWxBlock();
    }
                    failureBlock:^(RequestModel *respondObject) {
        [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:2.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    [SVProgressHUD show];
}

-(void)EnterLiveRoom:(NSString*) roomId fromString:(NSString *)from
{
    [self EnterLiveRoom:roomId fromString:from isStoneDetail:NO];
}
-(void)EnterLiveRoom:(NSString*) roomId fromString:(NSString *)from isStoneDetail:(BOOL)isStoneDetail{
    BOOL inLiveRoom=NO;
    for ( UIViewController *vc in self.navViewControllers) {
        if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
            inLiveRoom=YES;
            NTESAudienceLiveViewController * liveVC=(NTESAudienceLiveViewController*)vc;
            liveVC.fromString = from;
            WEAKSELF
            liveVC.closeBlock = ^{
                [weakSelf getLiveDetail:roomId isInLiveRoom:YES isStoneDetail:isStoneDetail];
            };
            liveVC.isExitVc = YES;
            [liveVC onCloseRoom];
            
            break;
        }
    }
    if (!inLiveRoom) {
        [self getLiveDetail:roomId isInLiveRoom:inLiveRoom isStoneDetail:isStoneDetail from:from];
    }
}

- (void)getLiveDetail:(NSString*)roomId  isInLiveRoom:(BOOL)inLiveRoom isStoneDetail:(BOOL)isStoneDetail {
    [self getLiveDetail:roomId isInLiveRoom:inLiveRoom isStoneDetail:isStoneDetail from:@""];
}

- (void)getLiveDetail:(NSString*)roomId isInLiveRoom:(BOOL)inLiveRoom isStoneDetail:(BOOL)isStoneDetail from:(NSString *)from {
    
    //crash判空处理,目前逻辑,如果异常可以return
    if([NSString isEmpty:roomId])
        return;
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:roomId ? :@""] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:JHKeyWindow animated:YES];
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        if ([channel.channelType isEqualToString:@"sell"]) {
            if ([channel.status integerValue]==2)
            {
                NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
                vc.type = 1;
                vc.channel=channel;
                vc.coverUrl = channel.coverImg;
                vc.fromString = from;
                [self.tabBarController.navigationController pushViewController:vc animated:YES];
                
            }
            else  if ([channel.status integerValue]==1||[channel.status integerValue]==0||[channel.status integerValue]==3){
                
                NSString *string = nil;
                if (channel.status.integerValue == 1) {
                    string = channel.lastVideoUrl;
                }
                
                NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
                vc.channel = channel;
                vc.coverUrl = channel.coverImg;
                vc.type = 1;
                vc.fromString = from;
                [self.tabBarController.navigationController pushViewController:vc animated:YES];
            }
            
            
        }else {
            if ([channel.status integerValue]==2)
            {
                NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
                vc.channel=channel;
                vc.applyApprassal=NO;
                vc.coverUrl = channel.coverImg;
                vc.fromString = from;
                [self.tabBarController.navigationController pushViewController:vc animated:YES];
            }
            else  {
                
                JHAnchorPageViewController *vc = [[JHAnchorPageViewController alloc] init];
                vc.anchorId=channel.anchorId;
                @weakify(self)
                vc.finishFollow = ^(NSString * _Nonnull anchorId, BOOL isFollow) {
                    if ([from isEqualToString:JHFromSQHomePage]) {
                        @strongify(self)
                        if (self.finishFollow) {
                            self.finishFollow(anchorId, isFollow);
                        }
                    }
                };
                [self.tabBarController.navigationController pushViewController:vc animated:YES];
            }
        }
        if (inLiveRoom) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(isStoneDetail){
                    NSMutableArray *vcArray = [NSMutableArray new];
                    for ( UIViewController *vc in self.navViewControllers) {
                        
                        if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
                            [vcArray addObject:self.navViewControllers.lastObject];
                            self.tabBarController.navigationController.viewControllers = vcArray;
                            break;
                        }
                        [vcArray addObject:vc];
                    }
                }
                else
                {
                    NSMutableArray *arr=self.navViewControllers;
                    for ( UIViewController *vc in arr) {
                        if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
                            [arr removeObject:vc];
                            self.tabBarController.navigationController.viewControllers=arr;
                            break;
                        }
                    }
                }
                
            });
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:JHKeyWindow animated:YES];
    }];
    [MBProgressHUD showHUDAddedTo:JHKeyWindow animated:YES];
}
- (BOOL)isShowRedPoint {
    
    NSInteger n = [[NSUserDefaults standardUserDefaults] integerForKey:@"firstNew"];
    self.tipLabel.hidden = n;
    return !n;
}
- (void)setHideRedPoint {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstNew"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)webToNativeVCName:(NSString *)vc param:(NSString *)string {
    NSDictionary *dic = [string mj_JSONObject];
    [self toNativeVC:vc withParam:dic from:JHLiveFromh5];
}

- (void)changeStoreHomePage:(NSDictionary*)params {
    [JHNotificationCenter postNotificationName:JHStoreHomePageIndexChangedNotification
                                       object:params];
}

- (void)toNativeVC:(NSString *)className withParam:(NSDictionary *)paraDic from:(NSString *)from {
    NSDictionary *dic = paraDic;
    
    if ([className isEqualToString:@"WebDialog"]) {
        JHWebView *webview = [[JHWebView alloc] init];
        webview.frame = [UIScreen mainScreen].bounds;
        
        [webview loadWebURL:dic[@"urlString"]];
        [[UIApplication sharedApplication].keyWindow addSubview:webview];
        return;
    }
    UIViewController *controller = [[NSClassFromString(className) alloc] init];
    if ([controller isKindOfClass:[UIViewController class]]) {
        if ([className isEqualToString:@"NTESAudienceLiveViewController"]) {
            if (dic[@"roomId"]) {
                [self EnterLiveRoom:dic[@"roomId"] fromString:from];
                
            }else {
                [SVProgressHUD showErrorWithStatus:@"参数错误"];
            }
            
        } else if ([controller isKindOfClass:[UITabBarController class]]) {
            
            BOOL inLiveRoom=NO;
            NSArray *vcArr=[LoginPageManager sharedInstance].tabBarController.navigationController.viewControllers;
            for ( UIViewController *vc in vcArr) {
                if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
                    inLiveRoom=YES;
                    NTESAudienceLiveViewController * liveVC=(NTESAudienceLiveViewController*)vc;
                    liveVC.fromString = from;
                    liveVC.closeBlock = ^{
                        [[LoginPageManager sharedInstance].tabBarController.navigationController popToRootViewControllerAnimated:YES];
                    };
                    liveVC.isExitVc = YES;
                    [liveVC onCloseRoom];
                    break;
                }
            }
            if (!inLiveRoom) {
                [[LoginPageManager sharedInstance].tabBarController.navigationController popToRootViewControllerAnimated:YES];
            }
            
            NSInteger selectedIndex = [dic[@"selectedIndex"] integerValue];
            if (selectedIndex == 1) { //源头直购
                self.tabBarController.selectedIndex = selectedIndex;
                if ([dic.allKeys containsObject:@"item_type"]) {
                    [self changeStoreHomePage:dic];
                 }
//                if ([dic.allKeys containsObject:@"item_type"]) {
//                    NSInteger itemIndex = [dic[@"item_type"] integerValue];
//                    [self changeStoreHomePageToIndex:itemIndex];
//                }
                
            } else if (selectedIndex == 2) { //点击【+】号
                [self publish];
                self.tabBarController.selectedIndex = 0; //切换到社区首页
                
            } else {
                self.tabBarController.selectedIndex = selectedIndex;
            }
            
        } else if ([controller isKindOfClass:[LoginViewController class]]) {
            
            if (![self isLogin]) {
                WEAKSELF
                [self presentLoginVCWithTarget:weakSelf.tabBarController complete:^(BOOL result) {
                    if (result){
                        if (dic[@"isRoom"]) {
                            if ([dic[@"isRoom"] integerValue] == 1) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"LiveLoginFinishNotifaction" object:nil];
                            }
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRefreshWebView object:nil];
                    }
                }];
            } else {
                [[UIApplication sharedApplication].keyWindow makeToast:@"已经登录"];
            }
            
        } else if ([controller isKindOfClass:[JHTopicDetailController class]]) {
            //跳转话题页
            [self enterTopicDetailVC:dic];
            
        } else if ([controller isKindOfClass:[JHShopWindowPageController class]]) {
            [self enterShopWindowVC:dic from:from];
            
        } else {
            for (NSString *key in dic.allKeys) {
                if ([self getVariableWithClass:NSClassFromString(className) varName:key]) {
                    [controller setValue:dic[key] forKey:key];
                }
            }
            
            
            if ([self.tabBarController presentedViewController]) {
                [[self currentViewController].navigationController pushViewController:controller animated:YES];
                
            } else {
                [self.tabBarController.navigationController pushViewController:controller animated:YES];
            }
        }
    }
}

- (BOOL)getVariableWithClass:(Class) myClass varName:(NSString *)name{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        
        if ([keyName isEqualToString:[NSString stringWithFormat:@"_%@",name]]) {
            return YES;
        }
    }
    return NO;
}

//进入商城橱窗页
- (void)enterShopWindowVC:(NSDictionary *)dic from:(NSString *)from {
    ///判断如果keywindow上有红包界面 需要移除
    [JHMaskingManager dismissPopWindow];
    NSString *ccId = dic[@"sc_id"];
    JHShopWindowPageController *vc = [JHShopWindowPageController new];
    vc.showcaseId = ccId.integerValue;
    vc.fromSource = from;
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
}

//进入话题页
- (void)enterTopicDetailVC:(NSDictionary *)dic {
    ///判断如果keywindow上有红包界面 需要移除
    [JHMaskingManager dismissPopWindow];
    NSString *itemId = dic[@"item_id"];
    JHTopicDetailController *vc = [JHTopicDetailController new];
    [vc setTitle:@"" itemId:itemId];
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
    
    //埋点 - 进入话题详情埋点
    [self buryPointWithTopicId:itemId];
}

//新增进入话题页埋点
- (void)buryPointWithTopicId:(NSString *)topicId {
    JHBuryPointEnterTopicDetailModel *pointModel = [JHBuryPointEnterTopicDetailModel new];
    pointModel.entry_type = 0;
    pointModel.entry_id = @"0";
    pointModel.topic_id = topicId;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    pointModel.time = timeSp;
    [[JHBuryPointOperator shareInstance] enterTopicDetailWithModel:pointModel];
}
- (void)exitApp {
#ifdef DEBUG
#else
    [self exit];
#endif
}
-(void)exit{
    if (timer) {
        [timer stopGCDTimer];
        timer=nil;
    }
    timer=[[BYTimer alloc]init];
    [timer createTimerWithTimeout:3 handlerBlock:^(int presentTime) {
        [[UIApplication sharedApplication].keyWindow makeToast:[NSString stringWithFormat:@"    %d    ",presentTime] duration:1.0 position:CSToastPositionCenter];
    } finish:^{
        exit(0);
    }];
}


- (UIViewController *)currentViewController {
    UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
    
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    
    return vc;
}

//获取首次进入app时选择的频道数据
- (NSMutableArray *)getLocalChannelData:(NSString *)channelType {
    NSArray *arr;
    NSMutableArray *cateArr=[NSMutableArray array];
    NSData * data=[FileUtils readDataFromFile:channelType];
    if (data) {
        arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    if ([arr isKindOfClass:[NSArray class]]) {
        cateArr =[JHDiscoverChannelModel mj_objectArrayWithKeyValuesArray:arr];
    }
    return cateArr;
}
-(NSMutableArray*)navViewControllers{
    return [self.tabBarController.navigationController.viewControllers mutableCopy];
}

- (UIViewController *)tabControllerWithIndex:(NSUInteger)index
{
    NSMutableArray *array = [self.tabBarController.viewControllers mutableCopy];
    if (array.count > index) {
        return array[index];
    }
    return nil;
}

#pragma mark -
#pragma mark - 直播按钮相关
- (void)hiddenLiveView {
    if (_animationView) {
        _animationView.hidden = YES;
    }
}

- (void)showLiveView {
    if (!_animationView) {
        JHLiveAnimationView *animationView = [[JHLiveAnimationView alloc] init];
        animationView.imageName = @"home_starLive";
        animationView.sourceType = JHLiveAnimationSourceTypeGif;
        _animationView = animationView;
        animationView.hidden = YES;
        [JHKeyWindow addSubview:_animationView];
        [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(JHKeyWindow);
            make.bottom.mas_equalTo(-JHSafeAreaBottomHeight - JHTabBarHeight-29);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        _animationView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [_animationView addGestureRecognizer:pangesture];
        @weakify(self);
        _animationView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:JHKeyWindow];
                if (CGRectContainsPoint(JHKeyWindow.bounds, p)) {
                    [self pressLiveVC];
                }
            }
        };
    }
    _animationView.hidden = NO;
}

- (void)pressLiveVC
{
    self.animationView.hidden = YES;
    
    UIViewController *viewController = self.currentViewController;
    JHUserTypeRole type = [UserInfoRequestManager sharedInstance].user.type;
    [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeVideo;
    [NTESLiveManager sharedInstance].liveQuality = NTESLiveQualityHigh;
    if ( type == JHUserTypeRoleAppraiseAnchor) {
        NTESAnchorPreviewController *vc = [[NTESAnchorPreviewController alloc]init];
        vc.type = 0;
        [viewController.navigationController presentViewController:vc animated:YES completion:nil];
    }
    //直播卖货
    else  if ( type == JHUserTypeRoleSaleAnchor || type == JHUserTypeRoleRestoreAnchor) {
        JHNormalLivePreviewController *vc = [[JHNormalLivePreviewController alloc]init];
          BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
        vc.type = 1;
        [viewController.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translatedPoint = [recognizer translationInView:JHKeyWindow];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translatedPoint.x,recognizer.view.center.y + translatedPoint.y);
    //限制屏幕范围：
    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(ScreenW - recognizer.view.frame.size.width/2,newCenter.x);
    newCenter.y = MAX(recognizer.view.frame.size.height/2+JHSafeAreaTopHeight, newCenter.y);
    newCenter.y = MIN(ScreenH - recognizer.view.frame.size.height/2 - JHSafeAreaTopHeight - JHSafeAreaBottomHeight,  newCenter.y);
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (newCenter.x < ScreenW/2) {//小于：屏幕左边
            newCenter.x = recognizer.view.width/2;
        }
        else {
            newCenter.x = ScreenW - recognizer.view.width/2;
        }
    }
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:JHKeyWindow];
}


///判断是否需要显示直播浮窗
- (BOOL)isNeedShowLiveBtn {
    if (!self.isLogin) { ///未登录 隐藏
        return NO;
    }
    else {
        NSString *vcName = NSStringFromClass([self.currentViewController class]);
        NSLog(@"currentViewController:--- %@",vcName);
        if ([vcName isEqualToString:@"JHDiscoverPageController"] ||
            [vcName isEqualToString:@"LNLaunchVC"] ||
            [vcName isEqualToString:@"JHStoreHomePageController"] ||
            [vcName isEqualToString:@"JHSourceMallViewController"] ||
            [vcName isEqualToString:@"JHStoneResaleViewController"] ||
            [vcName isEqualToString:@"JHStoreHomeListController"] ||
            [vcName isEqualToString:@"JHMallViewController"] ||
            [vcName isEqualToString:@"JHHomeViewController"] ||
            [vcName isEqualToString:@"JHPersonCenterViewController"] ||
            [vcName isEqualToString:@"LNDiscoverBottomCollecViewController"] ||
            [vcName isEqualToString:@"JHRecommentFocusViewController"] ||
            [vcName isEqualToString:@"JHMallListViewController"] ||
            [vcName isEqualToString:@"JHStoneResaleListViewController"] ||
            [vcName isEqualToString:@"BaseTabBarController"]) {
            JHUserTypeRole type = [UserInfoRequestManager sharedInstance].user.type;
            if (type == JHUserTypeRoleAppraiseAnchor ||
                type == JHUserTypeRoleSaleAnchor ||
                type == JHUserTypeRoleRestoreAnchor) {  ///判断是否显示直播入口
                BOOL isSeller = ![JHUserDefaults boolForKey:JHUSERDEFAULT_SWITCH_KEY];
                return isSeller;
            }
            else {
                return NO;
            }
        }
        else {
            return NO;
        }
    }
}


@end


