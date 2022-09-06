//
//  JHPlayControlView.h
//  TTJB
//
//  Created by 王记伟 on 2021/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHPlayControlView;
@protocol JHPlayControlViewDelegate <NSObject>
@optional;
- (void)controlView:(JHPlayControlView *)controlView showStatus:(BOOL)isShowing;
- (void)controlView:(JHPlayControlView *)controlView playStatus:(BOOL)isPlay;
- (void)controlView:(JHPlayControlView *)controlView changeProgress:(CGFloat)progress;
- (void)controlView:(JHPlayControlView *)controlView fullScreen:(BOOL)toFullScreen;
- (void)controlView:(JHPlayControlView *)controlView changeResolution:(NSInteger)resolution;
- (void)controlView:(JHPlayControlView *)controlView retry:(NSInteger)times;
- (void)controlView:(JHPlayControlView *)controlView playBackSpeed:(CGFloat)speed;
- (void)controlView:(JHPlayControlView *)controlView muted:(BOOL)isMuted;
- (void)controlView:(JHPlayControlView *)controlView mixWithOther:(BOOL)isOn;

@end

@interface JHPlayControlView : UIView

@property (nonatomic, weak) id<JHPlayControlViewDelegate> delegate;
/** 标题*/
@property (nonatomic,   copy) NSString *titleInfo;
/** 当前时间*/
@property (nonatomic, assign) NSTimeInterval currentPlayingTime;
/** 总时长*/
@property (nonatomic, assign) NSTimeInterval timeDuration;
/** 缓冲时长*/
@property (nonatomic, assign) NSTimeInterval playableDuration;
/** 是否播放*/
@property (nonatomic, assign) BOOL play;
/** 是否是全屏*/
@property (nonatomic, assign) BOOL fullScreen;
/** 是否是竖屏*/
@property (nonatomic, assign) BOOL verticalScreen;
    
- (void)startLoading;
- (void)stopLoading;
- (void)showRetry;

//更新播放进度
- (void)setCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime prePlayTime:(NSTimeInterval)prePlayTime;

//播放完成后添加分享页面
- (void)setCompleteView:(UIView *)completeView;
@end

NS_ASSUME_NONNULL_END
