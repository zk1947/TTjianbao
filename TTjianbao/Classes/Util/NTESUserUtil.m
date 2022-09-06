//
//  NTESUserUtil.m
//  NIM
//
//  Created by chris on 15/9/17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESUserUtil.h"
#import "NTESDataManager.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+NTES.h"
#import "NTESCustomKeyDefine.h"
#import "NSDictionary+NTESJson.h"
#import "NTESLiveManager.h"
#import "NTESBundleSetting.h"

@implementation NTESUserUtil

+ (NSString *)showName:(NSString *)userId
           withMessage:(NIMMessage *)message
{
    NTESDataUser * user = [[NTESDataManager sharedInstance] infoByUser:userId withMessage:message];
    return user.showName;
}

+ (NSString *)genderString:(NIMUserGender)gender{
    NSString *genderStr = @"";
    switch (gender) {
        case NIMUserGenderMale:
            genderStr = @"男";
            break;
        case NIMUserGenderFemale:
            genderStr = @"女";
            break;
        case NIMUserGenderUnknown:
            genderStr = @"未知";
        default:
            break;
    }
    return genderStr;
}

+ (void)requestMediaCapturerAccess:(NIMNetCallMediaType)type handler:(void (^)(NSError *))handler{
    [NTESUserUtil requestAuidoAccessWithHandler:^(NSError *error) {
        if (!error && type == NIMNetCallMediaTypeVideo)
        {
            [NTESUserUtil requestVideoAccessWithHandler:^(NSError *error) {
                handler(error);
            }];
        }
        else
        {
            handler(error);
        }
    }];
}

+ (void)requestVideoAccessWithHandler:(void (^)(NSError *))handler
{
    AVAuthorizationStatus videoAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
   
    if (AVAuthorizationStatusAuthorized == videoAuthorStatus) {
        handler(nil);
    }else{
        if (AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问摄像头，请设置", @"此应用需要访问摄像头，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:1 userInfo:userInfo];
            handler(error);
        }
        else
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(nil);
                    });
                }else{
                    NSString *errMsg = NSLocalizedString(@"不允许访问摄像头", @"不允许访问摄像头");
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                    NSError *error = [NSError errorWithDomain:@"访问权限" code:1 userInfo:userInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(error);
                    });
                }
            }];
        }
        
    }
}

+ (void)requestAuidoAccessWithHandler:(void (^)(NSError *))handler
{
    AVAuthorizationStatus audioAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (AVAuthorizationStatusAuthorized == audioAuthorStatus) {
        handler(nil);
    }else{
        if (AVAuthorizationStatusRestricted == audioAuthorStatus || AVAuthorizationStatusDenied == audioAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问麦克风，请设置", @"此应用需要访问麦克风，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            handler(error);
        }else{
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(nil);
                    });
                }else{
                    NSString *errMsg = NSLocalizedString(@"不允许访问麦克风", @"不允许访问麦克风");
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                    NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(error);
                    });
                }
            }];
        }
    }
}

+ (NSString *)meetingName:(NIMChatroom *)chatroom
{
    NSString *ext = chatroom.ext;
    id object = [ext jsonObject];
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSString *meetingName = [[ext jsonObject] jsonString:NTESCMMeetingName];
        return meetingName;
    }
    return nil;
}

+ (NIMNetCallOption *)fillNetCallOption:(NIMNetCallMeeting *)meeting{
    
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    option.scene = NIMAVChatSceneDefault;
    option.autoRotateRemoteVideo = NO;
    option.enableBypassStreaming = YES;
    option.autoResetAudio = YES;
//    option.remoteViewoShowType = NIMNetCallRemoteVideoShowTypeYuvData;
    
    option.bypassStreamingMixMode = NIMNetCallBypassStreamingMixModeCustomVideoLayout;
    
    //6600  5700
    NSString *string = @"{\"version\":0,\"set_host_as_main\":true,\"host_area\":{\"adaption\":1},\"special_show_mode\":true,\"n_host_area_number\":2,\"n_host_area_0\":{\"position_x\":5700,\"position_y\":1200,\"width_rate\":3333,\"height_rate\":2499,\"adaption\":1},\"n_host_area_1\":{\"position_x\":5700,\"position_y\":1200,\"width_rate\":3333,\"height_rate\":2499,\"adaption\":1}}";
    
//     NSString *string = @"{\"version\":0,\"set_host_as_main\":true,\"host_area\":{\"adaption\":1},\"special_show_mode\":true,\"n_host_area_number\":1,\"n_host_area_0\":{\"position_x\":5700,\"position_y\":1200,\"width_rate\":3333,\"height_rate\":2499,\"adaption\":1}}";
    
    option.bypassStreamingMixCustomLayoutConfig= string;
    option.bypassStreamingServerRecording = YES;
    
    // option.preferredVideoEncoder=NIMNetCallVideoCodecSoftware;
    //option.preferredVideoDecoder=NIMNetCallVideoCodecSoftware;
    
    //录屏模式 保证分辨率
    option.videoAdaptiveStrategy=NIMAVChatVideoAdaptiveStrategyScreenRecord;
    //用内建回声抑制
    option.acousticEchoCanceler=NIMAVChatAcousticEchoCancelerSDKBuiltin;
    
    option.preferHDAudio = YES;
    option.scene=NIMAVChatSceneHighQualityMusic;
    meeting.option = option;
    
    return option;
}

+ (NIMNetCallVideoCaptureParam *)videoCaptureParam
{
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc] init];
    param.preferredVideoQuality =NIMNetCallVideoQuality720pLevel;
    param.videoFrameRate = NIMNetCallVideoFrameRate15FPS;
    param.isPreviewMirror = NO;
    param.isCodeMirror = NO;
//    //不裁剪
//    param.videoCrop=NIMNetCallVideoCropNoCrop;
 //   param.videoProcessorParam = [[NIMNetCallVideoProcessorParam alloc] init];
    return param;
}

+ (NIMNetCallVideoQuality)defaultVideoQuality
{
    
    return [NTESLiveManager sharedInstance].liveQuality == NTESLiveQualityNormal? NIMNetCallVideoQualityDefault : NIMNetCallVideoQuality720pLevel;
}

@end

