//
//  JHLivePlayerManager.m
//  TTjianbao
//
//  Created by jiang on 2019/9/4.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "NTESAudienceLiveViewController.h"
#import "NTESAnchorLiveViewController.h"
#import "JHNormalLiveController.h"
#import "JHLivePlayerManager.h"
#import "BYTimer.h"
#import "NTESLiveLikeView.h"

#define limitDuring 10
#define playTimeout 5
static JHLivePlayerManager *instance;
@interface JHLivePlayerManager ()
{
    NSString *_url;
}

@property (nonatomic, strong) UIView *playerContainerView; //播放器包裹视图
@property (nonatomic, strong) BYTimer *timeDownTimer;
@property (nonatomic, strong) BYTimer *timeOutTimer;
@property (nonatomic, strong) JHFinishBlock timeEndBlock;
@property (nonatomic, strong) JHFinishBlock playFailBlock;
@property (nonatomic, assign) BOOL isPlaying;

///播放时间超时
@property (nonatomic, copy) dispatch_block_t playOutTimeBlock;

///播放超时时间 （秒）
@property (nonatomic, assign) NSTimeInterval timeInterval;

/// 是否动画
@property (nonatomic, assign) BOOL isAnimal;
/// 是否有点赞图标
@property (nonatomic, assign) BOOL isLikeImageView;
@property (nonatomic, strong) UIImageView *likeImageView;

///拉流动画
@property (nonatomic, weak) NTESLiveLikeView *likeView;

@property (nonatomic, copy) dispatch_block_t afterBlock;

@property (nonatomic, assign) BOOL isWiFi;

@property (nonatomic, assign) BOOL ignoreNetwork;

@end

@implementation JHLivePlayerManager

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHLivePlayerManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self netWorkReachable];
    }
    return self;
}

-(void)registerApplicationObservers{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlay:) name:NELivePlayerFirstVideoDisplayedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinshed:) name:NELivePlayerPlaybackFinishedNotification object:nil];
}

- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view andTimeEndBlock:(JHFinishBlock)block{
    [self startPlay:streamUrl inView:view andTimeEndBlock:block isAnimal:NO isLikeImageView:NO];
}


- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view andPlayFailBlock:(JHFinishBlock)failBlock
{
    [self startPlay:streamUrl inView:view andPlayFailBlock:failBlock isAnimal:NO];
}

///拉流成功失败的回调
- (void)startPlay:(NSString *)streamUrl
           inView:(UIView *)view
 andPlayFailBlock:(JHFinishBlock)failBlock
         isAnimal:(BOOL)isAnimal
{
    [self startPlay:streamUrl inView:view playFailBlock:failBlock playOutTimeBlock:nil timeInterval:0 isAnimal:isAnimal isLikeImageView:NO];
}

/// 轮播拉流
/// @param streamUrl 地址
/// @param view 流 展示容器
/// @param failBlock 失败
/// @param playOutTimeBlock 成功 N秒后
/// @param timeInterval 成功 N秒后
- (void)startPlay:(NSString *)streamUrl
           inView:(UIView *)view
    playFailBlock:(JHFinishBlock)failBlock
 playOutTimeBlock:(dispatch_block_t)playOutTimeBlock
     timeInterval:(NSTimeInterval)timeInterval
         isAnimal:(BOOL)isAnimal
 isLikeImageView:(BOOL)isLikeImageView
{
    _ignoreNetwork = NO;
    if(!self.isWiFi)
    {
        ///有播放超时时间，并且有回调的
        if(_timeInterval > 0 && _playOutTimeBlock)
        {
            self.afterBlock = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
                if(self.playOutTimeBlock)
                self.playOutTimeBlock();
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(),self.afterBlock );
        }
        return;
    }
    if([self isInLiveRoom])
    {///过掉在直播间时的拉流 （过滤列表轮播拉流）
        return;
    }
    if(timeInterval > 0 && self.afterBlock)
    {
        dispatch_block_cancel(self.afterBlock);
    }
    _playOutTimeBlock = playOutTimeBlock;
    _timeInterval = timeInterval;
    _playFailBlock = failBlock;
    _isAnimal = isAnimal;
    _isLikeImageView = isLikeImageView;
    _playerContainerView = view;
    _url=streamUrl?:@"http:";
     [self doInitPlayer];
     [self addtimeOutTimer];
}

- (void)startPlayIgnoreNetwork:(NSString *)streamUrl inView:(UIView *)view andPlayFailBlock:(JHFinishBlock)failBlock {
    
    _ignoreNetwork = YES;
    [self resetManagerParams];
    _playFailBlock = failBlock;
    _playerContainerView = view;
    _isAnimal = NO;
    _isLikeImageView = NO;
    _url = streamUrl ? : @"http:";
    [self doInitPlayer];
    [self addTimeDownTimer];
    
}

- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view andTimeEndBlock:(JHFinishBlock)block isAnimal:(BOOL)isAnimal isLikeImageView:(BOOL)isLikeImageView
{
    _ignoreNetwork = NO;
    if(!self.isWiFi)
    {
        return;
    }
    
    [self resetManagerParams];
    _timeEndBlock = block;
    _playerContainerView = view;
    _isAnimal = isAnimal;
    _isLikeImageView = isLikeImageView;
    _url = streamUrl ? : @"http:";
    [self doInitPlayer];
    [self addTimeDownTimer];
}

-(void)addtimeOutTimer{
    
    if (_timeOutTimer) {
        [_timeOutTimer stopGCDTimer];
        _timeOutTimer = nil;
    }
    _timeOutTimer = [[BYTimer alloc]init];
    @weakify(self)
    [_timeOutTimer createTimerWithTimeout:playTimeout handlerBlock:^(int presentTime) {
    } finish:^{
        
        NSLog(@"asasasasa");
        @strongify(self);
       if (!self.isPlaying&&(self.player || [_url isEqualToString:@"https"])) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self dismissAnimal];
             NSLog(@"asasasasa22");
            if (self.playFailBlock) {
                 NSLog(@"asasasasa33");
                self.playFailBlock();
            }
        }
    }];
    
}
-(void)addTimeDownTimer{
    //有值时,先stop,然后再重新创建
    if (_timeDownTimer) {
        [_timeDownTimer stopGCDTimer];
        _timeDownTimer = nil;
    }
    _timeDownTimer = [[BYTimer alloc]init];
    JH_WEAK(self)
    [_timeDownTimer createTimerWithTimeout:limitDuring handlerBlock:^(int presentTime) {
        JH_STRONG(self)
        NSLog(@"%d",presentTime);
        NELivePlayerRealTimeInfo * info = [self.player getMediaRealTimeInfo];
        NSLog(@"~~拉流信息~~~~~:%@",info);
    } finish:^{
        JH_STRONG(self)
        NSLog(@"结束");
        if (self.timeEndBlock) {
            self.timeEndBlock();
        }
    }];
}
- (void)doInitPlayer {
    NSError *error = nil;
    [self dismissAnimal];
    if (self.player) {
         [self.player shutdown];
         [self.player.view removeFromSuperview];
        self.player=nil;
        self.isPlaying = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
     [self registerApplicationObservers];
    
    NSLog(@"NELivePlayerController version==%@",[NELivePlayerController getSDKVersion]);
    self.player = [[NELivePlayerController alloc] initWithContentURL:[NSURL URLWithString:_url] error:&error];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = _playerContainerView.bounds;
    [_playerContainerView addSubview: self.player.view];
    [self.player setBufferStrategy:NELPAntiJitter]; // 点播抗抖动
    [self.player setShouldAutoplay:YES]; // 设置prepareToPlay完成后是否自动播放
    [self.player setHardwareDecoder:NO]; // 设置解码模式，是否开启硬件解码
    [self.player setPauseInBackground:YES]; // 设置切入后台时的状态，暂停还是继续播放
    [self.player setPlaybackTimeout:15 *1000]; // 设置拉流超时时间
    [self.player setScalingMode:NELPMovieScalingModeAspectFill];
    [self.player setBufferStrategy:NELPTopSpeed];
    [self.player setMute:YES];
    self.player.shouldAutoplay=YES;
    [self.player prepareToPlay];
}

- (void)shutdown
{
    [self doDestroyPlayer];
}

- (void)doDestroyPlayer {
    
    [self dismissAnimal];
    
    if (self.player) {
        
        NSLog(@"asasasasa444");
         [self.player shutdown];
        [self.player.view removeFromSuperview];
         self.player=nil;
        [self.timeDownTimer stopGCDTimer];
        _timeDownTimer = nil;
        [self.timeOutTimer stopGCDTimer];
         _timeOutTimer = nil;
        self.isPlaying = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)playerDidPlay:(NSNotification *)notification
{
    self.isPlaying = YES;
    if(_isAnimal)
    {
//        [self showAnimalMethod];
    }
    
    if (_isLikeImageView) {
//        [self showLikeImageView];
    }
    
    ///有播放超时时间，并且有回调的
    if(_timeInterval > 0 && _playOutTimeBlock)
    {
        self.afterBlock = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            if(self.playOutTimeBlock)
            self.playOutTimeBlock();
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(),self.afterBlock );
    }
}

-(BOOL)isInLiveRoom
{
    BOOL isLiveRoom = NO;
    UIViewController *vc = [JHRouterManager jh_getViewController];
    if([vc isKindOfClass:[NTESAudienceLiveViewController class]] || [vc isKindOfClass:[NTESAnchorLiveViewController class]] || [vc isKindOfClass:[JHNormalLiveController class]])
    {
        isLiveRoom = YES;
    }
    return isLiveRoom;
}

- (void)playbackFinshed:(NSNotification *)notification
{
      //如果拉流成功，才做结束的处理
    if (self.isPlaying == YES) {
        self.isPlaying = NO;
        if (self.playFailBlock) {
            self.playFailBlock();
        }
        [self dismissAnimal];
    }
}

///拉流的动画
- (NTESLiveLikeView *)showAnimalMethod
{
    NTESLiveLikeView *likeView = nil;
    if (_playerContainerView && _playerContainerView.superview)
    {
        likeView = [[NTESLiveLikeView alloc] initWithFrame:CGRectZero];
        [_playerContainerView.superview addSubview:likeView];
        [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 150));
            make.bottom.equalTo(self.playerContainerView).offset(-40);
            make.right.equalTo(self.playerContainerView).offset(7);
        }];
        [likeView fireRepeat];
        _likeView = likeView;
    }
    return _likeView;
}

- (void)showLikeImageView{
//    if (_playerContainerView && _playerContainerView.superview)
//    {
//        UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_buy_like"]];
//        likeImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_playerContainerView.superview addSubview:likeImageView];
//        self.likeImageView = likeImageView;
//        [likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.playerContainerView).offset(-9);
//            make.bottom.equalTo(self.playerContainerView).offset(-13);
//            make.size.mas_equalTo(CGSizeMake(18, 19));
//        }];
//    }
    
}

/// 入参配置重置
- (void)resetManagerParams
{
    _playOutTimeBlock = nil;
    _timeInterval = 0;
}

///结束动画
- (void)dismissAnimal
{
    if(_likeView)
    {
        [_likeView removeFromSuperview];
        _likeView = nil;
    }
    
    if (_likeImageView) {
        [_likeImageView removeFromSuperview];
        _likeImageView = nil;
    }
}

/// 网络状态改变
- (void)netWorkReachable{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.isWiFi = (status == AFNetworkReachabilityStatusReachableViaWiFi);
        if(!self.isWiFi && !_ignoreNetwork)
        {
            [self shutdown];
        }
    }];
}

@end
