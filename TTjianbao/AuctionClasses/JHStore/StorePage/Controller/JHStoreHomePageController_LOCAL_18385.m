//
//  JHStoreHomePageController.m
//  TTjianbao
//
//  Created by wuyd on 2019/10/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAnniversaryBagView.h"
#import "JHStoreHomePageController.h"
#import "JHStoreHomeTopBar.h"
#import "JHMessageViewController.h"
#import "JHMallPageViewController.h"
#import "JHSourceMallViewController.h"
#import "JHStoneResaleViewController.h"
#import "UIImage+WebP.h"
#import "YDGuideManager.h"
#import "GrowingManager.h"
#import "JHStoreHelp.h"
#import "UIImageView+Gradient.h"
#import "JHStoreApiManager.h"
#import "JHStoreNewRedpacketModel.h"
#import "JHMallOperationModel.h"
#import "NTESAudienceLiveViewController.h"
#import "NTESAnchorPreviewController.h"
#import "JHCustomServiceNewViewController.h"
#import "ZQSearchViewController.h"
#import "JHSearchResultViewController.h"
#import "JHAppAlertViewManger.h"
#import "JHNewGuideTipsView.h"
#import "JHCustomizeGuideTipView.h"
#import "JHRedPacketGuideModel.h"
#import "JHSkinManager.h"
#import "JHMallTitleContentView.h"
#import "NSObject+Cast.h"
#import "JHAuthorize.h"
#import "JHLuckyBagView.h"

NSString *const JHStoreHomePageIndexChangedNotification = @"JHStoreHomePageIndexChangedNotification";

@interface JHStoreHomePageController () <ZQSearchViewDelegate>

@property (nonatomic, strong) JHStoreHomeTopBar *topBar;
@property (nonatomic, strong) JHSourceMallViewController *mallVC;  ///源头直播330
@property (nonatomic, strong) JHMallPageViewController *mallPageVC;  ///源头直播334
@property (nonatomic, strong) JHCustomServiceNewViewController *customServiceVc;   ///定制服务

@property (nonatomic, strong) UIImageView* headerBackImage;

@property (strong, nonatomic) JHMallTitleContentView *titleView;

@property (nonatomic, copy) NSString *pushThirdIndex; /// 三级推送index

@end

@implementation JHStoreHomePageController

- (void)addTitleBackView
{
    self.titleView = [JHMallTitleContentView new];
        [self.view addSubview: self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view).offset(UI.statusBarHeight);
            make.size.mas_equalTo(CGSizeMake(ScreenW - 80, 44));
        }];
}

//虽然不需要释放,最好写全
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        _pushThirdIndex = @"";
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headerBackImage];
    [self.view sendSubviewToBack:self.headerBackImage];
    
    _mallPageVC = [JHMallPageViewController new];
    [self addChildViewController:_mallPageVC];
    [self.view addSubview:_mallPageVC.view];
    [_mallPageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(UI.statusAndNavBarHeight);
    }];
    if (!isEmpty(self.pushThirdIndex)) {
        [self.mallPageVC setPushLastSelectIndex:[self.pushThirdIndex integerValue]];
        self.pushThirdIndex = @"";
    }
    
    //把视图扩展到底部tabbar
    [self addTopBar];
    self.topBar.selectedIndex = 1;
    [self addObserver];
    [self addTitleBackView];
    
    [JHAuthorize verifyNotificationAuthorizetion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    JH_WEAK(self)
    [self getAllUnreadMsgCount:^(id obj) {
        JH_STRONG(self)
        [self.topBar refreshMsgCount:obj];
    }];

    [JHAppAlertViewManger showSuperRedPacketEnterWithSuperView:self.view];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithTop:ScreenH - 250];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if([UserInfoRequestManager sharedInstance].anniversaryType == 2){
        [JHAnniversaryBagView show];
    }
}

- (void)addObserver {
    @weakify(self);
    [[[JHNotificationCenter rac_addObserverForName:JHStoreHomePageIndexChangedNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        NSDictionary *params = notification.object;
        NSInteger  indexNum = [params[@"item_type"] integerValue];
        [self.categoryView selectItemAtIndex:indexNum];
        
        //hutao--add
        NSArray *arrKeys = [params allKeys];
        if ([arrKeys containsObject:@"sub_item_type"]) {
            NSInteger index = [params[@"sub_item_type"] integerValue];
            if (self.mallPageVC) {
                [self.mallPageVC setPushLastSelectIndex:index];
            } else {
                self.pushThirdIndex = [NSString stringWithFormat:@"%ld",(long)index];
            }
        }
    }];
    
    [[[JHNotificationCenter rac_addObserverForName:TableBarSelectNotifaction object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notification)
     {
        @strongify(self);
        if (self.mallVC) {
             [self.mallVC tableBarSelect:0];
        }
        if (self.mallPageVC) {
             [self.mallPageVC tableBarSelect:0];
        }
    }];
}

//导航栏
- (void)addTopBar {
    @weakify(self);
    _topBar = [JHStoreHomeTopBar topBarWithMsgClickBlock:^{
        @strongify(self);
//        [self enterMessageVC];
        JHLuckyBagView *luckView = [[JHLuckyBagView alloc]initWithShowType:JHLuckyBagShowTypeSet];
        [luckView show];
    } withSearchClickBlock:^{
        @strongify(self);
        [self showSearchVC];
        ///369神策埋点:点击搜索栏-特卖商城右上角搜索按钮
        [self reportSearchBarClick];
    }];
    [self.view addSubview:_topBar];
}

- (void)showSearchVC {
    JHSearchResultViewController *resultController = [JHSearchResultViewController new];
    ZQSearchFrom from = ZQSearchFromLive;
        from = ZQSearchFromLive;
    ZQSearchViewController *vc = [[ZQSearchViewController alloc] initSearchViewWithFrom:from resultController:resultController];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
    
}
- (void)reportSearchBarClick {
    NSDictionary *par = @{
        @"page_position" : @"源头直购",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"searchBarClick"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
#pragma mark - ZQSearchViewDelegate
- (void)searchFuzzyResultWithKeyString:(NSString *)keyString Data:(id<ZQSearchData>)data resultController:(UIViewController *)resultController From:(ZQSearchFrom)from{
    JHSearchResultViewController *vc = (JHSearchResultViewController *)resultController;
    [vc refreshSearchResult:keyString from:from keywordSource:data];
}

- (UIImageView*)headerBackImage {
    if (!_headerBackImage) {
        _headerBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*174/375.)];
        _headerBackImage.contentMode=UIViewContentModeScaleToFill;
    }
    return _headerBackImage;
}

//进入消息中心
- (void)enterMessageVC {
    
    if ([self isLgoin]) {
        JHMessageViewController *vc = [[JHMessageViewController alloc] init];
        vc.from = JHFromHomeSourceBuy;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)isLgoin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {}];
        return NO;
    }
    return YES;
}

- (void)trackUserProfilePage:(BOOL)isBegin
{
    if(isBegin)
    {
        //用户画像浏览时长:begin
        [JHUserStatistics noteEventType:kUPEventTypeLiveShopHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
    }
    else
    {
        //用户画像浏览时长:end
        [JHUserStatistics noteEventType:kUPEventTypeLiveShopHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd} resumeBrowse:YES];
    }
}

- (void)trackUserProfile:(NSInteger)index
{
    NSString *eventType, *lastEventType;
        //用户画像浏览时长:end
        lastEventType = kUPEventTypeLiveShopHomeBrowse;
        [JHUserStatistics noteEventType:lastEventType params:@{JHUPBrowseKey:JHUPBrowseEnd} resumeBrowse:YES];
        
        //用户画像浏览时长:begin
        eventType = kUPEventTypeLiveShopHomeBrowse;
        [JHUserStatistics noteEventType:eventType params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
}

- (void)refreshPageTheme:(NSInteger)index
{
        /* hutao--add */
        self.topBar.backgroundColor = [UIColor clearColor];
        [_headerBackImage setBackgroundColor:[UIColor clearColor]];
    
    [self.topBar refreshTheme:NO index:index];
}

@end
