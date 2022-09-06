//
//  HGSegmentedPageViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/1/3.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import "HGSegmentedPageViewController.h"
#import "HGPersonalCenterExtendMacro.h"

#import "Masonry.h"

#define kWidth self.view.frame.size.width

@interface HGSegmentedPageViewController () <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) HGPageViewController *currentPageViewController;
@property (nonatomic,assign) NSInteger selectedIndex;
@end

@implementation HGSegmentedPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPageViewController = self.pageViewControllers[self.categoryView.originalIndex];
    self.selectedIndex = self.categoryView.originalIndex;
    self.scrollView.contentSize = CGSizeMake(kWidth * self.pageViewControllers.count, 0);
    [self setupViews];
}

- (void)setupViews {
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.scrollView];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(52);
    }];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.pageViewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:obj];
        [self.scrollView addSubview:obj.view];
        [obj didMoveToParentViewController:self];
        [obj.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(idx * kWidth);
            make.top.width.height.equalTo(self.scrollView);
        }];
    }];
    [self.scrollView setContentOffset:CGPointMake(self.selectedIndex * kWidth, 0) animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerWillBeginDragging)]) {
        [self.delegate segmentedPageViewControllerWillBeginDragging];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDragging)]) {
        [self.delegate segmentedPageViewControllerDidEndDragging];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = (NSUInteger)(self.scrollView.contentOffset.x / kWidth);
    [self.categoryView changeItemToTargetIndex:index];
    self.currentPageViewController = self.pageViewControllers[index];
    self.selectedIndex = index;
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDeceleratingWithPageIndex:)]) {
        [self.delegate segmentedPageViewControllerDidEndDeceleratingWithPageIndex:index];
    }
}
#pragma mark - Getters
- (JHSourceMallSegmentView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JHSourceMallSegmentView alloc] init];
        if (self.segmentWidth>0) {
            _categoryView.segmentWidth = self.segmentWidth;
        }
        [_categoryView initSegmentScrollView];
        @weakify(self)
         _categoryView.selectedItemHelper = ^(NSInteger index) {
            @strongify(self)
            [self.scrollView setContentOffset:CGPointMake(index * kWidth, 0) animated:NO];
            self.currentPageViewController = self.pageViewControllers[index];
            self.selectedIndex = index;
            if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDeceleratingWithPageIndex:)]) {
                 [self.delegate segmentedPageViewControllerDidEndDeceleratingWithPageIndex:index];
             }
        };
    }
    return _categoryView;
}

#warning jiang --add
-(void)setPageIndex:(NSUInteger)index{
    
    [self.scrollView setContentOffset:CGPointMake(index * kWidth, 0) animated:NO];
    self.currentPageViewController = self.pageViewControllers[index];
    [self.categoryView changeItemToTargetIndex:index];
    self.selectedIndex = index;
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDeceleratingWithPageIndex:)]) {
        [self.delegate segmentedPageViewControllerDidEndDeceleratingWithPageIndex:index];
    }
}

- (HGPopGestureCompatibleScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[HGPopGestureCompatibleScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    


}
@end
