//
//  StreamPlayerManager.m
//  TaodangpuAuction
//
//  Created by jiang on 2019/8/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "StreamPlayerManager.h"
static StreamPlayerManager *instance;
@interface StreamPlayerManager ()

@property (nonatomic, strong) UIView *playerContainerView; //播放器包裹视图

@property (nonatomic, strong) JHVideoPlayControlView *controlView; //播放器控制视图

@property (nonatomic, strong)   BYTimer *timer;
@end

@implementation StreamPlayerManager
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[StreamPlayerManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
      
    }
    return self;
}


//
//  NELivePlayerVC.m
//  NELivePlayerDemo
//
//  Created by Netease on 2017/11/15.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "NELivePlayerViewController.h"


#define limitDuring 10
@interface NELivePlayerViewController ()<JHVideoPlayControlViewProtocol>
{
    NSURL *_url;
    NSString *_decodeType;
    NSString *_mediaType;
    BOOL _isHardware;
    BOOL playBackFinished;
}


@property (nonatomic, strong) UIView *playerContainerView; //播放器包裹视图

@property (nonatomic, strong) JHVideoPlayControlView *controlView; //播放器控制视图

@property (nonatomic, strong)   BYTimer *timer;


@end

@implementation StreamPlayerManager

- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view  andControlView:(JHVideoPlayControlView*)controlView{
    
    _playerContainerView = view;
    _controlView = controlView;
    _controlView.fileTitle = [_url.absoluteString lastPathComponent];
    _controlView.delegate = self;
    _url=[NSURL URLWithString:streamUrl];
    _controlView.isBuffing = YES;
    [self doInitPlayer];
    
}
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view andTimeEndBlock:(complete)block{
    
    self.isCellPullStream=YES;
    _timeEndBlock=block;
    [self startPlay:streamUrl inView:view andControlView:nil];
}
- (void)syncUIStatus
{
    _controlView.isPlaying = NO;
    __block NSTimeInterval mDuration = 0;
    __block NSTimeInterval currentPos = 0;
    WEAKSELF
    if (!_timer) {
        _timer=[[BYTimer alloc]init];
    }
    
    [_timer startGCDTimerOnMainQueueWithInterval:1 Blcok:^{
        
        mDuration = [weakSelf.player duration];
        mDuration = [weakSelf.player duration];
        currentPos = [weakSelf.player currentPlaybackTime];
        //        if (currentPos>=mDuration ) {
        //            [weakSelf.timer stopGCDTimer];
        //        }
        
        //        if (_isCellPullStream) {
        //            if (currentPos>=limitDuring ) {
        //                weakSelf.timeEndBlock();
        //            }
        //        }
        weakSelf.controlView.isAllowSeek = (mDuration > 0);
        weakSelf.controlView.duration = mDuration;
        weakSelf.controlView.currentPos = currentPos;
        weakSelf.controlView.isPlaying = ([weakSelf.player playbackState] == NELPMoviePlaybackStatePlaying);
        
    }];
}

-(void)timeCountDown{
    
    WEAKSELF
    if (!_timer) {
        _timer=[[BYTimer alloc]init];
    }
    [_timer createTimerWithTimeout:limitDuring handlerBlock:^(int presentTime) {
        NSLog(@"%d",presentTime);
        
    } finish:^{
        NSLog(@"结束");
        weakSelf.timeEndBlock();
    }];
}
#pragma mark - 播放器SDK功能
- (void)doInitPlayer {
    
    //[NELivePlayerController setLogLevel:NELP_LOG_VERBOSE];
    
    NSError *error = nil;
    
    if (self.player) {
        [self.player.view removeFromSuperview];
        [self.player shutdown];
    }
    self.player = [[NELivePlayerController alloc] initWithContentURL:_url error:&error];
    if (self.player == nil) {
        NSLog(@"player initilize failed, please tay again.error = [%@]!", error);
    }
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = _playerContainerView.bounds;
    
    [_playerContainerView addSubview: self.player.view];
    
    self.view.autoresizesSubviews = YES;
    [self.player setBufferStrategy:NELPAntiJitter]; // 点播抗抖动
    [self.player setShouldAutoplay:YES]; // 设置prepareToPlay完成后是否自动播放
    [self.player setHardwareDecoder:NO]; // 设置解码模式，是否开启硬件解码
    [self.player setPauseInBackground:NO]; // 设置切入后台时的状态，暂停还是继续播放
    [self.player setPlaybackTimeout:15 *1000]; // 设置拉流超时时间
    [self.player setScalingMode:NELPMovieScalingModeAspectFill];
    
    if (self.isCellPullStream) {
        [self.player setBufferStrategy:NELPTopSpeed];
        [self.player setMute:YES];
    }
    
    [self.player prepareToPlay];
}

- (void)doInitPlayerNotication {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlaybackStateChanged:)
                                                 name:NELivePlayerPlaybackStateChangedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstVideoDisplayed:)
                                                 name:NELivePlayerFirstVideoDisplayedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstAudioDisplayed:)
                                                 name:NELivePlayerFirstAudioDisplayedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerReleaseSuccess:)
                                                 name:NELivePlayerReleaseSueecssNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerVideoParseError:)
                                                 name:NELivePlayerVideoParseErrorNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerSeekComplete:)
                                                 name:NELivePlayerMoviePlayerSeekCompletedNotification
                                               object:_player];
}
-(void)removePlayerNotication{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerDidPreparedToPlayNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerPlaybackStateChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerLoadStateChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerPlaybackFinishedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerFirstVideoDisplayedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerFirstAudioDisplayedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerReleaseSueecssNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerVideoParseErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerMoviePlayerSeekCompletedNotification object:nil];
    
}
- (void)doDestroyPlayer {
    
    if (self.player) {
        [self.player.view removeFromSuperview];
        [self.player shutdown];
        self.player=nil;
        [self.timer stopGCDTimer];
    }
}

#pragma mark - 播放器通知事件
- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification {
    //add some methods
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerDidPreparedToPlayNotification 通知");
    
    //获取视频信息，主要是为了告诉界面的可视范围，方便字幕显示
    NELPVideoInfo info;
    memset(&info, 0, sizeof(NELPVideoInfo));
    [_player getVideoInfo:&info];
    _controlView.videoResolution = CGSizeMake(info.width, info.height);
    
    [_player play]; //开始播放
    if (self.isCellPullStream) {
        [self timeCountDown];
    }
    else{
        [self syncUIStatus];
    }
    
    //开
    [_player setRealTimeListenerWithIntervalMS:500 callback:^(NSTimeInterval realTime) {
        NSLog(@"当前时间戳：[%f]", realTime);
    }];
    
    //关
    [_player setRealTimeListenerWithIntervalMS:500 callback:nil];
}

- (void)NELivePlayerPlaybackStateChanged:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerPlaybackStateChangedNotification 通知");
}

- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification {
    
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerLoadStateChangedNotification 通知");
    
    NELPMovieLoadState nelpLoadState = _player.loadState;
    if (nelpLoadState == NELPMovieLoadStatePlayable)
    {
        NSLog(@"finish buffering");
        _controlView.isBuffing = NO;
    }
    
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK)
    {
        NSLog(@"finish buffering");
        _controlView.isBuffing = NO;
    }
    else if (nelpLoadState == NELPMovieLoadStateStalled)
    {
        NSLog(@"begin buffering");
        _controlView.isBuffing = YES;
    }
}

- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification {
   
}
- (void)NELivePlayerFirstVideoDisplayed:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerFirstVideoDisplayedNotification 通知");
    self.controlView.isPlaying=YES;
    self.controlView.duration =self.player.duration;
}
- (void)NELivePlayerFirstAudioDisplayed:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerFirstAudioDisplayedNotification 通知");
    
}

- (void)NELivePlayerVideoParseError:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerVideoParseError 通知");
}

- (void)NELivePlayerSeekComplete:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerMoviePlayerSeekCompletedNotification 通知");
    [self cleanSubtitls];
}

- (void)NELivePlayerReleaseSuccess:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerReleaseSueecssNotification 通知");
    
    if (self.shutdownHandler) {
        self.shutdownHandler();
        self.shutdownHandler=nil;
    }
}

- (void)shutdown:(NTESLivePlayerShutdownHandler)handler
{
    self.shutdownHandler = handler;
    [self doDestroyPlayer];
}
- (void)shutdown
{
    [self doDestroyPlayer];
}
@end

@end
