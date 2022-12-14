//
//  GKCycleScrollView.h
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/15.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKCycleScrollViewCell.h"

// 滚动方向
typedef NS_ENUM(NSUInteger, GKCycleScrollViewScrollDirection) {
    GKCycleScrollViewScrollDirectionHorizontal = 0, // 横向
    GKCycleScrollViewScrollDirectionVertical   = 1  // 纵向
};

// 滚动方向
typedef NS_ENUM(NSUInteger, GKCycleScrollViewAlignment) {
    GKCycleScrollViewAlignmentLeft = 0, //居左
    GKCycleScrollViewAlignmentCenter   = 1  //居中
};


@class GKCycleScrollView;

@protocol GKCycleScrollViewDataSource <NSObject>

- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView;

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index;

@end

@protocol GKCycleScrollViewDelegate <NSObject>

@optional
// 返回自定义cell尺寸
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView;

// cell滑动时调用
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index;

// cell点击时调用
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index;

#pragma mark - UIScrollViewDelegate 相关
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView willBeginDragging:(UIScrollView *)scrollView;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScroll:(UIScrollView *)scrollView;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDecelerating:(UIScrollView *)scrollView;
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndScrollingAnimation:(UIScrollView *)scrollView;

@end

@interface GKCycleScrollView : UIView

// 数据源
@property (nonatomic, weak) id<GKCycleScrollViewDataSource> dataSource;
// 代理
@property (nonatomic, weak) id<GKCycleScrollViewDelegate> delegate;

// 滚动方向，默认为横向
@property (nonatomic, assign) GKCycleScrollViewScrollDirection  direction;

// 滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

// 外部传入，自行处理
@property (nonatomic, weak) UIPageControl *pageControl;

// 当前展示的cell
@property (nonatomic, strong, readonly) GKCycleScrollViewCell *currentCell;

// 当前显示的页码
@property (nonatomic, assign, readonly) NSInteger currentSelectIndex;

// 默认选中的页码（默认：0）
@property (nonatomic, assign) NSInteger defaultSelectIndex;

// 是否自动滚动，默认YES
@property (nonatomic, assign) BOOL isAutoScroll;

// 是否无限循环，默认YES
@property (nonatomic, assign) BOOL isInfiniteLoop;

// 是否改变透明度，默认YES
@property (nonatomic, assign) BOOL isChangeAlpha;

// 非当前页cell的最小透明度，默认1.0f
@property (nonatomic, assign) CGFloat minimumCellAlpha;

// 左右间距，默认10
@property (nonatomic, assign) CGFloat leadMargin;
// 左右间距，默认0
@property (nonatomic, assign) CGFloat leftRightMargin;

// 上下间距，默认0
@property (nonatomic, assign) CGFloat topBottomMargin;

// 自动滚动时间间隔，默认3s
@property (nonatomic, assign) CGFloat autoScrollTime;

// 自动滚动时间间隔，默认3s
@property (nonatomic, assign) GKCycleScrollViewAlignment alignment;

@property (nonatomic, assign) NSInteger timerIndex;
/**
 刷新数据，必须调用此方法
 */
- (void)reloadData;

/**
 获取可重复使用的cell

 @return cell
 */
- (GKCycleScrollViewCell *)dequeueReusableCell;

/**
 滑动到指定cell

 @param index 指定cell的索引
 @param animated 是否动画
 */
- (void)scrollToCellAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)scrollToIndex:(int)index;
/**
 调整当前显示的cell的位置，防止出现滚动时卡住一半
 */
- (void)adjustCurrentCell;

/**
 开启定时器
 */
- (void)startTimer;

/**
 关闭定时器
 */
- (void)stopTimer;

///更新轮播的帧
- (void)timerUpdate;

@end
