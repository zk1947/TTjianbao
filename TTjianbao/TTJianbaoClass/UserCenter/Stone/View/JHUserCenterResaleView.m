//
//  JHUserCenterResaleView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/25.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHUserCenterResaleView.h"
#import "JHUIFactory.h"
#import "JHResaleSubViewController.h"

@interface JHUserCenterResaleView ()
{
    NSString* channelId;
    NSMutableArray *controllers;
}

@property (nonatomic, strong) NSArray* tabTitleArray;
@end

@implementation JHUserCenterResaleView

- (void)drawSubviews:(NSString*)mChannelId
{
    channelId = mChannelId;
    _tabTitleArray = [NSArray arrayWithObjects:@"买家出价", @"在售原石", @"已售原石", nil];
    //顶部tabs
    [self drawTabs];
    //page view controller
    [self drawPageViewController];
}

- (void)drawTabs
{
    [self.segmentView setSegmentTitle:_tabTitleArray];
    [self.segmentView setSegmentIndicateImageWithTopOffset:6];
}

- (void)drawPageViewController
{
    controllers = [NSMutableArray array];
    for (int i = 0 ; i < _tabTitleArray.count; i++ )
    {
        JHResaleSubViewController *controller = [[JHResaleSubViewController alloc] initWithPageType:i channelId:channelId];
        [controllers addObject:controller];
    }
    //设置page controller
    [self setPageViewController:controllers scrollViewTop:self.segmentView.bottom + 10];
    //页面配置好以后,再设置选中index
    [self setPageToIndex:_selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
}

- (void)backToTableviewTop:(NSUInteger)index
{
    [super backToTableviewTop: index];
    if(index < [self.pageViewControllers count])
    {
        JHResaleSubViewController* controller = controllers[index];
        [controller callbackRefreshData];
    }
}

@end
