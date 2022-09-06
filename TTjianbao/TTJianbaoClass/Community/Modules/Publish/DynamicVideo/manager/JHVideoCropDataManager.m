//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import "JHVideoCropDataManager.h"

#import "JHVideoCropManager.h"

@implementation JHVideoCropDataManager

- (instancetype)init {
    
    if (self = [super init]) {
        _minDuration = 10.0;
        _maxDuration = 300.0;
        _observerTimeSpace = CMTimeMake(1, 10);
    }
    return self;
}

#pragma mark - 接口方法

// 重新生成媒体Item
- (void)reloadPlayItemActionPath:(NSString *)outPath {
    _outPath = outPath;
    self.playItem = [[AVPlayerItem alloc] initWithAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:outPath]]];
}

- (void)setPlayItem:(AVPlayerItem *)playItem {
    
    _playItem = playItem;
    self.currentPlayTime = kCMTimeZero;
    self.playTimeRange = CMTimeRangeMake(kCMTimeZero, playItem.asset.duration);
    self.playTotalTimeRange = CMTimeRangeMake(kCMTimeZero, playItem.asset.duration);
    _playItem.forwardPlaybackEndTime = CMTimeAdd(kCMTimeZero, playItem.asset.duration);
}

- (void)setPlayTimeRange:(CMTimeRange)playTimeRange {
    
    if (CMTIME_COMPARE_INLINE(playTimeRange.start, <, kCMTimeZero)) {
        playTimeRange = CMTimeRangeMake(kCMTimeZero, playTimeRange.duration);
    }
    if (CMTIME_COMPARE_INLINE(playTimeRange.duration, >, self.playTotalTimeRange.duration)) {
        playTimeRange = CMTimeRangeMake(playTimeRange.start, self.playTotalTimeRange.duration);
    }
    _playTimeRange = playTimeRange;
}

@end
