//
//  AudioTool.m
//  AudioTool
//
//  Created by zhihuili on 2018/12/23.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "AudioTool.h"
#import "ZHWeakProxy.h"
#import "CommAlertView.h"

static AudioTool *audioTool;

typedef void(^recordBlock)(void);

@interface AudioTool ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property(strong,nonatomic)AVAudioRecorder *recorder;
@property(strong,nonatomic)AVAudioPlayer *player;

@property(weak,nonatomic)CADisplayLink *displayLink;

@property(strong,nonatomic)NSURL *recoderUrl;
@property(assign,nonatomic)NSInteger seconds;

@end

@implementation AudioTool

+ (AudioTool *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioTool = [[AudioTool alloc] init];
        audioTool.filePath = @"";
    });
    return audioTool;
}

- (BOOL)checkMicrophoneAuthority {
    AVAudioSessionRecordPermission authStatus = AVAudioSession.sharedInstance.recordPermission;
    if (authStatus == AVAudioSessionRecordPermissionDenied) {
        [AVAudioSession.sharedInstance requestRecordPermission:^(BOOL granted) {
            if (granted == false) {
                [self showAlertWithDesc:@"无麦克风权限请前往设置"];
            }
        }];
        return false;
    }
    return true;
}
- (void)showAlertWithDesc : (NSString *)desc {
    dispatch_async(dispatch_get_main_queue(), ^{
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:desc cancleBtnTitle:@"取消" sureBtnTitle:@"设置"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        alert.handle = ^{
            NSURL *settingUrl = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
            if ([UIApplication.sharedApplication canOpenURL:settingUrl]) {
                [UIApplication.sharedApplication openURL:settingUrl];
            }
        };
        alert.cancleHandle = ^{ };
    });
}
-(void)startRecordBlock:(void(^)(BOOL started))recordBlock{
    if (![self checkMicrophoneAuthority]) {
        if (recordBlock) {
            recordBlock(false);
        }
        return;
    }
//    NSDictionary *recordSetting = [self getAudioSetting];
//    NSError *recorderError;
//
//    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.filePath] settings:recordSetting error:&recorderError];
//    if (recorderError) {
//        if (recordBlock) {
//            recordBlock(false);
//        }
//        NSLog(@"%@", [recorderError description]);
//    } else {
//        if (recordBlock) {
//            recordBlock(true);
//        }
//        self.recorder.meteringEnabled = YES;
//        self.recorder.delegate = self;
//        [self.recorder prepareToRecord];
//        [self.recorder record];
//    }
    
    [self.recorder prepareToRecord];
    [self.recorder record];
    if (recordBlock) {
        recordBlock(true);
    }
}

-(void)resumeRecord{
    [self.recorder record];
}

-(void)pauseRecord{
    if ([self.recorder isRecording]) {
        [self.recorder pause];
    }
}

-(void)stopRecord{
    [self.recorder stop];
    self.recorder = nil;
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}

-(void)startPlayWithUrl:(NSURL *)url atTime:(float)value{
    
    NSError *playerError;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playerError];
    if (playerError) {
        NSLog(@"playerError = %@", [playerError description]);
        return;
    } else {
        self.player.delegate = self;
        self.player.volume = 1.0;
        [self.player prepareToPlay];
        self.player.currentTime = self.player.duration*value;
        [self.player play];
        
//        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:[ZHWeakProxy proxyWithTarget:self] selector:@selector(update)];
//        displayLink.paused = NO;
//        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//        self.displayLink = displayLink;
    }
}
-(void)update{
    @weakify(self)
    if ([self.delegate respondsToSelector:@selector(playerPlaying:andDuration:)]) {
        @strongify(self)
        [self.delegate playerPlaying:self.player.currentTime andDuration:self.player.duration];
    }
}

-(void)pausePlay{
    [self.player pause];
    self.displayLink.paused = YES;
}

-(void)stopPlay{
    [self invalidateDisplayLink];
    [self.player stop];
    self.player = nil;
    self.delegate = nil;
}

-(void)invalidateDisplayLink{
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

-(BOOL)isPlaying{
    return self.player.isPlaying;
}
-(BOOL)isRecording{
    return self.recorder.isRecording;
}
-(float)curTime{
    return self.player.currentTime;
}
-(float)duration{
    return self.player.duration;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    self.recordTimer.fireDate = [NSDate distantFuture];
    if ([self.delegate respondsToSelector:@selector(recorderDidFinishRecording:successfully:)]) {
        [self.delegate recorderDidFinishRecording:recorder successfully:flag];
    }
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if ([self.delegate respondsToSelector:@selector(playerDidFinishPlaying:successfully:)]) {
        [self.delegate playerDidFinishPlaying:player successfully:flag];
    }
}

-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    return dicM;
}

- (AVAudioRecorder *)recorder {
    if (!_recorder) {
    
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        //启动会话
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        //1.设置r录音存放的位置
        NSURL *url = [NSURL fileURLWithPath:self.filePath];
        
        //2. 设置录音参数
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        //设置编码格式
        /**
         kAudioFormatLinearPCM: 无损压缩，内容非常大
         */
        [settings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        //设置采样率 必须保证和转码设置的相同
        [settings setValue:@(44100.0) forKey:AVSampleRateKey];
        //通道数
        [settings setValue:@(1) forKey:AVNumberOfChannelsKey];
        //音频质量,采样质量(音频质量越高，文件的大小也就越大)
        [settings setValue:@(AVAudioQualityMin) forKey:AVEncoderAudioQualityKey];

        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
        _recorder.meteringEnabled = YES;
        _recorder.delegate = self;
    }
    return _recorder;
}
@end
