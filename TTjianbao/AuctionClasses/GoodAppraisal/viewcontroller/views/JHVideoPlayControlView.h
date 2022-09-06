//
//  JHVideoPlayControlView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/9.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbaoBussiness.h"

@protocol JHVideoPlayControlViewProtocol;

#import "BaseView.h"

@interface JHVideoPlayControlView : BaseView
@property (nonatomic, assign, readonly) BOOL isDragging; //正在拖拽

@property (nonatomic, assign) NSTimeInterval currentPos; //当前播放时间

@property (nonatomic, assign) NSTimeInterval duration; //视频时长

@property (nonatomic, copy) NSString *fileTitle; //视频标题

@property (nonatomic, assign) BOOL isPlaying; //正在播放

@property (nonatomic, assign) BOOL isBuffing; //正在缓冲

@property (nonatomic, assign) BOOL isAllowSeek; //是否允许seek

@property (assign, nonatomic) BOOL playControlHidden;
@property (nonatomic, weak) id<JHVideoPlayControlViewProtocol> delegate;

@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *subtitle_ex;
@property (nonatomic, assign) CGSize videoResolution;
@property(strong,nonatomic)AppraisalDetailMode* appraisalDetail;
@property(assign,nonatomic)BOOL isLike;

@end

@protocol JHVideoPlayControlViewProtocol <NSObject>

@optional
- (void)controlViewOnClickQuit:(JHVideoPlayControlView *)controlView;
- (void)controlViewOnClickPlay:(JHVideoPlayControlView *)controlView isPlay:(BOOL)isPlay;
- (void)controlViewOnClickSeek:(JHVideoPlayControlView *)controlView dstTime:(NSTimeInterval)dstTime;
- (void)controlViewOnClickMute:(JHVideoPlayControlView *)controlView isMute:(BOOL)isMute;
- (void)controlViewOnClickSnap:(JHVideoPlayControlView *)controlView;
- (void)controlViewOnClickScale:(JHVideoPlayControlView *)controlView isFill:(BOOL)isFill;
- (void)controlViewOnClickShare:(JHVideoPlayControlView *)controlView;
- (void)controlViewOnClickLike:(JHVideoPlayControlView *)controlView isLike:(BOOL)like;
- (void)controlViewOnClickHeadImage:(JHVideoPlayControlView *)controlView ;
@end


