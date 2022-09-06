//
//  JHAudioPlayerManager.m
//  TTjianbao
//
//  Created by lihui on 2021/5/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAudioPlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface JHAudioPlayerManager ()<AVAudioPlayerDelegate>
///播放器对象
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioSession *session;
///音频存放位置的路径
@property (nonatomic, copy) NSString *recordFilePath;

///兼容播放网络音频的相关类
@property (nonatomic, strong) AVPlayer *avPlayer;


@end

static JHAudioPlayerManager *shareManager = nil;

@implementation JHAudioPlayerManager
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self destory];
}
///实例化单例
+ (JHAudioPlayerManager *)shareManger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[JHAudioPlayerManager alloc] init];
    });
    return shareManager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupManager];
    }
    return self;
}
- (void)playDidFinish {
    if (self.didFinished) {
        self.didFinished();
        self.isFinished = true;
    }
}
- (void)playDidError {
    if (self.hasError) {
        self.hasError();
        self.isFinished = false;
    }
}
- (void)setupManager {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidError) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
}
///播放音频
/// @param filePath 本地音频路径
/// 该方法只适合播放本地音频 若想同时兼容 网络音频 请用下面的方法
- (void)createAudioWithAudioFilePath:(NSString *)filePath {
    if (filePath == nil) {
        return;
    }
    
    //获取本地播放文件路径
   
    if (_audioPlayer == nil) {
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:filePath];
        
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        //把播放文件加载到缓存中（注意：即使在播放之前音频文件没有加载到缓冲区程序也会隐式调用此方法。）
        [audioPlayer prepareToPlay];
        audioPlayer.delegate = self;
        _audioPlayer = audioPlayer;
        
        //设置代理，监听播放状态(例如:播放完成)

        // 设置音频会话模式，后台播放
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];

        if (error) {
            NSAssert(YES, @"音乐初始化过程报错");
        }
    }
}

/// 播放音频
/// @param url 音频资源的地址 兼容本地音频和网络音频
- (void)createAudioWithAudioUrl:(NSURL *)url {
    if (url == nil) {
        return;
    }
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:url];
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    self.avPlayer.volume = 0.2f;
    
    // 设置音频会话模式，后台播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    self.isFinished = false;
    
}
- (BOOL)isPlaying {
    if (self.avPlayer) {
        return self.avPlayer.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    }

    return false;
}
- (BOOL)isPause {
    if (self.avPlayer && self.isFinished == false) {
        return self.avPlayer.timeControlStatus == AVPlayerTimeControlStatusPaused;
    }
    
    return false;
}
- (void)play {
    if (self.audioPlayer && !self.audioPlayer.isPlaying) {
        ///当前没有在播放 此时开始播放音频
        [self.audioPlayer play];
    }
    if (self.avPlayer) {
        [self.avPlayer play];
    }
}

///暂停播放音频
- (void)pause {
    if (self.audioPlayer.isPlaying) {
        ///当前正在播放音频 需要暂停
        [self.audioPlayer pause];
    }
    if (self.avPlayer) {
        ///当前正在播放音频 需要暂停
        [self.avPlayer pause];
    }
}

///销毁播放器
- (void)destory {
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    if (self.avPlayer) {
        self.avPlayer = nil;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.didFinished) {
        self.didFinished();
        self.isFinished = true;
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    if (self.hasError) {
        self.hasError();
        self.isFinished = false;
    }
}



@end
