//
//  JHPlayerCustomConrolView.h
//  TTjianbao
//
//  Created by lihui on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "ZFPlayerControlView.h"
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "ZFSpeedLoadingView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;

@protocol JHPlayerCustomConrolViewDelegate <NSObject>

- (void)gesturePan:(CGFloat)panProgress;

@end

@interface JHPlayerCustomConrolView : UIView <ZFPlayerMediaControl>

/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;

@property (nonatomic, weak) id<JHPlayerCustomConrolViewDelegate> delegate;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
///当视频暂停时 需要显示暂停按钮
@property (nonatomic, strong) UIButton *playButton;
/// 控制层自动隐藏的时间，默认2.5秒
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;

/// 控制层显示、隐藏动画的时长，默认0.25秒
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;
///是否需要显示上面的按钮
@property (nonatomic, assign) BOOL isNeedShowTopBtn;

/// 横向滑动控制播放进度时是否显示控制层,默认 YES.
@property (nonatomic, assign) BOOL horizontalPanShowControlView;
/// 快进视图是否显示动画，默认NO.
@property (nonatomic, assign) BOOL fastViewAnimated;
/// 如果是暂停状态，seek完是否播放，默认YES
@property (nonatomic, assign) BOOL seekToPlay;
///帖子信息
@property (nonatomic, strong) JHPostDetailModel *postInfo;


/**
 设置标题、封面、全屏模式
 
 @param title 视频的标题
 @param coverUrl 视频的封面，占位图默认是灰色的
 @param fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(ZFFullScreenMode)fullScreenMode;

@property (nonatomic, copy) void(^actionBlock)(BOOL isLeft);
@property (nonatomic, copy) void(^fullScreenBlock)(void);
@property (nonatomic, copy) void(^playBlock)(BOOL isPlay);

- (void)playOrPause;
- (void)resetControlView;
- (void)prepareToRePlay;

@end

NS_ASSUME_NONNULL_END
