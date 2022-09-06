//
//  JHAdsCycleView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAdsCycleView.h"
#import "SDCycleScrollView.h"
#import "JHPageControl.h"
#import "JHMallOperationModel.h"
#import "JHGrowingIO.h"
@interface JHAdsCycleView()<SDCycleScrollViewDelegate>
/** 轮播图*/
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/** 提示控件*/
@property (nonatomic, strong) JHPageControl *pageControl;
@end
@implementation JHAdsCycleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = kColorF5F6FA;
        [self configUI];
    }
    return self;
}

- (void)setAdsArray:(NSArray *)adsArray{
    _adsArray = adsArray;
    if (_adsArray.count == 0 || !adsArray) {
        return;
    }
    NSMutableArray *cycleImageArray = [NSMutableArray array];
    for (JHOperationDetailModel *model in adsArray) {
        NSArray *array = model.definiDetails;
        if (array.count > 0) {
            JHOperationImageModel *imageModel = array[0];
            [cycleImageArray addObject:imageModel.imageUrl];
        }
    }
    self.cycleScrollView.imageURLStringsGroup = cycleImageArray;
    self.pageControl.hidden = adsArray.count <= 1;
    self.pageControl.numberOfPages = adsArray.count;
}

- (void)configUI{
    [self addSubview:self.cycleScrollView];
    [self addSubview:self.pageControl];
}

#pragma SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    //轮播图点击事件
    JHOperationDetailModel *model = self.adsArray[index];
    NSArray *array = model.definiDetails;
    if (array.count > 0) {
        JHOperationImageModel *bannerModel = model.definiDetails.firstObject;
        [JHRootController handleMessageModel:bannerModel.target from:@""];
        [JHGrowingIO trackEventId:JHTrackCustomizelive_top_banner_click variables:@{@"id":bannerModel.detailsId}];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    [self.pageControl setCurrentPage:index];
}

- (SDCycleScrollView *)cycleScrollView{
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 8, ScreenW - 20, 70 / 375.f * ScreenW) delegate:self placeholderImage:kDefaultCoverImage];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView. infiniteLoop = YES;
        _cycleScrollView.layer.cornerRadius = 4;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.showPageControl = NO;
    }
    return _cycleScrollView;
}

- (JHPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[JHPageControl alloc] initWithFrame:CGRectMake(10, self.cycleScrollView.bottom - 10, self.cycleScrollView.width, 10)];
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



@end
