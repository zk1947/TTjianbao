//
//  SHSegmentedScrollView.m
//  SHSegmentedControlTableView
//
//  Created by angle on 2018/1/9.
//  Copyright © 2018年 angle. All rights reserved.
//

#import "SHSegmentedScrollView.h"


@interface SHSegmentedScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL scroll;

@end


@implementation SHSegmentedScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
            scrollView.delegate = self;
            scrollView.pagingEnabled = YES;
            scrollView.showsHorizontalScrollIndicator = YES;
            scrollView.showsVerticalScrollIndicator = YES;
            scrollView;
        });
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:self.scrollView];
        self.index = 0;
        self.scroll = YES;
    }
    return self;
}
#pragma mark -
#pragma mark   ==============set==============
- (void)setTopView:(UIView *)topView {
    if (_topView != nil) {
        [_topView removeFromSuperview];
        _topView = nil;
    }
    _topView = topView;
    if (_topView) {
        _topView.frame = CGRectMake(0, 0, self.sh_width, _topView.sh_height);
        [self addSubview:_topView];
        if (self.barView != nil) {
            self.barView.frame = CGRectMake(0, _topView.sh_height, self.sh_width, self.barView.sh_height);
            self.scrollView.frame = CGRectMake(0, _topView.sh_height + self.barView.sh_height, self.sh_width, self.sh_height - _topView.sh_height - self.barView.sh_height);
        }else {
            self.scrollView.frame = CGRectMake(0, _topView.sh_height, self.sh_width, self.sh_height - _topView.sh_height);
        }
    }else {
        if (self.barView != nil) {
            self.barView.frame = CGRectMake(0, 0, self.sh_width, self.barView.sh_height);
            self.scrollView.frame = CGRectMake(0, self.barView.sh_height, self.sh_width, self.sh_height - self.barView.sh_height);
        }else {
            self.scrollView.frame = self.bounds;
        }
    }
}
- (void)setBarView:(UIView *)barView {
    if (_barView != nil) {
        [_barView removeFromSuperview];
        _barView = nil;
    }
    _barView = barView;
    if (_barView) {
        [self addSubview:_barView];
        if (self.topView != nil) {
            _barView.frame = CGRectMake(0, self.topView.sh_height, self.sh_width, _barView.sh_height);
            self.scrollView.frame = CGRectMake(0, self.topView.sh_height + _barView.sh_height, self.sh_width, self.sh_height - self.topView.sh_height - _barView.sh_height);
        }else {
            _barView.frame = CGRectMake(0, 0, self.sh_width, _barView.sh_height);
            self.scrollView.frame = CGRectMake(0, _barView.sh_height, self.sh_width, self.sh_height - _barView.sh_height);
        }
    }else {
        if (self.topView != nil) {
            self.scrollView.frame = CGRectMake(0, self.topView.sh_height, self.sh_width, self.sh_height - self.topView.sh_height);
        }else {
            self.scrollView.frame = self.bounds;
        }
    }
}
- (void)setFootView:(UIView *)footView {
    if (_footView != nil) {
        [_footView removeFromSuperview];
        _footView = nil;
    }
    _footView = footView;
    if (_footView) {
        [self addSubview:_footView];
        _footView.frame = CGRectMake(0, self.sh_height - _footView.sh_height, self.sh_width, _footView.sh_height);
        CGRect scrolFrame = self.scrollView.frame;
        scrolFrame.size.height -= _footView.sh_height;
        self.scrollView.frame = scrolFrame;
    }else {
        CGRect scrolFrame = self.scrollView.frame;
        scrolFrame.size.height = self.sh_height - scrolFrame.origin.y;
        self.scrollView.frame = scrolFrame;
    }
}
- (void)setTableViews:(NSArray *)tableViews {
    _tableViews = tableViews;
    if (_tableViews.count > 0) {
        if (self.scrollView.subviews.count > 0) {
            [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        self.scrollView.contentSize = CGSizeMake(self.sh_width * _tableViews.count, 0);
        for (NSInteger index = 0; index < tableViews.count; index++) {
            UIView *view = tableViews[index];
            view.frame = CGRectMake(self.sh_width * index, 0, self.sh_width, self.scrollView.sh_height);
            if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) {
                [(UITableView *)view reloadData];
            }
            [self.scrollView addSubview:view];
        }
    }
}
- (void)setSegmentSelectIndex:(NSInteger)selectedIndex {
    if (selectedIndex != self.index && selectedIndex >= 0 && selectedIndex < self.tableViews.count) {
        CGPoint point = CGPointMake(selectedIndex * self.sh_width, 0);
        self.index = selectedIndex;
        self.scroll = NO;
        [self.scrollView setContentOffset:point animated:YES];
    }
}
#pragma mark -
#pragma mark   ==============数据刷新==============
- (void)setRefreshHeader:(MJRefreshHeader *)refreshHeader {
    _refreshHeader = refreshHeader;
    if (refreshHeader) self.scrollView.mj_header = refreshHeader;
}
- (NSInteger)selectedIndex {
    return self.index;
}
#pragma mark -
#pragma mark   ==============UIScrollViewDelegate==============
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.scroll) return;
    
    if (self.delegateCell && [self.delegateCell respondsToSelector:@selector(scrollViewDidScrollIndex:)]) {
        NSInteger index = (NSInteger)((scrollView.contentOffset.x + self.sh_width * 0.5) / self.sh_width);
        if (index != self.index) {
            self.index = index;
            [self.delegateCell scrollViewDidScrollIndex:index];
        }
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.scroll = YES;
}
@end
