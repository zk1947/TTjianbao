//
//  JHSegmentPageView.h
//  TTjianbao
//  Description:带segment、tab的pageView(多个页面)base
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHSegmentUIView.h"
#import "JHTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHSegmentPageDelegate <NSObject>

@optional

- (void)JHSegmentPageWillBeginDragging;
- (void)JHSegmentPageDidEndDragging;
- (void)JHSegmentPageToTopAtPageIndex:(NSUInteger)index;

@end

@interface JHSegmentPageView : BaseView

@property (nonatomic, weak) id <JHSegmentPageDelegate> jDelegate;
@property (nonatomic, assign, readonly) NSUInteger lastSegmentIndex;
@property (nonatomic, strong) JHSegmentUIView* segmentView;
@property (nonatomic, strong) NSArray<JHTableViewController*> *pageViewControllers;
//切换tab页面的回调
@property (nonatomic, copy) JHActionBlock toTabBlock;

//上一个segmentz恢复置顶
- (void)backToTableviewTop:(NSUInteger)index;
//设置选中页
- (void)setPageToIndex:(NSUInteger)index;
- (void)setPageViewControllerScrollViewTop:(CGFloat)scrollViewTop isScroll:(BOOL)isScroll;
//segment与scroll之间没有其他view
- (void)setPageViewController:(NSArray<JHTableViewController*>*)controllers;
//segment与scroll之间可能有其他view
- (void)setPageViewController:(NSArray<JHTableViewController*>*)controllers scrollViewTop:(CGFloat)scrollViewTop;
//红点数量
- (void)setRedDotNum:(NSUInteger)num withIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
