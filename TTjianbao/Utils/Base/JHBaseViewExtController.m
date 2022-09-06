//
//  JHBaseViewExtController.m
//  TaoDangPuMall
//
//  Created by jiangchao on 2016/12/26.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JHMessageViewController.h"
#import "JHUploadManager.h"
#import "TTjianbaoBussiness.h"
#import "JHMyCenterDotNumView.h"
#import "JHMessageCenterData.h"
#import "UIImage+GIF.h"
#import "MyLiveViewController.h"
#if DEBUG
#import "YDActionSheet.h"
#import "JHWebViewController.h"
#endif
#import "PanSwiper.h"
#import "JHMsgCenterModel.h"

@interface JHBaseViewExtController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) JHMyCenterDotNumView *msgCountLabel;

@property (nonatomic, assign) BOOL activityViewAppear;

@end

@implementation JHBaseViewExtController

- (instancetype)init {
    if(self = [super init]) {
        _activityViewAppear = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityImageAppear:) name:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    if (_msgCountLabel) {
        JH_WEAK(self)
        [self getAllUnreadMsgCount:^(id obj) {
            JH_STRONG(self)
            if([obj isKindOfClass:[NSString class]] && [(NSString *)obj length] > 0){
                self.msgCountLabel.number = [obj integerValue];
            }
        }];
    }
    ///设置取消上传
    [JHUploadManager shareInstance].isNeedCancelUpload = NO;
}

#pragma mark - subviews
-(void)showActivityImage{
    [self.view addSubview:self.activityImage];
    [self.activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-55);
        make.right.equalTo(self.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(65,90));
    }];
}

-(void)showBackTopImage{
    [self.view addSubview:self.backTopImage];
    [_backTopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-25);
        make.right.equalTo(self.view).offset(-17);
        make.size.mas_equalTo(CGSizeMake(32,32));
    }];
}

-(UIImageView*)activityImage{
    if (!_activityImage) {
        _activityImage=[[YYAnimatedImageView alloc]init];
        _activityImage.contentMode=UIViewContentModeScaleAspectFit;
        _activityImage.image=[UIImage imageNamed:@""];
        
        _activityImage.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActivityImage:)];
        [_activityImage addGestureRecognizer:singleTap];
        
    }
    return _activityImage;
}

-(UIImageView*)backTopImage{
    
    if (!_backTopImage) {
        _backTopImage=[[UIImageView alloc]init];
        _backTopImage.contentMode=UIViewContentModeScaleAspectFit;
        _backTopImage.image=[UIImage imageNamed:@"list_back_top_image"];
        _backTopImage.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTop:)];
        [_backTopImage addGestureRecognizer:singleTap];
        
    }
    return _backTopImage;
}

- (void)tapActivityImage:(id)sender{
    
    JHHomeActivityInfoMode * model=[UserInfoRequestManager sharedInstance].homeActivityMode.homeActivityIcon;
    
    NSDictionary *dic = model.target.params;
    if(IS_DICTIONARY(dic) && [dic valueForKey:@"urlString"])
    {
        NSString *url = [dic valueForKey:@"urlString"];
        if(IS_STRING(url))
        {
            NSRange range = [url rangeOfString:@"html"];
            url = [url substringFromIndex:range.location];
            [JHGrowingIO trackEventId:@"float_popup_click" variables:@{@"popup_name" : url}];
        }
    }
    
    [JHRootController toNativeVC:model.target.componentName withParam:model.target.params from:JHLiveFromh5];
    
    if (![self.className isEqualToString:@"JHStoreHomePageController"]) return;
    
    NSDictionary *dict = @{
        @"page_position" : @"直播间外页",
        @"spm_type" : @"浮窗",
        @"content_url" : model.target.recordComponentName ?: @"",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSpm" params:dict type:JHStatisticsTypeSensors];
}

- (void)showImageName:(NSString *)imageName title:(NSString *)string superview:(UIView *)view
{
    [view addSubview:self.imageView];
    [view addSubview:self.label];
    self.imageView.hidden = NO;
    self.label.hidden = NO;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
    self.label.text = string;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY).offset(-70);
        make.centerX.equalTo(view.mas_centerX);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.imageView.mas_centerX);
    }];
}
- (void)setDefaultImageOffset:(CGFloat)offset andView:(UIView *)sView{
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sView.mas_centerY).offset(offset);
    }];
}
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:18];
        _label.textColor = HEXCOLOR(0xa7a7a7);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)showDefaultImageWithView:(UIView *)superView {
    [self showImageName:@"img_default_page" title:@"暂无数据~" superview:superView];
}

- (void)hiddenDefaultImage {
    _imageView.hidden = YES;
    _label.hidden = YES;
}
/**
 上拉加载 下拉刷新
 
 @param scrolle tableView
 @param target target
 @param refresh_selector refresh_selector
 @param loadmore_selector loadmore_selector
 */
- (void)setupScrollView:(UIScrollView *)scrollView
                 target:(id)target
            refreshData:(SEL)refresh_selector
           loadMoreData:(SEL)loadmore_selector
{
    if (refresh_selector) {
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:refresh_selector];
        header.automaticallyChangeAlpha = YES;
        scrollView.mj_header = header;
        [scrollView bringSubviewToFront:scrollView.mj_header];
    }
    
    if (loadmore_selector) {
        //加载更多
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:loadmore_selector];
        //footer.stateLabel.hidden = YES;//隐藏刷新状态的文字
        //让加载的底部文字不显示，并且加载圈居中显示
        footer.labelLeftInset = 0.0f;
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        footer.hidden = YES;
        
        footer.triggerAutomaticallyRefreshPercent = -5;//-1在快划到底部44px的时候就会自动刷新。
        footer.automaticallyRefresh = YES;//是否自动刷新(默认为YES)
        footer.autoTriggerTimes = YES;
        scrollView.mj_footer = footer;
    }
}

- (JHMyCenterDotNumView *)msgCountLabel {
    if (!_msgCountLabel) {
        _msgCountLabel = [JHMyCenterDotNumView new];
        _msgCountLabel.number = 0;
    }
    return _msgCountLabel;
}

- (void)getAllUnreadMsgCount:(JHActionBlock)response {
    
    [JHMessageCenterData requestUnreadMessage:^(id obj, id data) {
        JHMsgCenterUnreadModel* noreadModel = (JHMsgCenterUnreadModel*)obj;
        NSInteger count = [JHQYChatManage unreadMessage];
        NSInteger total = noreadModel.total + count;

        response(@(total).stringValue);
    }];
}

- (UIButton *)createAddMsgBtn {
    UIButton *msg = [[UIButton alloc] init];
    [msg setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
    msg.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //  msg.backgroundColor=[UIColor redColor];
    [msg addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
    msg.frame = CGRectMake(ScreenW-40, UI.statusBarHeight, 40, UI.navBarHeight);
    [self.view addSubview:msg];
    [msg addSubview:self.msgCountLabel];
    [self.msgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(msg).offset(-8);
        make.top.equalTo(msg.mas_centerY).offset(-20);
    }];
    return msg;
}

- (BOOL)isLgoin{
    
    if (![JHRootController isLogin]) {
        //   MJWeakSelf
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            
        }];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - events
-(void) backTop:(UIGestureRecognizer *)gestureRecognizer
{
    
}

-(void) tipTitleTap:(UIGestureRecognizer *)gestureRecognizer
{
    
}

- (void)msgAction
{
    if ([self isLgoin]) {
        JHMessageViewController *vc = [[JHMessageViewController alloc] init];
        if([@"JHPersonCenterViewController" isEqualToString: NSStringFromClass([self class])])
        {
            vc.from = JHFromHomePersonal;
        }
        else if([@"JHHomeViewController" isEqualToString: NSStringFromClass([self class])])
        {
            vc.from = JHFromHomeIdentity;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- motionAction
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
#if DEBUG
    [JHEnvVariableDefine showSwitchAlert];
#endif
}

- (void)activityImageAppear:(NSNotification *)sender {
    id b = sender.object;
    BOOL appear = [b boolValue];
    
    if(_activityViewAppear != appear)
    {
        _activityViewAppear = appear;
        [UIView animateWithDuration:0.3 animations:^{
            if(_activityImage && _activityImage.superview)
            {
                [self.activityImage mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.view).offset( appear ? -10 : (65.*2/3));
                }];
                
                self.activityImage.alpha = appear ? 1.f : .5f;
                [self.view layoutIfNeeded];
            }
        } completion:nil];
    }
}
@end
