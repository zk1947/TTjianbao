//
//  JHPlayerViewController.m
//  TTJB
//
//  Created by 王记伟 on 2021/1/15.
//

typedef enum : NSUInteger {
    PlayerScreenStatusSmall,   //小屏
    PlayerScreenStatusBig,     //全屏
    PlayerScreenStatusBigVerticalScreen, //竖屏全屏
} PlayerScreenStatus;

#import "JHPlayerViewController.h"
#import "JHSettingAutoPlayController.h"
#import "AppDelegate.h"

@interface JHPlayerViewController ()<TTVideoEngineDelegate, JHPlayControlViewDelegate>
/** 载体*/
@property (nonatomic, strong) UIView *contentView;
/** 播放控制层*/
@property (nonatomic, strong) JHPlayControlView *playControlView;
/** 记录原始视频位置*/
@property (nonatomic) CGRect originalFrame;
/** 记录当前屏幕状态*/
@property (nonatomic, assign) PlayerScreenStatus playerScreenStatus;
/** 退到后台之前是否播放*/
@property (nonatomic, assign) BOOL isPLayBeforeEnterBackground;
/** 中间的播放暂停键*/
@property (nonatomic, strong) UIButton *centrPlayButton;

@end

@implementation JHPlayerViewController
- (void)addObserver {
    @weakify(self);
    //进入前台
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        if (self.isPLayBeforeEnterBackground) {
            [self.engine play];
        }
    }];
    
    //进入后台
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        self.isPLayBeforeEnterBackground = self.isPLaying;
        if (self.isPLaying) {
            [self.engine pause];
        }
    }];
    
}
- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setFullScreenView:(JHPlayControlView *)fullScreenView {
    _fullScreenView = fullScreenView;
    fullScreenView.delegate = self;
    fullScreenView.hidden = YES;
    [self.contentView addSubview:fullScreenView];
}
- (void)setControlView:(JHPlayControlView *)controlView {
    [self.playControlView removeFromSuperview];
    self.playControlView = controlView;
    controlView.delegate = self;
    [self.contentView addSubview:self.playControlView];
}
- (void)dealloc {
    //    [TTVideoAudioSession inActive];
    //    [_fullScreenManager removeObserverBlocksForKeyPath:kFullScreenControllerKeyPath];
    //    [_engine removeObserverBlocksForKeyPath:kEnginePlaybackStateKeyPath];
    [self endObservePlayTime];
    [self removeObserver];
}

- (void)setSubviewsFrame {
    self.contentView.frame = self.view.bounds;
    self.playControlView.frame = self.contentView.bounds;
    self.engine.playerView.frame = self.contentView.bounds;
    self.originalFrame = self.contentView.bounds;
    self.centrPlayButton.frame = CGRectMake((self.contentView.width - 50) / 2, (self.contentView.height - 50) / 2, 50, 50);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self addObserver];
    [self startNetStatus];
}

- (void)startNetStatus {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    @weakify(self);
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        JHAutoPlayStatus type = [JHSettingAutoPlayController getAutoPlayStatus];
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                /// WIFI
                if (self.engine.playbackState == TTVideoEnginePlaybackStatePaused) {
                    [self play];
                }
            }
            break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                //移动蜂窝
                if(type == JHAutoPlayStatusWIFI && !self.alwaysPlay) {
                    [self pause];
                }
                if (self.hidePlayButton) {
                    [self setUrlString:self.urlString];
                }
            }
                break;
            default: {
                if(type == JHAutoPlayStatusWIFI && !self.alwaysPlay) {
                    [self pause];
                }
                if (self.hidePlayButton) {
                    [self setUrlString:self.urlString];
                }
            }
                break;
        }
    }];
}

- (void)play {
    [self.engine play];
}

- (void)pause {
    [self.engine pause:YES];
}

- (void)stop {
    [self resetEngine];
}

- (void)seekToTime:(NSTimeInterval)timeInterval {
    [self.engine setCurrentPlaybackTime:timeInterval complete:^(BOOL success) {
        
    }];
}

//添加播放完成页面
- (void)setCompleteView:(UIView *)completeView {
    if (self.playerScreenStatus == PlayerScreenStatusBigVerticalScreen) {
        [self.fullScreenView setCompleteView:completeView];
    }else {
        [self.playControlView setCompleteView:completeView];
    }
}

- (void)setUpUI {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.playControlView];
    [self.contentView addSubview:self.centrPlayButton];
    self.originalFrame = self.contentView.frame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.engine play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.engine pause:YES];
}

- (void)playButtonClickAction:(UIButton *)sender {
    if (self.urlString.length == 0) {
        return;
    }
    [self prepareToPlay];
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    //重置一下播放器
    [self resetEngine];
    if (urlString == nil || urlString.length == 0) {
        return;
    }
    if (self.alwaysPlay) { //总是播放就关闭
        [self prepareToPlay];
        return;
    }
    JHAutoPlayStatus type = [JHSettingAutoPlayController getAutoPlayStatus];
    BOOL isWiFi = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
    if (type == JHAutoPlayStatusClose || (type == JHAutoPlayStatusWIFI && !isWiFi)) {
        self.view.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.centrPlayButton.hidden = self.hidePlayButton ? YES : NO;
        self.playControlView.hidden = YES;
        return;
    }
    
    [self prepareToPlay];
}
//一切就绪 开始播放
- (void)prepareToPlay {
    self.view.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor blackColor];
    self.centrPlayButton.hidden = YES;
    self.playControlView.hidden = NO;
    
    NSString *cacheFileKey = [self.urlString md5String];
    [self.engine ls_setDirectURL:self.urlString key:cacheFileKey];
    
    self.engine.hardwareDecode = YES;
    // 设置代理
    self.engine.delegate = self;
    [self.engine setOptionForKey: VEKKeyModelCacheVideoInfoEnable_BOOL value:@(YES)]; /// 必要操作,缓存处理
    [self.engine setOptionForKey:VEKKeyViewRenderEngine_ENUM value:@(TTVideoEngineRenderEngineMetal)];/// metal 渲染，可以设置 opengl 模式
    [self.engine setOptions:@{VEKKEY(VEKKeyViewRenderEngine_ENUM):@(TTVideoEngineRenderEngineOpenGLES)}];///
    self.engine.playerView.frame = self.contentView.bounds;
    [self.contentView insertSubview:self.engine.playerView atIndex:0];
    self.engine.muted = self.muted;
    self.engine.looping = self.looping;
    [self startPlay];
    [self beginObservePlayTime];
}

- (void)resetEngine {
    [self.engine.playerView removeFromSuperview];
    [self.engine stop];
    [self.engine close];
    //    [self.engine removeObserverBlocks];
    _engine = nil;
    self.engine = [[TTVideoEngine alloc] initWithOwnPlayer:YES];
    // Engine 和 localserver 关联，必要的步骤
    //    self.engine.proxyServerEnable = YES;
    // Reset view show.
    self.playControlView.timeDuration = 0.0;
    self.playControlView.currentPlayingTime = 0.0f;
    self.playControlView.playableDuration = 0.0f;
    if (self.fullScreenView) {
        self.fullScreenView.timeDuration = 0.0;
        self.fullScreenView.currentPlayingTime = 0.0f;
        self.fullScreenView.playableDuration = 0.0f;
    }
}
/// MARK: - Private Method

- (void)beginObservePlayTime {
    [self endObservePlayTime];
    self.playControlView.currentPlayingTime = self.engine.currentPlaybackTime;
    if (self.fullScreenView) {
        self.fullScreenView.currentPlayingTime = self.engine.currentPlaybackTime;
    }
    
    @weakify(self);
    [self.engine addPeriodicTimeObserverForInterval:0.3 queue:dispatch_get_main_queue() usingBlock:^{
        @strongify(self);
        if (self.engine.duration > 0.0) {
            self.playControlView.currentPlayingTime = [self.engine currentPlaybackTime];
            self.playControlView.playableDuration = [self.engine playableDuration];
            [self.playControlView setCurrentTime:self.engine.currentPlaybackTime totalTime:self.engine.duration prePlayTime:self.engine.playableDuration];
            
            if (self.fullScreenView) {
                self.fullScreenView.currentPlayingTime = [self.engine currentPlaybackTime];
                self.fullScreenView.playableDuration = [self.engine playableDuration];
                [self.fullScreenView setCurrentTime:self.engine.currentPlaybackTime totalTime:self.engine.duration prePlayTime:self.engine.playableDuration];
            }
            
            
            if (self.playTimeChangeBlock) {
                self.playTimeChangeBlock(self.engine.currentPlaybackTime, self.engine.duration, self.engine.playableDuration);
            }
        }
    }];
}

- (void)endObservePlayTime {
    [self.engine removeTimeObserver];
}

- (void)startPlay {
    [self.playControlView startLoading];
    if (self.fullScreenView) {
        [self.fullScreenView startLoading];
    }
    [self.engine play];
}

/// MARK: - TTVideongineDelegate
- (void)videoEngineDidFinish:(TTVideoEngine *)videoEngine error:(NSError *)error {
    self.playControlView.play = NO;
    if (self.fullScreenView) {
        self.fullScreenView.play = NO;
    }
    if (error) {
        [self.playControlView showRetry];
    } else {
        self.playControlView.play = (videoEngine.playbackState == TTVideoEnginePlaybackStatePlaying);
        if (self.fullScreenView) {
            self.fullScreenView.play = (videoEngine.playbackState == TTVideoEnginePlaybackStatePlaying);
        }
    }
    NSLog(@"%@", [NSString stringWithFormat:@"播放结束：error:%@",error.localizedDescription]);
}

- (void)videoEngineDidFinish:(TTVideoEngine *)videoEngine videoStatusException:(NSInteger)status {
    self.playControlView.play = NO;
    [self.playControlView showRetry];
    if (self.fullScreenView) {
        self.fullScreenView.play = NO;
        [self.fullScreenView showRetry];
    }
    NSLog(@"%@", [NSString stringWithFormat:@"播放结束 StatusException:%zd",status]);
}

- (void)videoEngine:(TTVideoEngine *)videoEngine retryForError:(NSError *)error {
    
    NSLog(@"%@", [NSString stringWithFormat:@"播放错误，尝试重试: error:%@",error.localizedDescription]);
}

- (void)videoEngine:(TTVideoEngine *)videoEngine playbackStateDidChanged:(TTVideoEnginePlaybackState)playbackState {
    switch (playbackState) {
        case TTVideoEnginePlaybackStatePlaying:
            self.isPLaying = YES;
            self.playControlView.play = YES;
            self.playControlView.timeDuration = self.engine.duration;
            if (self.fullScreenView) {
                self.fullScreenView.play = YES;
                self.fullScreenView.timeDuration = self.engine.duration;
            }
            break;
        case TTVideoEnginePlaybackStatePaused:
            self.isPLaying = NO;
            self.playControlView.play = NO;
            if (self.fullScreenView) {
                self.fullScreenView.play = NO;
            }
            break;
        case TTVideoEnginePlaybackStateError:
            self.isPLaying = NO;
            [self.playControlView showRetry];
            if (self.fullScreenView) {
                [self.fullScreenView showRetry];
            }
            break;
        default:
            self.isPLaying = NO;
            self.playControlView.play = NO;
            if (self.fullScreenView) {
                self.fullScreenView.play = NO;
            }
            break;
    }
    
    if (self.playbackStateDidChangedBlock) {
        self.playbackStateDidChangedBlock(playbackState);
    }
    //解决播放视频的时候息屏的问题
    [UIApplication sharedApplication].idleTimerDisabled = playbackState == TTVideoEnginePlaybackStatePlaying ? YES : NO;
}

- (void)videoEngine:(TTVideoEngine *)videoEngine loadStateDidChanged:(TTVideoEngineLoadState)loadState {
    switch (loadState) {
        case TTVideoEngineLoadStatePlayable:
            [self.playControlView stopLoading];
            if (self.fullScreenView) {
                [self.fullScreenView stopLoading];
            }
            break;
        case TTVideoEngineLoadStateStalled:
            [self.playControlView startLoading];
            if (self.fullScreenView) {
                [self.fullScreenView startLoading];
            }
            break;
        case TTVideoEngineLoadStateError:
            [self.playControlView showRetry];
            if (self.fullScreenView) {
                [self.fullScreenView showRetry];
            }
            break;
        default:
            break;
    }
    
    if (self.loadStateDidChangedBlock) {
        self.loadStateDidChangedBlock(loadState);
    }
}

- (void)videoEngine:(TTVideoEngine *)videoEngine fetchedVideoModel:(TTVideoEngineModel *)videoModel {
    
}

- (void)videoEnginePrepared:(TTVideoEngine *)videoEngine {
    
}

- (void)videoEngineReadyToPlay:(TTVideoEngine *)videoEngine {
    
}

- (void)videoEngineStalledExcludeSeek:(TTVideoEngine *)videoEngine {
    
}

- (void)videoEngineUserStopped:(TTVideoEngine *)videoEngine {
    
}

- (void)videoEngineCloseAysncFinish:(TTVideoEngine *)videoEngine {
    
}


/// MARK: - JHPlayControlViewDelegate
//开始监听播放时间
- (void)controlView:(JHPlayControlView *)controlView showStatus:(BOOL)isShowing {
//    isShowing ? [self beginObservePlayTime] : [self endObservePlayTime];
}

//手动切换播放
- (void)controlView:(JHPlayControlView *)controlView playStatus:(BOOL)isPlay {
    isPlay ? [self.engine play] : [self.engine pause:YES];
}

//快进到...
- (void)controlView:(JHPlayControlView *)controlView changeProgress:(CGFloat)progress {
    NSTimeInterval currentTime = self.engine.duration * progress;
    [self.engine setCurrentPlaybackTime:currentTime complete:^(BOOL success) {
        
    }];
}
//屏幕切换
- (void)controlView:(JHPlayControlView *)controlView fullScreen:(BOOL)toFullScreen {
    if (self.isVerticalScreen) {  //竖屏
        if (self.fullScreenView) { //有自定义的全屏
            if (toFullScreen) {
                UIWindow *backgroundWindow = [self mainWindow];
                [backgroundWindow addSubview:self.contentView];
                [UIView animateWithDuration:0.3 animations:^{
                    //设置顺序(必须)：frame->center->transform
                    self.playControlView.hidden = YES;
                    self.contentView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
                    self.engine.playerView.frame = self.contentView.bounds;
                    [self.contentView layoutIfNeeded];
                    self.playControlView.fullScreen = YES;
                } completion:^(BOOL finished){
                    self.fullScreenView.hidden = NO;
                    self.playerScreenStatus = PlayerScreenStatusBigVerticalScreen;
                }];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    //设置顺序(必须)：frame->center->transform
                    self.fullScreenView.hidden = YES;
                    self.contentView.frame = self.originalFrame;
                    self.engine.playerView.frame = self.contentView.bounds;
                    [self.contentView layoutIfNeeded];
                    self.playControlView.fullScreen = NO;
                } completion:^(BOOL finished){
                    [self.view addSubview:self.contentView];
                    self.playControlView.hidden = NO;
                    self.playerScreenStatus = PlayerScreenStatusSmall;
                }];
            }
        }else{ //用默认的全屏
            if (toFullScreen) { //放大
                UIWindow *backgroundWindow = [self mainWindow];
                [backgroundWindow addSubview:self.contentView];
                [UIView animateWithDuration:0.3 animations:^{
                    //设置顺序(必须)：frame->center->transform
                    self.contentView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
                    self.engine.playerView.frame = self.contentView.bounds;
                    self.playControlView.frame = self.contentView.bounds;
                    [self.contentView layoutIfNeeded];
                    self.playControlView.fullScreen = YES;
                }completion:^(BOOL finished){
                    self.playerScreenStatus = PlayerScreenStatusBig;
                }];
            }else {  //缩小
                [UIView animateWithDuration:0.3 animations:^{
                    //设置顺序(必须)：transform->frame
                    self.contentView.frame = self.originalFrame;
                    self.engine.playerView.frame = self.contentView.bounds;
                    self.playControlView.frame = self.contentView.bounds;
                    self.contentView.center = self.view.center;
                    [self.contentView layoutIfNeeded];
                    self.playControlView.fullScreen = NO;
                } completion:^(BOOL finished){
                    [self.view addSubview:self.contentView];
                    self.playerScreenStatus = PlayerScreenStatusSmall;
                }];
            }
        }
    }else { //横屏
        if (toFullScreen) { //放大
            UIWindow *backgroundWindow = [self mainWindow];
            [backgroundWindow addSubview:self.contentView];
            [UIView animateWithDuration:0.3 animations:^{
                //设置顺序(必须)：frame->center->transform
                self.contentView.frame = CGRectMake(0, 0, ScreenH, ScreenW);
                self.contentView.center = backgroundWindow.center;
                self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
                self.engine.playerView.frame = self.contentView.bounds;
                self.playControlView.frame = self.contentView.bounds;
                [self.contentView layoutIfNeeded];
                self.playControlView.fullScreen = YES;
            }completion:^(BOOL finished){
                self.playerScreenStatus = PlayerScreenStatusBig;
            }];
        }else {  //缩小
            [UIView animateWithDuration:0.3 animations:^{
                //设置顺序(必须)：transform->frame
                self.contentView.transform = CGAffineTransformIdentity;
                self.contentView.frame = self.originalFrame;
                self.engine.playerView.frame = self.contentView.bounds;
                self.playControlView.frame = self.contentView.bounds;
                [self.contentView layoutIfNeeded];
                self.playControlView.fullScreen = NO;
            } completion:^(BOOL finished){
                [self.view addSubview:self.contentView];
                self.playerScreenStatus = PlayerScreenStatusSmall;
            }];
        }
    }
}

- (void)setPlayerScreenStatus:(PlayerScreenStatus)playerScreenStatus {
    _playerScreenStatus = playerScreenStatus;
    if (self.rotationCompleteBlock) {
        self.rotationCompleteBlock(self.engine.playbackState);
    }
}

//切换分辨率
- (void)controlView:(JHPlayControlView *)controlView changeResolution:(NSInteger)resolution {
    
}

//重试按钮
- (void)controlView:(JHPlayControlView *)controlView retry:(NSInteger)times {
    [self startPlay];
}

//切换播放速率
- (void)controlView:(JHPlayControlView *)controlView playBackSpeed:(CGFloat)speed {
    
}

//静音
- (void)controlView:(JHPlayControlView *)controlView muted:(BOOL)isMuted {
    self.muted = isMuted;
    self.engine.muted = isMuted;
}

//混播开关
- (void)controlView:(JHPlayControlView *)controlView mixWithOther:(BOOL)isOn {
    
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (JHPlayControlView *)playControlView {
    if (_playControlView == nil) {
        _playControlView = [[JHPlayControlView alloc] init];
        _playControlView.delegate = self;
    }
    return _playControlView;
}

- (UIButton *)centrPlayButton {
    if (_centrPlayButton == nil) {
        _centrPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centrPlayButton setImage:[UIImage imageNamed:@"appraisal_home_play"] forState:UIControlStateNormal];
        _centrPlayButton.hidden = YES;
        [_centrPlayButton addTarget:self action:@selector(playButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centrPlayButton;
}

//全屏必须加在window上，避免被其他view遮盖的情况
- (UIWindow *)mainWindow {
    UIWindow *window = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        window = [UIApplication sharedApplication].delegate.window;
    }
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}
@end
