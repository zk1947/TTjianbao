//
//  JHGoodsDetailHeaderView.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  header
//

#import <UIKit/UIKit.h>
#import "TTjianbaoHeader.h"
#import "CGoodsDetailModel.h"
#import "JHGoodsDetailHeaderCycleView.h"

@class UITapImageView;

NS_ASSUME_NONNULL_BEGIN

/*!
 * header  - CGodsInfo：头部轮播图<headImgList>、钱数/倒计时、商品名、商品描述
 *       - CShopInfo：店铺信息
 *       - safeHeadImgInfo：店铺信息下面的保障图
 */


///存在视频资源block
typedef void (^HasVideoInfoBlock)(CGoodsImgInfo *videoInfo, UITapImageView *videoContainer);

@interface JHGoodsDetailHeaderView : UIView

@property (nonatomic, copy) void(^countDownEndBlock)(CGoodsInfo *info);

///高度发生变化，isFill=YES表示描述信息已展开全部
@property (nonatomic, copy) void(^headerHeightChangedBlock)(BOOL isFill);
///点击播放block
@property (nonatomic, copy) void(^playClickBlock)(void);
///scroll view滑动停止后，返回当前是否是视频页索引
@property (nonatomic, copy) void(^cycleScrollEndDeceleratingBlock)(BOOL isVideoIndex);

///是否播放结束
@property (nonatomic, assign) BOOL isPlayEnd;

@property (nonatomic, strong) CGoodsDetailModel *curModel;

+ (CGFloat)heightWithGoodsModel:(CGoodsDetailModel *)model isFill:(BOOL)isFill;

- (instancetype)initWithFrame:(CGRect)frame goodsModel:(CGoodsDetailModel *)model hasVideoBlock:(HasVideoInfoBlock)hasBlock;

#pragma mark --------------- 自动播放 ---------------
/// 自动播放
@property (nonatomic, assign) BOOL autoPlay;

/// 静音
@property (nonatomic, assign) BOOL isMute;

@property (nonatomic, copy) dispatch_block_t muteBlock;

@end

NS_ASSUME_NONNULL_END
