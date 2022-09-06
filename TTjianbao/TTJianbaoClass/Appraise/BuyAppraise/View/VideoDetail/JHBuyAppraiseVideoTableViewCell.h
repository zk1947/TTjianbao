//
//  JHBuyAppraiseVideoTableViewCell.h
//  TTjianbao
//
//  Created by lihui on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHBuyAppraiseModel;

@interface JHBuyAppraiseVideoTableViewCell : UITableViewCell

/** 快进*/
@property (nonatomic, copy) void(^seekToTimeIntervalBlock)(NSTimeInterval timeInterval);
/** 播放*/
@property (nonatomic, copy) void(^playerStatusChangedBlock)(BOOL isPlay);
/** 是否正在播放中*/
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) NSIndexPath *indexPath;
/**封面图*/
@property (nonatomic, strong) UIImageView *coverImageView;
/** 中间的播放暂停键*/
@property (nonatomic, strong) UIButton *centrPlayButton;
@property (nonatomic, strong) JHBuyAppraiseModel *videoModel;
@property (nonatomic, copy) void(^sliderBlock)(float seekTime);

///设置当前播放时间
- (void)setCurrentTime:(NSTimeInterval)currentTime
             totalTime:(NSTimeInterval)totalTime
           prePlayTime:(NSTimeInterval)prePlayTime;
- (void)startLoading;
- (void)stopLoading;
- (void)showRetry;


@end

NS_ASSUME_NONNULL_END
