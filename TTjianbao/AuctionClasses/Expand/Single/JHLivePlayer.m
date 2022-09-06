//
//  JHLivePlayer.m
//  TTjianbao
//
//  Created by jiang on 2020/2/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLivePlayer.h"
#import "JHLivePlaySMallView.h"
static JHLivePlayer *instance;
@interface JHLivePlayer ()
@property (nonatomic, strong) UIView *playerContainerView; //播放器包裹视图
@property (nonatomic, strong)  NSString *url;
@end

@implementation JHLivePlayer
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHLivePlayer alloc] init];
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
-(void)removePlayerNotication{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)initPlayerNotication {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(livePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(livePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(livePlayerWillBecomeActive:)
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlay:) name:NELivePlayerFirstVideoDisplayedNotification object:nil];
    
    
}
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view;{
  
    _playerContainerView = view;
    _url=streamUrl;
    [self doInitPlayer];
}
- (void)doInitPlayer {
    if (self.player) {
        [self.player.view removeFromSuperview];
        [self.player shutdown];
        self.player=nil;
        [self removePlayerNotication];
        [[JHLivePlaySMallView sharedInstance] removeFromSuperview];
    }
     NSLog(@"NELivePlayerController version==%@",[NELivePlayerController getSDKVersion]);
     [self initPlayerNotication];
     self.player = [self makePlayer:self.url];
     [self.playerContainerView  addSubview:self.player.view];
     self.player.view.frame = _playerContainerView.bounds;
    self.player.shouldAutoplay=YES;
    [self.player prepareToPlay];
    
}
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
    [player setScalingMode:NELPMovieScalingModeAspectFill];
   
    return player;
}

- (void)doDestroyPlayer{
    if (self.player) {
        [self.player.view removeFromSuperview];
        [self.player shutdown];
        self.player=nil;
        [self removePlayerNotication];
    }
}
- (void)livePlayerDidPreparedToPlay:(NSNotification *)notification
{
    [self.player prepareToPlay];
    [self.player play];
}
- (void)livePlayerWillBecomeActive:(NSNotification *)notification
{
      [self.player play];
}
- (void)playerDidPlay:(NSNotification *)notification
{
    if (self.didPlayBlock) {
        self.didPlayBlock();
    }
}
- (void)livePlayerPlayBackFinished:(NSNotification*)notification
{
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:{
            DDLogDebug(@"playback end, will retry in 10 sec.");
            [self retry:10];
            break;
        }
        case NELPMovieFinishReasonPlaybackError:
        {
            DDLogDebug(@"playback error, will retry in 5 sec.");
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
- (void)setMute: (BOOL)isMute{
    
    [self.player setMute:isMute];
}
- (void)retry:(NSTimeInterval)delay
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.player) {
            [weakSelf doInitPlayer];
        }
    });
}
@end
