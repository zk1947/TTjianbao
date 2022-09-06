//
//  JHServiceCenter.m
//  TTjianbao
//
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHServiceCenter.h"
#import "JHLiveAnimationView.h"
#import "NTESLiveManager.h"
#import "NTESAnchorPreviewController.h"
#import "JHNormalLivePreviewController.h"
#import "ChannelMode.h"
#import "UserInfoRequestManager.h"
#import "BaseNavViewController.h"

@interface JHServiceCenter ()
 ///是不是闪屏广告过后？是,则可以显示开播按钮「这个布尔值反着用,避免赋值后被改变」
@property (nonatomic, assign) BOOL mayHideStartLiveButton;
@property (nonatomic, strong) JHLiveAnimationView *animationView;
@end

@implementation JHServiceCenter

- (instancetype)init
{
    if(self = [super init])
    {
        self.mayHideStartLiveButton = YES;
    }
    return self;
}

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
            make.bottom.mas_equalTo(-UI.bottomSafeAreaHeight - UI.tabBarHeight-29);
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
    [self sa_tracking_liveClick];
    UIViewController *viewController = [JHRootController currentViewController];
    User *user = [UserInfoRequestManager sharedInstance].user;
    [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeVideo;
    [NTESLiveManager sharedInstance].liveQuality = NTESLiveQualityHigh;
    if (user.blRole_appraiseAnchor) {
        NTESAnchorPreviewController *vc = [[NTESAnchorPreviewController alloc]init];
        vc.anchorLiveType = JHAnchorLiveAppraiseType;
        [viewController.navigationController presentViewController:vc animated:YES completion:nil];
    }
   else if (user.blRole_customize) {
           NTESAnchorPreviewController *vc = [[NTESAnchorPreviewController alloc]init];
           vc.anchorLiveType = JHAnchorLiveCustomizeType;
           [viewController.navigationController presentViewController:vc animated:YES completion:nil];
       }
   else if (user.blRole_recycle) {
           NTESAnchorPreviewController *vc = [[NTESAnchorPreviewController alloc]init];
           vc.anchorLiveType = JHAnchorLiveRecycleType;
           [viewController.navigationController presentViewController:vc animated:YES completion:nil];
       }
    //直播卖货
    else  if ( user.blRole_saleAnchor||
              user.blRole_restoreAnchor||
              user.blRole_communityAndSaleAnchor) {
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
    newCenter.y = MAX(recognizer.view.frame.size.height/2+UI.topSafeAreaHeight, newCenter.y);
    newCenter.y = MIN(ScreenH - recognizer.view.frame.size.height/2 - UI.topSafeAreaHeight - UI.bottomSafeAreaHeight,  newCenter.y);
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
- (BOOL)isNeedShowLiveBtn
{
    if (![JHRootController isLogin])
    { ///未登录 隐藏
        return NO;
    }
    else
    {
        UIViewController* currentController = [JHRootController currentViewController];
        NSString *vcName = NSStringFromClass([currentController class]);
        NSLog(@"currentViewController:--- %@",vcName);
        NSInteger count = [[currentController.navigationController childViewControllers] count];
        //有点重复,双保险
        if ([vcName isEqualToString:@"JHRootViewController"] || (count <= 1 && !(currentController.presentingViewController)))
        {
            User *user = [UserInfoRequestManager sharedInstance].user;
            if (user.blRole_appraiseAnchor) {
                ///判断是否显示直播入口
                    BOOL isSeller = ![JHUserDefaults boolForKey:JHUSERDEFAULT_SWITCH_KEY];
                    return isSeller;
            }
            if ((user.blRole_saleAnchor ||
                user.blRole_communityAndSaleAnchor||
                user.blRole_restoreAnchor||
                user.blRole_customize||
                user.blRole_recycle) && [UserInfoRequestManager sharedInstance].user.isCanOpenChannel)
            {  ///判断是否显示直播入口
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

- (void)checkStartLiveButton
{
    //是不是闪屏广告过后？是,则可以显示开播按钮
    if(!self.mayHideStartLiveButton)
    {
        if ([self isNeedShowLiveBtn])
        {///isCanOpenChannel ==  YES 可以开始直播
            [self showLiveView];
        }
        else
        {
            [self hiddenLiveView];
        }
    }
}


- (void)willShowStartLiveButton:(BOOL)isShow
{
    if(isShow)
    {
        //延迟显示直播按钮
        self.mayHideStartLiveButton = NO;
        //是不是闪屏广告过后？是,则可以显示开播按钮
        [self checkStartLiveButton];
    }
    else
    {
        [self hiddenLiveView];
    }
}

- (void)sa_tracking_liveClick{
    NSString * page_position = @"文玩社区";
    switch ([JHRootController tabBarSelectedIndex]) {
        case 0:
            page_position = @"文玩社区";
            break;
        case 1:
            page_position = @"源头直购";
            break;
        case 2:
            page_position = @"天天商城";
            break;
        case 3:
            page_position = @"在线鉴定";
            break;
        case 4:
            page_position = @"个人中心";
            break;
            
        default:
            break;
    }
    
    [JHTracking trackEvent:@"liveClick" property:@{@"page_position":page_position}];
}
@end
