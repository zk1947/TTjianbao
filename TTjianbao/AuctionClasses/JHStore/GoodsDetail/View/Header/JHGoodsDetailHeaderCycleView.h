//
//  JHGoodsDetailHeaderCycleView.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  视频、图片轮播器
//

#import <UIKit/UIKit.h>
#import "TTjianbaoHeader.h"
#import "UITapImageView.h"
#import "CGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kCycleViewH    (ScreenWidth) //轮播图高度

@interface JHGoodsDetailHeaderCycleView : UIView

@property (nonatomic, strong) NSArray<CGoodsImgInfo *> *headImgList;
@property (nonatomic, strong) NSArray *payMsgList;

///含有视频资源的block
@property (nonatomic, copy) void(^hasVideoBlock)(CGoodsImgInfo *videoInfo, UITapImageView *videoContainer);
///点击播放block
@property (nonatomic, copy) void(^playClickBlock)(void);
///scroll view滑动停止后，返回当前是否是视频页索引
@property (nonatomic, copy) void(^cycleScrollEndDeceleratingBlock)(BOOL isVideoIndex);

///是否播放结束
@property (nonatomic, assign) BOOL isPlayEnd;

- (void)playBtnClicked;

@end

NS_ASSUME_NONNULL_END
