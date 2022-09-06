//
//  JHCycleCollectionViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCycleCollectionViewCell.h"
#import "SDCycleScrollView.h"
#import "BannerMode.h"
#import "JHSkinManager.h"
#import "JHSkinSceneManager.h"
#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"


#define bannerHeight (70./355*(ScreenW-20))


@interface JHCycleCollectionViewCell () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labelArray;

@end


@implementation JHCycleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 8.f;
    view.layer.masksToBounds = YES;
    [view addSubview:self.cycleScrollView];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerCustomerModel *model = self.bannerArray[index];
    
    //hutao-add
//    NSMutableDictionary *params = model.target.params;
    
    [JHRootController toNativeVC:model.target.componentName withParam:model.target.params from:JHLiveFrompersonalBanner];
    
    //与JHLiveFrompersonalBanner优点重复
    ///个人中心banner被点击埋点  ---- 
//    [JHGrowingIO trackEventId:JHTrackMarketSaleBannerItemClick from:JHTrackMarketSaleClickPersonalBanner];
    [JHGrowingIO trackEventId:JHTrackMarketSaleBannerItemClick variables:@{
        @"from" : @"JHTrackMarketSaleClickPersonalBanner",
        @"banner_item_place_id":@(index+1),
        @"paly_name":NONNULL_STR(model.title)
    }];
    
    NSMutableDictionary *params2 = [NSMutableDictionary new];
    [params2 setValue:@"个人中心" forKey:@"page_position"];
    [params2 setValue:@(index) forKey:@"position_sort"];
    [params2 setValue:model.target.recordComponentName forKey:@"content_url"];
    [JHAllStatistics jh_allStatisticsWithEventId:@"bannerClick" params:params2 type:JHStatisticsTypeSensors];
}

- (void)setBannerArray:(NSMutableArray *)bannerArray {
    if(!bannerArray) {
        ///重复值闪烁
        return;
    }
    _bannerArray = bannerArray;
    NSMutableArray *urls = [NSMutableArray array];
    for (BannerCustomerModel *model in _bannerArray) {
        [urls addObject:model.image];
    }
    self.cycleScrollView.imageURLStringsGroup = urls;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW-20, bannerHeight)  delegate:self placeholderImage:kDefaultCoverImage];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView. infiniteLoop = YES;
        _cycleScrollView.layer.cornerRadius = 8.f;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _cycleScrollView;
    
}

@end
