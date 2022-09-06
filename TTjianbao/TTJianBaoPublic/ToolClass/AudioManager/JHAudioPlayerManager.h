//
//  JHAudioPlayerManager.h
//  TTjianbao
//
//  Created by lihui on 2021/5/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
/// 音频播放器工具类

#import <Foundation/Foundation.h>
typedef void(^AudioPlayDidFinished) (void);
NS_ASSUME_NONNULL_BEGIN

/**
     **************** -- 使用方法 -- ****************
    ///注意：退出页面 或者 退出app时需要执行destory方法 否则音频在后台会继续播放!!!!!!
 
     播放本地音频的两种方式：
     1. createAudioWithAudioFilePath
     [[JHAudioPlayerManager shareManger] createAudioWithAudioFilePath:@"本地音频文件名"];
     如：
     [[JHAudioPlayerManager shareManger] createAudioWithAudioFilePath:@"bensound-creativeminds.mp3"];

     2. createAudioWithAudioUrl
     NSURL *url = [[NSBundle mainBundle] URLForResource:@"bensound-creativeminds.mp3" withExtension:nil];
     [[JHAudioPlayerManager shareManger] createAudioWithAudioUrl:url];
 
     播放网络音频：
    [[JHAudioPlayerManager shareManger] createAudioWithAudioUrl:[NSURL urlWithString:@"网络音频资源链接"]]];
    如：
    [[JHAudioPlayerManager shareManger] createAudioWithAudioUrl:[NSURL urlWithString:@"http://music.com"]]];
 
    
     播放：
     [[JHAudioPlayerManager shareManger] play];
        
     暂停：
     [[JHAudioPlayerManager shareManger] pause];
 
     关闭播放音频：
     [[JHAudioPlayerManager shareManger] destory];
 */

@interface JHAudioPlayerManager : NSObject

@property (nonatomic, copy) AudioPlayDidFinished didFinished;

@property (nonatomic, copy) AudioPlayDidFinished hasError;

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isFinished;
///实例化单例
+ (JHAudioPlayerManager *)shareManger;

///播放音频
/// @param filePath 本地音频路径
/// 该方法只适合播放本地音频 若想同时兼容 网络音频 请用下面的方法
- (void)createAudioWithAudioFilePath:(NSString *)filePath;

/// 播放音频
/// @param url 音频资源的地址 兼容本地音频和网络音频
- (void)createAudioWithAudioUrl:(NSURL *)url;

///播放音频
- (void)play;

///暂停播放音频
- (void)pause;

///销毁播放器
- (void)destory;

@end

NS_ASSUME_NONNULL_END
