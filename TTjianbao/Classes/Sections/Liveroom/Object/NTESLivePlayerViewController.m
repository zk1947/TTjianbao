//
//  NTESLivePlayerViewController.m
//  NIMLiveDemo
//
//  Created by chris on 16/3/2.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLivePlayerViewController.h"
#import <NELivePlayerFramework/NELivePlayerFramework.h>
#import "NTESBundleSetting.h"
#import "NTESLiveManager.h"
#import "UIView+NTES.h"
#import "TTjianbaoUtil.h"

///播放器第一帧视频显示时的消息通知
NSString *const NTESLivePlayerFirstVideoDisplayedNotification = @"NELivePlayerFirstVideoDisplayedNotification";
///播放器第一帧音频播放时的消息通知
NSString *const NTESLivePlayerFirstAudioDisplayedNotification = @"NELivePlayerFirstAudioDisplayedNotification";
///播放器加载状态发生改变时的消息通知
NSString *const NTESLivePlayerLoadStateChangedNotification = @"NELivePlayerLoadStateChangedNotification";
///播放器播放完成或播放发生错误时的消息通知
NSString *const NTESLivePlayerPlaybackFinishedNotification = @"NELivePlayerPlaybackFinishedNotification";
///播放器播放状态发生改变时的消息通知
NSString *const NTESLivePlayerPlaybackStateChangedNotification = @"NELivePlayerPlaybackStateChangedNotification";


@interface NTESLivePlayerInfo : NSObject

@property (nonatomic,copy) NSString *streamUrl;
@property (nonatomic,weak) JHVideoPlayControlView *controlView;
@property (nonatomic,weak) UIView *container;


@end

@interface NTESLivePlayerViewController() <JHVideoPlayControlViewProtocol>
{
    BOOL _isShutdowning;
    NTESLivePlayerInfo *_nextPlayerInfo;
    BOOL playBackFinished;
    
}

@property (nonatomic,copy)   NSString *playUrl;

@property (nonatomic,weak)   UIView *container;

@property (nonatomic,weak) JHVideoPlayControlView *controlView;
@property (nonatomic,strong)  BYTimer  *timer;

@property (nonatomic,assign) BOOL isMute;

@property (nonatomic,strong) NELivePlayerController *player;

@property (nonatomic,assign) NELPMovieScalingMode scalingMode;

@property (nonatomic,strong) NSMutableSet<NTESLivePlayerShutdownHandler> *shutdownHandlers;

@property (nonatomic,assign) JHMediaType mediaType;
@end

@implementation NTESLivePlayerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _shutdownHandlers = [[NSMutableSet alloc] init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.needShutDown) {
        [self doInitPlayerNotication];
        _isShutdowning=NO;
        [self startPlay:self.playUrl inView:self.container andControlView:self.controlView andMedioType:self.mediaType];
    }
      self.needShutDown=NO;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    if (self.needShutDown) {
       [self shutdown];
        [self removePlayerNotication];
    }
    
}
-(void)removePlayerNotication{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerDidPreparedToPlayNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerPlaybackFinishedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerReleaseSueecssNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerLoadStateChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerFirstVideoDisplayedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NELivePlayerFirstAudioDisplayedNotification object:nil];
    
    
}
- (void)doInitPlayerNotication {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(livePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(livePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(livePlayerReleaseSueecssed:)
                                                 name:NELivePlayerReleaseSueecssNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlay) name:NELivePlayerFirstVideoDisplayedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlay) name:NELivePlayerFirstAudioDisplayedNotification object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doInitPlayerNotication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(livePlayerWillBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player.view removeFromSuperview];
    [self shutdown];
    [self.timer stopGCDTimer];
}
- (void)syncUIStatus
{
    _controlView.isPlaying = NO;
    
    __block NSTimeInterval mDuration = 0;
    __block NSTimeInterval currentPos = 0;
    
    JH_WEAK(self)
    if (!_timer) {
        _timer=[[BYTimer alloc]init];
    }
    [_timer startGCDTimerOnMainQueueWithInterval:1 Blcok:^{
        JH_STRONG(self)
        mDuration = [self.player duration];
        currentPos = [self.player currentPlaybackTime];
        //                if (currentPos>=mDuration ) {
        //                    [weakSelf.timer stopGCDTimer];
        //                }
        self.controlView.isAllowSeek = (mDuration > 0);
        self.controlView.duration = mDuration;
        self.controlView.currentPos = currentPos;
        self.controlView.isPlaying = ([self.player playbackState] == NELPMoviePlaybackStatePlaying);
        
    }];
}

- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view andControlView:(JHVideoPlayControlView*)controlView andMedioType:(JHMediaType)mediaType
{
    _nextPlayerInfo = [[NTESLivePlayerInfo alloc] init];
    _nextPlayerInfo.streamUrl = streamUrl;
    _nextPlayerInfo.container = view;
    _nextPlayerInfo.controlView = controlView;
    
    self.mediaType=mediaType;
    if (self.player) {
        [self.player.view removeFromSuperview];
        [self shutdown];
    }
    
    [self startPlay:_nextPlayerInfo];
    
    [self setScalingMode:NELPMovieScalingModeAspectFill];
    
    _controlView.isBuffing = YES;
}

- (void)startPlay:(NTESLivePlayerInfo *)info
{
    self.playUrl = info.streamUrl;
    self.container = info.container;
    self.controlView=info.controlView;
    self.controlView.delegate=self;
    self.player = [self makePlayer:info.streamUrl];
    
    DDLogInfo(@"player %@ try to start play url %@",self.player,info.streamUrl);
    [info.container addSubview:self.player.view];
    if (![self.player isPreparedToPlay]) {
        [self.player prepareToPlay];
    }
    _nextPlayerInfo=nil;
    
}

- (void)adjustPlayerView
{
    NELPVideoInfo info;
    [self.player getVideoInfo:&info];
    CGSize size = CGSizeMake(info.width, info.height);
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        DDLogInfo(@"get video info complete, width:%zd, height:%zd",info.width,info.height);
        if ([self videoInfoIsFromPC:size])
        {
            [self adjustPlayerViewFromPC:size];
        }
        else
        {
            [self adjustPlayerViewFromMobile:size];
        }
    }
    self.player.view.userInteractionEnabled = NO;
}

- (BOOL)videoInfoIsFromPC:(CGSize)size
{
    return size.width/size.height >= 4/3;  //大于等于4:3的屏幕，都认为是PC屏
}

- (void)adjustPlayerViewFromMobile:(CGSize)size
{
    UIView *superview = self.player.view.superview;
    CGFloat scaleW = superview.width/size.width;
    CGFloat scaleH = superview.height/size.height;
    CGFloat scale  = scaleW > scaleH? scaleW : scaleH;
    CGFloat width  = size.width * scale;
    CGFloat height = size.height * scale;
    self.player.view.frame = CGRectMake(0, 0, width, height);
    
    //放到右下角，保证小屏幕不会被裁掉
    self.player.view.bottom = superview.bottom;
    self.player.view.right  = superview.width;
}

- (void)adjustPlayerViewFromPC:(CGSize)size
{
    //因为 ScalingMode 本身是 NELPMovieScalingModeAspectFit，会黑边填充，所以放大到和 superview 一样大就好了
    UIView *superview = self.player.view.superview;
    self.player.view.frame = superview.bounds;
}

- (void)livePlayerDidPreparedToPlay:(NSNotification *)notification
{
    
    if (self.mediaType==JHMediaTypeVideoStream) {
        [self syncUIStatus];
    }
    [self.player setMute:self.isMute];
    [self.player prepareToPlay];
    [self.player play];
    
}

- (void)livePlayerWillBecomeActive:(NSNotification *)notification
{
    
//    if (playBackFinished) {
//
//         [self startPlay:self.playUrl inView:self.container andControlView:self.controlView andMedioType:self.mediaType];
//        playBackFinished=NO;
//    }
//    else{
//
//         [self.player play];
//    }
    
      [self.player play];
}
- (void)onToggleScaleMode:(BOOL)fullScreen
{
    if ([self.delegate respondsToSelector:@selector(onToggleScaleMode:)]) {
        [self.delegate onToggleScaleMode:fullScreen];
    }
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
- (void)livePlayerPlayBackFinished:(NSNotification*)notification
{
    if (self.mediaType==JHMediaTypeVideoStream) {
        
        return;
    }
    
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:{
            DDLogDebug(@"playback end, will retry in 10 sec.");
            playBackFinished=YES;
            [self retry:10];
            break;
        }
        case NELPMovieFinishReasonPlaybackError:
        {
            DDLogDebug(@"playback error, will retry in 5 sec.");
             playBackFinished=YES;
            [self retry:5];
            break;
        }
        case NELPMovieFinishReasonUserExited:
            DDLogDebug(@"playback user exited.");
            break;
            
        default:
            break;
    }
}
- (void)playerDidPlay
{
    if (self.mediaType==JHMediaTypeVideoStream) {
        
        self.controlView.isPlaying=YES;
        self.controlView.duration =self.player.duration;
        
    }
    
  //   [self adjustPlayerView];
}

- (void)livePlayerReleaseSueecssed:(NSNotification *)notification
{
    DDLogInfo(@"player resource has release successed! notification is main thread %zd",[[NSThread currentThread] isMainThread]);
    dispatch_async_main_safe(^{
        _isShutdowning = NO;
        [self fireShutdownHandlers];
        
        if (_nextPlayerInfo) {
            DDLogInfo(@"find next player info");
            // [self startPlay:_nextPlayerInfo];
        }
    });
}

- (void)shutdown:(NTESLivePlayerShutdownHandler)handler
{
    if (handler) {
        [self.shutdownHandlers addObject:handler];
    }
    [self shutdown];
}
- (BOOL)shutdown
{
    if (!self.player) {
        DDLogInfo(@"player is not initialized, may be called in dealloc function, ignore the shutdown request");
        [self fireShutdownHandlers];
        return NO;
    }
    if (_isShutdowning) {
        DDLogInfo(@"player %@ is now shutdowning, ignore the shutdown request",self.player);
        return NO;
    }
    _isShutdowning = YES;
    DDLogInfo(@"player %@ is now shutdowning",self.player);
    if (self.needShutDown){
        
         [self.player.view removeFromSuperview];
      }
    [self.player shutdown];
    self.player = nil;
    return YES;
}

- (void)fireShutdownHandlers{
    DDLogInfo(@"try to fire shut down handlers, handler count %zd",self.shutdownHandlers.count);
    for (NTESLivePlayerShutdownHandler handler in self.shutdownHandlers) {
        handler();
    }
    [self.shutdownHandlers removeAllObjects];
    DDLogInfo(@"try to fire shut down handlers,completion");
    
}

- (void)retry:(NSTimeInterval)delay
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf) {
            DDLogInfo(@"start retry, url: %@, container:%@",weakSelf.playUrl,weakSelf.container);
            [weakSelf startPlay:weakSelf.playUrl inView:weakSelf.container andControlView:weakSelf.controlView andMedioType:weakSelf.mediaType];
        }
    });
}

#pragma mark - Get
- (NELivePlayerController *)makePlayer:(NSString *)streamUrl
{
    
    
    NELivePlayerController *player;
    [NELivePlayerController setLogLevel:NELP_LOG_DEFAULT];
    NSURL *url = [NSURL URLWithString:streamUrl];
    player = [[NELivePlayerController alloc] initWithContentURL:url error:nil];
    DDLogInfo(@"live player start version %@",[NELivePlayerController getSDKVersion]);
       player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    NELPBufferStrategy strategy  = NELPTopSpeed;
    [player setPauseInBackground:YES]; // 设置切入后台时的状态，暂停还是继续播放
    [player setBufferStrategy:strategy];
    DDLogInfo(@"live player set buffer strategy %zd",strategy);
    [player setHardwareDecoder:NO];
    
    //    [player setLoopPlayCount:0];
    
    //    if (!player) {
    //        [self retry:5];
    //    }
    return player;
}

- (void)setScalingMode:(NELPMovieScalingMode)aScalingMode
{
    _scalingMode = aScalingMode;
    [self.player setScalingMode:aScalingMode];
}

- (void)controlViewOnClickPlay:(JHVideoPlayControlView *)controlView isPlay:(BOOL)isPlay {
    NSLog(@"[NELivePlayer Demo] 点击播放，当前状态: [%@]", (isPlay ? @"播放" : @"暂停"));
    if (isPlay) {
        [self.player play];
    } else {
        [self.player pause];
    }
}
- (void)controlViewOnClickSeek:(JHVideoPlayControlView *)controlView dstTime:(NSTimeInterval)dstTime {
    NSLog(@"[NELivePlayer Demo] 执行seek，目标时间: [%f]", dstTime);
    
    if (self.mediaType==JHMediaTypeVideoStream) {
        self.player.currentPlaybackTime = dstTime;
    }
}
- (void)doDestroyPlayer {
    
    if (self.player) {
        [self.player.view removeFromSuperview];
        [self.player shutdown];
        self.player=nil;
    }
}
@end

@implementation NTESLivePlayerInfo

@end


