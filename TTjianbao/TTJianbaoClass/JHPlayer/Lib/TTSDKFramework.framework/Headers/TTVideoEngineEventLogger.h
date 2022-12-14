//
//  TTVideoEngineEventLogger.h
//  Pods
//
//  Created by guikunzhi on 16/12/26.
//
//

#import <Foundation/Foundation.h>
#import "TTVideoEngineUtil.h"
#import "TTVideoEnginePlayerDefine.h"
#import "TTVideoEngine.h"

static NSInteger const LOGGER_VALUE_CODEC_TYPE  = 0;
static NSInteger const LOGGER_VALUE_RENDER_TYPE = 1;
static NSInteger const LOGGER_VALUE_PLAYER_INFO = 2;
static NSInteger const LOGGER_VALUE_API_STRING  = 3;
static NSInteger const LOGGER_VALUE_NET_CLIENT  = 4;
static NSInteger const LOGGER_VALUE_INTERNAL_IP                    = 5;
static NSInteger const LOGGER_VALUE_DNS_TIME                       = 7;
static NSInteger const LOGGER_VALUE_TRANS_CONNECT_TIME             = 10;
static NSInteger const LOGGER_VALUE_TRANS_FIRST_PACKET_TIME        = 11;
static NSInteger const LOGGER_VALUE_RECEIVE_FIRST_VIDEO_FRAME_TIME = 12;
static NSInteger const LOGGER_VALUE_RECEIVE_FIRST_AUDIO_FRAME_TIME = 13;
static NSInteger const LOGGER_VALUE_DECODE_FIRST_VIDEO_FRAME_TIME  = 14;
static NSInteger const LOGGER_VALUE_DECODE_FIRST_AUDIO_FRAME_TIME  = 15;
static NSInteger const LOGGER_VALUE_AUDIO_DEVICE_OPEN_TIME         = 16;
static NSInteger const LOGGER_VALUE_VIDEO_DEVICE_OPEN_TIME         = 17;
static NSInteger const LOGGER_VALUE_AUDIO_DEVICE_OPENED_TIME       = 18;
static NSInteger const LOGGER_VALUE_VIDEO_DEVICE_OPENED_TIME       = 19;
static NSInteger const LOGGER_VALUE_P2P_LOAD_INFO                  = 20;
static NSInteger const LOGGER_VALUE_PLAYBACK_STATE                 = 21;
static NSInteger const LOGGER_VALUE_LOAD_STATE                     = 22;
static NSInteger const LOGGER_VALUE_ENGINE_STATE                   = 23;
static NSInteger const LOGGER_VALUE_VIDEO_CODEC_NAME               = 24;
static NSInteger const LOGGER_VALUE_AUDIO_CODEC_NAME               = 25;
static NSInteger const LOGGER_VALUE_DURATION                       = 26;

static const NSString *kTTVideoEngineVideoDurationKey = @"duration";
static const NSString *kTTVideoEngineVideoSizeKey = @"size";
static const NSString *kTTVideoEngineVideoCodecKey = @"codec";
static const NSString *kTTVideoEngineVideoTypeKey = @"vtype";

typedef NS_ENUM(NSInteger,TTVideoSettingLogType){
    TTVideoSettingLogTypeBufferTimeOut,
};

@class TTVideoEngineEventLogger;

@protocol TTVideoEngineEventLoggerProtocol <NSObject>

@required

- (NSDictionary *)versionInfoForEventLogger:(TTVideoEngineEventLogger *)eventLogger;
- (NSDictionary *)bytesInfoForEventLogger:(TTVideoEngineEventLogger *)eventLogger;
- (int64_t)getLogValueLong:(NSInteger)key;
- (NSString *)getLogValueStr:(NSInteger)key;
- (NSInteger)getLogValueInt:(NSInteger)key;

@end

@interface TTVideoEngineEventLogger : NSObject

@property (nonatomic, weak) id<TTVideoEngineEventLoggerProtocol> delegate;
@property (nonatomic, assign) BOOL reportLogEnable; /// Report switch.
@property (nonatomic,   copy) NSString *userUniqueId;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, copy) NSString *vid;
@property (nonatomic, copy) NSArray *vu;
@property (nonatomic, assign) NSInteger loopCount;
@property (nonatomic, assign) NSTimeInterval accumulatedStalledTime;
@property (nonatomic, assign) NSInteger seekCount;

- (void)setURLArray:(NSArray *)urlArray;

- (void)setSourceType:(NSInteger)sourceType vid:(NSString *)vid;

- (void)beginToPlayVideo:(NSString *)vid;

- (void)setTag:(NSString *)tag;

- (void)setSubTag:(NSString *)subtag;

- (void)needRetryToFetchVideoURL:(NSError *)error apiVersion:(NSInteger)apiVersion;

- (void)playerError:(NSError *)error url:(NSString *)url;

- (void)mainURLCDNError:(NSError *)error url:(NSString *)url;

- (void)mainURLLocalDNSError:(NSError *)error;

- (void)mainURLHTTPDNSError:(NSError *)error;

- (void)firstDNSFailed:(NSError *)error;

- (void)fetchedVideoURL:(NSDictionary *)videoInfo error:(NSError *)error apiVersion:(NSInteger)apiVersion;

- (void)validateVideoMetaDataError:(NSError *)error;

- (void)showedOneFrame;

- (void)logPlayerSetURLToFirstFrameTimeWithDNSFinish:(int64_t)DNSTs
                                          TCPConnect:(int64_t)connectTs
                                             TCPRecv:(int64_t)recevTs
                                            vedeoPkt:(int64_t)vPktTs
                                            audioPkt:(int64_t)aPktTs
                                          videoFrame:(int64_t)vFrameTs
                                          audioFrame:(int64_t)aFrameTs;

- (void)setDNSParseTime:(int64_t)dnsTime;

- (void)setCurrentDefinition:(NSString *)toDefinition lastDefinition:(NSString *)lastDefinition;

- (void)switchToDefinition:(NSString *)toDefinition fromDefinition:(NSString *)fromDefinition;

- (void)seekToTime:(NSTimeInterval)afterSeekTime cachedDuration:(NSTimeInterval)cachedDuration switchingResolution:(BOOL)isSwitchingResolution;

- (void)movieStalled;

- (void)movieStalledAfterFirstScreen:(TTVideoEngineStallReason)reason;

- (void)stallEnd;

/// ????????????
- (void)movieBufferDidReachEnd;

- (void)moviePlayRetryWithError:(NSError *)error strategy:(TTVideoEngineRetryStrategy)strategy apiver:(TTVideoEnginePlayAPIVersion)apiver;

- (void)movieFinishError:(NSError *)error currentPlaybackTime:(NSTimeInterval)currentPlaybackTime apiver:(TTVideoEnginePlayAPIVersion)apiver;

- (void)playbackFinish:(TTVideoEngineFinishReason)reason;

- (void)videoStatusException:(NSInteger)status;

- (void)userCancelled;

- (void)setPreloadInfo:(NSDictionary *)preload;

- (void)setPlayItemInfo:(NSDictionary *)playItem;

- (void)setFeedInfo:(NSDictionary *)feed;

- (void)setInitalURL:(NSString *)url;

- (void)useHardware:(BOOL)enable;

- (void)loopAgain;
/// ????????????
- (void)watchFinish;
/// ????????????????????????
- (void)enableCacheFile;
/// ??????????????????host
- (void)setInitialHost:(NSString* )hostString;
/// ?????????????????????ip
- (void)setInitialIp:(NSString* )ipString;
/// ??????????????????????????????
- (void)setInitialResolution:(NSString* )resolutionString;
/// prepare????????????????????????????????????
- (void)setPrepareStartTime:(long long)prepareStartTime;
/// prepared????????????????????????????????????
- (void)setPrepareEndTime:(long long)prepareEndTime;
/// ????????????
- (void)setRenderType:(NSInteger )renderType;
/// ????????????????????????
- (void)enablePreload:(NSInteger) preload;
/// video_preload_size, ?????????????????????(?????????)
- (void)setVideoPreloadSize:(long long) preloadSize;
/// wifi ??????
- (void)setWifiName:(NSString* )wifiName;
/// ??????????????????????????????ms
- (void)logCurPos:(long)curPos;
/// ????????????
- (void)playerPause;
/// ????????????
- (void)playerPlay;
/// ?????????????????????????????????seek
- (void)beginLoadDataWhenBufferEmpty;
/// ?????????????????????????????????seek
- (void)endLoadDataWhenBufferEmpty;
/// ???????????????????????????
- (void)updateTryErrorCount:(NSInteger )count;
/// ??????????????????
- (void)updateCalculateErrorCount:(NSInteger )count;
/// ??????????????????????????????
- (void)updateCustomPlayerParms:(NSDictionary* )param;
/// ??????????????????0????????????FFMPEG????????? 1??????????????????????????????
- (void)setDecoderType:(NSInteger) decoderType;
/// 0???????????????1??????????????????
- (void)setPlayerSourceType:(NSInteger) sourceType;
/// ????????????
- (void)setVideoOutFPS:(NSInteger) fps;
// Socket????????????
- (void)setReuseSocket:(NSInteger)reuseSocket;
// ??????????????????
- (void)setDisableAccurateStart:(NSInteger)disableAccurateStart;
/// ??????????????????
- (void)logWatchDuration:(NSInteger)watchDuration;
/// ????????????
- (void)playbackState:(TTVideoEnginePlaybackState)playbackState;
/// ????????????
- (void)loadState:(TTVideoEngineLoadState)loadState;
/// engine??????
- (void)engineState:(TTVideoEngineState)engineState;
//????????????size
- (void)videoChangeSizeWidth:(NSInteger)width height:(NSInteger)height;
/// ?????????????????????
- (void)proxyUrl:(NSString *)proxyUrl;
// drm??????
- (void)setDrmType:(NSInteger)drmType;
// play????????????url
- (void)setApiString:(NSString *)apiString;
// ??????client??????
- (void)setNetClient:(NSString *)netClient;
// ??????apiversion???auth
- (void)setPlayAPIVersion:(TTVideoEnginePlayAPIVersion)apiVersion auth:(NSString *)auth;
// ???????????????????????????????????????
- (void)setStartTime:(NSInteger)startTime;
- (void)closeVideo;
/// ???????????????id
- (void)logCodecNameId:(NSInteger)audioNameId video:(NSInteger)videoNameId;
/// ???????????????????????????????????????
- (void)updateMediaDuration:(NSTimeInterval)duration;
/// ????????????
- (void)logBitrate:(NSInteger)bitrate;
/// ???????????????
- (void)logCodecName:(NSString *)audioName video:(NSString *)videoName;

- (void)setSettingLogType:(TTVideoSettingLogType)logType value:(int)value;

@end
