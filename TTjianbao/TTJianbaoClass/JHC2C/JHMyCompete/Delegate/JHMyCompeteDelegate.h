//
//  JHMyCompeteDelegate.h
//  TTjianbao
//
//  Created by miao on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMyCompeteModel.h"

@class  UIView;

NS_ASSUME_NONNULL_BEGIN

@protocol JHMyCompeteDelegate <NSObject>

/// 播放视频
- (void)playMyCompeteVideo:(UIView *)superView
                  videoUrl:(NSString *)videoUrl;
/// 滑动时停止播放视频
- (void)stopMyCompeteVideo;

/// 跳转商品详情
/// @param productId 商品id
- (void)jumpGoodsDetailsWith:(JHMyAuctionListItemModel *)model;


///// 立即付款
///// @param productId 商品id
//- (void)jumpImmediatePayment:(NSString *)productId;

@end

NS_ASSUME_NONNULL_END
