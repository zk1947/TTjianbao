//
//  JHGoodsDetailCustomizeHeaderCycleView.h
//  TTjianbao
//
//  Created by user on 2020/12/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbaoHeader.h"
#import "UITapImageView.h"
#import "CGoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

#define kCycleViewH    (ScreenWidth) //轮播图高度

@interface JHGoodsDetailCustomizeHeaderCycleView : UIView

@property (nonatomic, strong) NSArray<CGoodsImgInfo *> *__nullable headImgList;
@property (nonatomic, strong) NSMutableArray *photoUrls;
@property (nonatomic, strong) NSArray *payMsgList;

///含有视频资源的block
@property (nonatomic, copy) void(^hasVideoBlock)(CGoodsImgInfo *videoInfo, UITapImageView *videoContainer);
///点击播放block
@property (nonatomic, copy) void(^playClickBlock)(void);
///scroll view滑动停止后，返回当前是否是视频页索引
@property (nonatomic, copy) void(^cycleScrollEndDeceleratingBlock)(BOOL isVideoIndex);

///是否播放结束
@property (nonatomic, assign) BOOL isPlayEnd;

/// 是否支持查看原图
@property (nonatomic, assign) BOOL canLookOriginImg;

@property (nonatomic, strong) NSArray <NSString *>*originArr;
@property (nonatomic, strong) NSArray <NSString *>*mediumArr;

@property (nonatomic, assign) BOOL noNeedAspectFill;

- (void)playBtnClicked;

@end

NS_ASSUME_NONNULL_END
