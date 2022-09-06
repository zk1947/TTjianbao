//
//  JHLaunchGuideView.m
//  TTjianbao
//
//  Created by Jesse on 11/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLaunchGuideView.h"
#import "JHAdvertView.h"
#import "JHUpdateApp.h"
#import "JHSQManager.h"
#import "YDGuideManager.h"
#import "JHLiveGuideView.h"

@interface JHLaunchGuideView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *completeButton;
@property (strong, nonatomic) NSArray *imaArr;
@property (strong, nonatomic) JHUpdateApp *updateApp;
@property (strong, nonatomic) JHLiveGuideView *liveGuideView;
@end

@implementation JHLaunchGuideView

- (void)dealloc
{
    NSLog(@"JHLaunchGuideView");
}

- (void)showView {
    
    self.backgroundColor=[UIColor whiteColor];
    if (UI.bottomSafeAreaHeight>0) {
        self.imaArr=[NSArray arrayWithObjects:@"guide_1125_1",@"guide_1125_2",@"guide_1125_3",@"guide_1125_4", nil];
    }
    else{
        self.imaArr=[NSArray arrayWithObjects:@"guide750-1",@"guide750-2",@"guide750-3",@"guide750-4", nil];
    }
      [self setUpSubViews];
    
     [Growing track:@"fristleader" ];
}

-(void)setUpSubViews{
    
    [self addSubview:self.scrollView];

    float x=0;
    for (int i=0; i<[self.imaArr count]; i++) {
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, self.width, self.height)];
        imageview.contentMode = UIViewContentModeScaleToFill;
        imageview.image = [UIImage imageNamed:[self.imaArr objectAtIndex:i]];
        [self.scrollView addSubview:imageview];
        
        if (i==[self.imaArr count]-1) {
            [self.scrollView addSubview:self.completeButton];
            [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageview);
                make.bottom.equalTo(imageview.mas_bottom).offset(-25-UI.bottomSafeAreaHeight);
            }];
        }
        x+=self.width;
    }
    
    self.pageControl.numberOfPages = [self.imaArr count];
    self.scrollView.contentSize = CGSizeMake(self.width*[self.imaArr count], self.scrollView.frame.size.height);
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.frame);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
}

-(UIScrollView*)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate=self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator =NO;
    }
    return _scrollView;
}

-(UIPageControl*)pageControl{
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height-UI.bottomSafeAreaHeight-50, self.width, 10)];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.99f green:0.40f blue:0.42f alpha:1.00f];
        _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:1.00f green:0.75f blue:0.76f alpha:1.00f];
        
    }
    return _pageControl;
}

- (JHLiveGuideView *)liveGuideView
{
    if(!_liveGuideView)
    {
        _liveGuideView = [[JHLiveGuideView alloc] initWithFrame:self.frame];
    }
    return _liveGuideView;
}

-(JHUpdateApp *)updateApp
{
    if(!_updateApp)
    {
        _updateApp = [[JHUpdateApp alloc] init];
    }
    return _updateApp;
}

- (void)showAlertFromFirstLaunch:(BOOL)fromFirstLaunch{
    JH_WEAK(self)
    JHAdvertView* adver = [[JHAdvertView alloc] initWithFrame:self.frame];
    adver.block = ^{
        JH_STRONG(self)
        [self completeAdvertViewBlock:fromFirstLaunch];
    };
}

- (void)config99FreePage {
    [JHUserDefaults setBool:YES forKey:kShowAdversePage];
    [JHUserDefaults synchronize];
    if (JHRootController.homeTabController.selectedIndex == 1) {
        [JHNotificationCenter postNotificationName:kMallPage99FreeNotification object:nil];
    }
}

- (void)completeAdvertViewBlock:(BOOL)fromFirstLaunch
{
    [JHRootController getLocalChannelData:ChannelDeviceFileData];
    ///通知页面请求99包邮数据
    [self config99FreePage];
    
    ///判断是否第一次进入app 如果是 则展示分流引导页
    /// v3.6.3 去除分流引导页
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:kGuidePageDisplayKey]) {
////        JHLiveGuideViewController *guideVC = [[JHLiveGuideViewController alloc] init];
////        [[JHRootController currentViewController] presentViewController:guideVC animated:NO completion:nil];
////        [[JHRootController currentViewController].view addSubview:self.liveGuideView];
//    } else {
        if (!fromFirstLaunch) {
            [self.updateApp checkUpdate];
            [[UserInfoRequestManager sharedInstance] getAppraiseIssuelnfoCompletion:nil];
            [[UserInfoRequestManager sharedInstance] getHomePageActivitylnfoCompletion:nil];
        }
//    }
}

-(UIButton*)completeButton{
    
    if (!_completeButton) {
        
        _completeButton = [[UIButton alloc] init];
        [_completeButton setBackgroundImage:[UIImage imageNamed:@"guidebutton"] forState:UIControlStateNormal];
        //[_completeButton setTitle:@"立即体验" forState:UIControlStateNormal];
        //_completeButton.titleLabel.font=[UIFont systemFontOfSize:15];
        //[_completeButton setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [_completeButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        _completeButton.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _completeButton;
}

-(void)buttonPress:(UIButton*)button{
    
    [Growing track:@"experience"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRSTLAUNCHCOMPLETE];
    if(self.delegate)
        [self.delegate setupHomeViewController];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self showAlertFromFirstLaunch:YES];
}

@end
