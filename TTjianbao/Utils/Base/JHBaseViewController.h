//
//  JHBaseViewController.h
//  TTjianbao
//  Description:默认views>jhNavView+jhTitleLabel+jhLeftButton【nav controllers > 1】
//  Created by apple on 2019/12/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


//NS_ASSUME_NONNULL_BEGIN

@interface JHBaseViewController : UIViewController

@property (nonatomic, strong) UIImageView *jhNavView;
@property (nonatomic, strong) UILabel *jhTitleLabel;
@property (nonatomic, strong) UIButton *jhLeftButton;
@property (nonatomic, strong) UIButton *jhRightButton;
@property (nonatomic, strong) UIView *jhNavBottomLine;
///状态栏隐藏
@property (nonatomic, assign) BOOL jhStatusHidden;
@property (nonatomic, assign) UIStatusBarStyle jhStatusBarStyle;
//显示nav
- (void)showNavView;
//移除nav
- (void)removeNavView;
- (void)initLeftButton;
- (void)initLeftButtonWithName:(NSString *)name  action:(SEL)action;
- (void)initLeftButtonWithImageName:(NSString *)imageName action:(SEL)action;
- (void)initRightButtonWithName:(NSString *)name action:(SEL)action;
- (void)initRightButtonWithImageName:(NSString *)imageName action:(SEL)action;
- (void)backActionButton:(UIButton *)sender;
- (void)rightActionButton:(UIButton *)sender;
- (void)jhSetLightStatusBarStyle;
- (void)jhSetBlackStatusBarStyle;
- (void)jhBringSubviewToFront;

//MARK: 埋点-扩展创建页面（进入页面的参数）
- (NSMutableDictionary*)growingGetCreatePageParamDict;
//埋点：扩展浏览时长参数
- (void)growingSetParamDict:(NSDictionary*)paramDict;
//扩展方法:很无奈的方式
- (void)growingArticleBrowseWithStartTime:(NSTimeInterval)startTime;
/** 上报停留时长*/
- (void)growingWithTrackEventId:(NSString *)trackEventId dict:(NSDictionary *)dict;

@end

//NS_ASSUME_NONNULL_END
