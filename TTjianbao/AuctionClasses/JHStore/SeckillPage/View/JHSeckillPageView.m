//
//  JHSeckillPageView.m
//  TTjianbao
//
//  Created by jiang on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSeckillPageView.h"
#import "JHUIFactory.h"
#import "JHSeckillListViewController.h"
#import "UIView+JHShadow.h"
#import "JHSeckillPageTitleView.h"
#import "JHSeckillPageTitleView.h"
@interface JHSeckillPageView ()<UIScrollViewDelegate>
{
    NSMutableArray *controllers;
    UIImageView *headerBackImage;
}
@property (nonatomic, strong) JHSeckillPageTitleView *titleView;
@property (nonatomic, assign) NSUInteger lastSegmentIndex;
@property (nonatomic, strong) UIScrollView* scrollView;

@end

@implementation JHSeckillPageView
@synthesize lastSegmentIndex;

-(void)initSubviews{
    
    headerBackImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 74+UI.statusAndNavBarHeight)];
    headerBackImage.contentMode=UIViewContentModeScaleAspectFill;
    headerBackImage.backgroundColor=kColorMain;
    [self addSubview:headerBackImage];
    [self initSegmentView];
    [self initPageViewController];
    [self initTitleView];
    
}
- (void)initSegmentView
{
    [self.segmentView setUpSegmentView:self.tabTitleArray];
}
-(void)setHeaderMode:(JHSecKillHeaderMode *)headerMode{
    
    _headerMode=headerMode;
    [headerBackImage jhSetImageWithURL:[NSURL URLWithString:_headerMode.head_img]];
}
- (void)initTitleView
{
    self.titleView=[[JHSeckillPageTitleView alloc]init];
   
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBackImage.mas_bottom).offset(-21);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.offset(42);
       // make.width.offset(355);
        make.centerX.equalTo(self);
    }];
    [self layoutIfNeeded];
     [self.titleView viewShadowPathWithColor:[CommHelp toUIColorByStr:@"000000"] shadowOpacity:0.2 shadowRadius:2 shadowPathType:JHShadowPathBottom shadowPathWidth:5];
      JH_WEAK(self)
      self.titleView.timeEndBlock = ^{
        JH_STRONG(self)
        JHSeckillListViewController* controller = self->controllers[self.selectedIndex];
        [controller loadNewData];
        JHSecKillTitleMode *mode=self.tabTitleArray[self.selectedIndex];
        mode.sub_title = JHLocalizedString(@"finished");
        [self.segmentView setTitles:self.tabTitleArray];
        
    };
    
    self.titleView.beginBlock = ^{
        JH_STRONG(self)
        JHSeckillListViewController* controller = self->controllers[self.selectedIndex];
        [controller loadNewData];
        JHSecKillTitleMode *mode=self.tabTitleArray[self.selectedIndex];
        self.titleView.titleMode=mode;
        for (JHSecKillTitleMode *mode in self.tabTitleArray) {
        NSTimeInterval nowTime=[[CommHelp getNowTimetampBySyncServeTime] doubleValue]/1000;
          if (nowTime>=mode.offline_at )
               mode.sub_title = JHLocalizedString(@"finished");
        }
          [self.segmentView setTitles:self.tabTitleArray];
        
    };
    
    
     self.titleView.titleMode=self.tabTitleArray[self.selectedIndex];
}
- (JHSecKillSegmentUIView*)segmentView
{
    if(!_segmentView)
    {
        _segmentView = [[JHSecKillSegmentUIView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, 50)];
        [self addSubview:_segmentView];

        @weakify(self);
        _segmentView.selectedItemHelper = ^(NSInteger index) {
            @strongify(self);
            [self.scrollView setContentOffset:CGPointMake(index * self.width, 0)];
            [self loadNewpage:index isRefreshData:YES];
            
        };
    }
    
    return _segmentView;
}
- (void)initPageViewController
{
    controllers = [NSMutableArray array];
    for (int i = 0 ; i < _tabTitleArray.count; i++ )
    {
        JHSeckillListViewController *controller = [[JHSeckillListViewController alloc] init];
        controller.view.backgroundColor=[CommHelp randomColor];
        controller.ses_id=self.tabTitleArray[i].ses_id;
        controller.titleMode=self.tabTitleArray[i];
        [controllers addObject:controller];
        if (i==self.selectedIndex) {
          [controller loadNewData];
        }
    }
    [self setPageViewController:controllers];
    [self setPageToIndex:_selectedIndex];
}
- (UIScrollView*)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headerBackImage.bottom, self.width, self.height - headerBackImage.bottom)];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (void)setPageViewController:(NSArray<JHTableViewController*>*)controllers
{
   self.pageViewControllers = controllers;
    self.scrollView.contentSize = CGSizeMake(self.width * self.pageViewControllers.count, 0);
    [self.pageViewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.scrollView addSubview:obj.view];
        [obj.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.width * idx);
            make.top.width.height.equalTo(self.scrollView);
        }];
    }];
}
#pragma mark - table view back to top & segment page to index
- (void)loadNewpage:(NSUInteger)index isRefreshData:(BOOL)refresh
{
    if (lastSegmentIndex != index && index < self.pageViewControllers.count)
    {
        JHSeckillListViewController* controller = controllers[index];
        if (refresh) {
             [controller loadNewData];
        }
      //  self.titleView.selectedIndex=index;
        lastSegmentIndex = index;
        self.selectedIndex=index;
        self.titleView.titleMode=self.tabTitleArray[index];
    }
}
- (void)setPageToIndex:(NSUInteger)index
{
    [self.segmentView setCurrentIndex:index];
    lastSegmentIndex=index;
    [_scrollView setContentOffset:CGPointMake(index * self.width, 0)];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate == NO)
    {
        NSUInteger index = (NSUInteger)(self.scrollView.contentOffset.x / self.width);
        [_segmentView setCurrentIndex:index];
        [self loadNewpage:index isRefreshData:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = (NSUInteger)(self.scrollView.contentOffset.x / self.width);
    [_segmentView setCurrentIndex:index];
    [self loadNewpage:index isRefreshData:YES];
    
}

@end
