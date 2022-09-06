//
//  NTESLiveAudienceHandler.m
//  TTjianbao
//
//  Created by chris on 16/8/17.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveAudienceHandler.h"
#import "NSDictionary+NTESJson.h"
#import "NSString+NTES.h"
#import "NTESLiveViewDefine.h"
#import "NTESMicConnector.h"
#import "NTESLiveManager.h"
#import "NTESSessionMsgConverter.h"
#import "NTESUserUtil.h"
#import "NTESCustomKeyDefine.h"
#import "NTESMicAttachment.h"
#import "NTESMediaCapture.h"
#import "ChannelMode.h"
#import "CommAlertView.h"
#import "JHLivePlayer.h"

@interface NTESLiveAudienceHandler()
{
    
}
@property (nonatomic,strong) NIMChatroom *chatroom;

@property (nonatomic,copy)   NSString *meetingName;

@property (nonatomic, strong) NTESMediaCapture *capture;


@end

@implementation NTESLiveAudienceHandler

- (instancetype)initWithChatroom:(NIMChatroom *)room
{
    self = [super init];
    if (self) {
        _chatroom = room;
        _meetingName = [NTESUserUtil meetingName:self.chatroom];
        _capture = [[NTESMediaCapture alloc]init];
    }
    return self;
}

- (void)callUpdateUserOnMicWithUid:(NSString *)uid
{
    if ([self.delegate respondsToSelector:@selector(didUpdateUserOnMicWithUid:)]) {
        [self.delegate didUpdateUserOnMicWithUid:uid];
    }
}

- (void)dealWithBypassMessage:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    id<NIMCustomAttachment> attachment = object.attachment;
    
    DDLogInfo(@"audience: on receive bypass message");
    
    if ([attachment isKindOfClass:[NTESMicConnectedAttachment class]]) {
        DDLogInfo(@"audience: bypass message type is mic connected");
        //这个消息是主播发出的全局广播，主播自己不会收到
        NTESMicConnectedAttachment *attach = (NTESMicConnectedAttachment *)attachment;
        NSString *onMicUid = attach.connectorId;
        NTESMicConnector *connector = [[NTESMicConnector alloc] init];
        connector.uid    = onMicUid;
        connector.state  = NTESLiveMicStateConnected;
        connector.nick   = attach.nick;
        connector.avatar = attach.avatar;
        connector.type   = attach.type;
        [[NTESLiveManager sharedInstance] addConnectorOnMic:connector];
        [self callUpdateUserOnMicWithUid:onMicUid];
    }
    else if ([attachment isKindOfClass:[NTESDisConnectedAttachment class]]) {
      //  DDLogInfo(@"audience: bypass message type is mic disconnected");
        NTESDisConnectedAttachment *attach = (NTESDisConnectedAttachment *)attachment;
        NSString *onMicUid = attach.connectorId;
        
        if (onMicUid) {
            [[NTESLiveManager sharedInstance] delConnectorOnMicWithUid:onMicUid];
        }
        [self callUpdateUserOnMicWithUid:onMicUid];
    }
}

- (void)dealWithBypassCustomNotification:(NIMCustomSystemNotification *)notification
{
    //只有连麦的人会收到这条消息
    NSString *content  = notification.content;
    NSDictionary *dict = [content jsonObject];
    NSString *roomId = [dict jsonString:@"roomId"];
    NTESLiveCustomNotificationType type = [dict jsonInteger:@"type"];
    
    if (![self shouldDealWithNotification:notification]) {
         return;
    }
    switch (type) {
        case NTESLiveCustomNotificationTypeReverseLink:
        case NTESLiveCustomNotificationTypeAgreeConnectMic:{
            
            @weakify(self);
          
            [NTESUserUtil requestMediaCapturerAccess:NIMNetCallMediaTypeVideo handler:^(NSError *error) {
                if (!error) {
                    
                    @strongify(self);
                    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
                    meeting.name  = self.channel.meetingName;
                    meeting.actor = YES;
                    meeting.type  = NIMNetCallMediaTypeVideo;
                    NIMNetCallOption *option = [NTESUserUtil fillNetCallOption:meeting];
                    self.currentMeeting = meeting;
                    //开启摄像头
                    self.capture.cameraType = NIMNetCallCameraBack;
                    NIMNetCallVideoCaptureParam *param = [NTESUserUtil videoCaptureParam];
                    param.videoCaptureOrientation = [NTESLiveManager sharedInstance].orientation;
                    param.videoHandler = self.capture.videoHandler;
                    param.startWithBackCamera = self.capture.cameraType == NIMNetCallCameraBack;
                    option.videoCaptureParam = param;
                    //先关闭播放器 再连麦 防止底层音频资源共用引发问题
                    [[JHLivePlayer sharedInstance] doDestroyPlayer];
                    //屏幕常亮
                    [UIApplication sharedApplication].idleTimerDisabled = YES;
                    
                    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull currentMeeting, NSError * _Nonnull error) {
                        
                        @strongify(self);
                        if (error) {
                            DDLogError(@"agree connect mic -> join meeting error : %@",error);
                        if ([self.delegate respondsToSelector:@selector(joinMeetingError:)]) {
                             [self.delegate joinMeetingError:error];
                            }
                        }
                        else{
                            
                            self.isWaitingForAgreeConnect = NO;
                            self.currentMeeting = currentMeeting;
                            NTESMicConnector *connector = [NTESMicConnector me:roomId];
                            connector.state = NTESLiveMicStateConnected;
                            [[NTESLiveManager sharedInstance] addConnectorOnMic:connector];
                            [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:YES];
                            if ([self.delegate respondsToSelector:@selector(didStartByPassingWithUid:)]) {
                                [self.delegate didStartByPassingWithUid:connector.uid];
                            }
                        }
                    }];
                }
                else{
                    if (error.code == 0) {
                        NSLog(@"录音权限未授权");
                        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"当前应用缺少必要权限，请点击系统设置-权限-打开所需权限。" cancleBtnTitle:@"设置" sureBtnTitle:@"取消"];
                        [[UIApplication sharedApplication].keyWindow addSubview:alert];
                        alert.cancleHandle = ^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
                        };
                    }
                    if (error.code == 1) {
                        NSLog(@"相机权限未授权");
                        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"当前应用缺少必要权限，请点击系统设置-权限-打开所需权限。" cancleBtnTitle:@"设置" sureBtnTitle:@"取消"];
                        [[UIApplication sharedApplication].keyWindow addSubview:alert];
                        alert.cancleHandle = ^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
                        };

                    }
                }
            }];
            
            break;
        }
        
        case NTESLiveCustomNotificationTypeForceDisconnect: {
        
            if ([self.delegate respondsToSelector:@selector(didForceDisConnectMic)]) {
                [self.delegate didForceDisConnectMic];
            }
           
            break;
        }
        case NTESLiveCustomNotificationTypeRefuseConnectMic: {
            
            if ([self.delegate respondsToSelector:@selector(didForceDisConnectMic)]) {
                [self.delegate didRefuseConnectMic];
            }
    
            break;
        }
            
        default:
            DDLogError(@"audience: notification type is UNKNOWN!");
            break;
    }
}

- (void)dealWithNotificationMessage:(NIMMessage *)message
{
    DDLogInfo(@"audience: on receive chatroom notification message");
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    switch (object.notificationType) {
        case NIMNotificationTypeChatroom:{
            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
            switch (content.eventType) {
                case NIMChatroomEventTypeEnter:{
                    DDLogInfo(@"audience: notification type is NIMChatroomEventTypeEnter");
                    NSString *enterUserId = content.targets.firstObject.userId;
                    DDLogInfo(@"enter user is %@",enterUserId);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameEnterUser object:message];

                    
                    if (_delegate && [_delegate respondsToSelector:@selector(didUpdateChatroomMemebers:userId:)]) {
                        [_delegate didUpdateChatroomMemebers:YES userId:enterUserId];
                    }
                    if ([enterUserId isEqualToString:self.chatroom.creator]
                        && ![[[NIMSDK sharedSDK].loginManager currentAccount] isEqualToString:self.chatroom.creator]) {
                        NSDictionary *dict = [content.notifyExt jsonObject];
                        if ([dict isKindOfClass:[NSDictionary class]]){
                            if ([self.delegate respondsToSelector:@selector(didUpdateLiveType:)]) {
                                NTESLiveType type = [dict jsonInteger:NTESCMType];

                                [self.delegate didUpdateLiveType:type];

                            }
                            if ([self.delegate respondsToSelector:@selector(didUpdateLiveOrientation:)]) {
                                NIMVideoOrientation orientation =[dict jsonInteger:NTESCMOrientation] == 1 ? NIMVideoOrientationPortrait:NIMVideoOrientationLandscapeRight;
                                [self.delegate didUpdateLiveOrientation:orientation];

                            }
                            NSString *meetingName = [dict jsonString:NTESCMMeetingName];
                            self.meetingName = meetingName;
                        }
                    }
                    break;
                }
                case NIMChatroomEventTypeInfoUpdated:{
                   DDLogInfo(@"audience: notification type is NIMChatroomEventTypeInfoUpdated");
                    DDLogInfo(@"update info: %@",content.notifyExt);
                    NSDictionary *dict = [content.notifyExt jsonObject];
                    if ([dict isKindOfClass:[NSDictionary class]]){
                        if ([self.delegate respondsToSelector:@selector(didUpdateLiveType:)]) {
                            NTESLiveType type = [dict jsonInteger:NTESCMType];
                            [self.delegate didUpdateLiveType:type];
                        }
                        NSString *meetingName = [dict jsonString:NTESCMMeetingName];
                        self.meetingName = meetingName;
                    }
                    break;
                }
                case NIMChatroomEventTypeExit: {
                    NSString *exitUserId = content.targets.firstObject.userId;
                //    DDLogInfo(@"exit user is %@",exitUserId);
                    if (_delegate && [_delegate respondsToSelector:@selector(didUpdateChatroomMemebers:userId:)]) {
                        [_delegate didUpdateChatroomMemebers:NO userId:exitUserId];
                    }
                    break;
                }
                case NIMChatroomEventTypeAddMuteTemporarily: {
                    if (_delegate && [_delegate respondsToSelector:@selector(didUserBeMute:message:)]) {
                        [_delegate didUserBeMute:YES message:message];
                    }

                }
                    break;
                
                case NIMChatroomEventTypeRemoveMuteTemporarily: {
                    if (_delegate && [_delegate respondsToSelector:@selector(didUserBeMute:message:)]) {
                        [_delegate didUserBeMute:NO message:message];
                    }
                    
                }
                    break;

                case NIMChatroomEventTypeAddBlack : {
                    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
                    
                    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
                    
                    for (NIMChatroomNotificationMember *m in content.targets) {
                        NSString *uid = [NIMSDK sharedSDK].loginManager.currentAccount;
                        if ([uid isEqualToString:m.userId]) {
                            
                            if (_delegate && [_delegate respondsToSelector:@selector(didAddBlackMessage:)]) {
                                [_delegate didAddBlackMessage:message];
                            }
                        }
                    }
                }
                        
                    
                  
                    break;
                default:
                    DDLogError(@"audience: chatroom notification type is uncatch! type is %zd",content.eventType);
                    break;
            }
            break;
        }
        default:
            DDLogError(@"audience:  message type is UNKNOWN!");
            break;
    }
}

- (BOOL)shouldDealWithNotification:(NIMCustomSystemNotification *)notification
{
    
    NSString *content  = notification.content;
    NSDictionary *dict = [content jsonObject];
    NSDictionary *body = [dict jsonDict:@"body"];
    NSString *roomId = [NSString stringWithFormat:@"%@",[body objectForKey:@"roomId"]];
    
    NTESLiveCustomNotificationType type = [dict jsonInteger:@"type"];
    BOOL validRoom = [roomId isEqualToString:self.chatroom.roomId];
    BOOL shouldRejectAgreeMic = type == NTESLiveCustomNotificationTypeAgreeConnectMic && (!self.isWaitingForAgreeConnect || !validRoom);
    if (shouldRejectAgreeMic) {
        DDLogDebug(@"reject agree mic ! current room id %@",self.chatroom.roomId);

        NIMCustomSystemNotification *notification = [NTESSessionCustomNotificationConverter notificationWithRejectAgree:self.chatroom.roomId];
        NIMSession *session = [NIMSession session:notification.sender type:NIMSessionTypeP2P];
        [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
    }
    return validRoom || shouldRejectAgreeMic;
}

- (void)switchCamara {
    [self.capture switchCamera];
}
@end
