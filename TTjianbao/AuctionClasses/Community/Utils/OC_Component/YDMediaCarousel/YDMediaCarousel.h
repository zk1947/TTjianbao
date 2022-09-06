//
//  YDMediaCarousel.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  媒体资源(视频、图片)轮播器
//

#import <UIKit/UIKit.h>
#import "YDMediaCarouselUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDMediaCarousel : UIView

/** 开始播放block */
@property (nonatomic, copy) void(^startPlayBlock)(void);
/** 有视频时将容器视图返回给控制层 */
@property (nonatomic, copy) void(^hasVideoBlock)(YDMediaData *data, UITapImageView *videoContainer);
/** scrollView滑动停止后，返回当前是否是视频页索引 */
@property (nonatomic, copy) void(^didEndScrollBlock)(BOOL isVideoIndex);

/** 数据源<包含图片和视频> */
@property (nonatomic, strong) NSMutableArray<YDMediaData *> *mediaList;

/** 播放结束时外部调用 */
- (void)endPlay;

@end

NS_ASSUME_NONNULL_END
