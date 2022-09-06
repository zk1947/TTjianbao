//
//  NELivePlayerControlView.h
//  NELivePlayerDemo
//
//  Created by Netease on 2017/11/15.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NELivePlayerControlViewProtocol;

#import "BaseView.h"

@interface NELivePlayerControlView : BaseView

@property (nonatomic, assign, readonly) BOOL isDragging; //正在拖拽

@property (nonatomic, assign) NSTimeInterval currentPos; //当前播放时间

@property (nonatomic, assign) NSTimeInterval duration; //视频时长

@property (nonatomic, copy) NSString *fileTitle; //视频标题

@property (nonatomic, assign) BOOL isPlaying; //正在播放

@property (nonatomic, assign) BOOL isBuffing; //正在缓冲

@property (nonatomic, assign) BOOL isAllowSeek; //是否允许seek

@property (nonatomic, weak) id<NELivePlayerControlViewProtocol> delegate;

@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *subtitle_ex;
@property (nonatomic, assign) CGSize videoResolution;

@end

@protocol NELivePlayerControlViewProtocol <NSObject>

- (void)controlViewOnClickQuit:(NELivePlayerControlView *)controlView;
- (void)controlViewOnClickPlay:(NELivePlayerControlView *)controlView isPlay:(BOOL)isPlay;
- (void)controlViewOnClickSeek:(NELivePlayerControlView *)controlView dstTime:(NSTimeInterval)dstTime;
- (void)controlViewOnClickMute:(NELivePlayerControlView *)controlView isMute:(BOOL)isMute;
- (void)controlViewOnClickSnap:(NELivePlayerControlView *)controlView;
- (void)controlViewOnClickScale:(NELivePlayerControlView *)controlView isFill:(BOOL)isFill;
@end
