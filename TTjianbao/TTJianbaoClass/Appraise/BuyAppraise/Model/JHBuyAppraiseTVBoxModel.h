//
//  JHBuyAppraiseTVBoxModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBuyAppraiseTVBoxLivingModel : NSObject

/// 频道ID
@property (nonatomic, copy) NSString *channelId;

/// HLS拉流地址
@property (nonatomic, copy) NSString *pullHlsUrl;

/// HTTP拉流地址
@property (nonatomic, copy) NSString *pullHttpUrl;

/// RTMP拉流地址
@property (nonatomic, copy) NSString *pullRtmpUrl;

/// 当前展示仓
@property (nonatomic, copy) NSString *showingDepository;

/// 当前展示流水线
///
@property (nonatomic, copy) NSString *showingPipeline;

///封面
@property (nonatomic, copy) NSString *coverImg;

@end

@interface JHBuyAppraiseTVBoxplayVideoModel : NSObject

/// 播放秒数
@property (nonatomic, assign) NSInteger playSeconds;

///当前展示仓
@property (nonatomic, copy) NSString *showingDepository;

///当前展示流水线
@property (nonatomic, copy) NSString *showingPipeline;

/// 开始播放的绝对时间
@property (nonatomic, copy) NSString *startAbsoluteTime;

/// 开始秒数
@property (nonatomic, assign) NSInteger startSeconds;

///视频地址
@property (nonatomic, copy) NSString *videoUrl;

///封面
@property (nonatomic, copy) NSString *coverImg;

@end

@interface JHBuyAppraiseTVBoxModel : NSObject

@property (nonatomic, copy) NSArray <NSString *> *currentDepositories;

@property (nonatomic, copy) NSString *desc;

/// 直播中
@property (nonatomic, strong) JHBuyAppraiseTVBoxLivingModel *liveInfo;

/// 回放
@property (nonatomic, strong) NSArray <JHBuyAppraiseTVBoxplayVideoModel *> *playbackInfos;

/// 第n个
@property (nonatomic, assign) NSInteger videoIndex;

@property (nonatomic, copy) NSString *coverUrl;

/// status (string, optional): 直播状态 直播中=live,回放中=playback
@property (nonatomic, copy) NSString *status;

/// 是否是直播中
@property (nonatomic, assign) BOOL isLiving;

+ (void)requestDataModelBlock:(void (^) (BOOL success, JHBuyAppraiseTVBoxModel *model))complete;
   
@end

NS_ASSUME_NONNULL_END
