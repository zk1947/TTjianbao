//
//  NIMAVChatDefs.h
//  NIMAVChat
//
//  Created by Netease on 16/10/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#ifndef NIMAVChatDefs_h
#define NIMAVChatDefs_h

/**
 视频方向
 */
typedef NS_ENUM(NSInteger, NIMVideoOrientation) {
    /**
     *  默认方向
     */
    NIMVideoOrientationDefault             = 0,
    /**
     *  垂直方向, home 键朝下
     */
    NIMVideoOrientationPortrait            = 1,
    /**
     *  垂直方向, home 键朝上
     */
    NIMVideoOrientationPortraitUpsideDown  = 2,
    /**
     *  水平方向, home 键在右边
     */
    NIMVideoOrientationLandscapeRight      = 3,
    /**
     *  水平方向, home 键在左边
     */
    NIMVideoOrientationLandscapeLeft       = 4,
};

/**
 视频采集格式
 */
typedef NS_ENUM(NSInteger, NIMNetCallVideoCaptureFormat) {
    /**
     *  NV12 格式, full range, 对应 kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
     */
    NIMNetCallVideoCaptureFormat420f            = 0,
    /**
     *  NV12 格式, video range, 对应 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
     */
    NIMNetCallVideoCaptureFormat420v            = 1,
    /**
     *  ARGB 格式, 对应 kCVPixelFormatType_32BGRA
     */
    NIMNetCallVideoCaptureFormatBGRA            = 2,
};

/**
 *  网络通话视频质量
 */
typedef NS_ENUM(NSInteger, NIMNetCallVideoQuality) {
    /**
     *  默认视频质量. 一般是 480P 等级
     */
    NIMNetCallVideoQualityDefault    = 0,
    /**
     *  低视频质量
     */
    NIMNetCallVideoQualityLow        = 1,
    /**
     *  中等视频质量
     */
    NIMNetCallVideoQualityMedium     = 2,
    /**
     *  高视频质量
     */
    NIMNetCallVideoQualityHigh       = 3,
    /**
     *  480P 等级视频质量
     */
    NIMNetCallVideoQuality480pLevel  = 4,
    /**
     *  540P 等级视频质量
     */
    NIMNetCallVideoQuality540pLevel  = 5,
    /**
     *  720P 等级视频质量
     */
    NIMNetCallVideoQuality720pLevel  = 6,
};


/**
 *  画面裁剪
 */
typedef NS_ENUM(NSInteger, NIMNetCallVideoCrop) {
    /**
     *  16:9 裁剪
     */
    NIMNetCallVideoCrop16x9             = 0,
    /**
     *  4:3 裁剪
     */
    NIMNetCallVideoCrop4x3              = 1,
    /**
     *  1:1 裁剪
     */
    NIMNetCallVideoCrop1x1              = 2,
    /**
     *  不裁剪
     */
    NIMNetCallVideoCropNoCrop           = 3,
};


/**
 *  视频编码器
 */
typedef NS_ENUM(NSUInteger, NIMNetCallVideoCodec) {
    /**
     *  默认编解码器, SDK 自己选择合适的编码器
     */
    NIMNetCallVideoCodecDefault = 0,
    /**
     *  软件编解码
     */
    NIMNetCallVideoCodecSoftware = 1,
    /**
     *  硬件编解码. 注意: 硬件编解码只在 iOS 8.0 及以上系统适用
     */
    NIMNetCallVideoCodecHardware = 2,
};


/**
 *  视频帧率
 */
typedef NS_ENUM(NSUInteger, NIMNetCallVideoFrameRate) {
    /**
     *  SDK 支持的最小帧率
     */
    NIMNetCallVideoFrameRateMin = 0,
    /**
     *  5 FPS
     */
    NIMNetCallVideoFrameRate5FPS,
    /**
     *  10 FPS
     */
    NIMNetCallVideoFrameRate10FPS,
    /**
     *  15 FPS
     */
    NIMNetCallVideoFrameRate15FPS,
    /**
     *  20 FPS
     */
    NIMNetCallVideoFrameRate20FPS,
    /**
     *  25 FPS
     */
    NIMNetCallVideoFrameRate25FPS,
    /**
     *  缺省帧率. 15 FPS
     */
    NIMNetCallVideoFrameRateDefault,
    /**
     *  SDK 支持的最大帧率
     */
    NIMNetCallVideoFrameRateMax,
};

/**
 *  网络通话类型
 */
typedef NS_ENUM(NSInteger, NIMNetCallMediaType){
    /**
     *  音频通话
     */
    NIMNetCallMediaTypeAudio = 1,
    /**
     *  视频通话
     */
    NIMNetCallMediaTypeVideo = 2,
};

/**
 *  场景
 */
typedef NS_ENUM(NSUInteger, NIMAVChatScene) {
    /**
     *  默认场景
     */
    NIMAVChatSceneDefault,
    
    /**
     *  高清音乐场景. 只在 preferHDAudio 开启时生效
     */
    NIMAVChatSceneHighQualityMusic,    
};
/**
 * 近距离传感器类型
 */
typedef NS_ENUM(NSUInteger, NIMNetCallProximityMonitoringType) {
    /**
     *  默认在音频模式下打开，其他模式关闭
     */
    NIMNetCallProximityMonitoringTypeDefault = 0,
    
    /**
     *  手动关闭, 强制关闭
     */
    NIMNetCallProximityMonitoringTypeOff     = 1,
   
    /**
     *  手动打开，强制打开
     */
    NIMNetCallProximityMonitoringTypeOn      = 2
};


/**
 *  视频调控策略
 */
typedef NS_ENUM(NSUInteger, NIMAVChatVideoAdaptiveStrategy) {
    /**
     *  流畅优先
     */
    NIMAVChatVideoAdaptiveStrategySmooth = 1,
    /**
     *  清晰优先
     */
    NIMAVChatVideoAdaptiveStrategyQuality = 2,
    /**
     *  录屏模式
     */
    NIMAVChatVideoAdaptiveStrategyScreenRecord = 3,
};


/**
 *  回声抑制
 */
typedef NS_ENUM(NSUInteger, NIMAVChatAcousticEchoCanceler) {
    /**
     *  默认回声抑制
     */
    NIMAVChatAcousticEchoCancelerDefault = 0,
    /**
     *  SDK 内建回声抑制
     */
    NIMAVChatAcousticEchoCancelerSDKBuiltin,
    
    /**
     *  关闭回声抑制
     */
    NIMAVChatAcousticEchoCancelerClose,
};

/**
 *  自动增益
 */
typedef NS_ENUM(NSUInteger, NIMAVChatAGCType) {
    /**
     *  默认类型，以SDK适配为主
     */
    NIMAVChatAGCTypeDefault = 0,
    /**
     *  强制打开
     */
    NIMAVChatAGCTypeOn,
    
    /**
     *  强制关闭
     */
    NIMAVChatAGCTypeOff,
};

/**
 *  音视频混屏模式, 用于互动直播连麦时的音视频混屏参数设置
 */
typedef NS_ENUM(NSUInteger, NIMNetCallBypassStreamingMixMode) {
    /**
     *  右侧纵排浮窗(画中画)
     */
    NIMNetCallBypassStreamingMixModeFloatingRightVertical  = 0,
    /**
     *  左侧纵排浮窗(画中画)
     */
    NIMNetCallBypassStreamingMixModeFloatingLeftVertical   = 1,
    /**
     *  分格平铺, 显示完整画面, 不裁剪
     */
    NIMNetCallBypassStreamingMixModeLatticeAspectFit       = 2,
    /**
     *  分格平铺, 填满区域, 可能裁剪
     */
    NIMNetCallBypassStreamingMixModeLatticeAspectFill      = 3,
    /**
     *  自定义视频布局
     */
    NIMNetCallBypassStreamingMixModeCustomVideoLayout      = 4,
    /**
     *  自定义音频布局（混屏人数）
     */
    NIMNetCallBypassStreamingMixModeCustomAudioLayout      = 5,

};

/**
 *  NIM 网络通话 Error Domain
 */
extern NSString *const NIMNetCallErrorDomain;

/**
 *  网络通话错误码
 */
typedef NS_ENUM(NSInteger, NIMNetCallErrorCode) {
    /**
     *  网络通话没有启动
     */
    NIMNetCallErrorCodeNotStarted         = 20001,
    /**
     *  操作失败
     */
    NIMNetCallErrorCodeOperationFailed    = 20002,
    /**
     *  超过最大允许直播节点数量
     */
    NIMNetCallErrorCodeBypassSetExceedMax = 20202,
    
    /**
     *  必须由主播第一个开启直播
     */
    NIMNetCallErrorCodeBypassSetHostNotJoined = 20203,
    
    /**
     *  互动直播服务器错误
     */
    NIMNetCallErrorCodeBypassSetServerError = 20204,
    
    /**
     *  互动直播其他错误
     */
    NIMNetCallErrorCodeBypassSetOtherError = 20205,
    
    /**
     *  互动直播服务器没有响应
     */
    NIMNetCallErrorCodeBypassSetNoResponse = 20404,
    
    /**
     *  重连过程中无法进行相关操作，稍后再试
     */
    NIMNetCallErrorCodeBypassReconnecting = 20405,
    
    /**
     *  互动直播设置超时
     */
    NIMNetCallErrorCodeBypassSetTimeout   = 20408,
    
    /**
     *  与音视频服务器连接断开
     */
    NIMNetCallErrorCodeServerDisconnected = 20409,
    
    /**
     *  对方超时离开了房间
     */
    NIMNetCallErrorCodePeerLeftForTimeout = 20410,
    
    /**
     *  音频设备异常
     */
    NIMNetCallErrorCodeAudioDeviceError   = 20411,
    
    /**
     *  被踢出了音视频
     */
    NIMNetCallErrorCodeBeKicked           = 20412,

    /**
     *  房间被关闭
     */
    NIMNetCallErrorCodeChannelClosed      = 20413,

};


/**
 *  本地错误码 （AV） Doamin: NIMLocalErrorDomain
 */
typedef NS_ENUM(NSInteger, NIMAVLocalErrorCode) {
    /**
     *  有正在进行的网络通话
     */
    NIMAVLocalErrorCodeNetCallBusy                  = 10012,
    /**
     *  这一通网络通话已经被其他端处理过了
     */
    NIMAVLocalErrorCodeNetCallOtherHandled          = 10013,
    /**
     *  音频设备初始化失败
     */
    NIMAVLocalErrorCodeAudioDeviceInitFailed        = 10015,

    /**
     *  无法开始录制, 因为文件路径不合法
     */
    NIMAVLocalErrorCodeRecordInvalidFilePath       = 10017,
    /**
     *  开始录制失败
     */
    NIMAVLocalErrorCodeRecordStartFailed           = 10018,
    
    /**
     *  创建录制文件失败
     */
    NIMAVLocalErrorCodeRecordCreateFileFailed      = 10019,
    
    /**
     *  初始化录制音频失败
     */
    NIMAVLocalErrorCodeRecordInitAudioFailed       = 10020,
    
    /**
     *  初始化录制视频失败
     */
    NIMAVLocalErrorCodeRecordInitVideoFailed       = 10021,
    
    /**
     *  开始写录制文件失败
     */
    NIMAVLocalErrorCodeRecordStartWritingFailed    = 10022,
    
    /**
     *  结束录制失败
     */
    NIMAVLocalErrorCodeRecordStopFailed            = 10023,
    
    /**
     *  写录制文件失败
     */
    NIMAVLocalErrorCodeRecordWritingFileFailed     = 10024,
    
    /**
     *  空间不足，录制即将结束
     */
    NIMAVLocalErrorCodeRecordWillStopForLackSpace  = 10025,
    
    /**
     *  操作尚未完成
     */
    NIMAVLocalErrorCodeOperationIncomplete         = 10027,
    /**
     *  连接网络通话服务器超时
     */
    
    NIMAVLocalErrorCodeNetCallConnectTimeout       = 10029,
    /**
     *  非互动直播用户无法加入开启互动直播的房间，互动直播用户指主播和连麦者
     */
    NIMAVLocalErrorCodeNetCallCannotJoinBypassChannel = 10030,
    /**
     *  该频道超过了互动直播房间用户数限制: 每个房间只能有一个主播和三个连麦者
     */
    NIMAVLocalErrorCodeNetCallTooManyBypassStreamers = 10031,
    /**
     *  该房间超过了互动直播主播数限制: 每个房间只能有一个主播和三个连麦者
     */
    NIMAVLocalErrorCodeNetCallTooManyBypassStreamingHosts = 10032,
    /**
     *  主播尚未加入互动直播房间，连麦者无法在主播之前加入
     */
    NIMAVLocalErrorCodeNetCallHostNotJoined = 10033,
    /**
     *  主播设置定制布局参数错误
     */
    NIMAVLocalErrorCodeBypassStreamingCustomLayoutError  = 10034,
    /**
     *  被踢后当前通话无法再次加入
     */
    NIMAVLocalErrorCodeNetCallkickLimit      = 10035,

};

/**
 *  互动直播设置主画面错误码 （AV） Doamin:NIMAVRoomServerErrorDomain
 */
typedef NS_ENUM(NSInteger, NIMAVRoomServerErrorCode) {
    /**
     *  服务器错误
     */
    NIMAVRoomServerErrorServerError = 101,
    /**
     *  请求失败
     */
    NIMAVRoomServerErrorConnctionFailed = 102,
    /**
     *  发起者不是主播
     */
    NIMAVRoomServerErrorNotAnchor = 103,
    /**
     *  模式错误
     */
    NIMAVRoomServerErrorModeFault = 104,
    /**
     *  请求参数错误
     */
    NIMAVRoomServerErrorUserInvalidParam = 400,
    /**
     *  请求认证错误
     */
    NIMAVRoomServerErrorKeyInvalid = 401,
    /**
     *  房间不存在
     */
    NIMAVRoomServerErrorRoomNotExsit = 404,
    /**
     *  房间内不存在该用户
     */
    NIMAVRoomServerErrorUserNotJoined = 405,
    /**
     *  请求数据错误
     */
    NIMAVRoomServerErrorInvalidRequst = 417, 
    /**
     *  服务器内部错误
     */
    NIMAVRoomServerErrorServerUnknown = 500,
};

/**
 *  服务器错误码 （AV） Doamin: NIMRemoteErrorDomain
 *  @discussion 更多错误详见 [服务器端状态码](http://dev.netease.im/docs?doc=nim_status_code#服务器端状态码)
 */
typedef NS_ENUM(NSInteger, NIMAVRemoteErrorCode) {
    /**
     *  被叫离线(无可送达的被叫方)
     */
    NIMAVRemoteErrorCodeCalleeOffline       = 11001,
};


/**
 *  网络通话的网络状态
 */
typedef NS_ENUM(NSInteger, NIMNetCallNetStatus){
    
    /**
     *  网络极差,视频发送被关闭
     */
    NIMNetCallNetStatusVideoClosed = -1,
    /**
     *  网络好
     */
    NIMNetCallNetStatusGood = 0,
    /**
     *  网络一般
     */
    NIMNetCallNetStatusPoor = 1,
    /**
     *  网络差
     */
    NIMNetCallNetStatusBad  = 2,
};


/**
 *  用户离开多人实时会话的原因
 */
typedef NS_ENUM(NSUInteger, NIMRTSConferenceUserLeaveReason) {
    /**
     *  正常离开
     */
    NIMRTSConferenceUserLeaveReasonNormal,
    /**
     *  超时离开
     */
    NIMRTSConferenceUserLeaveReasonTimeout,
};


/**
 *  互动直播状态码
 */
typedef NS_ENUM(NSUInteger, NIMBypassStreamingStatus) {
    
    /**
     *  初始状态
     */
    NIMBypassStreamingStatusInitial          = 500,
    
    /**
     *  主播设置定制布局参数错误
     */
    NIMBypassStreamingStatusLayoutError      = 501,
    
    /**
     *  开始连接
     */
    NIMBypassStreamingStatusConnecting       = 502,
    
    /**
     *  连接成功
     */
    NIMBypassStreamingStatusConnected        = 503,
    
    /**
     *  连连接失败
     */
    NIMBypassStreamingStatusConnectFailed    = 504,
    
    /**
     *  推流中
     */
    NIMBypassStreamingStatusPushing          = 505,
    
    /**
     *  推流中
     */
    NIMBypassStreamingStatusPushFailed       = 506,
    
    /**
     *  互动直播服务器内部错误
     */
    NIMBypassStreamingStatusInternalError    = 507,
    
    /**
     *  人数超出限制
     */
    NIMBypassStreamingStatusUserCountLimit  = 508,
    
};

/**
 *  美颜滤镜类型
 */
typedef NS_ENUM(NSUInteger, NIMNetCallFilterType) {
    /**
     *  无滤镜
     */
    NIMNetCallFilterTypeNormal = 0,
    /**
     *  黑白
     */
    NIMNetCallFilterTypeSepia,
    /**
     *  自然
     */
    NIMNetCallFilterTypeZiran,
    /**
     *  粉嫩
     */
    NIMNetCallFilterTypeMeiyan1,
    /**
     *  怀旧
     */
    NIMNetCallFilterTypeMeiyan2,
};

/**
 *  水印位置
 */
typedef NS_ENUM(NSUInteger, NIMNetCallWaterMarkLocation) {
    /**
     *  由rect的origin定位置
     */
    NIMNetCallWaterMarkLocationRect = 0,
    /**
     *  左上
     */
    NIMNetCallWaterMarkLocationLeftUp,
    /**
     *  左下
     */
    NIMNetCallWaterMarkLocationLeftDown,
    /**
     *  右上
     */
    NIMNetCallWaterMarkLocationRightUp,
    /**
     *  右下
     */
    NIMNetCallWaterMarkLocationRightDown,
    /**
     *  中间
     */
    NIMNetCallWaterMarkLocationCenter
};

/**
 *  对焦模式
 */
typedef NS_ENUM(NSUInteger, NIMNetCallFocusMode) {
    /**
     *  手动对焦
     */
    NIMNetCallFocusModeManual = 1,
    /**
     *  自动对焦
     */
    NIMNetCallFocusModeAuto,
};


/**
 *  NIM 多人实时会话 Error Domain
 */
extern NSString *const NIMRTSConferenceErrorDomain;

/**
 *  多人实时会话错误码
 */
typedef NS_ENUM(NSInteger, NIMRTSConferenceErrorCode) {
    /**
     *  与服务器连接已断开
     */
    NIMRTSConferenceErrorCodeServerDisconnected  = 21001,
    
    /**
     *  TCP 连接关闭
     */
    NIMRTSConferenceErrorCodeTcpConnectionClosed = 21002,

};

/**
 *  音视频服务端录制模式
 */
typedef NS_ENUM(NSUInteger, NIMNetCallServerRecordMode) {
    /**
     *  参与混合录制也录制单人文件
     */
    NIMNetCallServerRecordModeDefault = 0,
    
    /**
     *  只参与混合录制
     */
    NIMNetCallServerRecordModeMix     = 1,
    
    /**
     *  只录制单人文件
     */
    NIMNetCallServerRecordModelSingle = 2
};

/**
 *  音视频代理类型
 */
typedef NS_ENUM(NSUInteger, NIMSocksType) {
    /**
     *  Socks5
     */
    NIMSocksTypeDefault     = 0,
    
    /**
     * 云信自定义类型
     */
    NIMSocksTypeNRTCProxy   = 1,
};

/**
 * 外部音频播放设备状态
 **/
typedef NS_ENUM(NSUInteger, NIMNetCallAudioExternalDeviceStatus) {
    /**
     * 外部音频播放设备拔出
     */
    NIMNetCallAudioExternalDeviceStatusUnplug = 0,
    
    /**
     * 外部音频播放设备插入
     */
    NIMNetCallAudioExternalDeviceStatusPlugin = 1,
};

/**
 * 外部音频设备类型
 **/
typedef NS_ENUM(NSUInteger, NIMNetCallAudioExternalDeviceType) {
    
    /**
     * 有线耳机
     */
    NIMNetCallAudioExternalDeviceTypeHeadphone = 0,
    
    /**
     * 无线耳机
     */
    NIMNetCallAudioExternalDeviceTypeWireLessHeadphone = 1,
    
    /**
     * 外接音箱
     */
    NIMNetCallAudioExternalDeviceTypeVoiceBox = 2,
};

typedef NS_ENUM(NSInteger, NIMNetCallSubscribeError)
{
    /**
     * 成功
     */
    NIMNetCallSubscribeErrorNO           = 0,
    /**
     * 失败
     */
    NIMNetCallSubscribeErrorFailed       = -1,
    /**
     * 视频mute,不能进行发布or取消发布视频操作
     */
    NIMNetCallSubscribeErrorVideoMute    = -100,
    /**
     * 观众模式,不能进行发布or取消发布视频操作
     */
    NIMNetCallSubscribeErrorAudience     = -200,
    /**
     * 音频模式,不能进行发布or取消发布视频操作
     */
    NIMNetCallSubscribeErrorAudioMode    = -300,
    /**
     * 重复操作/正在进行中
     */
    NIMNetCallSubscribeErrorOperationing = -400,
    /**
     * 模式互斥，自动模式下不能进行手动操作
     */
    NIMNetCallSubscribeErrorPatternMutex = -500,
    /**
     * 非会议模式不能进行任何操作
     */
    NIMNetCallSubscribeErrorNotMeeting   = -600,
    /**
     * 视频类型错误，需要取消之前的订阅
     */
    NIMNetCallSubscribeErrorVideoType    = -700, 
};


/**
 多流模式
 */
typedef NS_ENUM(NSInteger, NIMNetCallSimulcastModel) {
    /**
     * 单流
     */
    NIMNetCallSimulcastModelSingleStream = 0,
    /**
     * 双流
     */
    NIMNetCallSimulcastModelDualStream = 1,
};

/**
 流类型
 */
typedef NS_ENUM(NSInteger, NIMNetCallSimulcastProfile) {
    /**
     * 大流
     */
    NIMNetCallSimulcastProfileHigh = 0,
    /**
     * 小流
     */
    NIMNetCallSimulcastProfileLow = 2,
};

/**
 * 渲染视图的模式
 **/
typedef NS_ENUM(NSInteger, NIMNetCallRenderFillMode) {
    /**
     * 拉伸来填补完整视图
     */
    NIMNetCallRenderFillModeStretch = 0,
    /**
     * 保持源图像的宽高比,添加指定的背景颜色
     */
    NIMNetCallRenderFillModeAspectRatio = 1,
    /**
     * 保持源图像的宽高比,以它的中心放大来填充视图
     */
    NIMNetCallRenderFillModeAspectRatioAndFill = 2,
};

#endif /* NIMAVChatDefs_h */
