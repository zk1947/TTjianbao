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
#import "JHSkinSceneManager.h"
#import "JHMallTitleContentView.h"
#import "NSObject+Cast.h"
#import "JHAuthorize.h"
#import "JHC2CClassViewController.h"
#import "JHWebViewController.h"
#import "JHNewStoreTypeVC.h"
#import "JHHotWordModel.h"
#import "JHNewStoreSearchResultViewController.h"

#import "JHSearchViewController_NEW.h"
#import "JHNewStoreSearchResultViewController.h"

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
    _mallPageVC.vc = self;
    [self addChildViewController:_mallPageVC];
    [self.view addSubview:_mallPageVC.view];
    
//    _mallPageVC.view.frame = CGRectMake(0, ScreenWidth*134/375., kScreenWidth, kScreenHeight-UI.statusAndNavBarHeight);//50
    //UI.statusAndNavBarHeight+50
//    _mallPageVC.pageListView.mainTableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    //头部滑动效果实现
    @weakify(self);
    [RACObserve(_mallPageVC.pageListView.mainTableView, contentOffset) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        CGPoint offset = [x CGPointValue];
        CGFloat scrollY = offset.y;
        [self dealAllScrollAnimation:scrollY];
    }];
    
    if (!isEmpty(self.pushThirdIndex)) {
        [self.mallPageVC setPushLastSelectIndex:[self.pushThirdIndex integerValue]];
        self.pushThirdIndex = @"";
    }
    
    //把视图扩展到底部tabbar
    [self addTopBar];
    
    [_mallPageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@(0));
        make.top.equalTo(self.topBar.mas_bottom);
    }];
    
    self.topBar.selectedIndex = 1;
    [self addObserver];
    [self addTitleBackView];
    
    //获取热词
    [self getHotWordData:^(NSError * _Nullable error, NSArray *wordsArr) {
        JH_STRONG(self)
        if (!error) {
            self.topBar.searchBar.placeholderArray  = wordsArr;
        }
    }];
    
    [JHAuthorize verifyNotificationAuthorizetion];
}

///头部滑动效果
- (void)dealAllScrollAnimation:(CGFloat)scrollY{
    /*
     滑动区间0-50 (更改此处滑动区间的高度需同步改动JHMallPageViewController单元格高度)
     1>>头部和列表页整体上移
     2>>搜索框上移
     3>>头部文本透明度渐变
     */
    if (scrollY <= 0) {
        [self.topBar addAnimationWithOffset:0];
        [_mallPageVC addScrollAnimation:0];
        self.titleView.alpha = 1;
    }else if (scrollY>0 && scrollY<ScrollHeadBarHeight){
        [self.topBar addAnimationWithOffset:scrollY];
        [_mallPageVC addScrollAnimation:-scrollY];
        self.titleView.alpha = 1- scrollY/ScrollHeadBarHeight;
    }else{
        [self.topBar addAnimationWithOffset:ScrollHeadBarHeight];
        [_mallPageVC addScrollAnimation:-ScrollHeadBarHeight];
        self.titleView.alpha = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    JH_WEAK(self)
    [self getAllUnreadMsgCount:^(id obj) {
        JH_STRONG(self)
        [self.topBar refreshMsgCount:obj];
    }];

    //获取签到状态
    [self getUserSignStatus:^(BOOL isSign) {
        JH_STRONG(self)
        self.topBar.isSign = isSign;
    }];
    
    self.topBar.searchBar.stopScroll = NO;
    
    [JHAppAlertViewManger showSuperRedPacketEnterWithSuperView:self.view];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithTop:ScreenH - 250];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.topBar.searchBar.stopScroll = YES;
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
        [self enterMessageVC];
    } withSearchClickBlock:^{
        @strongify(self);
        //签到
        if (IS_LOGIN) {
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.titleString = @"签到有礼";
            vc.urlString = H5_BASE_STRING(@"/jianhuo/app/newSigned/newSigned.html");
            [self.navigationController pushViewController:vc animated:YES];
        }
        //埋点
        NSDictionary *param = @{
            @"model_name":@"签到",
            @"page_position":@"源头直购首页"
        };
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickModel" params:param type:JHStatisticsTypeSensors];
    }];
    //搜索
    _topBar.searchScrollBlock = ^(NSInteger index, BOOL isLeft) {
        @strongify(self);
        JHHotWordModel *wordModel = self.topBar.searchBar.placeholderArray[index];
        [self showSearchVC:wordModel.title];
        ///369神策埋点:点击搜索栏-特卖商城右上角搜索按钮
        [self reportSearchBarClick];
        //埋点
        NSString *locationStr = isLeft ? @"搜索框":@"搜索按钮";
        NSDictionary *param = @{
            @"model_name":locationStr,
            @"page_position":@"源头直购首页"
        };
        [JHAllStatistics jh_allStatisticsWithEventId:@"searchBarClick" params:param type:JHStatisticsTypeSensors];
    };
    //分类
    _topBar.classBlock = ^{
        @strongify(self);
        JHNewStoreTypeVC *vc = [JHNewStoreTypeVC new];
        vc.cateFromSoure = ZQSearchFromLive;
        [self.navigationController pushViewController:vc animated:YES];
        //埋点
        NSDictionary *param = @{
            @"model_name":@"直播分类",
            @"page_position":@"源头直购首页"
        };
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickModel" params:param type:JHStatisticsTypeSensors];
    };
    
    [self.view addSubview:_topBar];
}

- (void)showSearchVC:(NSString *)keyWord {
//    JHSearchResultViewController *resultController = [JHSearchResultViewController new];
//    ZQSearchFrom from = ZQSearchFromLive;
//        from = ZQSearchFromLive;
//    ZQSearchViewController *vc = [[ZQSearchViewController alloc] initSearchViewWithFrom:from resultController:resultController];
//    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:NO];
    
    //test
    JHNewStoreSearchResultViewController *resultController = [[JHNewStoreSearchResultViewController alloc] init];
    
    JHSearchViewController_NEW *vc = [[JHSearchViewController_NEW alloc] initSearchViewWithFrom:ZQSearchFromLive resultController:resultController];
    vc.placeholder = keyWord;
    vc.delegate = self;
    resultController.searchTextfield = vc.searchBar;
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
//    JHSearchResultViewController *vc = (JHSearchResultViewController *)resultController;
//    [vc refreshSearchResult:keyString from:from keywordSource:data];
    
    //test
    JHNewStoreSearchResultViewController *vc = (JHNewStoreSearchResultViewController *)resultController;
    [vc refreshSearchResult:keyString from:from keywordSource:data cateInfoDicModel:nil];
    ////test
}

- (UIImageView*)headerBackImage {
    if (!_headerBackImage) {
        _headerBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*174/375.)];
//        _headerBackImage.contentMode=UIViewContentModeScaleToFill;
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

#pragma mark -获取用户的签到状态
- (void)getUserSignStatus:(void(^)(BOOL isSign))completion{
    NSString *url = FILE_BASE_STRING(@"/activity/api/checkin/auth/getCheck");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        completion(NO);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        BOOL result = NO;
        if (respondObject.code == 200) {
            result = [respondObject.data[@"todayHasCheckin"] intValue] == 1 ? YES:NO;
        }
        completion(result);
    }];
}

#pragma mark -获取热搜轮播词
- (void)getHotWordData:(void(^)(NSError * _Nullable error,NSArray *wordsArr))completion{
    NSString *url = FILE_BASE_STRING(@"/mall/search/search/listHotWord");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *arr = respondObject.data;
        NSMutableArray *resultArr = [NSMutableArray array];
        for (NSString *words in arr) {
            JHHotWordModel *wordModel = [JHHotWordModel new];
            wordModel.title = words;
            [resultArr addObject:wordModel];
        }
        if (resultArr.count>0) {
            if (completion) {
                completion(nil,[resultArr copy]);
            }
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error, nil);
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error, nil);
        }
    }];
}

@end
