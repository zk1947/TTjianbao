//
//  JHMallRecommendHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallRecommendHeader.h"
#import "JHPageControl.h"
#import "JHMallRecommendHeaderCell.h"
#import "JHLiveRoomMode.h"
#import "GKCycleScrollView.h"
#import "GKPageControl.h"
#import "PageControl/TAPageControl.h"


@interface JHMallRecommendHeader () <GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>

@property (nonatomic, strong) GKCycleScrollView *cycleView;
@property (nonatomic, strong) JHPageControl *pageControl;

@end

@implementation JHMallRecommendHeader

- (void)setLiveRoomData:(NSArray *)liveRoomData {
    _liveRoomData = liveRoomData;
    if (!liveRoomData || liveRoomData.count == 0) {
        return;
    }
    
    _pageControl.numberOfPages = _liveRoomData.count;
    _pageControl.hidden = _liveRoomData.count <= 1;
    [self.cycleView reloadData];
    
    JHMallRecommendHeaderCell *cell = (JHMallRecommendHeaderCell *)self.cycleView.currentCell;
    JHLiveRoomMode *model =  [_liveRoomData firstObject];
    
    //    if ([model.status integerValue] == 2) {
    if (self.scrolledBlock) {
        self.scrolledBlock(cell.steamView, model);
    }
    //    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.cycleView];
    [self addSubview:self.pageControl];
    
    //    [self.cycleView reloadData];
}

#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.liveRoomData.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    JHMallRecommendHeaderCell *cell = (JHMallRecommendHeaderCell *)[cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [JHMallRecommendHeaderCell new];
    }
    // 设置数据
    cell.imageModel = self.liveRoomData[index];
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    CGFloat w = (ScreenW*210/375);
    return CGSizeMake(ceilf(w), w);
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index {
   // NSLog(@"pageNumber:---- %ld", (long)index);
    [self.pageControl setCurrentPage:index];
    //    JHMallRecommendHeaderCell *cell = (JHMallRecommendHeaderCell *)cycleScrollView.currentCell;
    //    JHLiveRoomMode *model =  self.liveRoomData[index];
    //    if (self.scrolledBlock) {
    //        self.scrolledBlock(cell.steamView, model);
    //    }
}
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDecelerating:(UIScrollView *)scrollView{
  
    JHMallRecommendHeaderCell *cell = (JHMallRecommendHeaderCell *)cycleScrollView.currentCell;
    JHLiveRoomMode *model =  self.liveRoomData[cycleScrollView.currentSelectIndex];
    if (self.scrolledBlock) {
        self.scrolledBlock(cell.steamView, model);
    }
    
}
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView willBeginDragging:(UIScrollView *)scrollView {
    if (self.willDraggBlock) {
        self.willDraggBlock();
    }
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index {
    if (self.didSelectBLock) {
        self.didSelectBLock(index);
    }
}

#pragma mark -- 轮播图

- (GKCycleScrollView *)cycleView {
    if (!_cycleView) {
        // 缩放样式：Masonry布局，自定义尺寸，无限轮播
        GKCycleScrollView *cycleView = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, 10, ScreenW, (ScreenW*210/375))];
        cycleView.backgroundColor = [UIColor clearColor];
        cycleView.dataSource = self;
        cycleView.delegate = self;
        cycleView.minimumCellAlpha = 0.0;
        cycleView.leftRightMargin = 10.0f;
        cycleView.topBottomMargin = 12.0f;
        cycleView.isAutoScroll = NO;
        _cycleView = cycleView;
    }
    return _cycleView;
}

- (JHPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[JHPageControl alloc] initWithFrame:CGRectMake(0, self.cycleView.bottom + 10, ScreenW, 4)];
        _pageControl.numberOfPages = 0; //点的总个数
        _pageControl.pointSize = 4;
        _pageControl.otherMultiple = 1; //其他点w是h的倍数(圆点)
        _pageControl.currentMultiple = 3; //选中点的宽度是高度的倍数(设置长条形状)
        _pageControl.pageControlAlignment = JHPageControlAlignmentMiddle; //居中显示
        _pageControl.otherColor = kColorEEE; //非选中点的颜色
        _pageControl.currentColor = kColorMain; //选中点的颜色
        _pageControl.numberOfPages = 0;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

///滚动下个view
- (void)scrollToNextPage {
    [self.cycleView timerUpdate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollComplete) object:nil];
    [self performSelector:@selector(scrollComplete) withObject:nil afterDelay:0.5];
   
}
-(void)scrollComplete{
    JHMallRecommendHeaderCell *cell = (JHMallRecommendHeaderCell *)self.cycleView.currentCell;
    JHLiveRoomMode *model =  self.liveRoomData[self.cycleView.currentSelectIndex];
    NSLog(@"pageNumber&:---- %ld", (long)self.cycleView.currentSelectIndex);
    if (self.scrolledBlock) {
        self.scrolledBlock(cell.steamView,model );
    }
}

- (void)dealloc {
    self.cycleView.delegate = nil;
    self.cycleView.dataSource = nil;
    [self.cycleView stopTimer];
}

@end
