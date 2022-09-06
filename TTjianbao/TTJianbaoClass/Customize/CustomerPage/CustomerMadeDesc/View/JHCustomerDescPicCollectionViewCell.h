//
//  JHCustomerDescPicCollectionViewCell.h
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITapImageView.h"
#import "CGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerDescPicCollectionViewCell : UICollectionViewCell
///含有视频资源的block
@property (nonatomic, copy) void(^bannerHasVideoBlock)(CGoodsImgInfo *videoInfo, UITapImageView *videoContainer);
///点击播放block
@property (nonatomic, copy) void(^bannerPlayClickBlock)(void);

/// 原料信息按钮
@property (nonatomic, copy) void(^stuffBtnActionBlock)(BOOL isComplete);

///scroll view滑动停止后，返回当前是否是视频页索引
@property (nonatomic, copy) void(^bannerCycleScrollEndDeceleratingBlock)(BOOL isVideoIndex);


///是否播放结束
@property (nonatomic, assign) BOOL isPlayEnd;


- (void)setViewModel:(id)viewModel;
//- (void)setCompleteLogoHidden:(BOOL)isComplete;
@end

NS_ASSUME_NONNULL_END
