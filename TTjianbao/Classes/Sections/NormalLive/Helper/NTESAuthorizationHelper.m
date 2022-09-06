//
//  NTESAuthorizationHelper.m
//  LiveStream_IM_Demo
//
//  Created by Netease on 17/3/20.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESAuthorizationHelper.h"
#import <Photos/Photos.h>

@implementation NTESAuthorizationHelper

+ (void)requestAblumAuthorityWithCompletionHandler:(void (^)(NSError *))handler
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (PHAuthorizationStatusAuthorized == status)
    {
        if (handler) {
            handler(nil);
        }
    }
    else
    {
        if (PHAuthorizationStatusRestricted == status || PHAuthorizationStatusDenied == status)
        {
            NSString *errMsg = @"此应用需要访问相册，请设置";
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            if (handler) {
                handler(error);
            }
        }
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized)
            {
                if (handler) {
                    handler(nil);
                }
            }
            else
            {
                NSString *errMsg = @"此应用需要访问相册，请设置";
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                if (handler) {
                    handler(error);
                }
            }
        }];
    }
}

+ (BOOL)requestMediaCapturerAccessWithHandler:(void (^)(NSError *))handler {
    AVAuthorizationStatus videoAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (AVAuthorizationStatusAuthorized == videoAuthorStatus && AVAuthorizationStatusAuthorized == audioAuthorStatus) {
        if (handler) {
            handler(nil);
        }
    }else{
        //AVAuthorizationStatusRestricted未授权，家长限制    //AVAuthorizationStatusDenied未授权
        if (AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问摄像头，请设置", @"此应用需要访问摄像头，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            if (handler) {
                handler(error);
            }
            
            return NO;
        }
        
        if (AVAuthorizationStatusRestricted == audioAuthorStatus || AVAuthorizationStatusDenied == audioAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问麦克风，请设置", @"此应用需要访问麦克风，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            if (handler) {
                handler(error);
            }
            
            return NO;
        }
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                        if (handler) {
                            handler(nil);
                        }
                    }else{
                        NSString *errMsg = NSLocalizedString(@"不允许访问麦克风", @"不允许访问麦克风");
                        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                        NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                        if (handler) {
                            handler(error);
                        }
                    }
                }];
            }else{
                NSString *errMsg = NSLocalizedString(@"不允许访问摄像头", @"不允许访问摄像头");
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                if (handler) {
                    handler(error);
                }
            }
        }];
        
    }
    return YES;
}

@end
