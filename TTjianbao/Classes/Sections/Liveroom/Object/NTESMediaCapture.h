//
//  NTESMediaCapture.h
//  TTjianbao
//
//  Created by chris on 16/2/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMAVChat/NIMAVChat.h>

@class NTESMediaCaptureRequest;

@interface NTESMediaCapture : NSObject

@property (nonatomic,assign) NIMNetCallCamera cameraType;

@property (nonatomic,assign) BOOL isLiveStream;

@property (nonatomic,copy) NIMNetCallVideoSampleBufferHandler videoHandler;

- (void)startVideoPreview:(NTESMediaCaptureRequest *)request
                  handler:(NIMNetCallMeetingHandler)handler;


- (void)startLiveStreamHandler:(NIMNetCallMeetingHandler)handler;

- (void)stopLiveStream;

- (void)switchCamera;

- (void)onLocalDisplayviewReady:(UIView *)displayView;

- (void)onCameraOrientationSwitchCompleted:(NIMVideoOrientation)orientation;

- (void)switchContainerToView:(UIView *)captureView;

- (void)startPreview:(NIMNetCallMediaType)type
           container:(UIView *)container
             handler:(void(^)(NSError * error))handler;

- (void)stopVideoCapture;

- (void)setMeeting:(NIMNetCallMeeting*)meeting;

- (BOOL)isCameraBack;
@end


@interface NTESMediaCaptureRequest : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *roomId;

@property (nonatomic, strong) UIView *container;

@property (nonatomic, copy) NSString *meetingName;

@property (nonatomic, assign) NIMNetCallMediaType type;

@end
