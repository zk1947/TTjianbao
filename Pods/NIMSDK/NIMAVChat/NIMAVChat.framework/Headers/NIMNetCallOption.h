//
//  NIMNetCallOption.h
//  NIMLib
//
//  Created by Netease.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMSampleBuffer.h>
#import "NIMAVChatDefs.h"


@class NIMNetCallVideoCaptureParam;
@class NIMNetCallCustomVideoParam;
@class NIMNetCallServerRecord;
@class NIMNetCallSocksParam;

NS_ASSUME_NONNULL_BEGIN

/**
 *  语音数据处理Block
 *
 *  @param audioSamples  麦克风采集到的语音原始 PCM 采样数据，处理完的数据通过该字段回填
 *  @param samplesNumber 采样数据点数量
 *  @param sampleRate 采样率
 *
 *  @return 回填数据采样点数，不允许超过samplesNumber
 */

typedef NSUInteger(^NIMNetCallAudioSamplesHandler)(SInt16 *audioSamples, NSUInteger samplesNumber, Float64 sampleRate);

/**
 *  网络通话选项
 */
@interface NIMNetCallOption : NSObject

/**
 *  视频采集参数, 指定该参数以在加入网络通话时自动设置视频采集, 如果不指定该参数, 需要开发者调用 startVideoCapture: 手动开启视频采集。如果在加入网络通话前已经开启了视频采集, 该参数无效，该参数与 customVideoParam 不能同时设置
 */
@property (nullable, nonatomic, strong)   NIMNetCallVideoCaptureParam *videoCaptureParam;

/**
 *  自定义输入视频参数，该参数与 videoCaptureParam 不能同时设置
 */
@property (nullable, nonatomic, strong)   NIMNetCallCustomVideoParam *customVideoParam;

/**
 *  结束网络通话时自动停止视频采集, 默认为 YES。如果需要在离开会话以后摄像头保持开启，将该选项设置为 NO
 */
@property (nonatomic, assign) BOOL stopVideoCaptureOnLeave;

/**
 *  自动旋转远端画面, 默认为 YES
 *  @discussion 开启该选项, 以在远端设备旋转时在本端自动调整角度
 */
@property (nonatomic, assign)   BOOL          autoRotateRemoteVideo;


/**
 *  期望的视频编码器. 硬件编码设置仅在 iOS 8.0 及以上系统有效
 */
@property (nonatomic,assign)    NIMNetCallVideoCodec     preferredVideoEncoder;

/**
 *  期望的视频解码器. 硬件解码设置仅在 iOS 8.0 及以上系统有效
 */
@property (nonatomic,assign)    NIMNetCallVideoCodec     preferredVideoDecoder;

/**
 *  视频最大编码码率 (bps). 如果不指定, SDK 会根据视频质量自动选择
 */
@property (nonatomic, assign) NSUInteger videoMaxEncodeBitrate;

/**
 *  纯视频模式, 将不启动所有音频相关的模块, 默认为 NO
 */
@property (nonatomic, assign) BOOL pureVideo;

/**
 *  结束网络通话时自动停止AudioSession, 默认为 YES
 */
@property (nonatomic, assign) BOOL autoDeactivateAudioSession;

/**
 *   是否关闭SDK AudioSession配置 默认为 NO
 */
@property (nonatomic, assign) BOOL disEnableAudioSessionConfigration;

/**
 *  语音降噪, 默认为 YES
 */
@property (nonatomic, assign) BOOL audioDenoise;

/**
 *  自动增益, 默认为 YES
 */
@property (nonatomic, assign) NIMAVChatAGCType agcType;

/**
 *  人声检测, 默认为 YES
 */
@property (nonatomic, assign) BOOL voiceDetect;


/**
 *  回声抑制
 */
@property (nonatomic, assign) NIMAVChatAcousticEchoCanceler acousticEchoCanceler;

/**
 期望发送高清语音, 只有在通话的所有的参与者都设置为高清语音时才完全生效。3.3.0 之前的版本无法加入已经开启高清语音的多人会议。开启该选项后蓝牙耳机将不能使用
 */
@property (nonatomic, assign) BOOL preferHDAudio;

/**
 *  自动重置音频设备, 默认为NO 当检查音频采集数据不正常时，自动重置音频设备
 */
@property (nonatomic, assign) BOOL autoResetAudio;

/**
 *  近距离传感器类型，默认为 NIMNetCallProximityMonitoringTypeDefault
 */
@property (nonatomic, assign) NIMNetCallProximityMonitoringType proximityMonitoringType;

/**
 *  场景设置
 */
@property (nonatomic, assign) NIMAVChatScene scene;

/**
 *  视频调控策略 默认为 清晰优先
 */
@property (nonatomic, assign) NIMAVChatVideoAdaptiveStrategy videoAdaptiveStrategy;

/**
 *  本地采集的语音数据回调，供上层实现变音等功能
 */
@property (nullable, nonatomic, copy) NIMNetCallAudioSamplesHandler  audioHandler;

/**
 *  启用互动直播，只在加入会议时设置有效
 */
@property (nonatomic, assign) BOOL enableBypassStreaming;

/**
 *  互动直播推流地址。只在加入会议时设置有效，只有主播端可以指定，每个频道只能有一个主播。
 *
 * @discussion 指定推流地址的客户端被认为是互动直播的主播端
 */
@property (nullable,nonatomic, strong) NSString *bypassStreamingUrl;

/**
 *  互动直播音视频混屏模式，在 NIMNetCallBypassStreamingMixMode 里面选择合适的模式，只有主播设置有效
 */
@property (nonatomic, assign) NSUInteger bypassStreamingMixMode;

/**
 *  互动直播音视频混屏自定义布局配置，在 bypassStreamingMixMode 为 NIMNetCallBypassStreamingMixModeCustomVideoLayout 或 NIMNetCallBypassStreamingMixModeCustomAudioLayout 时必须设置
 */
@property (nonatomic, copy) NSString *bypassStreamingMixCustomLayoutConfig;

/**
 互动直播服务器录制，只有主播设置生效（互动直播服务器录制功能需要开通才能使用）
 */
@property (nonatomic, assign) BOOL bypassStreamingServerRecording;


/**
 *  扩展消息
 *  @discussion 仅在主叫发起点对点通话时设置有效，用于在主被叫之间传递额外信息，被叫收到呼叫时会携带该信息
 */
@property (nullable,nonatomic,copy)      NSString      *extendMessage;

/**
 *  始终持续呼叫
 *  @discussion 仅在主叫发起点对点通话时设置有效，用于设置被叫离线时是否仍然需要持续呼叫, 默认为 YES
 */
@property (nonatomic, assign)   BOOL          alwaysKeepCalling;

/**
 *  网络通话请求是否附带推送
 *  @discussion 仅在主叫发起点对点通话时设置有效，默认为YES。将这个字段设为NO，网络通话请求将不再有苹果推送通知。
 */
@property (nonatomic,assign)    BOOL          apnsInuse;

/**
 *  推送是否需要角标计数
 *  @discussion 仅在主叫发起点对点通话时设置有效，默认为YES。将这个字段设为NO，网络通话请求将不再对角标计数。
 */
@property (nonatomic,assign)    BOOL          apnsBadge;

/**
 *  推送是否需要带前缀(一般为昵称)
 *  @discussion 仅在主叫发起点对点通话时设置有效，默认为YES。将这个字段设为NO，推送消息将不带有前缀(xx:)。
 */
@property (nonatomic,assign)    BOOL          apnsWithPrefix;

/**
 *  apns推送文案，长度限制500字
 *  @discussion 仅在主叫发起点对点通话时设置有效，默认为nil，用户可以设置当前通知的推送文案
 */
@property (nullable,nonatomic,copy)      NSString      *apnsContent;

/**
 *  apns推送声音文件
 *  @discussion 仅在主叫发起点对点通话时设置有效，默认为nil，用户可以设置当前通知的推送声音。该设置会覆盖apnsPayload中的sound设置
 */
@property (nullable,nonatomic,copy)      NSString      *apnsSound;

/**
 *  apns推送Payload
 *  @discussion 仅在主叫发起点对点通话时设置有效，可以通过这个字段定义自定义通知的推送Payload,支持字段参考苹果技术文档,最多支持2K
 */
@property (nullable,nonatomic,copy)      NSDictionary   *apnsPayload;

/**
 *  服务端录制参数
 *  @discussion 服务端录制相关参数
 */
@property (nullable,nonatomic,strong)    NIMNetCallServerRecord *serverRecord;

/**
 * Sock5代理设置
 * @discussion 是否使用音视频代理socks5代理，建议使用接口方式设置代理，该参数已废弃，且不能与接口方式同时使用
 */
@property (nullable,nonatomic,strong)     NIMNetCallSocksParam       *socks5Info;

/**
 *  可选参数
 */
@property (nullable,nonatomic,strong)     NSDictionary *extInfo;

@end



NS_ASSUME_NONNULL_END
