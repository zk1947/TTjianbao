//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


// 用户添加视频媒体的通知
#define VideoArrayItemAddNotificationName @"VideoArrayItemAddNotificationName"

// 用户删除视频的下标位置的通知
#define VideoArrayItemDeleteIndexNotificationName @"VideoArrayItemDeleteIndexNotificationName"

// 用户交换视频的下标位置的通知
#define VideoArrayItemExchangeIndexNotificationName @"VideoArrayItemExchangeIndexNotificationName"

// 播放媒体改变的通知
#define VideoPlayItemChangeNotificationName @"VideoPlayItemChangeNotificationName"

@protocol SDVideoCropVideoDragDelegate <NSObject>

@optional

// 用户开始拖拽视频左右或进度按钮
- (void)userStartChangeVideoTimeRangeAction;

// 用户正在拖拽视频左右或进度按钮,数据已经同步到JHVideoCropDataManager中
- (void)userChangeVideoTimeRangeAction;

// 用户结束拖拽视频左右按钮或者进度按钮
- (void)userEndChangeVideoTimeRangeAction;

@end

@interface JHVideoCropDataManager : NSObject

@property (nonatomic, copy) NSString *outPath;

/// 播放的媒体Item
@property(nonatomic,copy)AVPlayerItem *playItem;

/// 媒体的总播放区间
@property(nonatomic,assign)CMTimeRange playTotalTimeRange;

/// 播放的区间
@property(nonatomic,assign)CMTimeRange playTimeRange;

/// 最小的时长,默认为10s
@property(nonatomic,assign)CGFloat minDuration;

/// 最大的时长,默认为300s
@property(nonatomic,assign)CGFloat maxDuration;

/// 每过多少秒监听移除播放时间.默认为0.1s
@property(nonatomic,assign,readonly)CMTime observerTimeSpace;

/// 当前播放时间
@property(nonatomic,assign)CMTime currentPlayTime;

- (void)reloadPlayItemActionPath:(NSString *)outPath;
@end

