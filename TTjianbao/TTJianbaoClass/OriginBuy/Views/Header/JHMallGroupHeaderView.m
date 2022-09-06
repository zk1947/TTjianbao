//
//  JHMallGroupHeaderView.m
//  TTjianbao
//
//  Created by lihui on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallGroupHeaderView.h"
#import "TTjianbao.h"
#import "SDCycleScrollView.h"
#import "JHPageControl.h"
#import "JHMallOperationModel.h"

@interface JHMallGroupHeaderView () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) JHPageControl *pageControl;

@end

@implementation JHMallGroupHeaderView

+ (CGFloat)bannerHeight {
    return (85.f/355*(ScreenW-20)+10);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.layer.cornerRadius = 8;
        _scrollView.clipsToBounds = YES;
        _scrollView.autoScrollTimeInterval = 3;
        _scrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _scrollView.showPageControl = NO; //隐藏自带的pageControl
        [self addSubview:_scrollView];
        @weakify(self);
        _scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            @strongify(self);
            if (self.clickBlock && self.bannerList.count > currentIndex) {
                self.clickBlock(self.bannerList[currentIndex], currentIndex);
            }
            [JHNotificationCenter postNotificationName:UIKeyboardWillHideNotification object:nil];
        };
    }
    
    if (!_pageControl) {
        [self addPageControl];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(10, self.height - [[self class] bannerHeight] - 10, ScreenW-20, [[self class] bannerHeight]);
    _pageControl.frame = CGRectMake(0, CGRectGetMaxY(_scrollView.frame) - 15, kScreenWidth, 10);
}

- (void)addPageControl {
    //创建pageControl
    _pageControl = [[JHPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) - 5, kScreenWidth, 10)];
    _pageControl.numberOfPages = 0; //点的总个数
    _pageControl.pointSize = 4;
    _pageControl.otherMultiple = 1; //其他点w是h的倍数(圆点)
    _pageControl.currentMultiple = 3; //选中点的宽度是高度的倍数(设置长条形状)
    _pageControl.pageControlAlignment = JHPageControlAlignmentMiddle; //居中显示
    _pageControl.otherColor = kColorEEE; //非选中点的颜色
    _pageControl.currentColor = kColorMain; //选中点的颜色
    //_pageControl.delegate = nil;
    //_pageControl.tag = 999;
    
    [self addSubview:_pageControl];
}

- (void)setBannerList:(NSArray<JHOperationImageModel *> *)bannerList {
    if (!bannerList) {
        return;
    }
    _bannerList = bannerList;
    NSMutableArray *imgUrls = [NSMutableArray new];
    for (NSInteger i = 0; i < bannerList.count; i++) {
        JHOperationImageModel *imgData = bannerList[i];
        if ([imgData.imageUrl isNotBlank]) {
            [imgUrls addObject:imgData.imageUrl];
        }
    }
    _scrollView.imageURLStringsGroup = imgUrls;
    _pageControl.hidden = bannerList.count <= 1;
    _pageControl.numberOfPages = bannerList.count;
}

#pragma mark -
#pragma mark - SDCycleScrollViewDelegate

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

@end
