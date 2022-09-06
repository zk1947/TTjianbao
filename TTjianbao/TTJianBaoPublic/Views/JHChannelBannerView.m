//
//  JHChannelBannerView.m
//  TTjianbao
//
//  Created by YJ on 2020/12/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHChannelBannerView.h"
#import "JHChannelBannerModel.h"
#import "SDCycleScrollView.h"
#import "JHPageControl.h"
#import "JHMallOperationModel.h"
#import "JHGrowingIO.h"
#import "TTJianBaoColor.h"

@interface JHChannelBannerView()<SDCycleScrollViewDelegate>
/** 轮播图*/
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/** 提示控件*/
@property (nonatomic, strong) JHPageControl *pageControl;
@end

@implementation JHChannelBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        [self configUI];
    }
    return self;
}

- (void)setChannelModelArray:(NSMutableArray *)channelModelArray
{
    _channelModelArray = channelModelArray;

    NSMutableArray *urlsArray = [NSMutableArray new];

    for (JHChannelBannerModel *model in channelModelArray)
    {
        if (channelModelArray.count > 0)
        {
            [urlsArray addObject:model.imageUrl];
        }
    }

    self.cycleScrollView.imageURLStringsGroup = urlsArray;
    self.pageControl.hidden = channelModelArray.count <= 1;
    self.pageControl.numberOfPages = channelModelArray.count;
}

- (void)configUI
{
    [self addSubview:self.cycleScrollView];
    [self addSubview:self.pageControl];
}

#pragma SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //轮播图点击事件
    if (index < self.channelModelArray.count)
    {
        JHChannelBannerModel *model = self.channelModelArray[index];
        if (model.target)
        {
            [JHRootController toNativeVC:model.target.vc withParam:model.target.params from:nil];
            NSDictionary *dict = @{
                @"page_position" : @"直播间分类页",
                @"position_sort" : [NSString stringWithFormat:@"%@", @(index)],
                @"content_url" : model.target.recordComponentName ?: @"",
            };
            [JHAllStatistics jh_allStatisticsWithEventId:@"bannerClick" params:dict type:JHStatisticsTypeSensors];
        }
        
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    [self.pageControl setCurrentPage:index];
}

- (SDCycleScrollView *)cycleScrollView
{
    if (_cycleScrollView == nil)
    {
        CGFloat scale = ScreenW/375;
        CGFloat banner_height = scale * 150;
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, banner_height) delegate:self placeholderImage:nil];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView. infiniteLoop = YES;
        //_cycleScrollView.layer.cornerRadius = 4;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.backgroundColor = BACKGROUND_COLOR;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //_cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _cycleScrollView.showPageControl = NO;
    }
    return _cycleScrollView;
}

- (JHPageControl *)pageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[JHPageControl alloc] initWithFrame:CGRectMake(10, self.cycleScrollView.bottom - 20, self.cycleScrollView.width, 10)];
        _pageControl.numberOfPages = 0; //点的总个数
        _pageControl.pointSize = 4;
        _pageControl.otherMultiple = 1; //其他点w是h的倍数(圆点)
        _pageControl.currentMultiple = 3; //选中点的宽度是高度的倍数(设置长条形状)
        _pageControl.pageControlAlignment = JHPageControlAlignmentMiddle; //居中显示
        _pageControl.otherColor = kColorEEE; //非选中点的颜色
        _pageControl.currentColor = kColorMain; //选中点的颜色
    }
    return _pageControl;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
