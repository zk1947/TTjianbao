//
//  JHNewStoreHomeBannerView.m
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeBannerView.h"
#import "JHNewStoreBannerModel.h"
#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"
#import "SDCycleScrollView.h"

#define kScaleRatio (float)115/355

@interface JHNewStoreHomeBannerView ()
@property (nonatomic,   copy) BannerDidClickBlock clickBlock;
@property (nonatomic, strong) SDCycleScrollView  *scrollView;

@end

@implementation JHNewStoreHomeBannerView
+ (CGFloat)bannerHeight {
    return round(kScaleRatio * (ScreenW - 24)) + 10;
}

+ (instancetype)bannerWithClickBlock:(BannerDidClickBlock)block {
    JHNewStoreHomeBannerView *banner = [[JHNewStoreHomeBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, [[self class] bannerHeight])];
    banner.clickBlock = block;
    return banner;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 0.f, ScreenWidth-20, [[self class] bannerHeight]-10) delegate:nil placeholderImage:kDefaultNewStoreCoverImage];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.layer.cornerRadius = 5.f;
        _scrollView.clipsToBounds = YES;
        _scrollView.autoScrollTimeInterval = 3;
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _scrollView.hidesForSinglePage = YES;
        _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleJH;
        _scrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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
}

- (void)setBannerList:(NSArray<JHNewStoreBannerModel *> *)bannerList {
    if (!bannerList) {
        return;
    }
    _bannerList = bannerList;
    NSMutableArray *imgUrls = [NSMutableArray new];
    for (NSInteger i = 0; i < bannerList.count; i++) {
        JHNewStoreBannerModel *data = bannerList[i];
        if ([data.smallCoverImg isNotBlank]) {
            [imgUrls addObject:data.smallCoverImg];
        }
    }
    _scrollView.imageURLStringsGroup = imgUrls;
}

@end
