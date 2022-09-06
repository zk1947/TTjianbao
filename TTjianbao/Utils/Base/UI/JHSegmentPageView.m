//
//  JHSegmentPageView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSegmentPageView.h"

@interface JHSegmentPageView () <UIScrollViewDelegate, JHSegmentUIViewDelegate>

@property (nonatomic, assign) NSUInteger lastSegmentIndex;
@property (nonatomic, strong) UIScrollView* scrollView;
@end

@implementation JHSegmentPageView
@synthesize lastSegmentIndex;

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLOR(0xf8f8f8);
    }
    
    return self;
}

#pragma mark - subviews
- (JHSegmentUIView*)segmentView
{
    if(!_segmentView)
    {
        _segmentView = [[JHSegmentUIView alloc] init];
        _segmentView.sDelegate = self;
        [_segmentView setTabSideMargin:(ScreenW - 60*3 - 29*2)/2.0];
        [_segmentView setTabIntervalSpace:29];
        [_segmentView setFontSize:15];
        [_segmentView setSegmentIndicateImage:@"coupon_segment_image"];
        [self addSubview:_segmentView];
    }
    
    return _segmentView;
}

- (UIScrollView*)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentView.bottom, self.width, self.height - _segmentView.bottom)];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)setPageViewControllerScrollViewTop:(CGFloat)scrollViewTop isScroll:(BOOL)isScroll;
{
    self.scrollView.scrollEnabled = isScroll;
    if(self.pageViewControllers.count > 0)
    {
        JHTableViewController* viewController = self.pageViewControllers[0];
        viewController.jhTableView.scrollEnabled = isScroll;
        [viewController.jhTableView scrollToTopAnimated:NO];
    }
    
    CGRect rect = self.scrollView.frame;
    rect.origin.y = scrollViewTop;
    self.scrollView.frame = rect;
}

- (void)setPageViewController:(NSArray<JHTableViewController*>*)controllers
{
    [self setPageViewController:controllers scrollViewTop:-1];
}

- (void)setPageViewController:(NSArray<JHTableViewController*>*)controllers scrollViewTop:(CGFloat)scrollViewTop
{
    self.pageViewControllers = controllers;
    //重设frame, segment与scroll之间可能有其他view
    if(scrollViewTop > 0)
    {
        self.scrollView.frame = CGRectMake(0, scrollViewTop, self.width, self.height - scrollViewTop);
    }
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
- (void)backToTableviewTop:(NSUInteger)index
{
    if (lastSegmentIndex != index && lastSegmentIndex < self.pageViewControllers.count)
    {
        JHTableViewController* viewController = self.pageViewControllers[lastSegmentIndex];
        if([viewController isKindOfClass:[JHTableViewController class]])
        {
            [viewController.jhTableView setContentOffset:CGPointZero animated:NO];
        }
    }
        
    lastSegmentIndex = index;

    //清空红点
    [self setRedDotNum:0 withIndex:index];
    if (self.toTabBlock) {
        self.toTabBlock(@(index));
    }
}

- (void)setPageToIndex:(NSUInteger)index
{
    [self.segmentView setCurrentIndex:index];
    [_scrollView setContentOffset:CGPointMake(index * self.width, 0)];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.jDelegate respondsToSelector:@selector(JHSegmentPageWillBeginDragging)])
    {
        [self.jDelegate JHSegmentPageWillBeginDragging];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate == NO)
    {
        NSUInteger index = (NSUInteger)(self.scrollView.contentOffset.x / self.width);
        [_segmentView setCurrentIndex:index];

        [self backToTableviewTop:index]; //上一个tab回top
        
        if ([self.jDelegate respondsToSelector:@selector(JHSegmentPageDidEndDragging)])
        {
            [self.jDelegate JHSegmentPageDidEndDragging];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = (NSUInteger)(self.scrollView.contentOffset.x / self.width);
    [_segmentView setCurrentIndex:index];

    [self backToTableviewTop:index]; //上一个tab回top
    
    if ([self.jDelegate respondsToSelector:@selector(JHSegmentPageToTopAtPageIndex:)])
    {
        [self.jDelegate JHSegmentPageToTopAtPageIndex:index];
    }
}

#pragma mark - segment delegate
- (void)pressSegmentButtonIndex:(NSUInteger)index
{
    [_scrollView setContentOffset:CGPointMake(index * self.width, 0)];
    [self backToTableviewTop:index];
}

- (void)setRedDotNum:(NSUInteger)num withIndex:(NSUInteger)index {
    [self.segmentView setRedDotNum:num withIndex:index];

}

@end
