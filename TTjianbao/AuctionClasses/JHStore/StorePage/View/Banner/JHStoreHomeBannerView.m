//
//  JHStoreHomeBannerView.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeBannerView.h"
#import "TTjianbaoBussiness.h"

#import "TTjianbaoHeader.h"

#import "SDCycleScrollView.h"

#define kScaleRatio (float)115/355

@interface JHStoreHomeBannerView ()
@property (nonatomic, copy) BannerDidClickBlock clickBlock;
@property (nonatomic, strong) SDCycleScrollView *scrollView;

@end


@implementation JHStoreHomeBannerView

+ (CGFloat)bannerHeight {
    return round(kScaleRatio * (ScreenW - 20)) + 10;
}

+ (instancetype)bannerWithClickBlock:(BannerDidClickBlock)block {
    JHStoreHomeBannerView *banner = [[JHStoreHomeBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, [[self class] bannerHeight])];
    banner.clickBlock = block;
    return banner;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (!_scrollView) {
            _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 5, ScreenWidth-20, [[self class] bannerHeight]-10) delegate:nil placeholderImage:kDefaultCoverImage];
            _scrollView.backgroundColor = [UIColor clearColor];
            _scrollView.layer.cornerRadius = 8;
            _scrollView.clipsToBounds = YES;
            _scrollView.autoScrollTimeInterval = 3;
            _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            _scrollView.hidesForSinglePage = YES;
            _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
            _scrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            [self addSubview:_scrollView];
            
            @weakify(self);
            _scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
                @strongify(self);
                if (self.clickBlock && self.bannerList.count > currentIndex) {
                    self.clickBlock(self.bannerList[currentIndex], currentIndex);
                }
            };
        }
    }
    return self;
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
}

@end
