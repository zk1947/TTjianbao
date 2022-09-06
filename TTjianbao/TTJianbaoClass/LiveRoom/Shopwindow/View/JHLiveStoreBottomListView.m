//
//  JHLiveStoreBottomListView.m
//  TTjianbao
//
//  Created by YJ on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveStoreBottomListView.h"
#import "JHLiveStoreListViewController.h"

@interface JHLiveStoreBottomListView ()
{
    NSMutableArray *controllers;
}
@property (nonatomic, strong) NSArray* tabTitleArray;
@property (nonatomic, strong) JHLiveStoreListViewController *controller;
@end

@implementation JHLiveStoreBottomListView

//用户列表
- (void)setViewUIConfigForUserWithChannel:(ChannelMode *)channel
{
    [self setCornerForView];
    self.controller = [[JHLiveStoreListViewController alloc] initWithType:JHLiveStoreListShowTypeWithNormal channel:channel];
    [self addSubview:self.controller.view];
    self.controller.hiddenBlock = self.hiddenBlock;
    self.controller.removeBlock = self.removeBlock;
    [self.controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
//卖家列表
- (void)setViewUIConfig:(ChannelMode *)channel{
    [self setCornerForView];
    _tabTitleArray = [NSArray arrayWithObjects:@"上架商品", @"历史记录", nil];
    [self drawTabs];
    //page view controller
    [self drawPageViewController:(ChannelMode *)channel];
}
- (void)drawTabs
{
    self.segmentView.tabSideMargin = (ScreenW - 160)/2;
    self.segmentView.tabIntervalSpace = 40;
    [self.segmentView setSegmentTitle:_tabTitleArray];
    [self.segmentView setSegmentIndicateImageWithTopOffset:6];
}

- (void)drawPageViewController:(ChannelMode *)channel
{
    controllers = [NSMutableArray array];
    for (int i = 0 ; i < _tabTitleArray.count; i++ )
    {
        JHLiveStoreListViewController *controller = [[JHLiveStoreListViewController alloc] initWithType:(i == 0?JHLiveStoreListShowTypeWithSaler_Header:JHLiveStoreListShowTypeWithSaler) channel:channel];
        controller.hiddenBlock = self.hiddenBlock;
        controller.removeBlock = self.removeBlock;
        [controllers addObject:controller];
    }
    //设置page controller
    [self setPageViewController:controllers scrollViewTop:self.segmentView.bottom + 10];
    //页面配置好以后,再设置选中index
    [self setPageToIndex:0];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
