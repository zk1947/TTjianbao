//
//  JHMpBannerCollectionViewCell.h
//  TTjianbao
//
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITapImageView.h"
#import "CGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMpBannerCollectionViewCell : UICollectionViewCell
///scroll view滑动停止后，返回当前是否是视频页索引
@property (nonatomic, copy) void(^bannerCycleScrollEndDeceleratingBlock)(BOOL isVideoIndex);
- (void)setViewModel:(NSArray<NSString *> *)viewModel;

@end

NS_ASSUME_NONNULL_END
