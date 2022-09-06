//
//  JHOnlineAppraiseVideoDetailCell.h
//  TTjianbao
//
//  Created by lihui on 2020/12/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPostDetailEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;

static NSString *const kVideoDetailIdentifer = @"kJHOnlineVideoDetailControllerIdentifer";

@interface JHOnlineAppraiseVideoDetailCell : UITableViewCell
/** 快进*/
@property (nonatomic, copy) void(^seekToTimeIntervalBlock)(NSTimeInterval timeInterval);
/** 播放*/
@property (nonatomic, copy) void(^playerStatusChangedBlock)(BOOL isPlay);
/** 是否正在播放中*/
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) JHPostDetailModel *postDetail;
/** 封面图 播放器载体*/
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL showFollowBtn;
@property (nonatomic, copy) void (^actionBlock)(NSInteger selectIndex, JHFullScreenControlActionType actionType);
- (void)refreshAnimation;
- (void)updateFollowStatus:(BOOL)isFollow;
- (void)updateCommentInfo:(NSInteger)commentCount;
- (void)updateLikeInfo:(NSInteger)likeCount isLike:(BOOL)isLike;

//更新播放进度
- (void)setCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime prePlayTime:(NSTimeInterval)prePlayTime;
- (void)startLoading;
- (void)stopLoading;
- (void)showRetry;
@end

NS_ASSUME_NONNULL_END
