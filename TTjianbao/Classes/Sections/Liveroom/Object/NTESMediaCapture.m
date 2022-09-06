//
//  NTESMediaCapture.m
//  TTjianbao
//
//  Created by chris on 16/2/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMediaCapture.h"
#import <AVFoundation/AVFoundation.h>
#import "NTESUserUtil.h"
#import "NSDictionary+NTESJson.h"
#import "NTESCustomKeyDefine.h"
#import "NTESBundleSetting.h"
#import "NTESLiveManager.h"

typedef void(^LiveStreamHandler)(NSError *error);

@interface NTESMediaCapture(){
    NIMNetCallMeeting *_currentMeeting;
}


@property (nonatomic,strong) CALayer *localVideoLayer;

@property (nonatomic,strong) NTESMediaCaptureRequest *request;

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) UIView *displayView;


@end

@implementation NTESMediaCapture

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cameraType = NIMNetCallCameraFront;
        __weak typeof(self) wself = self;

        _videoHandler = ^(CMSampleBufferRef sampleBuffer) {
            [wself processVideoSampleBuffer:sampleBuffer];
        };
    }
    return self;
}

- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t bufferWidth = 0;
    size_t bufferHeight = 0;
    
    if (CVPixelBufferIsPlanar(pixelBuffer)) {
        bufferHeight = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
        bufferWidth = CVPixelBufferGetWidthOfPlane(pixelBuffer, 0);
    } else {
        bufferWidth = CVPixelBufferGetWidth(pixelBuffer);
        bufferHeight = CVPixelBufferGetHeight(pixelBuffer);
    }
    
    if ([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight) {
        if (bufferWidth < bufferHeight) {
            NSLog(@"============== bufferWidth < bufferHeight");
            return;
        }
    }
    
    [[NIMAVChatSDK sharedSDK].netCallManager sendVideoSampleBuffer:sampleBuffer];
    
}
- (void)startPreview:(NIMNetCallMediaType)type container:(UIView *)container handler:(void(^)(NSError * error))handler
{
    self.containerView  = container;
    
    [NTESUserUtil requestMediaCapturerAccess:type handler:^(NSError *error) {
        handler(error);
        if (!error) {
            if(type == NIMNetCallMediaTypeVideo)
            {
                NIMNetCallVideoCaptureParam *param = [NTESUserUtil videoCaptureParam];
                param.startWithBackCamera = _cameraType == NIMNetCallCameraBack;
                //初始化 无滤镜
//                param.videoProcessorParam.filterType = NIMNetCallFilterTypeNormal;
//                param.videoHandler = weakSelf.videoHandler;
                [[NIMAVChatSDK sharedSDK].netCallManager startVideoCapture:param];
           
            }
        }
    }];
}

- (void)stopVideoCapture
{
    [[NIMAVChatSDK sharedSDK].netCallManager stopVideoCapture];
}

//语音直播掉这个接口
- (void)startVideoPreview:(NTESMediaCaptureRequest *)request
                  handler:(NIMNetCallMeetingHandler)handler
{
    
    self.request = request;
    
//    [self setupFilter];
    [NTESUserUtil requestMediaCapturerAccess:request.type handler:^(NSError *error) {
        //预定会议
        NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
        meeting.name = request.meetingName;
        meeting.type = request.type;
        meeting.actor = YES;
        
        NIMNetCallOption *option = [NTESUserUtil fillNetCallOption:meeting];
        option.bypassStreamingUrl = request.url;
        if (!error) {
            [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull currentMeeting, NSError * _Nonnull error) {
                if (error.code == NIMRemoteErrorCodeExist) {
                    DDLogInfo(@"meeting exists, %@",currentMeeting);
                    error = nil;
                }
                if (error) {
                    DDLogError(@"reserve meeting error: %@",error);
                }
                _currentMeeting = currentMeeting;
                if (handler) {
                    handler(meeting,error);
                }
            }];
        }
        else{
            if(handler) handler(meeting,error);
        }
    }];
}


- (void)startLiveStreamHandler:(NIMNetCallMeetingHandler)handler
{

    if (!self.isLiveStream) {
        self.isLiveStream = YES;
        __weak typeof(self) weakSelf = self;
      
        [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_currentMeeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        
            DDLogError(@"join meeting error: %@",error);
            if (!error)
            {
                [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:YES];
            }
            weakSelf.isLiveStream = !error;
            _currentMeeting = meeting;
            if (handler) {
                handler(meeting,error);
            }
        }];
    }else{
        DDLogError(@"stream is already start");
        if (handler) {
            NSError * error = [NSError errorWithDomain:@"startLiveHandler" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"stream is already start"}];
            handler(_currentMeeting,error);
        }
    }
}

- (void)stopLiveStream
{
    if (_currentMeeting) {
        [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:_currentMeeting];
        self.isLiveStream = NO;
    }
}

- (void)switchCamera
{
    if (self.cameraType == NIMNetCallCameraFront) {
        self.cameraType = NIMNetCallCameraBack;
    }else{
        self.cameraType = NIMNetCallCameraFront;
    }
    [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:self.cameraType];

}

-(void)switchContainerToView:(UIView *)captureView
{
    self.containerView = captureView;
    
    if ([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight) {
        self.displayView.hidden = YES;
    }
    self.displayView =[[NIMAVChatSDK sharedSDK].netCallManager localPreview];
    
    [self setUpDisplayView];
    
}

-(void)onCameraOrientationSwitchCompleted:(NIMVideoOrientation)orientation
{
    if (orientation == NIMVideoOrientationLandscapeRight) {
        self.displayView.hidden = NO;
    }
}

- (BOOL)isCameraBack
{
    return self.cameraType == NIMNetCallCameraBack;
}

//摄像头画面回调
- (void)onLocalDisplayviewReady:(UIView *)displayView
{
    self.displayView = displayView;
    [self setUpDisplayView];
}


- (void)setUpDisplayView
{
    
    CGRect frame = self.containerView.frame;

    CGRect displayViewframe = frame;
    self.displayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.displayView.frame = displayViewframe;

//    [self.containerView.superview addSubview:self.displayView];
    
    [self.containerView addSubview:self.displayView];

}

- (void)setIsLiveStream:(BOOL)isLiveStream
{
    _isLiveStream = isLiveStream;
}

- (void)setMeeting:(NIMNetCallMeeting*)meeting
{
    _currentMeeting = meeting;
}


@end


@implementation NTESMediaCaptureRequest

@end
