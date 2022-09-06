//
//  NELivePlayerVC.m
//  NELivePlayerDemo
//
//  Created by Netease on 2017/11/15.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "NELivePlayerViewController.h"
#import "BYTimer.h"

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
//外挂字幕处理缓存
@property (nonatomic, strong) NSMutableArray *subtitleIdArray;
@property (nonatomic, strong) NSMutableDictionary *subtitleDic;
@property (nonatomic, strong) NSMutableArray *exSubtitleIdArray;
@property (nonatomic, strong) NSMutableDictionary *exSubtitleDic;


@property (nonatomic, strong) JHFinishBlock timeEndBlock;
@property(assign,nonatomic)BOOL isCellPullStream;
@end

@implementation NELivePlayerViewController

- (void)dealloc {
    NSLog(@"[NELivePlayer Demo] NELivePlayerVC 已经释放！");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player shutdown]; // 退出播放并释放相关资源
    [self.player.view removeFromSuperview];
    self.player = nil;
    [self.timer stopGCDTimer];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self doInitPlayerNotication];
    if (self.player&&![self.player isPlaying]) {
        [self.player play];
     }
    self.viewDisAppear=NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.player&&[self.player isPlaying]) {
        [self.player pause];
    }
      self.viewDisAppear=YES;
      [self removePlayerNotication];
}
- (instancetype)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm {
    if (self = [super init]) {
        _url = url;
     
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(livePlayerWillBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
 
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    _playerContainerView.frame = self.view.bounds;
//    _controlView.frame = self.view.bounds;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    
    if (UI.bottomSafeAreaHeight>0) {
        return NO;
    }
    return YES;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeRight;
//}

- (void)setupSubviews {
    
//    _playerContainerView = [[UIView alloc] init];
//    _playerContainerView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_playerContainerView];
    
//    _controlView = [[NELivePlayerControlView alloc] init];
//    _controlView.fileTitle = [_url.absoluteString lastPathComponent];
//    _controlView.delegate = self;
//    [self.view addSubview:_controlView];
}
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view  andControlView:(JHVideoPlayControlView*)controlView{
    
    _playerContainerView = view;
    _controlView = controlView;
    _controlView.fileTitle = [_url.absoluteString lastPathComponent];
    _controlView.delegate = self;
    _url=[NSURL URLWithString:streamUrl];
    _controlView.isBuffing = YES;
     [self doInitPlayer];

}
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view andTimeEndBlock:(JHFinishBlock)block{
    
      self.isCellPullStream=YES;
      _timeEndBlock=block;
      [self startPlay:streamUrl inView:view andControlView:nil];
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
        mDuration = [self.player duration];
        currentPos = [self.player currentPlaybackTime];
//        if (currentPos>=mDuration ) {
//            [weakSelf.timer stopGCDTimer];
//        }
       
//        if (_isCellPullStream) {
//            if (currentPos>=limitDuring ) {
//                weakSelf.timeEndBlock();
//            }
//        }
        self.controlView.isAllowSeek = (mDuration > 0);
        self.controlView.duration = mDuration;
        self.controlView.currentPos = currentPos;
        self.controlView.isPlaying = ([self.player playbackState] == NELPMoviePlaybackStatePlaying);
        
    }];
}

-(void)timeCountDown{
    
    JH_WEAK(self)
    if (!_timer) {
        _timer=[[BYTimer alloc]init];
    }
    [_timer createTimerWithTimeout:limitDuring handlerBlock:^(int presentTime) {
        NSLog(@"%d",presentTime);
        
    } finish:^{
        JH_STRONG(self)
          NSLog(@"结束");
          self.timeEndBlock();
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
    [self.player setPauseInBackground:YES]; // 设置切入后台时的状态，暂停还是继续播放
    [self.player setPlaybackTimeout:15 *1000]; // 设置拉流超时时间
     [self.player setScalingMode:NELPMovieScalingModeAspectFill];

    if (self.isCellPullStream) {
     [self.player setBufferStrategy:NELPTopSpeed];
    [self.player setMute:YES];
    }
    
//    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryMultiRoute withOptions:kAudioSessionCategory_PlayAndRecord error:nil];
    
    //字幕功能
    //[self subtitleFunction];
    
    //透传自定义信息功能
    //[self syncContentFunction];
    
#ifdef KEY_IS_KNOWN // 视频云加密的视频，自己已知密钥
    NSString *key = @"HelloWorld";
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte *flv_key = (Byte *)[keyData bytes];
    
    unsigned long len = [keyData length];
    flv_key[len] = '\0';
    __weak typeof(self) weakSelf = self;
    [self.player setDecryptionKey:flv_key andKeyLength:(int)len :^(NELPKeyCheckResult ret) {
        if (ret == 0 || ret == 1) {
            [weakSelf.liveplayer prepareToPlay];
        }
    }];
    
#else
    
#ifdef DECRYPT //用视频云整套加解密系统
    if ([self.mediaType isEqualToString:@"videoOnDemand"]) {
        NSString *transferToken = NULL;
        NSString *accid = NULL;
        NSString *appKey = NULL;
        NSString *token = NULL;
        [self.liveplayer initDecryption:transferToken :accid :appKey :token :^(NELPKeyCheckResult ret) {
            NSLog(@"ret = %d", ret);
            switch (ret) {
                case NELP_NO_ENCRYPTION:
                case NELP_ENCRYPTION_CHECK_OK:
                    [self.liveplayer prepareToPlay];
                    break;
                case NELP_ENCRYPTION_UNSUPPORT_PROTOCAL:
                    [self decryptWarning:@"NELP_ENCRYPTION_UNSUPPORT_PROTOCAL"];
                    break;
                case NELP_ENCRYPTION_KEY_CHECK_ERROR:
                    [self decryptWarning:@"NELP_ENCRYPTION_KEY_CHECK_ERROR"];
                    break;
                case NELP_ENCRYPTION_INPUT_INVALIED:
                    [self decryptWarning:@"NELP_ENCRYPTION_INPUT_INVALIED"];
                    break;
                case NELP_ENCRYPTION_UNKNOWN_ERROR:
                    [self decryptWarning:@"NELP_ENCRYPTION_UNKNOWN_ERROR"];
                    break;
                case NELP_ENCRYPTION_GET_KEY_TIMEOUT:
                    [self decryptWarning:@"NELP_ENCRYPTION_GET_KEY_TIMEOUT"];
                    break;
                default:
                    break;
            }
        }];
    }
#else
    [self.player prepareToPlay];
#endif
#endif
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
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerPlaybackFinishedNotification 通知");
    

//    UIAlertController *alertController = NULL;
//    UIAlertAction *action = NULL;
//    __weak typeof(self) weakSelf = self;
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
            
             playBackFinished=YES;
            if ([_mediaType isEqualToString:@"livestream"]) {
//                alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"直播结束" preferredStyle:UIAlertControllerStyleAlert];
//                action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                    [weakSelf doDestroyPlayer];
//                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                }];
//                [alertController addAction:action];
//                [weakSelf presentViewController:alertController animated:YES completion:nil];
            }
            break;
            
        case NELPMovieFinishReasonPlaybackError:
        {
            
             playBackFinished=YES;
//            alertController = [UIAlertController alertControllerWithTitle:nil message:@"播放失败" preferredStyle:UIAlertControllerStyleAlert];
//            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                [weakSelf doDestroyPlayer];
//                [weakSelf dismissViewControllerAnimated:YES completion:nil];
//            }];
//            [alertController addAction:action];
//            [weakSelf presentViewController:alertController animated:YES completion:nil];
            break;
        }
            
        case NELPMovieFinishReasonUserExited:
            break;
            
        default:
            break;
    }
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

#pragma mark - 控制页面的事件
- (void)controlViewOnClickQuit:(NELivePlayerControlView *)controlView {
    NSLog(@"[NELivePlayer Demo] 点击退出");
    
    [self doDestroyPlayer];
    
//    // 释放timer
//    if (_timer != nil) {
//        dispatch_source_cancel(_timer);
//        _timer = nil;
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)controlViewOnClickPlay:(NELivePlayerControlView *)controlView isPlay:(BOOL)isPlay {
    NSLog(@"[NELivePlayer Demo] 点击播放，当前状态: [%@]", (isPlay ? @"播放" : @"暂停"));
    if (isPlay) {
        [self.player play];
    } else {
        [self.player pause];
    }
}
- (void)controlViewOnClickSeek:(NELivePlayerControlView *)controlView dstTime:(NSTimeInterval)dstTime {
    NSLog(@"[NELivePlayer Demo] 执行seek，目标时间: [%f]", dstTime);
    self.player.currentPlaybackTime = dstTime;
    
}
- (void)controlViewOnClickMute:(NELivePlayerControlView *)controlView isMute:(BOOL)isMute{
    NSLog(@"[NELivePlayer Demo] 点击静音，当前状态: [%@]", (isMute ? @"静音开" : @"静音关"));
    [self.player setMute:isMute];
}

- (void)controlViewOnClickSnap:(NELivePlayerControlView *)controlView{
    
    NSLog(@"[NELivePlayer Demo] 点击屏幕截图");
    
    UIImage *snapImage = [self.player getSnapshot];
    
    UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"截图已保存到相册" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)controlViewOnClickScale:(NELivePlayerControlView *)controlView isFill:(BOOL)isFill {
    NSLog(@"[NELivePlayer Demo] 点击屏幕缩放，当前状态: [%@]", (isFill ? @"全屏" : @"适应"));
    if (isFill) {
        [self.player setScalingMode:NELPMovieScalingModeAspectFill];
    } else {
        [self.player setScalingMode:NELPMovieScalingModeAspectFit];
    }
}
- (void)livePlayerWillBecomeActive:(NSNotification *)notification
{
//    if (playBackFinished) {
//
//        [self doInitPlayer];
//        playBackFinished=NO;
//    }
//    else{
//        [self.player play];
   // }
    //
    //  [self startPlay:_nextPlayerInfo];
}
#pragma mark - Tools
dispatch_source_t CreateDispatchSyncUITimerN(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    //创建Timer
    dispatch_source_t timer  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);//queue是一个专门执行timer回调的GCD队列
    if (timer) {
        //使用dispatch_source_set_timer函数设置timer参数
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval*NSEC_PER_SEC), interval*NSEC_PER_SEC, (1ull * NSEC_PER_SEC)/10);
        //设置回调
        dispatch_source_set_event_handler(timer, block);
        //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
        dispatch_resume(timer);
    }
    
    return timer;
}

- (void)decryptWarning:(NSString *)msg {
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
    
    alertController = [UIAlertController alertControllerWithTitle:@"注意" message:msg preferredStyle:UIAlertControllerStyleAlert];
    action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (self.presentingViewController) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 外挂字幕功能示例

- (void)subtitleFunction {
    
    NSString *srtPath1 = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"srt"];
    
    //设置外挂字幕
    NSURL *url = [NSURL fileURLWithPath:srtPath1];
    [self.player setLocalSubtitleFile:url];
    
    //关闭外挂字幕
//    [self.player setSubtitleFile:NULL];
    
    //切换外挂字幕
//    NSString *srtPath2 = @"test2";
//    NSURL *url2 = [NSURL fileURLWithPath:srtPath2];
//    [self.player setSubtitleFile:url];
//    [self.player setSubtitleFile:url2];
    
    //设置监听
    __weak typeof(self) weakSelf = self;
    [self.player registSubtitleStatBlock:^(BOOL isShown, NSInteger subtitleId, NSString *subtitleText) {
        [weakSelf processSubtitle:isShown subId:subtitleId subtitle:subtitleText];
    }];
}

//处理字幕
- (void)processSubtitle:(BOOL)isShown  subId:(NSInteger)subId subtitle:(NSString *)subtitle {
    //NSString *str = (isShown ? @"显示" : @"隐藏");
    //NSLog(@"[%@] id:[%zi] tx:[%@]", str, subId, subtitle);
    if (!_subtitleIdArray) {
        _subtitleIdArray = [NSMutableArray array];
    }
    if (!_subtitleDic) {
        _subtitleDic = [NSMutableDictionary dictionary];
    }
    
    if (!_exSubtitleIdArray) {
        _exSubtitleIdArray = [NSMutableArray array];
    }
    if (!_exSubtitleDic) {
        _exSubtitleDic = [NSMutableDictionary dictionary];
    }
    
    //数据存放
    NSRange range;
    BOOL isExSubtitle = [self isExSubtitle:subtitle range:&range];
    __block NSMutableArray *idArray = (isExSubtitle ? _exSubtitleIdArray : _subtitleIdArray);
    __block NSMutableDictionary *subDic  = (isExSubtitle ? _exSubtitleDic : _subtitleDic);
    NSString *insertSubStr = (isExSubtitle ? [subtitle stringByReplacingCharactersInRange:range withString:@""] : subtitle);
    if (isShown)
    {
        [idArray addObject:@(subId)];
        [subDic setObject:insertSubStr forKey:@(subId)];
    }
    else
    {
        __block NSUInteger index;
        [idArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj integerValue] == subId) {
                [subDic removeObjectForKey:obj];
                index = idx;
                *stop = YES;
            }
        }];
        if (index < idArray.count) {
            [idArray removeObjectAtIndex:index];
        }
    }
    
    //获取显示字符串
    NSMutableString *showStr = [NSMutableString stringWithFormat:@""];
    for (int i = 0; i < idArray.count; i++) {
        if (subDic[idArray[i]]) {
            [showStr appendString:subDic[idArray[i]]];
            if (i != idArray.count - 1) {
                [showStr appendString:@"\n"];
            }
        }
        else
        {
            break;
        }
    }
    
    //更新UI
    if (isExSubtitle) {
        //-----------
        _controlView.subtitle_ex = showStr;
    }
    else
    {
        //----------- 根据显示的字符串做格式处理 ---------------
        _controlView.subtitle = showStr;
    }
}

//扩展的字幕信息{扩展字幕信息，主要包括{}，主要记录附加信息}
- (BOOL)isExSubtitle:(NSString *)subtitle range:(NSRange *)range {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{[\\S\\s]+\\}"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:subtitle
                                                     options:0
                                                       range:NSMakeRange(0, [subtitle length])];
    BOOL ret = NO;
    if (result) {
        *range = result.range;
        ret = YES;
    }
    return ret;
}

- (void)cleanSubtitls { //seek完成后，或者切换完字幕，需要清空
    [_exSubtitleDic removeAllObjects];
    [_exSubtitleIdArray removeAllObjects];
    [_subtitleDic removeAllObjects];
    [_subtitleIdArray removeAllObjects];
    
    //更新UI
    _controlView.subtitle_ex = @"";
    _controlView.subtitle = @"";
}

#pragma mark - 透传自定义信息示例
- (void)syncContentFunction {
    [self.player registerSyncContentCB:^(NELivePlayerSyncContent *content) {
        NSArray *strings = content.contents;
        [strings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"透传的自定义信息是 ：----- %@ ------", obj);
        }];
    }];
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
