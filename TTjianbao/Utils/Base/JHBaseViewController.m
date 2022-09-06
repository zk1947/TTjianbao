//
//  JHBaseViewController.m
//  TTjianbao
//
//  Created by apple on 2019/12/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "GrowingManager.h"
#import "JHWebImage.h"
#import <YDCategoryKit/YDCategoryKit.h>
#import "PanNavigationController.h"

static CGFloat NavButtonW = 60.f;
static CGFloat TitleSize = 15.f;
static CGFloat MainTitleSize = 18.f;

@interface JHBaseViewController ()
@property (nonatomic, assign) UIStatusBarAnimation jh_statusBarUpdateAnimation;
//进入界面时间戳
@property (nonatomic, assign) NSTimeInterval jh_enterTime;
@property (nonatomic, strong) NSMutableDictionary *growingInfoDict;
@end

@implementation JHBaseViewController

- (void)dealloc{
    NSLog(@"🔥dealloc－－－－%@",self.class);
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showNavView];
    
    ///页面被创建埋点
    NSMutableDictionary* dic = [self growingGetCreatePageParamDict];
    [GrowingManager appViewControllerCreate:dic];
    
    if ([self.navigationController isKindOfClass:[PanNavigationController class]]) {
        PanNavigationController *nav = (PanNavigationController *)self.navigationController;
        nav.isForbidDragBack = NO;
        [nav setShouldReceiveTouchViewController:nil];
    }
    
    if (@available(iOS 11.0, *))
    {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    NSLog(@"进入*****************%@",[self class]);
    
    if (self.title) {
        self.title = self.title;
    }
    
    // 设置允许摇一摇功能:切换环境
#ifdef DEBUG
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    ///进入界面的时间
    self.jh_enterTime = [YDHelper get13TimeStamp].longLongValue;
    ///页面被展示埋点
    NSString * vcName = NSStringFromClass([self class]);
    [GrowingManager appViewWillAppear:@{@"page_name":vcName, @"page_full_name":@""}];

    //开播按钮检查
    [JHRootController.serviceCenter checkStartLiveButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    ///页面被关闭埋点
    NSString * vcName = NSStringFromClass([self class]);
    [GrowingManager appViewControllerClose:@{@"page_name":vcName, @"page_full_name":@""}];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    ///浏览时长埋点
    [self growingArticleBrowse];
    //开播按钮检查
    [JHRootController.serviceCenter checkStartLiveButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [JHWebImage clearCacheMemory];
}

#pragma mark - track
//埋点：扩展创建页面（进入页面的参数）
- (NSMutableDictionary*)growingGetCreatePageParamDict
{
    NSString * vcName = NSStringFromClass([self class]);
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:vcName forKey:@"page_name"];
    [dic setValue:@"" forKey:@"page_full_name"];
    return dic;
}
//埋点：浏览时长
- (void)growingArticleBrowse {
    NSLog(@"baseviewcontroller:-------,%@", NSStringFromClass([self class]));

    [self growingArticleBrowseWithStartTime:self.jh_enterTime];
}

- (void)growingArticleBrowseWithStartTime:(NSTimeInterval)startTime
{
    NSTimeInterval outTime = [YDHelper get13TimeStamp].longLongValue;
    NSDate *enterDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:outTime];
    NSTimeInterval duration = [outDate timeIntervalSinceDate:enterDate];
    [self.growingInfoDict addEntriesFromDictionary:@{@"duration":@(duration)}];
    [JHNotificationCenter postNotificationName:JHGrowingNotify_AllPageBrowseDuration object:nil userInfo:self.growingInfoDict];
}

- (void)growingWithTrackEventId:(NSString *)trackEventId dict:(NSDictionary *)dict{
    NSTimeInterval outTime = [YDHelper get13TimeStamp].longLongValue;
    NSDate *enterDate = [NSDate dateWithTimeIntervalSince1970:self.jh_enterTime];
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:outTime];
    NSTimeInterval duration = [outDate timeIntervalSinceDate:enterDate];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    param[@"duration"] = @(duration);
    [JHGrowingIO trackEventId:trackEventId variables:param];
}

//埋点：扩展浏览时长参数
- (void)growingSetParamDict:(NSDictionary*)paramDict
{
    if(paramDict)
    {
        [self.growingInfoDict addEntriesFromDictionary:paramDict];
    }
    else
    {
        [self growingInfoDict];
    }
}

- (NSMutableDictionary *)growingInfoDict
{
    if(!_growingInfoDict)
    {
        _growingInfoDict = [NSMutableDictionary dictionary];
    }
    return _growingInfoDict;
}

#pragma mark --------------- action ---------------
- (void)backActionButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightActionButton:(UIButton *)sender
{
    
}

#pragma mark --------------- method ---------------
-(void)jhBringSubviewToFront
{
    [self.view bringSubviewToFront:self.jhNavView];
}

- (void)jhSetLightStatusBarStyle
{
    self.jhLeftButton.jh_imageName(@"navi_icon_back_white");
    self.jhTitleLabel.textColor = [UIColor whiteColor];
    self.jhStatusBarStyle = UIStatusBarStyleLightContent;
}

- (void)jhSetBlackStatusBarStyle
{
    self.jhLeftButton.jh_imageName(@"navi_icon_back_black");
    self.jhTitleLabel.textColor = [UIColor blackColor];
    self.jhStatusBarStyle = UIStatusBarStyleDefault;
}

- (void)setJhStatusBarStyle:(UIStatusBarStyle)jhStatusBarStyle
{
    _jhStatusBarStyle = jhStatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.jhStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return _jhStatusHidden;
}

- (void)setJhStatusHidden:(BOOL)jhStatusHidden {
    _jhStatusHidden = jhStatusHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)initLeftButtonWithName:(NSString *)name  action:(SEL)action
{
    if (_jhLeftButton) {
        [_jhLeftButton removeFromSuperview];
    }
    
    self.jhLeftButton.titleLabel.font = [UIFont systemFontOfSize:TitleSize];
    [_jhLeftButton setTitle:name forState:UIControlStateNormal];
    [_jhLeftButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.jhNavView addSubview:_jhLeftButton];
    [_jhLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.jhNavView);
        make.size.mas_equalTo(CGSizeMake(NavButtonW, UI.navBarHeight));
    }];
}

- (void)initLeftButton
{
    [self initLeftButtonWithImageName:@"navi_icon_back_black" action:@selector(backActionButton:)];
}

- (void)initLeftButtonWithImageName:(NSString *)imageName action:(SEL)action
{
    if (_jhLeftButton) {
        [_jhLeftButton removeFromSuperview];
    }
    
    [self.jhLeftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_jhLeftButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.jhNavView addSubview:_jhLeftButton];
    [_jhLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.jhNavView);
        make.size.mas_equalTo(CGSizeMake(NavButtonW, UI.navBarHeight));
    }];
}

- (void)initRightButtonWithName:(NSString *)name action:(SEL)action
{
    if (_jhRightButton) {
        [_jhRightButton removeFromSuperview];
    }
    
    [self.jhRightButton setTitle:name forState:UIControlStateNormal];
    [_jhRightButton setTitleColor:RGB515151 forState:UIControlStateNormal];
    [_jhRightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.jhNavView addSubview:_jhRightButton];
    [_jhRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.jhNavView);
        make.size.mas_equalTo(CGSizeMake(NavButtonW, UI.navBarHeight));
    }];
}

- (void)initRightButtonWithImageName:(NSString *)imageName action:(SEL)action
{
    if (_jhRightButton) {
        [_jhRightButton removeFromSuperview];
    }
    
    [self.jhRightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_jhRightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.jhNavView addSubview:_jhRightButton];
    [_jhRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.jhNavView);
        make.size.mas_equalTo(CGSizeMake(NavButtonW, UI.navBarHeight));
    }];
}
//显示nav
- (void)showNavView
{
    //整个navView
    [self.view addSubview:self.jhNavView];
    [self.jhNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(UI.statusAndNavBarHeight);
    }];
    self.jhNavView.userInteractionEnabled = YES;
    //title
    [self.jhNavView addSubview:self.jhTitleLabel];
    [self.jhTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jhNavView);
        make.bottom.equalTo(self.jhNavView);
        make.height.mas_equalTo(UI.navBarHeight);
        make.width.mas_lessThanOrEqualTo(ScreenW -150);
    }];
    //left button
    if (self.navigationController.viewControllers.count > 1) {
        [self initLeftButtonWithImageName:@"navi_icon_back_black" action:@selector(backActionButton:)];
    }
}
//移除nav
- (void)removeNavView
{
    self.jhLeftButton = nil;
    self.jhRightButton = nil;
    self.jhTitleLabel = nil;
    self.jhNavBottomLine = nil;
    [self.jhNavView removeFromSuperview];
    self.jhNavView = nil;
}

#pragma mark --------------- get & set ---------------
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.jhTitleLabel.text = title;
}

- (UIImageView *)jhNavView
{
    if(!_jhNavView)
    {
        _jhNavView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _jhNavView.backgroundColor = [UIColor whiteColor];
    }
    return _jhNavView;
}

- (UILabel *)jhTitleLabel
{
    if(!_jhTitleLabel)
    {
        _jhTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _jhTitleLabel.backgroundColor = [UIColor clearColor];
        _jhTitleLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        _jhTitleLabel.font = [UIFont boldSystemFontOfSize:MainTitleSize];
        _jhTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _jhTitleLabel;
}

- (UIButton *)jhLeftButton
{
    if(!_jhLeftButton)
    {
        _jhLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jhLeftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _jhLeftButton;
}

- (UIButton *)jhRightButton
{
    if(!_jhRightButton)
    {
        _jhRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _jhRightButton.titleLabel.font = [UIFont systemFontOfSize:TitleSize];
    }
    return _jhRightButton;
}

- (UIView *)jhNavBottomLine
{
    if (!_jhNavBottomLine) {
        
        _jhNavBottomLine = [UIView new];
        [_jhNavView addSubview: self.jhNavBottomLine];
        _jhNavBottomLine.backgroundColor = HEXCOLOR(0xF5F6FA);//RGB(238, 238, 238);
        [_jhNavBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.jhNavView);
            make.height.mas_equalTo(1.0);
        }];
    }
    return _jhNavBottomLine;
}

@end
