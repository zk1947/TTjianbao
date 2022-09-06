//  Created by jiang on 2019/9/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NTESLiveDataCenter.h"

@implementation NTESLiveDataCenter

+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESLiveDataCenter alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self defaultLiveParaCtx];
    }
    return self;
}

- (void)defaultLiveParaCtx
{
    if (!_pParaCtx) {
        _pParaCtx = [LSLiveStreamingParaCtxConfiguration defaultLiveStreamingConfiguration];
        LSVideoParaCtxConfiguration * sLSVideoParaCtx=[LSVideoParaCtxConfiguration defaultVideoConfiguration:LSVideoParamQuality_Super_High];
          sLSVideoParaCtx.isVideoFilterOn=NO;
          sLSVideoParaCtx.filterType=LS_GPUIMAGE_NORMAL;
         sLSVideoParaCtx.cameraPosition=LS_CAMERA_POSITION_BACK;
        //   _pParaCtx.eHaraWareEncType=LS_HRD_NO;
      //   _pParaCtx.eOutFormatType               = LS_OUT_FMT_RTMP;
        sLSVideoParaCtx.videoStreamingQuality      = LS_VIDEO_QUALITY_SUPER_HIGH; //分辨率
        sLSVideoParaCtx.bitrate                    = 1500000; //码率
        sLSVideoParaCtx.fps                        = 15;     //帧率
    
        sLSVideoParaCtx.isCameraZoomPinchGestureOn = YES; //打开摄像头zoom功能
        sLSVideoParaCtx.videoRenderMode            = LS_VIDEO_RENDER_MODE_SCALE_16x9;//设置为16:9模式 //对端接收的图像将以16:9比例绘制
        sLSVideoParaCtx.isQosOn = NO;  // 开启码率自适应调整功能
        _pParaCtx.sLSVideoParaCtx=sLSVideoParaCtx;
        _pParaCtx.uploadLog = YES;
        LSAudioParaCtxConfiguration* sLSAudioParaCtx=[LSAudioParaCtxConfiguration defaultAudioConfiguration];
        //音频相关参数
//        _pParaCtx.sLSAudioParaCtx.bitrate       = 64000;
//        _pParaCtx.sLSAudioParaCtx.frameSize     = 2048;
//        _pParaCtx.sLSAudioParaCtx.numOfChannels = 1
//        _pParaCtx.sLSAudioParaCtx.samplerate    = 44100;
          _pParaCtx.sLSAudioParaCtx=sLSAudioParaCtx;
    }
}

@end
