//
//  JHMallRecommendBannarView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallRecommendBannarView.h"
#import "JHMallRecommendBannarCell.h"
#import "JHPageControl.h"
#import "GKCycleScrollView.h"
#import "GKPageControl.h"
#import "PageControl/TAPageControl.h"
#import "JHMallModel.h"
#import "BannerMode.h"
#import "JHSkinManager.h"
#import "JHSkinSceneManager.h"
#import "JHGrowingIO.h"

@interface JHMallRecommendBannarView ()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>

@property (nonatomic, weak) GKCycleScrollView *cycleView;

@property (nonatomic, weak) JHPageControl *pageControl;


///直播中图片
@property (nonatomic, weak) YYAnimatedImageView *gifIcon;

@end

@implementation JHMallRecommendBannarView

- (void)setBannarArray:(NSArray<JHMallBannerModel *> *)bannarArray {
    _bannarArray = bannarArray;
    self.pageControl.numberOfPages = _bannarArray.count;
    self.pageControl.hidden = (_bannarArray.count <= 1);
    [self.cycleView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self cycleView];
        [self pageControl];
        [self.cycleView reloadData];
        [self bindData];
    }
    return self;
}
- (void)bindData {
    JHSkinSceneManager *manager = [JHSkinSceneManager shareManager];
    
    @weakify(self)
    [RACObserve(manager, sceneLiveModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.gifIcon.image = scene.imageNor;
    }];
}
#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.bannarArray.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    JHMallRecommendBannarCell *cell = (JHMallRecommendBannarCell *)[cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [JHMallRecommendBannarCell new];
    }
    if(index < self.bannarArray.count) {
        cell.model = self.bannarArray[index];
    }
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    CGFloat height = (122.f / 375.f) * ScreenW;
    CGFloat width = (267.f / 375.f) * ScreenW;
    return CGSizeMake(ceilf(width) + 12, floorf(height));
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index {
    [self.pageControl setCurrentPage:index];
    if(index < self.bannarArray.count) {
        JHMallBannerModel *model = self.bannarArray[index];
        if(model.status == 2) {
            [self showGifIcon];
        }
        else {
            [self dismissGifIcon];
        }
    }
}
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDecelerating:(UIScrollView *)scrollView{
}
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView willBeginDragging:(UIScrollView *)scrollView {
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index {
    NSLog(@"点击第%ld个广告",(long)index);
    if(index < self.bannarArray.count) {
        JHMallBannerModel *model = self.bannarArray[index];
        
        [JHGrowingIO trackEventId:@"tv_banner_in" variables:@{
            @"from" : @"banner",
            @"tv_banner_place_id":@(index +1),
            @"channelLocalId":NONNULL_STR(model.target.params[@"roomId"])
        }];
        
        NSDictionary *dict = @{
            @"page_position":@"直播购物",
            @"model_type":@"直播购物顶部轮播图",
            @"position_sort": [NSString stringWithFormat:@"%@", @(index)],
            @"channel_name":@"",
            @"anchor_id":@"",
            @"anchor_nick_name":@"",
            @"channel_local_id":NONNULL_STR(model.target.params[@"roomId"]),
            @"channel_label":@"无"
        };
        [JHAllStatistics jh_allStatisticsWithEventId:@"zbgwBannerClick" params:dict type:JHStatisticsTypeSensors];
        
        
        
        NSMutableArray * listRoom = [NSMutableArray array];
        for (JHMallBannerModel *temp in self.bannarArray) {
            if ([temp.target.vc isEqualToString:@"NTESAudienceLiveViewController"] && model.status == 2) {
                JHLiveRoomMode *roomMode = [[JHLiveRoomMode alloc] init];
                roomMode.roomId = temp.target.params[@"roomId"];
                roomMode.channelLocalId = temp.target.params[@"roomId"];
                roomMode.status = [NSString stringWithFormat:@"%ld",temp.status];
                [listRoom addObject:roomMode];
            }
        }
        if (listRoom.count>0) {
            [model.target.params setValue:listRoom forKey:@"roomList"];
        }
        
        if (model.target) {
            [JHRootController toNativeVC:model.target.vc withParam:model.target.params from:@"mallBannar"];
        }
    }
}

- (GKCycleScrollView *)cycleView {
    if (!_cycleView) {
        // 缩放样式：Masonry布局，自定义尺寸，无限轮播
        GKCycleScrollView *cycleView = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, (ScreenW*210/375))];
        cycleView.backgroundColor = [UIColor clearColor];
        cycleView.dataSource = self;
        cycleView.delegate = self;
        cycleView.minimumCellAlpha = 0.0;
        cycleView.leftRightMargin = 6.0f;
        cycleView.leadMargin = 6.f;
        cycleView.topBottomMargin = 6.0f;
        cycleView.isAutoScroll = YES;
        cycleView.autoScrollTime = 3.f;
        [self addSubview:cycleView];
        _cycleView = cycleView;
        [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5., 0, 0, 0));
        }];
    }
    return _cycleView;
}

///分页指示器
- (JHPageControl *)pageControl {
    if (!_pageControl) {
        JHPageControl *pageControl = [[JHPageControl alloc] initWithFrame:CGRectMake(0, 0, ScreenW,4)];
        pageControl.numberOfPages = 0; //点的总个数
        pageControl.pointSize = 4;
        pageControl.otherMultiple = 1; //其他点w是h的倍数(圆点)
        pageControl.currentMultiple = 3; //选中点的宽度是高度的倍数(设置长条形状)
        pageControl.otherColor = HEXCOLORA(0xFFFFFF, .5f); //非选中点的颜色
        pageControl.currentColor = HEXCOLOR(0xFFD70F); //选中点的颜色
        pageControl.pointSpacing = 4.;
        [self addSubview:pageControl];
        _pageControl = pageControl;
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-8);
            make.size.mas_equalTo(CGSizeMake(ScreenW, 4));
        }];
    }
    return _pageControl;
}

- (void)showGifIcon {
//    JHSkinModel *model = [JHSkinManager liveBottom];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imagePath = [JHSkinManager getImageFilePath:model.name];
//            YYImage *image = [YYImage imageWithContentsOfFile:imagePath];
//            self.gifIcon.image = image;
//        }
//    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.gifIcon.alpha = 1.0;
    }];
}

- (void)dismissGifIcon {
    [UIView animateWithDuration:0.3 animations:^{
        self.gifIcon.alpha = 0.0;
    }];
}

- (YYAnimatedImageView *)gifIcon {
    if(!_gifIcon) {
        YYAnimatedImageView *gifIcon = [[YYAnimatedImageView alloc] initWithImage:[YYImage imageNamed:@""]];
        gifIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:gifIcon];
        [gifIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(6);
            make.top.equalTo(self).offset(15.f);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        _gifIcon = gifIcon;
    }
    return _gifIcon;
}

+ (CGSize)viewSize {
    CGFloat height = (122.f / 375.f) * ScreenW;
    return CGSizeMake(ScreenW, height+5.);
}

@end
