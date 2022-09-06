//
//  NELivePlayerControlView.m
//  NELivePlayerDemo
//
//  Created by Netease on 2017/11/15.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "NELivePlayerControlView.h"
#import "UIView+NEPlayer.h"

#define kPlayerBtnWidth (40)

@interface NELivePlayerControlView ()
{
    BOOL _isDraggingInternal;
}
@property (nonatomic, strong) UIControl *mediaControl; //媒体覆盖层
@property (nonatomic, strong) UIControl *overlayControl; //控制层
@property (nonatomic, strong) UIActivityIndicatorView *bufferingIndicate; //缓冲动画
@property (nonatomic, strong) UILabel *bufferingReminder; //缓冲提示
@property (nonatomic, strong) UIView *topControlView; //顶部控制条
@property (nonatomic, strong) UIView *bottomControlView; //底部控制条
@property (nonatomic, strong) UIButton *playQuitBtn; //退出
@property (nonatomic, strong) UILabel *fileName; //文件名字
@property (nonatomic, strong) UILabel *currentTime;   //播放时间
@property (nonatomic, strong) UILabel *totalDuration; //文件时长
@property (nonatomic, strong) UISlider *videoProgress;//播放进度
@property (nonatomic, strong) UIButton *playBtn;  //播放/暂停按钮
@property (nonatomic, strong) UIButton *muteBtn;  //静音按钮
@property (nonatomic, strong) UIButton *scaleModeBtn; //显示模式按钮
@property (nonatomic, strong) UIButton *snapshotBtn;  //截图按钮
@property (nonatomic, strong) UILabel *subtitleLab;//字幕
@property (nonatomic, strong) UILabel *subtitleExLab;//额外的字幕
@end

@implementation NELivePlayerControlView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    [self addSubview:self.subtitleExLab];
    [self addSubview:self.subtitleLab];
    
    [self addSubview:self.mediaControl];
    [_mediaControl addSubview:self.bufferingIndicate];
    [_mediaControl addSubview:self.bufferingReminder];
    
    [self addSubview:self.overlayControl];
    [_overlayControl addSubview:self.topControlView];
    [_topControlView addSubview:self.playQuitBtn];
    [_topControlView addSubview:self.fileName];
    
    [_overlayControl addSubview:self.bottomControlView];
    [_bottomControlView addSubview:self.playBtn];
    [_bottomControlView addSubview:self.currentTime];
    [_bottomControlView addSubview:self.videoProgress];
    [_bottomControlView addSubview:self.totalDuration];
    [_bottomControlView addSubview:self.muteBtn];
    [_bottomControlView addSubview:self.snapshotBtn];
    [_bottomControlView addSubview:self.scaleModeBtn];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _mediaControl.frame = self.bounds;
    _bufferingIndicate.center = CGPointMake(_overlayControl.width/2, (_overlayControl.height - 32)/2);
    _bufferingReminder.top = _bufferingIndicate.bottom + 32.0;
    _bufferingReminder.centerX = _bufferingIndicate.centerX;
    
    _overlayControl.frame = self.bounds;
    _topControlView.frame = CGRectMake(0, 0, _overlayControl.width, kPlayerBtnWidth);
    _playQuitBtn.frame = CGRectMake(8.0, 0, kPlayerBtnWidth, _topControlView.height);
    _fileName.frame = CGRectMake(_playQuitBtn.right + 8.0,
                                 0,
                                 _topControlView.width - (_playQuitBtn.right + 8.0)*2,
                                 _topControlView.height);
    
    _bottomControlView.frame = CGRectMake(0,
                                          _overlayControl.height-kPlayerBtnWidth*1.5,
                                          _overlayControl.width,
                                          kPlayerBtnWidth*1.5);
    _playBtn.frame = CGRectMake(8.0, 0, kPlayerBtnWidth, _bottomControlView.height);
    _scaleModeBtn.frame = CGRectMake(_bottomControlView.width - kPlayerBtnWidth, 0, kPlayerBtnWidth, _bottomControlView.height);
    _snapshotBtn.frame = CGRectMake(_scaleModeBtn.left-kPlayerBtnWidth, 0, kPlayerBtnWidth, _bottomControlView.height);
    _muteBtn.frame = CGRectMake(_snapshotBtn.left-kPlayerBtnWidth, 0, kPlayerBtnWidth, _bottomControlView.height);
    
    _currentTime.frame = CGRectMake(_playBtn.right + 8.0,
                                    0,
                                    _currentTime.width + 4.0,
                                    _bottomControlView.height);
    _totalDuration.frame = CGRectMake(_muteBtn.left - (_totalDuration.width + 4.0),
                                      0,
                                      _currentTime.width,
                                      _bottomControlView.height);
    _videoProgress.frame = CGRectMake(_currentTime.right + 4.0,
                                      0,
                                      _totalDuration.left - 4.0 - _currentTime.right - 4.0,
                                      _bottomControlView.height);
}

#pragma mark - Action
- (void)onClickMediaControlAction:(UIControl *)control {
    _overlayControl.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:8];
}

- (void)onClickOverlayControlAction:(UIControl *)control {
    _overlayControl.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
}

- (void)controlOverlayHide {
    _overlayControl.hidden = YES;
}

- (void)onClickBtnAction:(UIButton *)btn {
    
    if (btn == _playQuitBtn) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
        
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickQuit:)]) {
            [_delegate controlViewOnClickQuit:self];
        }
    } else if (btn == _playBtn) {
        _playBtn.selected = !_playBtn.isSelected;
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickPlay:isPlay:)]) {
            [_delegate controlViewOnClickPlay:self isPlay:_playBtn.isSelected];
        }
    } else if (btn == _muteBtn) {
        _muteBtn.selected = !_muteBtn.isSelected;
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickMute:isMute:)]) {
            [_delegate controlViewOnClickMute:self isMute:_muteBtn.isSelected];
        }
    } else if (btn == _scaleModeBtn) {
        _scaleModeBtn.selected = !_scaleModeBtn.isSelected;
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickScale:isFill:)]) {
            [_delegate controlViewOnClickScale:self isFill:_scaleModeBtn.isSelected];
        }
    } else if (btn == _snapshotBtn) {
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickSnap:)]) {
            [_delegate controlViewOnClickSnap:self];
        }
    }
}

- (void)onClickSeekAction:(UISlider *)slider {
    if (_isAllowSeek) {
        NSTimeInterval currentPlayTime = slider.value;
        int mCurrentPostion = (int)currentPlayTime;
        _currentTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                             (int)(mCurrentPostion / 3600),
                             (int)(mCurrentPostion > 3600 ? (mCurrentPostion - (mCurrentPostion / 3600)*3600) / 60 : mCurrentPostion/60),
                             (int)(mCurrentPostion % 60)];
    }
}

- (void)onClickSeekTouchUpInside:(UISlider *)slider {
    
    
    if (_isAllowSeek) {
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickSeek:dstTime:)]) {
            [_delegate controlViewOnClickSeek:self dstTime:slider.value];
        }
        _isDraggingInternal = NO;
    }
}

- (void)onClickSeekTouchUpOutside:(UISlider *)slider {
    if (_isAllowSeek) {
        _isDraggingInternal = NO;
    }
}

#pragma mark - Setter
- (BOOL)isDragging {
    return _isDraggingInternal;
}

- (void)setCurrentPos:(NSTimeInterval)currentPos {
    _currentPos = currentPos;
    NSInteger currPos  = round(currentPos);
    _currentTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                         (int)(currPos / 3600),
                         (int)(currPos > 3600 ? (currPos - (currPos / 3600)*3600) / 60 : currPos/60),
                         (int)(currPos % 60)];
    _videoProgress.value = currentPos;
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    
    if (duration > 0) {
        NSInteger mDuration = round(duration);
        _totalDuration.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                               (int)(mDuration / 3600),
                               (int)(mDuration > 3600 ? (mDuration - 3600 * (mDuration / 3600)) / 60 : mDuration/60),
                               (int)(mDuration > 3600 ? ((mDuration - 3600 * (mDuration / 3600)) % 60) :(mDuration % 60))];
        _videoProgress.maximumValue = duration;
    }
    else {
        _videoProgress.value = 0.0;
        _totalDuration.text = @"--:--:--";
    }
}

- (void)setFileTitle:(NSString *)fileTitle {
    _fileTitle = fileTitle;
    if (fileTitle) {
        _fileName.text = fileTitle;
    }
}

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    _playBtn.selected = isPlaying;
}

- (void)setIsBuffing:(BOOL)isBuffing {
    _isBuffing = isBuffing;
    
    if (isBuffing) {
        _bufferingIndicate.hidden = NO;
        [_bufferingIndicate startAnimating];
        _bufferingReminder.hidden = NO;
    
    } else {
        _bufferingIndicate.hidden = YES;
        [_bufferingIndicate stopAnimating];
        _bufferingReminder.hidden = YES;
    }
}

- (void)setSubtitle_ex:(NSString *)subtitle_ex {
    _subtitle_ex = (subtitle_ex ? subtitle_ex : @"");
    self.subtitleExLab.text = subtitle_ex;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = (subtitle ? subtitle : @"");
    self.subtitleLab.text = subtitle;
}

- (void)setVideoResolution:(CGSize)videoResolution {
    
    //计算画面尺寸
    CGFloat oriSizeRatio = videoResolution.width * 1.0 / videoResolution.height;
    CGFloat targetSizeRatio = self.width * 1.0 / self.height;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    if (oriSizeRatio > targetSizeRatio) //上下添黑
    {
        width = self.width;
        height = self.width * videoResolution.height / videoResolution.width;
    }
    else if (oriSizeRatio < targetSizeRatio) //左右填黑
    {
        height = self.height;
        width = self.height * videoResolution.width / videoResolution.height;
    }
    else //不需要添黑
    {
        width = self.width;
        height = self.height;
    }
    
    CGRect venderRect = CGRectMake((self.width-width)/2, (self.height-height)/2, width, height);
    
    //调整字幕位置
    self.subtitleLab.frame = CGRectMake(0, venderRect.origin.y+venderRect.size.height - 80, self.width, 80);
    self.subtitleExLab.frame = CGRectMake(0, self.subtitleLab.top - 80, self.width, 80);
}

#pragma mark - 控件属性
- (UIControl *)mediaControl {
    if (!_mediaControl) {
        _mediaControl = [[UIControl alloc] init];
        [_mediaControl addTarget:self action:@selector(onClickMediaControlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mediaControl;
}

- (UIControl *)overlayControl {
    if (!_overlayControl) {
        _overlayControl = [[UIControl alloc] init];
        [_overlayControl addTarget:self action:@selector(onClickOverlayControlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overlayControl;
}

- (UIActivityIndicatorView *)bufferingIndicate {
    if (!_bufferingIndicate) {
        _bufferingIndicate = [[UIActivityIndicatorView alloc] init];
        _bufferingIndicate.hidden = YES;
    }
    return _bufferingIndicate;
}

- (UILabel *)bufferingReminder {
    if (!_bufferingReminder) {
        _bufferingReminder = [[UILabel alloc] init];
        _bufferingReminder.text = @"缓冲中";
        _bufferingReminder.textAlignment = NSTextAlignmentCenter; //文字居中
        _bufferingReminder.textColor = [UIColor whiteColor];
        _bufferingReminder.hidden = YES;
        [_bufferingReminder sizeToFit];
    }
    return _bufferingReminder;
}

-(UIView *)topControlView {
    if (!_topControlView) {
        _topControlView = [[UIView alloc] init];
        _topControlView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_background_black"]];
        _topControlView.alpha = 0.8;
    }
    return _topControlView;
}

- (UIView *)bottomControlView {
    if (!_bottomControlView) {
        _bottomControlView = [[UIView alloc] init];
        _bottomControlView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_background_black"]];
        _bottomControlView.alpha = 0.8;
    }
    return _bottomControlView;
}

- (UIButton *)playQuitBtn {
    if (!_playQuitBtn) {
        _playQuitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playQuitBtn setImage:[UIImage imageNamed:@"btn_player_quit"] forState:UIControlStateNormal];
        [_playQuitBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playQuitBtn;
}

- (UILabel *)fileName {
    if (!_fileName) {
        _fileName = [[UILabel alloc] init];
        _fileName.textAlignment = NSTextAlignmentCenter; //文字居中
        _fileName.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        _fileName.font = [UIFont systemFontOfSize:13.0];
    }
    return _fileName;
}

- (UILabel *)currentTime {
    if (!_currentTime) {
        _currentTime = [[UILabel alloc] init];
        _currentTime.text = @"00:00:00"; //for test
        _currentTime.textAlignment = NSTextAlignmentCenter;
        _currentTime.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        _currentTime.font = [UIFont systemFontOfSize:10.0];
        [_currentTime sizeToFit];
    }
    return _currentTime;
}

- (UILabel *)totalDuration {
    if (!_totalDuration) {
        _totalDuration = [[UILabel alloc] init];
        _totalDuration.text = @"--:--:--";
        _totalDuration.textAlignment = NSTextAlignmentCenter;
        _totalDuration.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        _totalDuration.font = [UIFont systemFontOfSize:10.0];
        [_totalDuration sizeToFit];
    }
    return _totalDuration;
}

- (UISlider *)videoProgress {
    if (!_videoProgress) {
        _videoProgress = [[UISlider alloc] init];
        [_videoProgress setThumbImage:[UIImage imageNamed:@"btn_player_slider_thumb"] forState:UIControlStateNormal];
        [_videoProgress setMaximumTrackImage:[UIImage imageNamed:@"btn_player_slider_all"] forState:UIControlStateNormal];
        [_videoProgress setMinimumTrackImage:[UIImage imageNamed:@"btn_player_slider_played"] forState:UIControlStateNormal];
        [_videoProgress addTarget:self action:@selector(onClickSeekAction:) forControlEvents:UIControlEventValueChanged];
        [_videoProgress addTarget:self action:@selector(onClickSeekTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_videoProgress addTarget:self action:@selector(onClickSeekTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _videoProgress;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"btn_player_pause"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)muteBtn {
    if (!_muteBtn) {
       _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn setImage:[UIImage imageNamed:@"btn_player_mute02"] forState:UIControlStateNormal];
        [_muteBtn setImage:[UIImage imageNamed:@"btn_player_mute01"] forState:UIControlStateSelected];
        [_muteBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteBtn;
}

- (UIButton *)scaleModeBtn {
    if (!_scaleModeBtn) {
        _scaleModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
        [_scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateSelected];
        [_scaleModeBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scaleModeBtn;
}

- (UIButton *)snapshotBtn {
    if (!_snapshotBtn) {
        self.snapshotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.snapshotBtn setImage:[UIImage imageNamed:@"btn_player_snap"] forState:UIControlStateNormal];
        [self.snapshotBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _snapshotBtn;
}

//字幕
- (UILabel *)subtitleLab {
    if (!_subtitleLab) {
        _subtitleLab = [[UILabel alloc] init];
        _subtitleLab.textAlignment = NSTextAlignmentCenter;
        _subtitleLab.textColor = [UIColor whiteColor];
        _subtitleLab.font = [UIFont systemFontOfSize:17.0];
        _subtitleLab.numberOfLines = 0;
    }
    return _subtitleLab;
}

//额外的字幕
- (UILabel *)subtitleExLab {
    if (!_subtitleExLab) {
        _subtitleExLab = [[UILabel alloc] init];
        _subtitleExLab.textAlignment = NSTextAlignmentCenter;
        _subtitleExLab.textColor = [UIColor redColor];
        _subtitleExLab.font = [UIFont systemFontOfSize:14.0];
        _subtitleExLab.numberOfLines = 0;
    }
    return _subtitleExLab;
}
@end
