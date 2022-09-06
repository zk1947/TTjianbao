//
//  NTESBundleSetting.m
//  NIM
//
//  Created by chris on 15/7/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESBundleSetting.h"

@implementation NTESBundleSetting

+ (instancetype)sharedConfig
{
    static NTESBundleSetting *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESBundleSetting alloc] init];
    });
    return instance;
}

- (NELPBufferStrategy)preferredBufferStrategy
{
    NELPBufferStrategy strategy = (NELPBufferStrategy)[[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled_preferred_buffer_strategy"] integerValue];
    return strategy;
}


- (BOOL)preferHDAudio
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_prefer_hd_audio"];
    
    if (setting) {
        return [setting boolValue];
    }
    else {
        return NO;
    }
}

- (NIMAVChatScene)scene
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"avchat_scene"];
    
    if (setting) {
        return [setting unsignedIntegerValue];
    }
    else {
        return NIMAVChatSceneDefault;
    }

}

- (BOOL)bypassStreamingServerRecord
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"bypass_server_record"];
    
    if (setting) {
        return [setting boolValue];
    }
    else {
        return NO;
    }
}

- (NIMNetCallVideoCaptureFormat)videoCaptureFormat
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"video_capture_format"];
    
    return setting ? [setting integerValue] : NIMNetCallVideoCaptureFormat420f;
}

- (NSUInteger)bypassVideoMixMode
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"bypass_mix_mode"];
    
    if (setting) {
        return [setting unsignedIntegerValue];
    }
    else {
        return NIMNetCallBypassStreamingMixModeCustomVideoLayout;
    }
}

- (NSString *)bypassVideoMixCustomLayoutConfig
{

    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"bypass_mix_layout_config"];
    
    return setting;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"enabled_preferred_buffer_strategy %zd\nvideochat_prefer_hd_audio %zd\navchat_scene %zd\nbypass_server_record %zd\nbypass_mix_mode %zd\n",
            [self preferredBufferStrategy],[self preferHDAudio],[self scene],[self bypassStreamingServerRecord],[self bypassVideoMixMode]];
}

@end
