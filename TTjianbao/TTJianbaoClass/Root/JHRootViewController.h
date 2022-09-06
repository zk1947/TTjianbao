//
//  JHRootViewController.h
//  TTjianbao
//  Description:项目唯一根,RootViewController
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewController.h"
#import "JHServiceCenter.h"
#import "JHHomeTabController.h"

//NS_ASSUME_NONNULL_BEGIN

@interface JHRootViewController : JHBaseViewController

singleton_h(JHRootViewController)

///ttjb服务中心处理特殊事件
@property (nonatomic, strong) JHServiceCenter* serviceCenter;
@property (nonatomic, strong) JHHomeTabController* homeTabController; //tab for rootView
@property (nonatomic, strong) NSMutableArray* navViewControllers;
@property (nonatomic, copy) JHFinishBlock bindWxBlock;
///1:个人中心绑定微信 2:网页调起绑定微信
@property (nonatomic, copy) NSString *bindWxSource;

- (void)didLaunchWithOptions:(NSDictionary *)aLaunchOptions window:(UIWindow**)window;
- (void)setTabBarSelectedIndex:(NSUInteger)index;
- (void)popToSQHomePageController;
- (NSUInteger)tabBarSelectedIndex;
- (UIViewController *)currentViewController;
- (NSMutableArray *)getLocalChannelData:(NSString *)channelType;
- (UIViewController *)tabControllerWithIndex:(NSUInteger)index;
- (void)gotoPagesFromMsgRouter:(id)keyValues from:(NSString*)from;
@end

//NS_ASSUME_NONNULL_END
