//
//  JHSQBannerView.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQBannerView.h"
#import "TTjianbao.h"
#import "SDCycleScrollView.h"
#import "JHPageControl.h"

#define kScaleRatio ((float)115/355)

@interface JHSQBannerView () <SDCycleScrollViewDelegate>
@property (nonatomic, copy) BannerClickBlock clickBlock;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) JHPageControl *pageControl;

@end

@implementation JHSQBannerView

+ (CGFloat)bannerHeight {
    return round(kScaleRatio * (ScreenW - 20)) + 10;
}
///轮播图的高度
static CGFloat _bannerHeight = 0.f;

+ (instancetype)bannerWithHeight:(CGFloat)bannerHeight ClickBlock:(BannerClickBlock)block {
    _bannerHeight = bannerHeight;
    JHSQBannerView *banner = [[JHSQBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _bannerHeight)];
    banner.clickBlock = block;
    return banner;
}

+ (instancetype)bannerWithClickBlock:(BannerClickBlock)block {
    _bannerHeight = [[self class] bannerHeight];
    JHSQBannerView *banner = [[JHSQBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _bannerHeight)];
    banner.clickBlock = block;
    return banner;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (!_scrollView) {
            CGFloat space = 5.f;
            _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, space, ScreenW-20, _bannerHeight-2*space) delegate:self placeholderImage:nil];
            _scrollView.backgroundColor = [UIColor clearColor];
            _scrollView.layer.cornerRadius = 8;
            _scrollView.clipsToBounds = YES;
            _scrollView.autoScrollTimeInterval = 3;
            _scrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            _scrollView.showPageControl = NO; //隐藏自带的pageControl
            
            /*
            //pageControl
            _scrollView.hidesForSinglePage = YES;
            //_scrollView.pageControlBottomOffset = 0;
            _scrollView.pageControlDotSize = CGSizeMake(5, 5);
            _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            _scrollView.pageDotImage = [UIImage imageWithColor:kColorEEE];
            _scrollView.currentPageDotImage = [UIImage imageWithColor:kColorMain];
            //_scrollView.pageDotImage = [UIImage imageNamed:@"sq_banner_page_icon_normal"];
            //_scrollView.currentPageDotImage = [UIImage imageNamed:@"sq_banner_page_icon_selected"];
            */
            
            [self addSubview:_scrollView];
            
            @weakify(self);
            _scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
                @strongify(self);
                if (self.clickBlock && self.bannerList.count > currentIndex) {
                    self.clickBlock(self.bannerList[currentIndex], currentIndex);
                }
                if (self.growingClickBlock) {
                    self.growingClickBlock();
                }
                [JHNotificationCenter postNotificationName:UIKeyboardWillHideNotification object:nil];
            };
        }
        
        if (!_pageControl) {
            [self addPageControl];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andEdge:(UIEdgeInsets)edge andClickBlock:(BannerClickBlock)block {
    self = [super initWithFrame:frame];
    self.clickBlock = block;
    if (self) {
        if (!_scrollView) {
            CGFloat wide = ScreenW - edge.left - edge.right;
            CGFloat height = frame.size.height - edge.top - edge.bottom;
            _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(edge.left, edge.top, wide, height) delegate:self placeholderImage:nil];
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
                if (self.growingClickBlock) {
                    self.growingClickBlock();
                }
                [JHNotificationCenter postNotificationName:UIKeyboardWillHideNotification object:nil];
            };
        }
        if (!_pageControl) {
            [self addPageControl];
        }
    }
    return self;
}



- (void)addPageControl {
    //创建pageControl
    _pageControl = [[JHPageControl alloc] initWithFrame:CGRectMake(0, 0 , kScreenWidth, 10)];
    _pageControl.bottom = CGRectGetMaxY(_scrollView.frame) - 5;
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

- (void)setBannerList:(NSArray<BannerCustomerModel *> *)bannerList {
    if (!bannerList) {
        return;
    }
    _bannerList = bannerList;
    NSMutableArray *imgUrls = [NSMutableArray new];
    for (NSInteger i = 0; i < bannerList.count; i++) {
        BannerCustomerModel *data = bannerList[i];
        if ([data.image isNotBlank]) {
            [imgUrls addObject:data.image];
        }
    }
    _scrollView.imageURLStringsGroup = imgUrls;
    
    _pageControl.hidden = bannerList.count <= 1;
    _pageControl.numberOfPages = bannerList.count;
}
- (void)setNotCornerRadius:(BOOL)notCornerRadius{
    _notCornerRadius = notCornerRadius;
    self.scrollView.layer.cornerRadius = notCornerRadius ? 0 : 8;
}
#pragma mark -
#pragma mark - SDCycleScrollViewDelegate

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

@end
