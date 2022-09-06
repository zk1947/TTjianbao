//
//  JHMediaCapture.m
//  TTjianbao
//
//  Created by jiang on 2019/9/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHMediaCapture.h"
#import "NTESAuthorizationHelper.h"
#import "NTESLiveDataCenter.h"
#import "TTjianbaoHeader.h"

@interface JHMediaCapture ()
{
    BOOL _videoIsPause;
}
@property (nonatomic, assign) BOOL liveStreamIsStart; // 推流状态
@property (nonatomic, assign) BOOL allowStartLiveStream; //保证startLiveStream 接口不会重复调用
@property (nonatomic, assign) BOOL allowStopLiveStream; //保证stopLiveStream  接口不会重复调用

@property (nonatomic, assign) UIBackgroundTaskIdentifier backTaskId; //后台id
@property (nonatomic, assign) BOOL needReplayVideo;  //需要恢复视频.(前后台切换)
@property (nonatomic, assign) BOOL needReplayAudio;  //需要恢复音频.(前后台切换)
@property (nonatomic, assign) BOOL needRecoverLive;  //需要恢复推流.(网络切换)

@property (nonatomic, weak) UIView *container;
@property (nonatomic, copy) LiveCompleteBlock stopStreamBlock;
@property (nonatomic, copy) LiveCompleteBlock startStreamBlock;
@end

@implementation JHMediaCapture
- (instancetype)init
{
    if (self = [super init])
    {
        _allowStartLiveStream = YES;
        _allowStopLiveStream = YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onStartLiveStream:) name:LS_LiveStreaming_Started object:nil]; //直播开始通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFinishedLiveStream:) name:LS_LiveStreaming_Finished object:nil]; // 直播结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onBadNetworking:) name:LS_LiveStreaming_Bad object:nil]; //直播过程中网络差通知
        //进入后台通知
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                       selector:@selector(onEnterBackground:)
                                           name:UIApplicationDidEnterBackgroundNotification
                                         object:nil];
        
        //进入前台通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                       selector:@selector(onBecomeActive:)
                                           name:UIApplicationDidBecomeActiveNotification
                                         object:nil];
    }
    return self;
}
- (void)destory{
    
      [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_capturer) {
        [_capturer unInitLiveStream];
        _capturer=nil;
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_capturer) {
            [_capturer unInitLiveStream];
             _capturer=nil;
    }
    NSLog(@"capturer dealloc");
}
#pragma mark - Public
- (void)startVideoPreview:(NSString *)url
                container:(UIView *)view
{
    _pushUrl = url;
    _container = view;
    
    //申请权限
    __weak typeof(self) weakSelf = self;
    [NTESAuthorizationHelper requestMediaCapturerAccessWithHandler:^(NSError *error) {
        if (!error) //开始预览
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (weakSelf.capturer)
                {
                    [weakSelf.capturer startVideoPreview:view];
                }
                else
                {
                    NSLog(@"[Demo] >>>> self.capturer 为空");
                }
                
            });
        }
        else //权限未开启
        {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意"
                                                                    message:@"请开启摄像头和麦克风访问权限"
                                                                   delegate:nil cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                [alertView show];
//                [alertView showAlertWithCompletionHandler:^(NSInteger index) {
//                //    [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                }];
            });
        }
    }];
}

- (void)stopVideoPreview
{
    
    if (_capturer)
    {
        [_capturer pauseVideoPreview];
        [_capturer unInitLiveStream];
    }
    else
    {
        NSLog(@"[Demo] >>>> self.capturer 为空");
    }
}

- (void)startLiveStream:(LiveCompleteBlock)complete
{
    _startStreamBlock = complete;
    
    if (!_allowStartLiveStream)
    {
        NSLog(@"startStream接口调用中，等调用结束后再次调用");
        if (complete) {
            NSError *error = [[NSError alloc] initWithDomain:@"PushSdkDemo" code:10010 userInfo:nil];
            complete(error);
        }
        return;
    }
    else
    {
        _allowStartLiveStream = NO; //允许重新调用startStream接口
    }
    
    if (_liveStreamIsStart) //推流已开始，直接返回
    {
        _allowStartLiveStream = YES;
        if (_startStreamBlock)
        {
            _startStreamBlock(nil);
        }
        return;
    }
    
    if (!self.capturer)
    {
        _allowStartLiveStream = YES;
        if (complete) {
            NSError *error = [[NSError alloc] initWithDomain:@"PushSdkDemo" code:10011 userInfo:@{@"description" : @"未初始化"}];
            complete(error);
        }
        return;
    }
    
    [self.capturer startLiveStream:^(NSError *error) {
        if (error) {
            NSLog(@"开始推流失败，[%@]", [error localizedDescription]);
            _allowStartLiveStream = YES; //允许重新调用startStream接口
        }
        if (_startStreamBlock) {
            _startStreamBlock(error);
        }
    }];
}

- (void)stopLiveStream:(LiveCompleteBlock)complete
{
    _stopStreamBlock = complete;
    
    if (!_allowStopLiveStream)
    {
        NSLog(@"startStream接口调用中，等调用结束后再次调用");
        if (complete) {
            NSError *error = [[NSError alloc] initWithDomain:@"PushSdkDemo" code:10010 userInfo:nil];
            complete(error);
        }
        return;
    }
    else
    {
        _allowStopLiveStream = NO; //不允许调用startStream接口
    }
    
    if (!_liveStreamIsStart) //没推流，直接返回
    {
        _allowStopLiveStream = YES; //允许调用stopStream接口
        
        if (_stopStreamBlock)
        {
            _stopStreamBlock(nil);
        }
        return;
    }
    
    if (!_capturer)
    {
        NSLog(@"[Demo] >>>> self.capturer 为空");
        if (complete) {
            NSError *error = [[NSError alloc] initWithDomain:@"PushSdkDemo" code:10011 userInfo:nil];
            complete(error);
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [self.capturer stopLiveStream:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error)
            {
                NSLog(@"停止推流出错[%@]", [error localizedDescription]);
                weakSelf.allowStopLiveStream = YES; //允许重新调用stopStream接口
                
                if (weakSelf.stopStreamBlock)
                {
                    weakSelf.stopStreamBlock(error);
                }
            }
        });
    }];
}

//暂停视频
- (void)pauseVideo:(BOOL)isPause
{
    if (!self.capturer)
    {
        NSLog(@"[Demo] >>>> self.capturer 为空");
    }
    else
    {
        _videoIsPause = isPause;
        
        if (_liveStreamIsStart)
        {
            if (isPause) //暂停
            {
                [self.capturer pauseVideoLiveStream];
            }
            else //恢复
            {
                [self.capturer resumeVideoLiveStream];
            }
        }
        else
        {
            NSLog(@"视频推流未开始");
        }
    }
}

//暂停音频
- (void)pauseAudio:(BOOL)isPause
{
    if (!self.capturer)
    {
        NSLog(@"[Demo] >>>> self.capturer 为空");
    }
    else
    {
        _videoIsPause = isPause;
        
        if (_liveStreamIsStart)
        {
            if (isPause) //暂停
            {
                [self.capturer pauseAudioLiveStream];
            }
            else //恢复
            {
                [self.capturer resumeAudioLiveStream];
            }
        }
        else
        {
            NSLog(@"视频推流未开始");
        }
    }
}

//切换镜头
- (void)switchCamera
{
    if (!self.capturer)
    {
        NSLog(@"[Demo] >>>> self.capturer 为空");
    }
    else
    {
        [self.capturer switchCamera:nil];
    }
}

//截屏
- (void)snapImage:(LiveSnapBlock)complete
{
    if (!self.capturer)
    {
        NSLog(@"[Demo] >>>> self.capturer 为空");
    }
    else
    {
        if (_liveStreamIsStart)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.capturer snapShotWithCompletionBlock:^(UIImage *latestFrameImage) {
                    if (complete) {
                        complete(latestFrameImage);
                    }
                }];
            });
        }
        else
        {
            NSLog(@"视频推流未开始");
            if (complete) {
                complete(nil);
            }
        }
    }
}

#pragma mark - Notication
//网络不好的情况下，连续一段时间收到这种错误，可以提醒应用层降低分辨率
-(void)onBadNetworking:(NSNotification *)notification
{
    //NSLog(@"live streaming on bad networking");
}

//收到此消息，说明直播真的开始了
-(void)onStartLiveStream:(NSNotification *)notification
{
    NSLog(@"on start live stream");//只有收到直播开始的 信号，才可以关闭直播
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        _liveStreamIsStart = YES; //推流已经开启
        
        _allowStartLiveStream = YES; //允许重新调用startStream接口
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(doDidStartLiveStream)]) {
              [self.delegate doDidStartLiveStream];
        }
    });
}

//直播结束的通知消息
-(void)onFinishedLiveStream:(NSNotification *)notification
{
    NSLog(@"on finished live stream");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _liveStreamIsStart = NO;
        
        _allowStopLiveStream = YES; //允许重新调用stopStream接口
        
        [SVProgressHUD dismiss];
        
        if (_stopStreamBlock) {
            _stopStreamBlock(nil);
        }
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(doDidStopLiveStream)]) {
           [self.delegate doDidStopLiveStream];
        }
      
    });
}
//进入后台
- (void)onEnterBackground:(NSNotification *)notification
{
    UIApplication *app = [UIApplication sharedApplication];
    //申请后台时间
    _backTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"===在额外申请的10分钟内依然没有完成任务===");
        // 结束后台任务
        [app endBackgroundTask:_backTaskId];
    }];
    if(_backTaskId == UIBackgroundTaskInvalid){
        NSLog(@"===iOS版本不支持后台运行,后台任务启动失败===");
        return;
    }
//    [self pauseVideo:YES];
//    [self pauseAudio:YES];
//    _needReplayVideo = YES;
//    _needReplayAudio = YES;
  //  后台一分钟后结束推流
  //  [self performSelector:@selector(stopLiveWhenBackground) withObject:nil afterDelay:300];
}

//进入前台
- (void)onBecomeActive:(NSNotification *)notification
{
//        [NSObject cancelPreviousPerformRequestsWithTarget:self];
//
//        if (_needReplayAudio)
//        {
//            [self pauseAudio:NO];
//        }
//
//        if (_needReplayVideo)
//        {
//            [self pauseVideo:NO];
//        }
}


#pragma mark - Exception Handling
//后台超时结束
- (void)stopLiveWhenBackground
{
    NSLog(@"超时了，结束推流了...");
    
    UIApplication *app = [UIApplication sharedApplication];
    __weak typeof(self) weakSelf = self;
    [self stopLiveStream:^(NSError *error) {
        
        weakSelf.needReplayAudio = NO;
        weakSelf.needReplayVideo = NO;
        
        if (error != nil)
        {
            NSLog(@"退到后台的结束直播发生错误");
        }
        
        [app endBackgroundTask:weakSelf.backTaskId];
    }];
}

//断网重连接
- (void)restartLiveWhenNetRecover
{
    [SVProgressHUD dismiss];
    
    _needRecoverLive = NO;
    NSString *toast = [NSString stringWithFormat:@"重连失败"];
  //  [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
}

#pragma mark - Getter/Setter
- (LSLiveStreamingParaCtxConfiguration *)pParaCtx
{
    return [NTESLiveDataCenter shareInstance].pParaCtx;
}

- (BOOL)isOnlyPushVideo
{
    return [NTESLiveDataCenter shareInstance].isPushOnlyVideo;
}

- (LSMediaCapture *)capturer
{
    if (!_capturer) {
        _capturer = [[LSMediaCapture alloc] initLiveStream:self.pushUrl withLivestreamParaCtxConfiguration: self.pParaCtx];
     //   _capturer=[[LSMediaCapture alloc]initLiveStream:self.pushUrl];
        [_capturer setTraceLevel:LS_LOG_INFO];
       NSLog(@"sdkbersion==%@",  [LSMediaCapture getSDKVersionID]);
        if (_capturer == nil) {
            NSLog(@"[Demo] >>>> 推流sdk初始化失败");
        }
        //直播过程中发生错误的回调函数
       // __weak typeof(self) weakSelf = self;
        JH_WEAK(self)
        _capturer.onLiveStreamError = ^(NSError *error){
            JH_STRONG(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate&&[self.delegate respondsToSelector:@selector(doLiveStreamError:)]) {
                    [self.delegate doLiveStreamError:error];
                }
            });
        };
        //变焦回调
        _capturer.onZoomScaleValueChanged = ^(CGFloat value){
            JH_STRONG(self)
            if (self.delegate&&[self.delegate respondsToSelector:@selector(doZoomScaleValueChanged:)]) {
                 [self.delegate doZoomScaleValueChanged:value];
            }
        };
    }
    return _capturer;
}
@end
