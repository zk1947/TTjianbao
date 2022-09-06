//
//  JHPlayerViewController.h
//  TTJB
//
//  Created by 王记伟 on 2021/1/15.
//

#import <UIKit/UIKit.h>
#import "JHPlayControlView.h"
#import <TTSDKFramework/TTVideoEngineHeader.h>
#import <TTSDKFramework/TTSDKManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPlayerViewController : UIViewController

/** 播放状态回调*/
@property (nonatomic, copy) void(^playbackStateDidChangedBlock)(TTVideoEnginePlaybackState playbackState);
/** 加载状态回调*/
@property (nonatomic, copy) void(^loadStateDidChangedBlock)(TTVideoEngineLoadState loadState);
/** 播放时间回调*/
@property (nonatomic, copy) void(^playTimeChangeBlock)(NSTimeInterval currentPlaybackTime, NSTimeInterval duration, NSTimeInterval playableDuration);

/** 播放器*/
@property (nonatomic, strong) TTVideoEngine *engine;
/** 切换播放数据源*/
@property (nonatomic, copy) NSString *urlString;
/** 循环播放,默认NO*/
@property (nonatomic, assign) BOOL looping;
/** 静音,默认NO*/
@property (nonatomic, assign) BOOL muted;
/** 全屏后是否是竖屏*/
@property (nonatomic, assign) BOOL isVerticalScreen;
/** 全屏后的控制图层*/
@property (nonatomic, strong) JHPlayControlView *fullScreenView;
/** 是否正在播放*/
@property (nonatomic, assign) BOOL isPLaying;
/** 旋转完成*/
@property (nonatomic, copy) void(^rotationCompleteBlock)(TTVideoEnginePlaybackState playbackState);
/** 是否监听网络变化而选择自动播放*/
@property (nonatomic, assign) BOOL alwaysPlay;
/** 非自动播放是否展示播放按钮*/
@property (nonatomic, assign) BOOL hidePlayButton;
/** 设定初始的控制图层*/
- (void)setControlView:(JHPlayControlView *)controlView;
/** 设置subViews的frame*/
- (void)setSubviewsFrame;
//暂停
- (void)pause;
//播放
- (void)play;
//结束
- (void)stop;
//跳转到某一时间
- (void)seekToTime:(NSTimeInterval)timeInterval;
//播放完成后添加分享页面
- (void)setCompleteView:(UIView *)completeView;

@end

NS_ASSUME_NONNULL_END
