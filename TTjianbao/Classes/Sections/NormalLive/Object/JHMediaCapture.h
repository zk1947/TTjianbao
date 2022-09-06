//
//  JHMediaCapture.h
//  TTjianbao
//
//  Created by jiang on 2019/9/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NMCLiveStreaming/NMCLiveStreaming.h>
@protocol  JHMediaCaptureDelegate <NSObject>

@optional
//已经停止直播
- (void)doDidStopLiveStream;
//已经开始直播
- (void)doDidStartLiveStream;
//直播中出错
- (void)doLiveStreamError:(NSError*_Nullable)error;
//变焦事件
- (void)doZoomScaleValueChanged:(CGFloat)value;

@end

typedef void(^LiveCompleteBlock)(NSError * _Nullable error);
typedef void(^LiveSnapBlock)(UIImage * _Nullable image);
NS_ASSUME_NONNULL_BEGIN

@interface JHMediaCapture : NSObject
@property (nonatomic, strong) LSMediaCapture *  __nullable capturer;
@property (nonatomic, weak) id<JHMediaCaptureDelegate>delegate;
@property (nonatomic, copy) NSString *pushUrl;
@property (nonatomic, assign, readonly) LSLiveStreamingParaCtxConfiguration *pParaCtx;
//开始预览
- (void)startVideoPreview:(NSString *)url
                container:(UIView *)view;

//停止预览
- (void)stopVideoPreview;

//开始直播
- (void)startLiveStream:(LiveCompleteBlock)complete;

//停止直播
- (void)stopLiveStream:(LiveCompleteBlock)complete;

//暂停视频
- (void)pauseVideo:(BOOL)isPause;

//暂停音频
- (void)pauseAudio:(BOOL)isPause;

//切换镜头
- (void)switchCamera;

//截屏
- (void)snapImage:(LiveSnapBlock)complete;

- (void)destory;
@end

NS_ASSUME_NONNULL_END
