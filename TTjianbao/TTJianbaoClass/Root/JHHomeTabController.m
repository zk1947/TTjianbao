//
//  JHHomeTabController.m
//  TTjianbao
//
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHHomeTabController.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESService.h"
#import "NTESLoginManager.h"
#import "GrowingManager.h"
#import "UIAlertView+NTESBlock.h"
#import "JHGuestLoginNIMSDKManage.h"
#import "BaseNavViewController.h"
#import "JHHomeViewController.h"
#import "JHHomePageAllViewController.h"
#import "JHSQHomePageController.h"
#import "JHNewStoreHomeViewController.h"
#import "JHStoreHomePageController.h"
#import "JHPersonCenterViewController.h"
#import "NTESNavigationHandler.h"
#import "JHLiveAnimationView.h"
#import "JHSQManager.h"
#import "JHAnchorStyleViewController.h"
#import "JHStoreHomeListController.h"
#import "JHSkinManager.h"
#import "JHSkinSceneManager.h"
#import "JHNewStoreHomeReport.h"
#import "JHMarketHomeViewController.h"
#define kTabDefaultTag 8000
#define SIZE_WIDTH  25

typedef NS_ENUM(NSInteger, JHHomeTabType)
{
    /// 文玩社区
    JHHomeTabTypeCommunity = 0,
    
    ///源头直购
    JHHomeTabTypeSourceMall = 1,
    
    ///特卖商城
    JHHomeTabTypeShop = 2,
    
    ///鉴定·服务
    JHHomeTabTypeAppraise = 3,
    
    ///个人中心
    JHHomeTabTypePersonCenter = 4,
};

@interface JHHomeTabController () <NIMLoginManagerDelegate, NIMChatroomManagerDelegate, UITabBarControllerDelegate, NIMSystemNotificationManagerDelegate>
{
    JHPersonCenterViewController* personCenterPage;
    JHHomeViewController* appraisePage;
//    JHSQHomePageController *sqHomePage;
    JHHomePageAllViewController *homeAllPage;
    
    JHStoreHomePageController *storePage;
    
//    JHStoreHomeListController *storeList;
    JHNewStoreHomeViewController *storeList;

    
    UIButton *publishButton;
    BYTimer *timer;
    BOOL willRefreshThemeTabbar;
}

@property (nonatomic, assign) NSInteger lastSelectIndex;
@property (nonatomic, assign) NSUInteger tableSelectIndex;
@property (nonatomic, strong) UILabel *tipLabel; //tab上标签
@property (nonatomic, strong) UIButton *appraisalBtn;
@property (nonatomic, strong) UIImageView* appraiseTagImg;
@property (nonatomic, strong) NTESNavigationHandler *handler;

/// 返回顶部
@property (nonatomic, weak) UIButton *toTopButton;

/// 可以返回顶部的scrollview 可以为空
@property (nonatomic, weak) UIScrollView *subScrollView;

/// 可以返回顶部的scrollview 可以为空
@property (nonatomic, weak) UIScrollView *mainScrollView;

@property (strong, nonatomic) YYAnimatedImageView *aImageView;

@property (strong, nonatomic) UIView *communityBackView; //文玩社区
@property (strong, nonatomic) YYAnimatedImageView *communityView;
@property (strong, nonatomic) UILabel *communitylable;

@property (strong, nonatomic) UIView *shopBackView; //源头直购
@property (strong, nonatomic) YYAnimatedImageView *shopView;
@property (strong, nonatomic) UILabel *shoplable;

@property (strong, nonatomic) UIView *saleBackView; //特卖商城
@property (strong, nonatomic) YYAnimatedImageView *saleView;
@property (strong, nonatomic) UILabel *salelabel;

@property (strong, nonatomic) UIView *onlineBackView; //鉴定·服务
@property (strong, nonatomic) YYAnimatedImageView *onlineView;
@property (strong, nonatomic) UILabel *onelable;

@property (strong, nonatomic) UIView *perBackView; //个人中心
@property (strong, nonatomic) YYAnimatedImageView *perView;
@property (strong, nonatomic) UILabel *perlable;

//@property (strong, nonatomic) UIView *publishBackView;
//@property (strong, nonatomic) YYAnimatedImageView *publishView;

@property (strong, nonatomic) UIView *tabBarBackView;

@property (strong, nonatomic) YYAnimatedImageView *txtNewImgv;

@end

@implementation JHHomeTabController

-(void)tapTabBarView:(UIView *)view
{
    view.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
              
            view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
              
            view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
              
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}
- (void)setTabBarUI
{
//    UIColor *color = kColor222;
//    JHSkinModel *font_model = [JHSkinManager bottomNavigation];
//    if (font_model.isChange)
//    {
//        if ([font_model.type intValue] == 1)
//        {
//            color = COLOR_CHANGE(font_model.name);
//        }
//    }
    
    self.tabBarBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, UI.tabBarAndBottomSafeAreaHeight)];
    self.tabBarBackView.backgroundColor = [UIColor whiteColor];
    [self.tabBar addSubview:self.tabBarBackView];
    
//    [self.tabBarBackView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.edges.mas_equalTo(0);
//        make.bottom.mas_equalTo(self.tabBar.mas_bottom).offset(0);
//    }];
//
    
    /* 文玩社区 */
    CGFloat w = ScreenW / 5.f;
    self.communityBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 49.f)];
    self.communityBackView.tag = 0;
    [self.communityBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackViewMethod:)]];
    [self.tabBarBackView addSubview:self.communityBackView];
    
    self.communityView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, (33-25)/2, w, 25)];
    self.communityView.contentMode = UIViewContentModeScaleAspectFit;
    [self.communityBackView addSubview:self.communityView];
    
    self.communitylable = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, w, 49-33)];
    self.communitylable.text = @"宝友集市";
    self.communitylable.textAlignment = NSTextAlignmentCenter;
    self.communitylable.font = [UIFont fontWithName:kFontNormal size:11.0f];
//    self.communitylable.textColor = color;
    [self.communityBackView addSubview:self.communitylable];
    
    /* 源头直购 */
    self.shopBackView = [[UIView alloc] initWithFrame:CGRectMake(w, 0, w, 49.f)];
    self.shopBackView.tag = 1;
    [self.shopBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackViewMethod:)]];
    [self.tabBarBackView addSubview:self.shopBackView];
    
    self.shopView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, (33-25)/2, w, 25)];
    self.shopView.contentMode = UIViewContentModeScaleAspectFit;
    [self.shopBackView addSubview:self.shopView];
    
    self.shoplable = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, w, 49-33)];
    self.shoplable.text = @"源头直购";
    self.shoplable.textAlignment = NSTextAlignmentCenter;
    self.shoplable.font = [UIFont fontWithName:kFontNormal size:11.0f];
//    self.shoplable.textColor = color;
    [self.shopBackView addSubview:self.shoplable];
    
    /* 特卖商城 */
    self.saleBackView = [[UIView alloc] initWithFrame:CGRectMake(w * 2, 0, w, 49.f)];
    self.saleBackView.tag = 2;
    [self.saleBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackViewMethod:)]];
    [self.tabBarBackView addSubview:self.saleBackView];
    
    self.saleView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, (33-25)/2, w, 25)];
    self.saleView.contentMode = UIViewContentModeScaleAspectFit;
    [self.saleBackView addSubview:self.saleView];
    
    self.salelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, w, 49-33)];
    self.salelabel.text = @"天天商城";
    self.salelabel.textAlignment = NSTextAlignmentCenter;
    self.salelabel.font = [UIFont fontWithName:kFontNormal size:11.0f];
//    self.salelabel.textColor = color;
    [self.saleBackView addSubview:self.salelabel];

    /* 鉴定·服务 */
    self.onlineBackView = [[UIView alloc] initWithFrame:CGRectMake(w * 3, 0, w, 49.f)];
    self.onlineBackView.tag = 3;
    [self.onlineBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackViewMethod:)]];
    [self.tabBarBackView addSubview:self.onlineBackView];
    
    self.onlineView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, (33-25)/2, w, 25)];
    self.onlineView.contentMode = UIViewContentModeScaleAspectFit;
    [self.onlineBackView addSubview:self.onlineView];
    
    self.onelable = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, w, 49-33)];
    self.onelable.text = @"鉴定·回收";
    self.onelable.textAlignment = NSTextAlignmentCenter;
//    self.onelable.textColor = color;
    self.onelable.font = [UIFont fontWithName:kFontNormal size:11.0f];
    [self.onlineBackView addSubview:self.onelable];
    
    /* 个人中心 */
    self.perBackView = [[UIView alloc] initWithFrame:CGRectMake(w * 4, 0, w, 49.f)];
    self.perBackView.tag = 4;
    [self.perBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackViewMethod:)]];
    [self.tabBarBackView addSubview:self.perBackView];
    
    self.perView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, (33-25)/2, w, 25)];
    self.perView.contentMode = UIViewContentModeScaleAspectFit;
    [self.perBackView addSubview:self.perView];
    
    self.perlable = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, w, 49-33)];
    self.perlable.text = @"个人中心";
    self.perlable.textAlignment = NSTextAlignmentCenter;
    self.perlable.font = [UIFont fontWithName:kFontNormal size:11.0f];
//    self.perlable.textColor = color;
    [self.perBackView addSubview:self.perlable];
}
- (void)setCommunity:(BOOL)isSelected
{
    //标识位（新）
    if (_txtNewImgv && isSelected) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tabShowNewOnce"];
        _txtNewImgv.hidden = YES;
    }
    
    JHSkinSceneModel *scene = [JHSkinSceneManager shareManager].sceneBarOneModel;
    if (isSelected) {
        self.communityView.image = scene.imageSel;
    }else {
        self.communityView.image = scene.imageNor;
    }
    
//    JHSkinModel *custom_model = [JHSkinManager oneDefini];
//    if (custom_model.isChange)
//    {
//        if ([custom_model.type intValue] == 0)
//        {
//            //换图
//            if (isSelected)
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:custom_model.useName];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.communityView.image = image;
//            }
//            else
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:custom_model.name];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.communityView.image = image;
//            }
//        }
//    }
//    else
//    {
//        //不换肤，默认
//        if (isSelected)
//        {
//            YYImage *image = [YYImage imageNamed:@"home_newtable_select"];
//            self.communityView.image = image;
//        }
//        else
//        {
//            YYImage *image = [YYImage imageNamed:@"home_newtable_nomal"];
//            self.communityView.image = image;
//        }
//    }
}

- (void)setShop:(BOOL)isSelected
{
    JHSkinSceneModel *scene = [JHSkinSceneManager shareManager].sceneBarTwoModel;
    if (isSelected) {
        self.shopView.image = scene.imageSel;
    }else {
        self.shopView.image = scene.imageNor;
    }
    
//    JHSkinModel *shop_model = [JHSkinManager twoDefini];
//    if (shop_model.isChange)
//    {
//        if ([shop_model.type intValue] == 0)
//        {
//            //换图
//            if (isSelected)
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:shop_model.useName];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.shopView.image = image;
//            }
//            else
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:shop_model.name];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.shopView.image = image;
//            }
//        }
//    }
//    else
//    {
//        if (isSelected)
//        {
//            YYImage *image = [YYImage imageNamed:@"mall_newtable_select"];
//            self.communityView.image = image;
//        }
//        else
//        {
//            YYImage *image = [YYImage imageNamed:@"mall_newtable_nomal"];
//            self.communityView.image = image;
//        }
//    }
}

/* 特卖商城 */
- (void)setSale:(BOOL)isSelected
{
    
    JHSkinSceneModel *scene = [JHSkinSceneManager shareManager].sceneBarThreeModel;
    if (isSelected) {
        self.saleView.image = scene.imageSel;
    }else {
        self.saleView.image = scene.imageNor;
    }
//    JHSkinModel *model = [JHSkinManager threeDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            //换图
//            if (isSelected)
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:model.useName];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.saleView.image = image;
//            }
//            else
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:model.name];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.saleView.image = image;
//            }
//        }
//    }
//    else
//    {
//        if (isSelected)
//        {
//            YYImage *image = [YYImage imageNamed:@"tabbar_shop_select"];
//            self.saleView.image = image;
//        }
//        else
//        {
//            YYImage *image = [YYImage imageNamed:@"tabbar_shop_normal"];
//            self.saleView.image = image;
//        }
//    }

}

//- (void)setPublish:(BOOL)isSelected
//{
//    JHSkinModel *model = [JHSkinManager threeDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            //换图
//            if (isSelected)
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:model.useName];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.publishView.image = image;
//            }
//            else
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:model.name];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.publishView.image = image;
//            }
//        }
//    }
//    else
//    {
//        YYImage *image = [YYImage imageNamed:@"tablebar_publish"];
//        self.communityView.image = image;
//    }
//}
- (void)setOnlineIdentification:(BOOL)isSelected
{
    JHSkinSceneModel *scene = [JHSkinSceneManager shareManager].sceneBarFourModel;
    if (isSelected) {
        self.onlineView.image = scene.imageSel;
    }else {
        self.onlineView.image = scene.imageNor;
    }
//    JHSkinModel *model = [JHSkinManager fourDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            //换图
//            if (isSelected)
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:model.useName];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.onlineView.image = image;
//            }
//            else
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:model.name];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.onlineView.image = image;
//            }
//        }
//    }
//    else
//    {
//        if (isSelected)
//        {
//            YYImage *image = [YYImage imageNamed:@"appraisal_newtable_select"];
//            self.communityView.image = image;
//        }
//        else
//        {
//            YYImage *image = [YYImage imageNamed:@"appraisal_newtable_nomal"];
//            self.communityView.image = image;
//        }
//    }
}

- (void)setPerCenter:(BOOL)isSelected
{
    JHSkinSceneModel *scene = [JHSkinSceneManager shareManager].sceneBarFiveModel;
    if (isSelected) {
        self.perView.image = scene.imageSel;
    }else {
        self.perView.image = scene.imageNor;
    }
    
//    JHSkinModel *model = [JHSkinManager fiveDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            //换图
//            if (isSelected)
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:model.useName];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.perView.image = image;
//            }
//            else
//            {
//                NSString *imagePath = [JHSkinManager getImageFilePath:model.name];
//                YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//                self.perView.image = image;
//            }
//        }
//    }
//    else
//    {
//        if (isSelected)
//        {
//            YYImage *image = [YYImage imageNamed:@"my_newtable_select"];
//            self.communityView.image = image;
//        }
//        else
//        {
//            YYImage *image = [YYImage imageNamed:@"my_newtable_nomal"];
//            self.communityView.image = image;
//        }
//    }
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [[NIMSDK sharedSDK].loginManager addDelegate:self];

        self.lastSelectIndex = 0;
        self.tableSelectIndex = 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTabbar:) name:kCelebrateRunningOrNotNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self homeSetup];
    [self bindData];
}

#pragma mark - draw subviews
- (void)homeSetup
{
    //login & service start
    [self startNTESService];
    //create tab
    [self setupTabController];
}

- (void)startNTESService
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
}

- (void)setupTabController
{
    [self drawItemsController];
    [self drawTabController]; //add tab
//    [UIApplication sharedApplication].keyWindow.rootViewController = [self drawTabController];
    [UITabBar appearance].clipsToBounds = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (BaseNavViewController*)drawTabController
{
    BaseNavViewController *tabNav = [[BaseNavViewController alloc] initWithRootViewController:self];
    self.navigationController.navigationBarHidden = YES;
    
    self.viewControllers = @[homeAllPage, storePage, storeList, appraisePage, personCenterPage];
    self.delegate = self;
    self.selectedIndex = self.tableSelectIndex;
    self.tabBar.translucent = NO;
   // self.tabBar.alpha = 1;
    [self.tabBar setBarTintColor:kColor222];
    [self.tabBar setBarStyle:UIBarStyleDefault];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundImage: [[UIImage imageNamed:@"tablebar_image_new"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)resizingMode:UIImageResizingModeStretch]];

    /* hutao--add */
//    JHSkinModel *model = [JHSkinManager oneDefini];
//    if (model.isChange)
//    {
//        self.tabBarBackView.hidden = NO;
        //publishButton.hidden = YES;
        
        [self setTabBarUI];
        
        [self setCommunity:NO];
        [self setShop:YES];
        [self setSale:NO];
        [self setOnlineIdentification:NO];
        [self setPerCenter:NO];
        //[self setPublish:NO];
//    }
//    else
//    {
        //publishButton.hidden = NO;
//        self.tabBarBackView.hidden = YES;
//    }


    //添加发布按钮
    [self.view addSubview:publishButton];
    publishButton.centerX = self.view.centerX;
    publishButton.bottom = self.view.bottom-UI.bottomSafeAreaHeight;
    //设置tabbar
//    [self resetTabbarWithTheme:NO];
    
    //tab上标签
    self.tipLabel.right = ScreenW - (ScreenW/self.tabBar.items.count)/2.+15;
    [self.tabBar addSubview:self.tipLabel];
    
    //标识位（新）(仅首次安装应用展示)
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"tabShowNewOnce"]) {
        self.txtNewImgv.frame = CGRectMake(ScreenW / 5.f-40, 0, 29, 20);
        [self.tabBar addSubview:self.txtNewImgv];
//        [self addTxtNewAnimation];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postNotifcation:) name:POST_JHHOMETABCONTROLLER object:nil];

    return tabNav;
}
- (void)bindData {
    JHSkinSceneManager *manager = [JHSkinSceneManager shareManager];
    
    @weakify(self)
    [RACObserve(manager, sceneBarOneModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.communityView.image = self.selectedIndex == 0 ? scene.imageSel : scene.imageNor;
        self.communitylable.textColor = self.selectedIndex == 0 ? scene.colorSel : scene.colorNor;
    }];
    [RACObserve(manager, sceneBarTwoModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.shopView.image = self.selectedIndex == 1 ? scene.imageSel : scene.imageNor;
        self.shoplable.textColor = self.selectedIndex == 1 ? scene.colorSel : scene.colorNor;
    }];
    [RACObserve(manager, sceneBarThreeModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.saleView.image = self.selectedIndex == 2 ? scene.imageSel : scene.imageNor;
        self.salelabel.textColor = self.selectedIndex == 2 ? scene.colorSel : scene.colorNor;
    }];
    [RACObserve(manager, sceneBarFourModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.onlineView.image = self.selectedIndex == 3 ? scene.imageSel : scene.imageNor;
        self.onelable.textColor = self.selectedIndex == 3 ? scene.colorSel : scene.colorNor;
    }];
    [RACObserve(manager, sceneBarFiveModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.perView.image = self.selectedIndex == 4 ? scene.imageSel : scene.imageNor;
        self.perlable.textColor = self.selectedIndex == 4 ? scene.colorSel : scene.colorNor;
    }];
    [RACObserve(manager, sceneBarTopModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        [self.toTopButton setImage:scene.imageNor forState:UIControlStateNormal];
    }];
    
}
- (void)postNotifcation:(NSNotification *)info
{
    JHSkinModel *model = [JHSkinManager getSkinInfoWithType:JHSkinTypeBarIndex0];
    
    NSMutableDictionary *param = info.object;
    //NSString *item_type = param[@"item_type"];
    NSString *selectedIndex = param[@"selectedIndex"];
    if ([selectedIndex intValue] == 0)
    {
        //宝友集市
        if (model.isChange)
        {
            [self setCommunity:YES];
            [self setShop:NO];
            [self setSale:NO];
            [self setOnlineIdentification:NO];
            [self setPerCenter:NO];
        }
    }
    else if ([selectedIndex intValue] == 1)
    {
        //源头直购
        if (model.isChange)
        {
            [self setCommunity:NO];
            [self setShop:YES];
            [self setSale:NO];
            [self setOnlineIdentification:NO];
            [self setPerCenter:NO];
        }
    }
    else if ([selectedIndex intValue] == 2)
    {
        //特卖商城
        if (model.isChange)
        {
            [self setCommunity:NO];
            [self setShop:NO];
            [self setSale:YES];
            [self setOnlineIdentification:NO];
            [self setPerCenter:NO];
        }
    }
    else if ([selectedIndex intValue] == 3)
    {
        //鉴定·服务
        if (model.isChange)
        {
            [self setCommunity:NO];
            [self setShop:NO];
            [self setSale:NO];
            [self setOnlineIdentification:YES];
            [self setPerCenter:NO];
        }
    }
    else if ([selectedIndex intValue] == 4)
    {
        //个人在中心
        if (model.isChange)
        {
            [self setCommunity:NO];
            [self setShop:NO];
            [self setSale:NO];
            [self setOnlineIdentification:NO];
            [self setPerCenter:YES];
        }
    }
    
    self.selectedIndex = [selectedIndex integerValue];
}

- (void)drawItemsController
{
    homeAllPage = [[JHHomePageAllViewController alloc]init];
//    sqHomePage = [[JHSQHomePageController alloc] init]; //0
    storePage = [[JHStoreHomePageController alloc] init]; //1
    
//    storeList = [[JHStoreHomeListController alloc] init]; //1
    storeList = [[JHNewStoreHomeViewController alloc] init];
    
    appraisePage = [[JHHomeViewController alloc] init];  //3
    personCenterPage = [[JHPersonCenterViewController alloc] init];  //4
}

- (void)resetTabbarWithTheme:(BOOL)isActivityTheme
{
    if(isActivityTheme)
    {
        [CommHelp setTabBarItem:homeAllPage.tabBarItem
                          title:@"宝友集市"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"celebrate_tabbar_discover_select"
                 withTitleColor:kColor222
                unselectedImage:@"celebrate_tabbar_discover_normal"
                 withTitleColor:kColor222];
        
        [CommHelp setTabBarItem:storePage.tabBarItem
                          title:@"源头直购"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"celebrate_tabbar_store_select"
                 withTitleColor:kColor222
                unselectedImage:@"celebrate_tabbar_store_normal"
                 withTitleColor:kColor222];
        
        [CommHelp setTabBarItem:storeList.tabBarItem
                          title:@"天天商城"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"tabbar_shop_select"
                 withTitleColor:kColor222
                unselectedImage:@"tabbar_shop_normal"
                 withTitleColor:kColor222];
        [CommHelp setTabBarItem:appraisePage.tabBarItem
                          title:@"鉴定·回收"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"celebrate_tabbar_appraise_select"
                 withTitleColor:kColor222
                unselectedImage:@"celebrate_tabbar_appraise_normal"
                 withTitleColor:kColor222];
        //角标
        [self.appraisalBtn setHidden:YES];//防止两个同时存在
        [[NSUserDefaults standardUserDefaults] setObject:[CommHelp getCurrentDate] forKey:SHOWFREEAPPRAISELASTTIME];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //新角标
        [self.appraiseTagImg removeFromSuperview];
        self.appraiseTagImg = [[UIImageView alloc] initWithFrame:CGRectMake([self currentItemX:3]-13, 0, 32, 15)];
        [self.appraiseTagImg setImage:[UIImage imageNamed:@"celebrate_tabbar_appraise_normal_tag"]];
        [self.tabBar addSubview:self.appraiseTagImg];
        
        [CommHelp setTabBarItem:personCenterPage.tabBarItem
                          title:@"个人中心"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"celebrate_tabbar_person_select"
                 withTitleColor:kColor222
                unselectedImage:@"celebrate_tabbar_person_normal"
                 withTitleColor:kColor999];
    }
    else
    {
        [CommHelp setTabBarItem:homeAllPage.tabBarItem
                          title:@"宝友集市"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"home_newtable_select"
                 withTitleColor:kColor222
                unselectedImage:@"home_newtable_nomal"
                 withTitleColor:kColor222];
        
        [CommHelp setTabBarItem:storePage.tabBarItem
                          title:@"源头直购"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"mall_newtable_select"
                 withTitleColor:kColor222
                unselectedImage:@"mall_newtable_nomal"
                 withTitleColor:kColor222];
        
        [CommHelp setTabBarItem:storeList.tabBarItem
                          title:@"天天商城"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"tabbar_shop_select"
                 withTitleColor:kColor222
                unselectedImage:@"tabbar_shop_normal"
                 withTitleColor:kColor222];
        
        [CommHelp setTabBarItem:appraisePage.tabBarItem
                          title:@"鉴定·回收"
                  withTitleSize:11
                    andFoneName:@"Marion-Italic"
                  selectedImage:@"appraisal_newtable_select"
                 withTitleColor:kColor222
                unselectedImage:@"appraisal_newtable_nomal"
                 withTitleColor:kColor222];
        
//        [CommHelp setTabBarItem:appraisePage.tabBarItem
//                          title:@"鉴定·回收"
//                  withTitleSize:11
//                    andFoneName:@"Marion-Italic"
//                  selectedImage:@"appraisal_newtable_select"
//                 withTitleColor:kColor222
//                unselectedImage:@"appraisal_newtable_nomal"
//                 withTitleColor:kColor222];
        //角标
        [self.appraiseTagImg removeFromSuperview];
        //首次显示(免费角标原来逻辑)
        if (![CommHelp checkTheDate:[[NSUserDefaults standardUserDefaults ] objectForKey:SHOWFREEAPPRAISELASTTIME]]) {
//            [self.tabBar addSubview:self.appraisalBtn]; // c2c 版本 隐藏该按钮
//            self.appraisalBtn.left = ScreenW - (ScreenW/self.tabBar.items.count)*1.5+8;
//            self.appraisalBtn.top = 3;
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
                 withTitleColor:kColor222];
    }
    NSInteger num = kTabDefaultTag;
    for (UIControl *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            tabBarButton.tag = num;
            num++;
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
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

- (UILabel *)tipLabel
{
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

-(UIButton*)appraisalBtn
{
    if (!_appraisalBtn) {
        _appraisalBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 15)];
        [_appraisalBtn setTitle:@"免费" forState:UIControlStateNormal];
        [_appraisalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _appraisalBtn.titleLabel.font=[UIFont systemFontOfSize:10];
        _appraisalBtn.backgroundColor=[CommHelp toUIColorByStr:@"#ff4200"];
        _appraisalBtn.layer.cornerRadius = 8;
        [_appraisalBtn bringSubviewToFront:self.tabBar];
    }
    return _appraisalBtn;
}

#pragma mark - red point
- (BOOL)isShowRedPoint {
    
    NSInteger n = [[NSUserDefaults standardUserDefaults] integerForKey:@"firstNew"];
    self.tipLabel.hidden = n;
    return !n;
}

- (void)setHideRedPoint {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstNew"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - set & event
- (void)setTableSelectIndex:(NSUInteger)tableSelectIndex
{
    _tableSelectIndex=tableSelectIndex;
    self.selectedIndex=_tableSelectIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    //self.lastSelectIndex = selectedIndex; //hutao--change
    if(selectedIndex == 3) {
        [self.appraisalBtn setHidden:YES];
    }
}

- (CGFloat)currentItemX:(NSInteger)index
{
    //当item有五个的时候，每一个item的宽度是屏幕的1/15
    CGFloat offsetRight = (3.0*(index+1)-2.0)*ScreenWidth/(self.tabBar.items.count*3);
    offsetRight += ScreenWidth/15.0;
    return offsetRight;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if(viewController == appraisePage)
    {
        [self.appraiseTagImg setImage:[UIImage imageNamed:@"celebrate_tabbar_appraise_select_tag"]];
    }
    else
    {
        [self.appraiseTagImg setImage:[UIImage imageNamed:@"celebrate_tabbar_appraise_normal_tag"]];
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"selectIndex = %lu", (unsigned long)tabBarController.selectedIndex);
    if (tabBarController.selectedIndex == self.lastSelectIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TableBarSelectNotifaction object:tabBarController];
    }
    [self trackUserProfileLastIndex:self.lastSelectIndex currentIndex:tabBarController.selectedIndex]; //用户画像浏览时长
    self.lastSelectIndex = tabBarController.selectedIndex;

    NSUInteger index = tabBarController.selectedIndex;
    if (index == 0)
    {
        [self setCommunity:YES];
        [self setShop:NO];
        [self setSale:NO];
        [self setOnlineIdentification:NO];
        [self setPerCenter:NO];
        [JHAllStatistics jh_allStatisticsWithEventId:@"tabClick" params:@{@"tab_name" : @"宝友集市"} type:JHStatisticsTypeSensors];
    }
    else if (index == 1)
    {
        [self setCommunity:NO];
        [self setShop:YES];
        [self setSale:NO];
        [self setOnlineIdentification:NO];
        [self setPerCenter:NO];
        [JHAllStatistics jh_allStatisticsWithEventId:@"tabClick" params:@{@"tab_name" : @"源头直购"} type:JHStatisticsTypeSensors];
    }
    else if (index == 2)
    {
        [self setCommunity:NO];
        [self setShop:NO];
        [self setSale:YES];
        [self setOnlineIdentification:NO];
        [self setPerCenter:NO];
        [JHGrowingIO trackEventId:@"home_switch_tab" variables:@{@"index" : @"4"}];
        [JHNewStoreHomeReport jhNewStoreHomeTabBarItemClickReport:@"导航"];
        
    }
    else if (index == 3)
    {
        [self setCommunity:NO];
        [self setShop:NO];
        [self setSale:NO];
        [self setOnlineIdentification:YES];
        [self setPerCenter:NO];
        [JHAllStatistics jh_allStatisticsWithEventId:@"tabClick" params:@{@"tab_name" : @"在线鉴定"} type:JHStatisticsTypeSensors];
    }
    else if (index == 4)
    {
        [self setCommunity:NO];
        [self setShop:NO];
        [self setSale:NO];
        [self setOnlineIdentification:NO];
        [self setPerCenter:YES];
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"tabClick" params:@{@"tab_name" : @"个人中心"} type:JHStatisticsTypeSensors];
    }
    
    NSUInteger currentIndex = index;
    
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    
    //埋点：切换tab
    NSString *indexStr = @"";
    if (currentIndex == 0) {
        indexStr = @"社区";
    } else if (currentIndex == 1) {
        indexStr = @"卖场";
    } else if (currentIndex == 2) {
        indexStr = @"天天商城";
    } else if (currentIndex == 3) {
        indexStr = @"鉴定";
    } else if (currentIndex == 4) {
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

#pragma mark - NIMLoginManagerDelegate
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
    
    [JHRootController logoutAccountData];
    // [[NTESServiceManager sharedManager] destory];
    //    [[NTESLoginManager sharedManager] setCurrentNTESLoginData:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //修复alert错位问题
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"下线通知" message:reason preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:true completion:nil];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert showAlertWithCompletionHandler:nil];
    });
}

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
    
    [JHRootController logoutAccountData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //修复
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"下线通知" message:reason preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:true completion:nil];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert showAlertWithCompletionHandler:nil];
    });
}

+ (CAAnimationGroup *)animationGroup {
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.removedOnCompletion = YES;
    group.duration = 1.5;
    group.repeatCount = 2;
    CGFloat value = M_PI/8.f;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(-value), @(0)];
    anim.duration = 0.05;
    anim.beginTime = 1;
    anim.repeatCount = 1;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *anim1 = [CAKeyframeAnimation animation];
    anim1.keyPath = @"transform.rotation";
    anim1.values = @[@(value), @(0)];
    anim1.duration = 0.05;
    anim1.beginTime = 1;
    anim1.repeatCount = 1;
    anim1.removedOnCompletion = NO;
    anim1.fillMode = kCAFillModeForwards;
    
    [group setAnimations:[NSArray arrayWithObjects:anim,anim1, nil]];
    
    return group;
}

-(void)tabBarButtonClick:(UIControl *)tabBarButton
 {
    for (UIImageView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.duration = 0.2;
            animation.repeatCount = 1;
            animation.fromValue = [NSNumber numberWithFloat:0.7];
            animation.toValue = [NSNumber numberWithFloat:1];
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

- (void)trackUserProfileLastIndex:(NSInteger)lastIndex currentIndex:(NSInteger)currentIndex
{
    switch (lastIndex)
    {
        case JHHomeTabTypeSourceMall:
            [storePage trackUserProfilePage:NO];
            break;
            
        case JHHomeTabTypeCommunity:
            [homeAllPage trackUserProfilePage:NO];
            break;
        
        case JHHomeTabTypeAppraise:
            [appraisePage trackUserProfilePage:NO];
            break;
            
        default:
            break;
    }
    
    switch (currentIndex)
    {
        case JHHomeTabTypeSourceMall:
            [storePage trackUserProfilePage:YES];
            break;
            
        case JHHomeTabTypeCommunity:
            [homeAllPage trackUserProfilePage:YES];
            break;
        
        case JHHomeTabTypeAppraise:
            [appraisePage trackUserProfilePage:YES];
            break;
            
        default:
            break;
    }
}


- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (void)tapBackViewMethod:(UITapGestureRecognizer *)gesture
{
    [self setViewAnimation:gesture.view.tag];
    
    self.selectedIndex = gesture.view.tag;
    
    if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [self.delegate tabBarController:self didSelectViewController:self.tabBarController.childViewControllers[gesture.view.tag]];
    }
}

- (void)setViewAnimation:(NSInteger)tag
{    
    if (tag == 0)
    {
        [self tapTabBarView:self.communityView];
    }
    else if (tag == 1)
    {
        [self tapTabBarView:self.shopView];
    }
    else if (tag == 2)
    {
        [self tapTabBarView:self.saleView];
    }
    else if (tag == 3)
    {
        [self tapTabBarView:self.onlineView];
    }
    else
    {
        [self tapTabBarView:self.perView];
    }
}
- (UIButton *)toTopButton {
    if(!_toTopButton) {
        CGFloat w = ScreenW / 5.f;
        _toTopButton = [UIButton jh_buttonWithImage:@"my_newtable_totop" target:self action:@selector(toTopMethod) addToSuperView:self.tabBar];
        
//        JHSkinModel *model = [JHSkinManager top];
//        if (model.isChange) {
//            if ([model.type intValue] == 0) {
//                UIImage *image = [JHSkinManager getTopImage];
//                [_toTopButton setImage:image forState:UIControlStateNormal];
//            }
//        }
        
        _toTopButton.frame = CGRectMake(w, 0, w, 49.f);
        _toTopButton.backgroundColor = [UIColor whiteColor]; // APP_BACKGROUND_COLOR;
        _toTopButton.jh_title(@"返回顶部").jh_titleColor(RGB(34,34,34)).jh_fontNum(11);
        [_toTopButton setTitleEdgeInsets:UIEdgeInsetsMake(15, -12.5, -15, 12.5)];
        [_toTopButton setImageEdgeInsets:UIEdgeInsetsMake(-7, 23, 7, -23)];
    }
    return _toTopButton;
}

/// 不显示 -1
- (void)changeToTopButtonIndex:(NSInteger)index {
    
    if(index >= 0 && index <= 4) {
        self.toTopButton.hidden = NO;
        CGFloat w = ScreenW / 5.f;
        self.toTopButton.frame = CGRectMake(w * index, 0, w, 49.f);
    }
    else {
        self.toTopButton.hidden = YES;
    }
}

+ (void)setSubScrollView:(UIScrollView *)subScrollView {
    
    if(subScrollView && ([subScrollView isKindOfClass:[UIScrollView class]] || [subScrollView isKindOfClass:[UICollectionView class]] || [subScrollView isKindOfClass:[UITableView class]]))
    {
        JHRootController.homeTabController.subScrollView = subScrollView;
    }
}

/// 返回顶部
/// @param scrollView 二级 scrollView
/// @param index 第几个 tabbar
+ (void)changeStatusWithMainScrollView:(UIScrollView * __nullable)scrollView
                             index:(NSInteger)index {
    [self changeStatusWithMainScrollView:scrollView index:index hasSubScrollView:NO];
}

/// 返回顶部
/// @param mainScrollView 主 mainScrollView
/// @param index 第几个 tabbar
/// @param hasSubScrollView 是否有子scrollView
+ (void)changeStatusWithMainScrollView:(UIScrollView * __nullable)mainScrollView
                             index:(NSInteger)index
                  hasSubScrollView:(BOOL)hasSubScrollView {
    
    JHHomeTabController *vc = JHRootController.homeTabController;
    if(mainScrollView && ([mainScrollView isKindOfClass:[UIScrollView class]] || [mainScrollView isKindOfClass:[UICollectionView class]] || [mainScrollView isKindOfClass:[UITableView class]]))
    {
        vc.mainScrollView = mainScrollView;
        if(!hasSubScrollView) {
            vc.subScrollView = nil;
        }
        if(mainScrollView.contentOffset.y > 100) {
            [vc changeToTopButtonIndex:index];
        } else {
            [vc changeToTopButtonIndex:-1];
        }
    }
    else {
        [vc changeToTopButtonIndex:-1];
    }
}

- (void)toTopMethod {
    if (self.subScrollView && ([self.subScrollView isKindOfClass:[UIScrollView class]] || [self.subScrollView isKindOfClass:[UICollectionView class]] || [self.subScrollView isKindOfClass:[UITableView class]])) {
        [self.subScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
    if (self.mainScrollView && ([self.mainScrollView isKindOfClass:[UIScrollView class]] || [self.mainScrollView isKindOfClass:[UICollectionView class]] || [self.mainScrollView isKindOfClass:[UITableView class]])) {
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if ([JHMarketHomeViewController has:self.mainScrollView.superview.viewController]) {
        JHMarketHomeViewController *vc = (JHMarketHomeViewController *)self.mainScrollView.superview.viewController;
        vc.cannotScroll = NO;
        [vc subScrollViewDidScrollToTop];
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if ([JHNewStoreHomeViewController has:self.mainScrollView.superview.viewController]) {
        [JHNewStoreHomeReport jhNewStoreHomeTabBarItemClickReport:@"返回顶部"];
        /// 新版商城滚动到最顶部按钮点击
        if(self.subScrollView && ([self.subScrollView isKindOfClass:[UIScrollView class]] || [self.subScrollView isKindOfClass:[UICollectionView class]] || [self.subScrollView isKindOfClass:[UITableView class]])) {
            storeList.cannotScroll = YES;
            [storeList subScrollViewDidScrollToTop];
            [self.subScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        if (self.mainScrollView && ([self.mainScrollView isKindOfClass:[UIScrollView class]] || [self.mainScrollView isKindOfClass:[UICollectionView class]] || [self.mainScrollView isKindOfClass:[UITableView class]])) {
            storeList.cannotScroll = NO;
            [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

        }
    }
}

- (YYAnimatedImageView *)txtNewImgv{
    if (!_txtNewImgv) {
        YYImage *image = [YYImage imageNamed:@"tabMarket.gif"];
        _txtNewImgv = [[YYAnimatedImageView alloc]initWithImage:image];
        _txtNewImgv.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _txtNewImgv;
}

- (void)addTxtNewAnimation{
    //创建动画
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI)];//度数转弧度
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.3;
    keyAnimaion.repeatCount = MAXFLOAT;
    [self.txtNewImgv.layer addAnimation:keyAnimaion forKey:nil];
}

@end

