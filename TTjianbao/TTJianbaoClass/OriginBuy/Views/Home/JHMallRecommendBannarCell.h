//
//  JHMallRecommendBannarCell.h
//  TTjianbao
//
//  Created by wangjianios on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "GKCycleScrollViewCell.h"

@class JHMallBannerModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHMallRecommendBannarCell : GKCycleScrollViewCell

@property (nonatomic, strong) JHMallBannerModel *model;

@end

NS_ASSUME_NONNULL_END
