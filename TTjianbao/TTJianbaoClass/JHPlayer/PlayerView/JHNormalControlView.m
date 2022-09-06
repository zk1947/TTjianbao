//
//  JHNormalControlView.m
//  TTJB
//
//  Created by 王记伟 on 2021/1/15.
//

#import "JHNormalControlView.h"
#import "JHPlaySliderView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "JHVideoPlayerLoadingView.h"
#import "UIView+JHGradient.h"

static NSString *const kLoadingViewKeyPath = @"hidden";

@interface JHNormalControlView()<JHPlaySliderViewDelegate, UIGestureRecognizerDelegate>
{
    CGPoint currentPoint;
    float origional;
}
/** 顶部交互视图*/
@property (nonatomic, strong) UIView *topBarView;
/** 返回按钮*/
@property (nonatomic, strong) UIButton *backButton;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/** 底部交互式图*/
@property (nonatomic, strong) UIView *bottomBarView;
/** 菜单按钮*/
@property (nonatomic, strong) UIButton *menuButton;
/** 播放按钮*/
@property (nonatomic, strong) UIButton *playButton;
/** 播放时间*/
@property (nonatomic, strong) UILabel *playedTimeLabel;
/** 总时长*/
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 进度条*/
@property (nonatomic, strong) JHPlaySliderView *progressSlider;
/** 全屏按钮*/
@property (nonatomic, strong) UIButton *fullScreenButton;
/** 滑块正在进行中*/
@property (nonatomic, assign) BOOL isDragging;
/** 总时长*/
@property (nonatomic, assign) NSTimeInterval totalTime;
/** 播放时长*/
@property (nonatomic, assign) NSTimeInterval playedTime;
/** 是否隐藏控制栏*/
@property (nonatomic, assign) BOOL hideBottomView;
/** 中间的播放暂停键*/
@property (nonatomic, strong) UIButton *centrPlayButton;
/** 快进视图*/
@property (nonatomic, strong) UILabel *speedLabel;
/** 加载框*/
@property (nonatomic, strong) JHVideoPlayerLoadingView *loadingView;
/** 音量视图*/
@property (nonatomic, strong) MPVolumeView *volumeView;
/** 音量滑块*/
@property (nonatomic, strong) UISlider *volumeViewSlider;
/** 记录底部菜单的高度*/
@property (nonatomic, assign) CGFloat bottomViewHeight;

@end
@implementation JHNormalControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.bottomViewHeight = 36;
        self.clipsToBounds = YES;
        [self configUI];
        
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouchAction:)];
        [self addGestureRecognizer:tag];
        [self autoFadeOutControlView];
        
        UIPanGestureRecognizer  *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDown:)];
        panGesture.delegate=self;
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)configUI{
    [self addSubview:self.topBarView];
    [self addSubview:self.bottomBarView];
    [self addSubview:self.loadingView];
    [self addSubview:self.centrPlayButton];
    [self addSubview:self.speedLabel];
    [self.topBarView addSubview:self.backButton];
    [self.topBarView addSubview:self.titleLabel];
    [self.bottomBarView addSubview:self.playButton];
    [self.bottomBarView addSubview:self.playedTimeLabel];
    [self.bottomBarView addSubview:self.fullScreenButton];
    [self.bottomBarView addSubview:self.totalTimeLabel];
    [self.bottomBarView addSubview:self.progressSlider];
    [self addSubview:self.volumeView];
    
    [self bringSubviewToFront:self.topBarView];
}

//延时5秒退下
- (void)autoFadeOutControlView {
    [self performSelector:@selector(hideControlView) withObject:nil afterDelay:5.0];
}
- (void)viewTouchAction:(UITapGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer.view isEqual:self.topBarView] || gestureRecognizer.view == self.bottomBarView) {
        return;
    }
    [self hideControlView];
}

/** 触摸屏幕隐藏控制条*/
- (void)hideControlView{
    if ([self.delegate respondsToSelector:@selector(controlView:showStatus:)]) {
        [self.delegate controlView:self showStatus:self.hideBottomView];
    }
    
    if (self.hideBottomView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomBarView.frame = CGRectMake(0, self.height - self.bottomViewHeight, self.width, self.bottomViewHeight);
        }completion:^(BOOL finished) {
            self.hideBottomView = NO;
            [self autoFadeOutControlView];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomBarView.frame = CGRectMake(0, self.height, self.width, self.bottomViewHeight);
        }completion:^(BOOL finished) {
            self.hideBottomView = YES;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
        }];
    }
}

//全屏
- (void)setFullScreen:(BOOL)fullScreen{
    [super setFullScreen:fullScreen];
    CGFloat statusBarHeight = self.isNeedVertical ? 0 : UI.topSafeAreaHeight + 20;
    self.fullScreenButton.selected = fullScreen;
    if (fullScreen) {
        self.bottomViewHeight = 50;
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.topBarView.hidden = NO;
    }else{
        self.bottomViewHeight = 36;
        [UIApplication sharedApplication].statusBarHidden = NO;
        self.topBarView.hidden = YES;
    }
    self.topBarView.frame = CGRectMake(0, 10, self.width, self.bottomViewHeight);
    self.bottomBarView.frame = CGRectMake(0, self.height - self.bottomViewHeight, self.width, self.bottomViewHeight);
    self.backButton.frame = CGRectMake(fullScreen ? statusBarHeight + 10 : 10, 0, 40, self.topBarView.height);
    self.titleLabel.frame = CGRectMake(self.backButton.right, 0, self.topBarView.width - self.backButton.right * 2, self.topBarView.height);
    self.playButton.frame = CGRectMake(fullScreen ? statusBarHeight + 10 : 10, 0, 40, self.bottomBarView.height);
    self.playedTimeLabel.frame = CGRectMake(self.playButton.right, 0, 35, self.bottomBarView.height);
    self.fullScreenButton.frame = CGRectMake(self.bottomBarView.width - self.playButton.right, 0, 40, self.bottomBarView.height);
    self.totalTimeLabel.frame = CGRectMake(self.fullScreenButton.left
                                           - 35, 0, 35, self.bottomBarView.height);
    self.progressSlider.frame = CGRectMake(self.playedTimeLabel.right + 10, 0, self.totalTimeLabel.left - 20 - self.playedTimeLabel.right, self.bottomBarView.height);
    self.centrPlayButton.frame = CGRectMake((self.width - 50) / 2, (self.height - 50) / 2, 50, 50);
    self.speedLabel.frame = CGRectMake((self.width - 100) / 2, (self.height - 30) / 2, 100, 30);
    self.loadingView.frame = CGRectMake((self.width - 50) / 2, (self.height - 50) / 2, 50, 50);
}

- (void)setPlay:(BOOL)play {
    [super setPlay:play];
    self.playButton.selected = play;
    self.centrPlayButton.hidden = play;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime prePlayTime:(NSTimeInterval)prePlayTime {
    if (self.isDragging) {
        return;
    }
    self.totalTime = totalTime;
    self.playedTime = currentTime;
    self.playedTimeLabel.text = [self transformValueToTime:currentTime];
    self.totalTimeLabel.text =  [self transformValueToTime:totalTime];
    self.progressSlider.bufferValue = prePlayTime / totalTime;
    self.progressSlider.value = currentTime / totalTime;
}

- (void)setCompleteView:(UIView *)completeView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.centrPlayButton.hidden = YES;
    });
    completeView.frame = self.bounds;
    [self insertSubview:completeView belowSubview:self.topBarView];
}

- (void)setPlayImage:(UIImage *)playImage{
    _playImage = playImage;
    [_centrPlayButton setImage:playImage forState:UIControlStateNormal];
}

// 转时间格式
- (NSString *)transformValueToTime:(NSTimeInterval)timeInterval {
    if (timeInterval < 0) {
        timeInterval = 0;
    }
    int minute = (int)timeInterval / 60;
    int second = (int)timeInterval % 60;
    return [NSString stringWithFormat:@"%02i:%02i", minute, second];
}

// 展示全屏
- (void)fullScreenButtonClickAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(controlView:fullScreen:)]) {
        [self.delegate controlView:self fullScreen:!self.fullScreen];
    }
}

// 播放/暂停
- (void)playButtonClickAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(controlView:playStatus:)]) {
        [self.delegate controlView:self playStatus:!sender.selected];
    }
}

#pragma JHPlaySliderViewDelegate
- (void)sliderTapped:(float)value {
    if ([self.delegate respondsToSelector:@selector(controlView:changeProgress:)]) {
        [self.delegate controlView:self changeProgress:value];
    }
}
- (void)sliderTouchBegan:(float)value {
    self.isDragging = YES;
}
- (void)sliderTouchEnded:(float)value {
    self.isDragging = NO;
    if ([self.delegate respondsToSelector:@selector(controlView:changeProgress:)]) {
        [self.delegate controlView:self changeProgress:value];
    }
}
- (void)sliderValueChanged:(float)value {
    NSTimeInterval playedTimeInterval = self.totalTime * value;
    self.playedTimeLabel.text = [self transformValueToTime:playedTimeInterval];
}

- (void)startLoading {
    [self.loadingView startLoading];
}

- (void)stopLoading {
    [self.loadingView stopLoading];
}

- (void)showRetry {
    [self.loadingView showRetry];
}

//全屏返回按钮
- (void)backButtonClickAction{
    if ([self.delegate respondsToSelector:@selector(controlView:fullScreen:)]) {
        [self.delegate controlView:self fullScreen:NO];
    }
}

- (UIView *)topBarView{
    if (_topBarView == nil) {
        _topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 36)];
        _topBarView.hidden = YES;
    }
    return _topBarView;
}

- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(10, 0, 40, self.topBarView.height);
        [_backButton setImage:[UIImage imageNamed:@"navi_icon_back_white"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.backButton.right + 10, 0, self.topBarView.width - 100, self.topBarView.height)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UIView *)bottomBarView{
    if (_bottomBarView == nil) {
        _bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 36, self.width, 36)];
        [_bottomBarView jh_setGradientBackgroundWithColors:@[HEXCOLORA(0x000000,0.f), HEXCOLORA(0x000000,0.5f)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    }
    return _bottomBarView;
}

- (UIButton *)playButton{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(10, 0, 40, self.bottomBarView.height);
        [_playButton setImage:[UIImage imageNamed:@"icon_post_detail_stop"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"icon_post_detail_play"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UILabel *)playedTimeLabel{
    if (_playedTimeLabel == nil) {
        _playedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.playButton.right, 0, 35, self.bottomBarView.height)];
        _playedTimeLabel.textColor = [UIColor whiteColor];
        _playedTimeLabel.font = [UIFont systemFontOfSize:11];
        _playedTimeLabel.text = @"00:00";
    }
    return _playedTimeLabel;
}

- (UIButton *)fullScreenButton{
    if (_fullScreenButton == nil) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenButton.frame = CGRectMake(self.bottomBarView.width - 50, 0, 40, self.bottomBarView.height);
        [_fullScreenButton setImage:[UIImage imageNamed:@"icon_post_detail_full_screen"] forState:UIControlStateNormal];
        [_fullScreenButton setImage:[UIImage imageNamed:@"icon_post_detail_fold"] forState:UIControlStateSelected];
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

- (UILabel *)totalTimeLabel{
    if (_totalTimeLabel == nil) {
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.fullScreenButton.left
                                                                    - 35, 0, 35, self.bottomBarView.height)];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:11];
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (JHPlaySliderView *)progressSlider {
    if (_progressSlider == nil) {
        _progressSlider = [[JHPlaySliderView alloc] initWithFrame:CGRectMake(self.playedTimeLabel.right + 10, 0, self.totalTimeLabel.left - 20 - self.playedTimeLabel.right, self.bottomBarView.height)];
        _progressSlider.maximumTrackTintColor = [UIColor whiteColor];
        _progressSlider.minimumTrackTintColor = HEXCOLOR(0xfee100);
        _progressSlider.bufferTrackTintColor  = [UIColor lightGrayColor];
        _progressSlider.sliderHeight = 2.;
        _progressSlider.value = 0;
        _progressSlider.delegate = self;
        [_progressSlider setThumbImage:[UIImage imageNamed:@"icon_post_detail_track"] forState:UIControlStateNormal];
    }
    return _progressSlider;
}

- (UIButton *)centrPlayButton {
    if (_centrPlayButton == nil) {
        _centrPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _centrPlayButton.frame = CGRectMake((self.width - 50) / 2, (self.height - 50) / 2, 50, 50);
        [_centrPlayButton setImage:[UIImage imageNamed:@"icon_play_cirle"] forState:UIControlStateNormal];
        _centrPlayButton.hidden = YES;
        [_centrPlayButton addTarget:self action:@selector(playButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centrPlayButton;
}

- (UILabel *)speedLabel{
    if (_speedLabel == nil) {
        _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 100) / 2, (self.height - 30) / 2, 100, 30)];
        _speedLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _speedLabel.layer.cornerRadius = 5;
        _speedLabel.clipsToBounds = YES;
        _speedLabel.textAlignment = NSTextAlignmentCenter;
        _speedLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _speedLabel.textColor = [UIColor whiteColor];
        _speedLabel.hidden = YES;
    }
    return _speedLabel;
}

- (JHVideoPlayerLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[JHVideoPlayerLoadingView alloc] initWithFrame:CGRectMake((self.width - 140) / 2, (self.height - 140) / 2, 140, 140)];
        @weakify(self);
        [_loadingView setRetryCall:^{
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(controlView:retry:)]) {
                [self.delegate controlView:self retry:0];
            }
        }];
    }
    return _loadingView;
}

- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.showsRouteButton = NO;
        _volumeView.showsVolumeSlider = NO;
        self.volumeViewSlider = nil;
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}

#pragma mark - 滑动快进后退,音量 亮度
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch{
    if([touch.view isKindOfClass:[UISlider class]] || (touch.view == self.topBarView) || [touch.view isEqual:self.bottomBarView]){
        return NO;
    }else{
        return YES;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    currentPoint = [[touches anyObject] locationInView:self];
}

-(void)panGestureDown:(UIPanGestureRecognizer*)sender{
    CGPoint point= [sender locationInView:self];// 上下控制点
    CGPoint tranPoint=[sender translationInView:self];//播放进度
    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
        UIPanGestureRecognizerDirectionUndefined,
        UIPanGestureRecognizerDirectionUp,
        UIPanGestureRecognizerDirectionDown,
        UIPanGestureRecognizerDirectionLeft,
        UIPanGestureRecognizerDirectionRight
    };
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
           origional = self.progressSlider.value;// 记录开始滑动位置
            if (direction == UIPanGestureRecognizerDirectionUndefined) {
                CGPoint velocity = [sender velocityInView:self];
                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown;
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp;
                    }
                }
                else {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight;
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft;
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: {
                    if (!self.fullScreen) {
                        break;
                    }
                    float dy = point.y - currentPoint.y;
                    int index = (int)dy;
                    // 左侧 上下改变亮度
                    if(currentPoint.x <self.frame.size.width/2){
                        if(index >0){
                            [UIScreen mainScreen].brightness = [UIScreen mainScreen].brightness- 0.01;
                        }else{
                            [UIScreen mainScreen].brightness = [UIScreen mainScreen].brightness+ 0.01;
                        }
                    }else{// 右侧上下改变声音
                        if(index>0){
                            self.volumeViewSlider.value -= 0.01;
                        }else{
                            self.volumeViewSlider.value += 0.01;
                        }
                    }
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: {
                    if (!self.fullScreen || !self.isNeedVertical) {
                        if (!self.isNeedVertical && !self.fullScreen && self.canScanToFullScreen) {
                            //放大到全屏
                            [self fullScreenButtonClickAction:self.fullScreenButton];
                        }
                        break;
                    }
                    float dy = point.y - currentPoint.y;
                    int index = (int)dy;
                    // 左侧 上下改变亮度
                    if(currentPoint.x <self.frame.size.width/2){
                        if(index >0){
                            [UIScreen mainScreen].brightness = [UIScreen mainScreen].brightness- 0.01;
                        }else{
                            [UIScreen mainScreen].brightness = [UIScreen mainScreen].brightness+ 0.01;
                        }
                    }else{// 右侧上下改变声音
                        if(index>0){
                            self.volumeViewSlider.value -= 0.01;
                        }else{
                            self.volumeViewSlider.value += 0.01;
                        }
                    }
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: {
                    if (!self.fullScreen) {   //去掉小屏滑动快进
                        break;
                    }
                    self.isDragging = YES;
                    // 手势滑动控制 快进进度
                    if(tranPoint.x/self.width + origional <=0){
                        self.progressSlider.value = 0.0f;
                    }else
                    {
                        self.progressSlider.value = tranPoint.x/self.width + origional;
                    }
                    self.playedTimeLabel.text = [self transformValueToTime:self.totalTime * self.progressSlider.value];
                    self.speedLabel.hidden = NO;
                    self.speedLabel.text = [NSString stringWithFormat:@"%@ / %@", self.playedTimeLabel.text, self.totalTimeLabel.text];
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: {
                    if (!self.fullScreen) {
                        break;
                    }
                    self.isDragging = YES;
                    if(tranPoint.x/self.width + origional <=0){
                        self.progressSlider.value=0.0f;
                    }else
                    {
                        self.progressSlider.value=tranPoint.x/self.width + origional;
                    }
                    self.playedTimeLabel.text = [self transformValueToTime:self.totalTime * self.progressSlider.value];
                    self.speedLabel.hidden = NO;
                    self.speedLabel.text = [NSString stringWithFormat:@"%@ / %@", self.playedTimeLabel.text, self.totalTimeLabel.text];
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (!self.fullScreen) {
                break;
            }
            self.isDragging = NO;
            [self autoFadeOutControlView];
            origional = self.progressSlider.value;// 记录结束滑动位置
            direction = UIPanGestureRecognizerDirectionUndefined;
            if ([self.delegate respondsToSelector:@selector(controlView:changeProgress:)]) {
                [self.delegate controlView:self changeProgress:self.progressSlider.value];
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.speedLabel.hidden = YES;
            }];
            break;
        }
        default:
            break;
    }
}

// 左滑返回手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
