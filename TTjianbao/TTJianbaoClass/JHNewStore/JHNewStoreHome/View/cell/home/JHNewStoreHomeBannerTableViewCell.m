//
//  JHNewStoreHomeBannerTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeBannerTableViewCell.h"
#import "JHNewStoreHomeBannerView.h"
#import "JHNewStoreBannerModel.h"
#import "JHMallModel.h"
#import "JHNewStoreHomeReport.h"

#define kScaleRatio (float)115/355

@interface JHNewStoreHomeBannerTableViewCell ()
@property (nonatomic, strong) JHNewStoreHomeBannerView *bannerView;
@property (nonatomic, strong) NSMutableArray           *dataSourceArray;
@end

@implementation JHNewStoreHomeBannerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (JHNewStoreHomeBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [JHNewStoreHomeBannerView bannerWithClickBlock:^(JHNewStoreBannerModel * _Nonnull bannerData, NSInteger index) {
            [JHRootController toNativeVC:bannerData.target.vc withParam:bannerData.target.params from:JHTrackMarketSaleClickSaleBanner];
            if ([bannerData.target.vc isEqualToString:@"JHWebViewController"]) {
                NSString *str = bannerData.target.params[@"urlString"];
                /// 商城首页 banner被点击埋点 ----
                [JHNewStoreHomeReport jhNewStoreHomeBannerClickReport:@"天天商场首页"
                                                        position_sort:index+1
                                                          content_url:@""
                                                             ad_title:str];
            } else {
                /// 商城首页 banner被点击埋点 ----
                [JHNewStoreHomeReport jhNewStoreHomeBannerClickReport:@"天天商场首页"
                                                        position_sort:index+1
                                                          content_url:@""
                                                             ad_title:bannerData.target.vc];
            }
        }];
    }
    return _bannerView;
}


- (CGFloat)bannerHeight {
    return round(kScaleRatio * (ScreenW - 24)) + 2.f;
}


- (void)setupViews {
    [self.contentView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo([self bannerHeight] + 2.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setViewModel:(id)viewModel {
    NSArray <JHMallBannerModel*>* bannerModels = viewModel;
    if (!bannerModels || bannerModels.count == 0) {
        [self.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.f);
        }];
    } else {
        [self.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([self bannerHeight] + 2.f);
        }];
        
        NSArray<JHNewStoreBannerModel *> *models = [bannerModels jh_map:^id _Nonnull(JHMallBannerModel * _Nonnull obj, NSUInteger idx) {
            JHNewStoreBannerModel *model = [[JHNewStoreBannerModel alloc] init];
            model.target                 = obj.target;
            model.landingTarget          = obj.landingTarget;
            model.status                 = obj.status;
            model.smallCoverImg          = obj.smallCoverImg;
            return model;
        }];
        self.bannerView.bannerList = models;
    }
}

@end
