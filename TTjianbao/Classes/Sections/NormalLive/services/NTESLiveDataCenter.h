//
//  Created by jiang on 2019/9/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NMCLiveStreaming/NMCLiveStreaming.h>
@interface NTESLiveDataCenter : NSObject

+ (instancetype)shareInstance;

//直播伴音文件
@property (nonatomic, strong) NSMutableArray *audios;

//推流地址
@property (nonatomic, copy) NSString *pushUrl;

//推流参数
@property (nonatomic, strong) LSLiveStreamingParaCtxConfiguration *pParaCtx;

//是否只推流纯视频。
//因为产品要求推纯视频流的时候，要使用AV模式，方便随时开关，因此有了这个奇葩参数。
@property (nonatomic, assign) BOOL isPushOnlyVideo;

//拉流地址
@property (nonatomic, copy) NSString *pullUrl;

@property (nonatomic, copy) NSString *rtmpPullUrl;

@property (nonatomic, copy) NSString *hlsPullUrl;

@property (nonatomic, copy) NSString *httpPullUrl;

//推流配置信息
//- (NSString *)liveStreamConfigInfo;

@end
