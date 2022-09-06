//
//  JHRootViewController.m
//  TTjianbao
//
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRootViewController.h"
#import "JHRootViewController+TransitPage.h"
#import "JHRootViewController+Notification.h"
#import "JHLaunchGuideView.h"
#import "FileUtils.h"
#import "SVProgressHUD.h"
#import "BaseNavViewController.h"
#import "SourceMallApiManager.h"
#import "JHDiscoverChannelModel.h"

@interface JHRootViewController () <JHLaunchGuideViewDelegate>
{
    NSDictionary *launchOptions;
    /*懒加载导致一些初始化有点早,需要控制初始化homeTabController时间点
    *虽然没出现什么异常,dan按正常逻辑限制一下,viewDidLoad在加载
    */
}

@property (nonatomic, strong) JHLaunchGuideView* guideView;
@end

@implementation JHRootViewController

singleton_m(JHRootViewController)

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWXBind:) name:WXBINDSUSSNotifaction object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceivreNotification:) name:APNSNotifaction object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self removeNavView];
    //放在这里初始化,避免启动后,root没初始化好,tab先好了
    self.homeTabController = [JHHomeTabController new];

    //第一次启动
    BOOL firstLaunch = ![[NSUserDefaults standardUserDefaults] boolForKey:FIRSTLAUNCHCOMPLETE];
    if (firstLaunch)
    {
        [SourceMallApiManager deleteDataFromFiles];
//        [self.view addSubview:self.guideView];
//        [self.guideView showView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRSTLAUNCHCOMPLETE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self setupHomeViewController];

    if (!launchOptions)
    {
        [self.guideView showAlertFromFirstLaunch:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Service Center for external use
- (JHServiceCenter *)serviceCenter
{
    if(!_serviceCenter)
    {
        _serviceCenter = [JHServiceCenter new];
    }
    return _serviceCenter;
}

#pragma mark - sub view
//- (JHHomeTabController *)homeTabController
//{
//    if(!_homeTabController)
//    {
//        _homeTabController = [JHHomeTabController new];
//    }
//    return _homeTabController;
//}

- (JHLaunchGuideView *)guideView
{
    if(!_guideView)
    {
        _guideView = [[JHLaunchGuideView alloc] initWithFrame:self.view.frame];
        _guideView.delegate = self;
    }
    return _guideView;
}

#pragma mark - external methods
- (void)didLaunchWithOptions:(NSDictionary *)aLaunchOptions window:(UIWindow**)window
{
    launchOptions = aLaunchOptions;
    // AppDelegate 进行全局设置
     if (@available(iOS 11.0, *))
     {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    //create root navigationController
    BaseNavViewController* navigationController = [[BaseNavViewController alloc] initWithRootViewController:JHRootController];
    [navigationController setNavigationBarHidden:YES];
    ((UIWindow*)(*window)).rootViewController = navigationController;
}

- (void)setupHomeViewController
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [self.homeTabController homeSetup];
    [self.view addSubview:self.homeTabController.view];
    [self addChildViewController:self.homeTabController];
}

- (NSUInteger)tabBarSelectedIndex
{
    return self.homeTabController.selectedIndex;
}

- (void)setTabBarSelectedIndex:(NSUInteger)index
{
    [self.homeTabController setTableSelectIndex:index];
}

- (void)popToSQHomePageController
{
    [[JHRootController currentViewController].navigationController popToRootViewControllerAnimated:YES];
    [JHRootController setTabBarSelectedIndex:0];
    [JHNotificationCenter postNotificationName:kSQNeedSwitchToRcmdTabNotication object:nil];
}

- (NSMutableArray*)navViewControllers
{
    return [self.homeTabController.navigationController.viewControllers mutableCopy];
}

- (UIViewController *)tabControllerWithIndex:(NSUInteger)index
{
    NSMutableArray *array = [self.homeTabController.viewControllers mutableCopy];
    if (array.count > index) {
        return array[index];
    }
    return nil;
}

- (UIViewController *)currentViewController
{
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


#pragma mark - deeplink
- (void)gotoPagesFromMsgRouter:(id)keyValues from:(NSString*)from
{
    [self gotoPagesFromMessageDeepLink:keyValues from:from];
}

#pragma mark - Notification
- (void)onReceivreNotification:(NSNotification*)notify
{
    [self onReceivreNotify:notify];
}

- (void)onWXBind:(NSNotification*)notify
{
    [self WXBind:notify];
}

#pragma mark - external method
- (NSMutableArray *)getLocalChannelData:(NSString *)channelType
{//获取首次进入app时选择的频道数据
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

@end

