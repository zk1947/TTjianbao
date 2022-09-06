//
//  NTESBundleSetting.h
//  NIM
//
//  Created by chris on 15/7/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMAVChat/NIMAVChat.h>
#import <NELivePlayerFramework/NELivePlayerFramework.h>

//部分API提供了额外的选项，如删除消息会有是否删除会话的选项,为了测试方便提供配置参数
//上层开发只需要按照策划需求选择一种适合自己项目的选项即可，这个设置只是为了方便测试不同的case下API的正确性

@interface NTESBundleSetting : NSObject

+ (instancetype)sharedConfig;

- (NELPBufferStrategy)preferredBufferStrategy;

- (BOOL)preferHDAudio;                              //期望高清语音

- (NIMAVChatScene)scene;                            //音视频场景设置

- (BOOL)bypassStreamingServerRecord;                //互动直播服务器录制

- (NIMNetCallVideoCaptureFormat)videoCaptureFormat; //视频采集格式

- (NSUInteger)bypassVideoMixMode;                   //合流混屏模式

- (NSString *)bypassVideoMixCustomLayoutConfig;     //合流混屏自定义布局配置

@end
