//
//  JHPlayerCustomConrolView.m
//  TTjianbao
//
//  Created by lihui on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlayerCustomConrolView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#import <ZFPlayer/ZFPlayerController.h>
//#import <ZFPlayer/ZFPlayerConst.h>
#import "ZFSliderView.h"
#import "UIImageView+ZFCache.h"
#import "ZFVolumeBrightnessView.h"
#import "JHPostDetailModel.h"
#import "JHSQModel.h"

@interface JHPlayerCustomConrolView () <ZFSliderViewDelegate>

/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
///左侧按钮
@property (nonatomic, strong) UIButton *leftButton;
///右侧按钮
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *titleLabel;
/// 播放的当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) BOOL controlViewAppeared;

@property (nonatomic, strong) dispatch_block_t afterBlock;

@property (nonatomic, assign) NSTimeInterval sumTime;

/// 底部播放进度
@property (nonatomic, strong) ZFSliderView *bottomPgrogress;

/// 加载loading
@property (nonatomic, strong) ZFSpeedLoadingView *activity;

/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) ZFVolumeBrightnessView *volumeBrightnessView;

/// 快进快退View
@property (nonatomic, strong) UIView *fastView;
/// 快进快退进度progress
@property (nonatomic, strong) ZFSliderView *fastProgressView;
/// 快进快退时间
@property (nonatomic, strong) UILabel *fastTimeLabel;
/// 快进快退ImageView
@property (nonatomic, strong) UIImageView *fastImageView;
/// 加载失败按钮
@property (nonatomic, strong) UIButton *failBtn;

@end

@implementation JHPlayerCustomConrolView
@synthesize player = _player;

- (void)setPostInfo:(JHPostDetailModel *)postInfo {
    if (!postInfo) {
        return;
    }
    _postInfo = postInfo;
    NSString *content = [[_postInfo.content componentsSeparatedByString:@"\n"] componentsJoinedByString:@""];
    content = [[content componentsSeparatedByString:@"&nbsp;"] componentsJoinedByString:@""];
    _titleLabel.text = [_postInfo.title isNotBlank] ? _postInfo.title : content;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isNeedShowTopBtn = YES;
        _horizontalPanShowControlView = YES;
        _autoFadeTimeInterval = 0.25;
        _autoHiddenTimeInterval = 2.5;

        // 添加子控件
        [self addSubview:self.coverImageView];
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.leftButton];
        [self.topToolView addSubview:self.rightButton];
        [self.topToolView addSubview:self.titleLabel];
        
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.fullScreenBtn];

        [self addSubview:self.bottomPgrogress];
        [self addSubview:self.activity];
        [self addSubview:self.failBtn];
        [self addSubview:self.fastView];
        [self.fastView addSubview:self.fastImageView];
        [self.fastView addSubview:self.fastTimeLabel];
        [self.fastView addSubview:self.fastProgressView];
        [self addSubview:self.playButton];
        
        self.autoFadeTimeInterval = 0.2;
        self.autoHiddenTimeInterval = 2.5;

        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        [self resetControlView];
        self.clipsToBounds = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(volumeChanged:)
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
    }
    return self;
}

- (void)setIsNeedShowTopBtn:(BOOL)isNeedShowTopBtn {
    _isNeedShowTopBtn = isNeedShowTopBtn;
    [self setupBackButton];
}

- (void)makeSubViewsAction {
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
            }
        }];
    } else {
        self.slider.isdragging = NO;
    }
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
}

- (void)sliderTapped:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
                [self.player.currentPlayerManager play];
            }
        }];
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

#pragma mark - action

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

- (void)growingForEnterFullScreen {
    NSMutableArray *topicIds = [NSMutableArray array];
    for (JHTallyInfo *info in self.postInfo.labels) {
        [topicIds addObject:@(info.labelId)];
    }

    NSDictionary *dic = @{@"page_from" : JHFromSQPostDetail,
                          @"item_type" : @(self.postInfo.item_type),
                          @"item_id" : self.postInfo.item_id,
                          @"author_id" : self.postInfo.publisher.user_id,
                          @"plate_id" : self.postInfo.plateInfo.ID,
                          @"topic_ids" : topicIds.mj_JSONString
    };
    
    NSString *key = nil;
    if (self.postInfo.item_type == JHPostItemTypePost) {
        ///长文章
        key = JHTrackSQArticleDetailVideoEnter;
    }
    else {
        key = JHTrackSQTwitterDetailVideoEnter;
    }
    if ([key isNotBlank]) {
        [JHAllStatistics jh_allStatisticsWithEventId:key params:dic  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
    }
}

- (void)fullScreenButtonClickAction:(UIButton *)sender {
    if (!self.player.isFullScreen) {
        ///340埋点 - 动态详情页点开视频（全屏）
        [self growingForEnterFullScreen];
    }
    
    if (self.postInfo.wh_scale <= 1 && self.postInfo.item_type != JHPostItemTypePost) {
        ///是竖屏全屏显示
        ///长文章不需要走这个逻辑
        if (self.fullScreenBlock) {
            self.fullScreenBlock();
        }
    }
    else {
        sender.selected = !sender.selected;
        [self setupBackButton];
        [self.player enterFullScreen:!self.player.isFullScreen animated:YES];
    }
}

- (void)setupBackButton {
    if (self.isNeedShowTopBtn) {
        self.leftButton.hidden = NO;
    }
    else {
        self.leftButton.hidden = !self.fullScreenBtn.selected;
    }
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected ? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
    if (self.playBlock) {
        self.playBlock(self.playOrPauseBtn.isSelected);
    }
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
    self.playButton.hidden = selected;
    self.playButton.selected = !selected;
}

#pragma mark - 添加子控件约束

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    self.coverImageView.frame = self.bounds;
    
    min_w = 80;
    min_h = 80;
    self.activity.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.activity.zf_centerX = self.zf_centerX;
    self.activity.zf_centerY = self.zf_centerY + 10;
        
    min_w = 150;
    min_h = 30;
    self.failBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.failBtn.center = self.center;
    
    min_w = 140;
    min_h = 80;
    self.fastView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fastView.center = self.center;
    
    min_w = 32;
    min_x = (self.fastView.zf_width - min_w) / 2;
    min_y = 5;
    min_h = 32;
    self.fastImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = self.fastImageView.zf_bottom + 2;
    min_w = self.fastView.zf_width;
    min_h = 20;
    self.fastTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 12;
    min_y = self.fastTimeLabel.zf_bottom + 5;
    min_w = self.fastView.zf_width - 2 * min_x;
    min_h = 10;
    self.fastProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);

    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = self.player.isFullScreen ? 64 : UI.statusAndNavBarHeight;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 44.f;
    min_h = 44.f;
    min_x = self.player.isFullScreen ? (iPhoneX?30:0) : 5;
    min_y = self.topToolView.bounds.size.height - min_h;
    self.leftButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = ScreenW - 50.f;
    min_y = iPhoneX ? 44.f : 20.f;
    min_w = 44.f;
    min_h = 44.f;
    self.rightButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.rightButton.zf_centerY = self.leftButton.zf_centerY;

    min_x = self.player.isFullScreen ? (iPhoneX ? 64 : 44) : 54;
    min_y = 20;
    min_w = ScreenW*2/3;
    min_h = 25.f;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.titleLabel.zf_centerY = self.leftButton.zf_centerY;

    min_h = (iPhoneX && self.player.isFullScreen) ? 80 : 40;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.player.isFullScreen ? (iPhoneX?30:0) : 5;
    min_y = 0;
    min_w = 44.f;
    min_h = min_w;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);

    min_x = self.playOrPauseBtn.zf_right + 5;
    min_w = 35;
    min_h = 28;
    min_y = (self.bottomToolView.zf_height - min_h)/2;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playOrPauseBtn.zf_centerY = self.currentTimeLabel.zf_centerY;

    min_w = 44.f;
    min_h = min_w;
    min_x = self.bottomToolView.zf_width - min_w - ((iPhoneX && self.player.isFullScreen) ? 30 : 10);
    min_y = 0;
    self.fullScreenBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fullScreenBtn.zf_centerY = self.currentTimeLabel.zf_centerY;

    min_w = 35;
    min_h = 28;
    min_x = self.fullScreenBtn.zf_left - min_w - 4 - 5;
    min_y = 0;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_x = self.currentTimeLabel.zf_right + 10;
    min_y = 0;
    min_w = self.totalTimeLabel.zf_left - min_x - 10;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_x = 0;
    min_y = min_view_h - 1;
    min_w = min_view_w;
    min_h = 1;
    self.bottomPgrogress.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 40;
    min_h = 40;
    self.playButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playButton.center = CGPointMake(self.center.x, self.center.y+(!self.player.isFullScreen ? 20 : 0));
    
    if (!self.isShow) {
//        self.topToolView.zf_y = -self.topToolView.zf_height;
        self.bottomToolView.zf_y = self.zf_height;
        self.playOrPauseBtn.alpha = 0;
    } else {
//        self.topToolView.zf_y = 0;
        self.bottomToolView.zf_y = self.zf_height - self.bottomToolView.zf_height;
        self.playOrPauseBtn.alpha = 1;
    }
}

- (void)prepareToRePlay {
    self.backgroundColor             = [UIColor clearColor];
    self.bottomToolView.alpha        = 1;
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.bottomPgrogress.value       = 0;
    self.playOrPauseBtn.selected     = YES;
    self.volumeBrightnessView.hidden = YES;
    self.playOrPauseBtn.selected     = NO;
    [self.player.currentPlayerManager pause];
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
}

#pragma mark - private

/** 重置ControlView */
- (void)resetControlView {
    self.playButton.hidden           = YES;
    self.bottomToolView.alpha        = 1;
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.volumeBrightnessView.hidden = YES;
    self.failBtn.hidden              = YES;
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
}

- (void)showControlView {
//    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = YES;
//    self.topToolView.zf_y            = 0;
    self.bottomToolView.zf_y         = self.zf_height - self.bottomToolView.zf_height;
    self.playOrPauseBtn.alpha        = 1;
    self.player.statusBarHidden      = NO;
}

- (void)hideControlView {
    self.isShow                      = NO;
//    self.topToolView.zf_y            = -self.topToolView.zf_height;
    self.bottomToolView.zf_y         = self.zf_height;
    self.player.statusBarHidden      = NO;
    self.playOrPauseBtn.alpha        = 0;
//    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
}

- (void)autoFadeOutControlView {
    self.controlViewAppeared = YES;
    [self cancelAutoFadeOutControlView];
    @weakify(self)
    self.afterBlock = dispatch_block_create(0, ^{
        @strongify(self)
        [self hideControlViewWithAnimated:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.autoHiddenTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(),self.afterBlock);
}

/// 取消延时隐藏controlView的方法
- (void)cancelAutoFadeOutControlView {
    if (self.afterBlock) {
        dispatch_block_cancel(self.afterBlock);
        self.afterBlock = nil;
    }
}

/// 隐藏控制层
- (void)hideControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = NO;
    [UIView animateWithDuration:animated ? self.autoFadeTimeInterval : 0 animations:^{
        [self hideControlView];
    } completion:^(BOOL finished) {
        self.bottomPgrogress.hidden = NO;
    }];
}

/// 显示控制层
- (void)showControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = YES;
    [self autoFadeOutControlView];
    self.rightButton.hidden = self.player.isFullScreen;
    if (self.player.isFullScreen) {
        _titleLabel.hidden = (_postInfo.item_type == JHPostItemTypePost && _postInfo.wh_scale <= 1);
    }
    else {
        _titleLabel.hidden = YES;
    }
    [UIView animateWithDuration:animated ? self.autoFadeTimeInterval : 0 animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.bottomPgrogress.hidden = YES;
    }];
}


- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    return YES;
}

/**
 设置标题、封面、全屏模式
 
 @param title 视频的标题
 @param coverUrl 视频的封面，占位图默认是灰色的
 @param fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    UIImage *placeholder = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:self.coverImageView.bounds.size];
    [self resetControlView];
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    [self.coverImageView setImageWithURLString:coverUrl placeholder:placeholder];
//    [self.player.currentPlayerManager.view.coverImageView setImageWithURLString:coverUrl placeholder:placeholder];
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - ZFPlayerControlViewDelegate

/// 手势筛选，返回NO不响应该手势
- (BOOL)gestureTriggerCondition:(ZFPlayerGestureControl *)gestureControl gestureType:(ZFPlayerGestureType)gestureType gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer touch:(nonnull UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen && gestureType != ZFPlayerGestureTypeSingleTap) {
        return NO;
    }
    
    return [self shouldResponseGestureWithPoint:point withGestureType:gestureType touch:touch];
}

/// 单击手势事件
- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
    if (!self.player) return;
    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen) {
        [self.player enterFullScreen:YES animated:YES];
    } else {
        if (self.controlViewAppeared) {
            [self hideControlViewWithAnimated:YES];
        } else {
            /// 显示之前先把控制层复位，先隐藏后显示
            [self hideControlViewWithAnimated:NO];
            [self showControlViewWithAnimated:YES];
        }
    }
}

/// 双击手势事件
- (void)gestureDoubleTapped:(ZFPlayerGestureControl *)gestureControl {
//    [self playOrPause];
}

/// 捏合手势事件，这里改变了视频的填充模式
- (void)gesturePinched:(ZFPlayerGestureControl *)gestureControl scale:(float)scale {
    self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
//    if (scale > 1) {
//        self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
//    } else {
//        self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
//    }
}

/// 准备播放
- (void)videoPlayer:(ZFPlayerController *)videoPlayer prepareToPlay:(NSURL *)assetURL {
    [self hideControlViewWithAnimated:NO];
}

/// 播放状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer playStateChanged:(ZFPlayerPlaybackState)state {
    if (state == ZFPlayerPlayStatePlaying) {
        [self playBtnSelectedState:YES];
        /// 开始播放时候判断是否显示loading
        if (videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStateStalled) {
            [self.activity startAnimating];
        } else if ((videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStateStalled || videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStatePrepare)) {
            [self.activity startAnimating];
        }
    } else if (state == ZFPlayerPlayStatePaused) {
        [self playBtnSelectedState:NO];
        /// 暂停的时候隐藏loading
        [self.activity stopAnimating];
    } else if (state == ZFPlayerPlayStatePlayFailed) {
        [self.activity stopAnimating];
    }
}

/// 加载状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state {
    if (state == ZFPlayerLoadStatePrepare) {
        self.coverImageView.hidden = NO;
    } else if (state == ZFPlayerLoadStatePlaythroughOK || state == ZFPlayerLoadStatePlayable) {
        self.coverImageView.hidden = YES;
        self.player.currentPlayerManager.view.backgroundColor = [UIColor blackColor];
    }
    if (state == ZFPlayerLoadStateStalled && videoPlayer.currentPlayerManager.isPlaying) {
        [self.activity startAnimating];
    } else if ((state == ZFPlayerLoadStateStalled || state == ZFPlayerLoadStatePrepare) && videoPlayer.currentPlayerManager.isPlaying) {
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
    }
}

/// 播放进度改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        self.slider.value = videoPlayer.progress;
    }
    self.bottomPgrogress.value = videoPlayer.progress;
}

/// 缓冲改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
    self.bottomPgrogress.bufferValue = videoPlayer.bufferProgress;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
    
}

/// 视频view即将旋转
- (void)videoPlayer:(ZFPlayerController *)videoPlayer orientationWillChange:(ZFOrientationObserver *)observer {
    if (videoPlayer.isSmallFloatViewShow) {
        if (observer.isFullScreen) {
            self.controlViewAppeared = NO;
            [self cancelAutoFadeOutControlView];
        }
    }
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
}

/// 视频view已经旋转
- (void)videoPlayer:(ZFPlayerController *)videoPlayer orientationDidChanged:(ZFOrientationObserver *)observer {
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
    [self layoutIfNeeded];
    [self setNeedsDisplay];
}

/// 锁定旋转方向
- (void)lockedVideoPlayer:(ZFPlayerController *)videoPlayer lockedScreen:(BOOL)locked {
    [self showControlViewWithAnimated:YES];
}

#pragma mark - setter

- (void)setPlayer:(ZFPlayerController *)player {
    _player = player;
}

- (void)handleLeftButtonEvent {
    if (self.actionBlock) {
        self.fullScreenBtn.selected = NO;
        [self setupBackButton];
        self.actionBlock(YES);
    }
}

- (void)handleRightButtonButtonEvent {
    if (self.actionBlock) {
        self.actionBlock(NO);
    }
}

#pragma mark - getter

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"icon_post_detail_stop"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"icon_post_detail_play"] forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:11.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithWhite:1 alpha:.2];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = kColorMain;
        [_slider setThumbImage:[UIImage imageNamed:@"icon_post_detail_track"] forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:11.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIView *)fastView {
    if (!_fastView) {
        _fastView = [[UIView alloc] init];
        _fastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _fastView.layer.cornerRadius = 4;
        _fastView.layer.masksToBounds = YES;
        _fastView.hidden = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel = [[UILabel alloc] init];
        _fastTimeLabel.textColor = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _fastTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _fastTimeLabel;
}

- (ZFSliderView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView = [[ZFSliderView alloc] init];
        _fastProgressView.maximumTrackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        _fastProgressView.minimumTrackTintColor = [UIColor whiteColor];
        _fastProgressView.sliderHeight = 2;
        _fastProgressView.isHideSliderBlock = NO;
    }
    return _fastProgressView;
}

- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _failBtn.hidden = YES;
    }
    return _failBtn;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"icon_post_detail_full_screen"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"icon_post_detail_fold"] forState:UIControlStateSelected];
    }
    return _fullScreenBtn;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (ZFSliderView *)bottomPgrogress {
    if (!_bottomPgrogress) {
        _bottomPgrogress = [[ZFSliderView alloc] init];
        _bottomPgrogress.maximumTrackTintColor = [UIColor clearColor];
        _bottomPgrogress.minimumTrackTintColor = [UIColor whiteColor];
        _bottomPgrogress.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _bottomPgrogress.sliderHeight = 1;
        _bottomPgrogress.isHideSliderBlock = NO;
    }
    return _bottomPgrogress;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:kNavBackWhiteShadowImg forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(handleLeftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"topic_nav_more1"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(handleRightButtonButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _titleLabel.textColor = kColorFFF;
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"icon_play_cirle"] forState:UIControlStateSelected];
        _playButton.hidden = IS_OPEN_RECOMMEND;
        [_playButton addTarget:self action:@selector(playCenterButtonBlock) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (void)playCenterButtonBlock {
    [self.player.currentPlayerManager play];
}

- (ZFSpeedLoadingView *)activity {
    if (!_activity) {
        _activity = [[ZFSpeedLoadingView alloc] init];
    }
    return _activity;
}

/// 音量改变的通知
- (void)volumeChanged:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *reasonstr = userInfo[@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"];
    if ([reasonstr isEqualToString:@"ExplicitVolumeChange"]) {
        float volume = [ userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
        if (self.player.isFullScreen) {
            [self.volumeBrightnessView updateProgress:volume withVolumeBrightnessType:ZFVolumeBrightnessTypeVolume];
        } else {
            [self.volumeBrightnessView addSystemVolumeView];
        }
    }
}

/// 滑动中手势事件
- (void)gestureChangedPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location withVelocity:(CGPoint)velocity {
    if (direction == ZFPanDirectionH && self.player.isFullScreen) {
        // 每次滑动需要叠加时间
        self.sumTime += velocity.x / 200;
        // 需要限定sumTime的范围
        NSTimeInterval totalMovieDuration = self.player.totalTime;
        if (totalMovieDuration == 0) return;
        if (self.sumTime > totalMovieDuration) self.sumTime = totalMovieDuration;
        if (self.sumTime < 0) self.sumTime = 0;
        BOOL style = NO;
        if (velocity.x > 0) style = YES;
        if (velocity.x < 0) style = NO;
        if (velocity.x == 0) return;
        [self sliderValueChangingValue:self.sumTime/totalMovieDuration isForward:style];
        
    } else if (direction == ZFPanDirectionV) {
        
        if (location == ZFPanLocationLeft) { /// 调节亮度
            if (self.player.isFullScreen) {
                self.player.brightness -= (velocity.y) / 10000;
                [self.volumeBrightnessView updateProgress:self.player.brightness withVolumeBrightnessType:ZFVolumeBrightnessTypeumeBrightness];
            }
        } else if (location == ZFPanLocationRight) { /// 调节声音
            if (self.player.isFullScreen) {
                self.player.volume -= (velocity.y) / 10000;
                [self.volumeBrightnessView updateProgress:self.player.volume withVolumeBrightnessType:ZFVolumeBrightnessTypeVolume];
            }
            else if (self.postInfo.wh_scale <= 1) {
                ///非全屏下手势处理 需要跟随手势的滑动 改变播放器的大小
                CGPoint point = [gestureControl.panGR translationInView:gestureControl.panGR.view];
                if (self.delegate && [self.delegate respondsToSelector:@selector(gesturePan:)]) {
                    [self.delegate gesturePan:point.y];
                }
            }
        }
    }
}

#pragma mark - Private Method

- (void)sliderValueChangingValue:(CGFloat)value isForward:(BOOL)forward {
    if (self.horizontalPanShowControlView) {
        /// 显示控制层
        [self showControlViewWithAnimated:NO];
        [self cancelAutoFadeOutControlView];
    }

    self.fastProgressView.value = value;
    self.fastView.hidden = NO;
    self.fastView.alpha = 1;
    if (forward) {
        self.fastImageView.image = ZFPlayer_Image(@"ZFPlayer_fast_forward");
    } else {
        self.fastImageView.image = ZFPlayer_Image(@"ZFPlayer_fast_backward");
    }
    NSString *draggedTime = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    NSString *totalTime = [ZFUtilities convertTimeSecond:self.player.totalTime];
    self.fastTimeLabel.text = [NSString stringWithFormat:@"%@ / %@",draggedTime,totalTime];
    /// 更新滑杆
//    [self.portraitControlView sliderValueChanged:value currentTimeString:draggedTime];
//    [self.landScapeControlView sliderValueChanged:value currentTimeString:draggedTime];
    self.bottomPgrogress.isdragging = YES;
    self.bottomPgrogress.value = value;

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFastView) object:nil];
    [self performSelector:@selector(hideFastView) withObject:nil afterDelay:0.1];

    if (self.fastViewAnimated) {
        [UIView animateWithDuration:0.4 animations:^{
            self.fastView.transform = CGAffineTransformMakeTranslation(forward?8:-8, 0);
        }];
    }
}

/// 隐藏快进视图
- (void)hideFastView {
    [UIView animateWithDuration:0.4 animations:^{
        self.fastView.transform = CGAffineTransformIdentity;
        self.fastView.alpha = 0;
    } completion:^(BOOL finished) {
        self.fastView.hidden = YES;
    }];
}

/// 加载失败
- (void)failBtnClick:(UIButton *)sender {
    [self.player.currentPlayerManager reloadPlayer];
}


/// 滑动结束手势事件
- (void)gestureEndedPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location {
    @weakify(self)
    if (direction == ZFPanDirectionH && self.sumTime >= 0 && self.player.totalTime > 0) {
        [self.player seekToTime:self.sumTime completionHandler:^(BOOL finished) {
            if (finished) {
                @strongify(self)
                /// 左右滑动调节播放进度
//                [self.portraitControlView sliderChangeEnded];
//                [self.landScapeControlView sliderChangeEnded];
                self.bottomPgrogress.isdragging = NO;
                if (self.controlViewAppeared) {
                    [self autoFadeOutControlView];
                }
            }
        }];
        if (self.seekToPlay) {
            [self.player.currentPlayerManager play];
        }
        self.sumTime = 0;
    }
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [self cancelAutoFadeOutControlView];
}

#pragma mark - Private Method

@end
