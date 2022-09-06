//
//  AppDelegate.m
//  TTjianbao
//
//  Created by jiangchao on 2018/11/7.
//  Copyright © 2018 jiangchao. All rights reserved.
//
#import "AppDelegate.h"
#import "AppDelegate+push.h"
#import "AppDelegate+pullApp.h"
#import "AppDelegate+thirdRegister.h"
#import "AppDelegate+checkNet.h"
#import "UIConstManager.h"
#import "JHFilterBoxView.h"
#import "JHASAManager.h"
#import "JHAuthorize.h"
#import "JHLiveActivityManager.h"
#import "JHSkinSceneManager.h"
#import "JHWebView.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"TTjianbao app~冷启动~finishLaunching");
    //set window root
    UIWindow* windowExt = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [windowExt makeKeyAndVisible];
    //界面常量类初始化
    [UIConstManager shareManager];

    [JHRootController didLaunchWithOptions:launchOptions window:&windowExt];
    self.window = windowExt;
    //注册&初始化
    [self launchingRegisterThirdWithOptions:launchOptions];
    [self launchingRegisterPullAppOptions:launchOptions];
    // 检查网络权限
    [self checkInternetPermission];
    /// 获取归因数据包
    [[JHASAManager sharedManager] asaAttribution];
    [JHAuthorize sharedManager];
    // 提前设置 userAgent - H5需要判断天天鉴宝 环境 有的机型 有时间差，导致H5获取TOKEN 时 拿不到自定义 userAgent
    JHWebView *webView = [JHWebView new];
    [webView setUserAgent];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    [self ttJianbaoWillResignActive:application];
    [[JHLiveActivityManager sharedManager] stopCountDown];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"TTjianbao app~热启动~becomeActive");
    [self ttJianbaoDidBecomeActive:application];
    [[JHLiveActivityManager sharedManager] restartCountDown];
    [[JHSkinSceneManager shareManager] loadData];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"TTjianbao app~WillTerminate");
    [self ttJianbaoWillTerminate:application];
    
    [JHFilterBoxView clearRecord];
}

///程序即将进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"TTjianbao app~WillEnterForeground");
    [self ttJianbaoWillEnterForeground:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"TTjianbao app~DidEnterBackground");
    [self ttJianbaoDidEnterBackground:application];
}

/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // 可以这么写
    if (self.allowOrentitaionRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
