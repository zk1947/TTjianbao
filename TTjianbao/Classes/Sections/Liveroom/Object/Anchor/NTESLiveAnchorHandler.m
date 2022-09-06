//
//  NTESLiveAnchorHandler.m
//  TTjianbao
//
//  Created by chris on 16/8/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveAnchorHandler.h"
#import "NSString+NTES.h"
#import "NSDictionary+NTESJson.h"
#import "NTESLiveViewDefine.h"
#import "NTESLiveManager.h"
#import "UIView+Toast.h"

@interface NTESLiveAnchorHandler ()

@property (nonatomic,strong) NIMChatroom *chatroom;

@end

@implementation NTESLiveAnchorHandler

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom
{
    self = [super init];
    if (self) {
        _chatroom = chatroom;
    }
       return self;
}

- (void)dealWithBypassCustomNotification:(NIMCustomSystemNotification *)notification
{
    NSString *content  = notification.content;
    NSDictionary *dict = [content jsonObject];
    NSDictionary *body = [dict jsonDict:@"body"];
    NSString *from  = [body jsonString:@"accid"];
    
    if (![self shouldDealWithNotification:notification]) {
        return;
    }
    NTESLiveCustomNotificationType type = [[dict objectForKey:@"type"]  integerValue];
    
    switch (type) {
        case NTESLiveCustomNotificationTypePushMic:{
            //这个是连麦者发来的请求
            DDLogInfo(@"anchor: on receive notification NTESLiveCustomNotificationTypePushMic%@",dict);
            NSString *nick   = [body jsonString:@"name"];
            NSString *accid   = [body jsonString:@"accid"];
            NSString *avatar = [body jsonString:@"icon"];
            NSString *Id = [body jsonString:@"id"];
            NSArray *imgList = [body jsonArray:@"imgList"];
            
            
            NIMNetCallMediaType callType = NIMNetCallMediaTypeVideo;
            
            NTESMicConnector *connector = [[NTESMicConnector alloc] init];
            connector.uid    = accid;
            connector.Id    = Id;
            connector.state  = NTESLiveMicStateWaiting;
            connector.nick   = nick;
            connector.avatar = avatar;
            connector.type   = callType;
            connector.imgList   = imgList;
            connector.bought   = [body jsonBool:@"bought"];
            connector.isBiggerThen   = [body jsonBool:@"isBiggerThen"];
            connector.appraiseRecordId = [body jsonString:@"appraiseRecordId"];
            connector.customizeRecordId = [body jsonString:@"customizeRecordId"];
            connector.applyId = [body jsonString:@"applyId"];
            
            connector.orderId = [body jsonString:@"orderId"];
            connector.orderCode = [body jsonString:@"orderCode"];
            connector.goodsTitle = [body jsonString:@"goodsTitle"];
            connector.goodsUrl = [body jsonString:@"goodsUrl"];
            connector.statusDesc = [body jsonString:@"statusDesc"];
            
            connector.goodsCateId = [body jsonString:@"goodsCateId"];
            connector.goodsCateName = [body jsonString:@"goodsCateName"];
            connector.customizeFeeId = [body jsonString:@"customizeFeeId"];
            connector.customizeFeeName = [body jsonString:@"customizeFeeName"];
            connector.orderCategory = [body jsonString:@"orderCategory"];
            
        
            [[NTESLiveManager sharedInstance] updateConnectors:connector];
            if ([self.delegate respondsToSelector:@selector(didUpdateConnectors)]) {
                [self.delegate didUpdateConnectors];
            }
           //   [[UIApplication sharedApplication].keyWindow makeToast:@"有新用户申请鉴定" duration:1.0 position:CSToastPositionCenter];
            
            break;
        }
        case NTESLiveCustomNotificationTypePopMic:
            //这个是连麦者发来的请求，取消状态
        {
            NTESMicConnector *connector= [[NTESLiveManager sharedInstance] findConnector:from];
            
            if (connector.state==NTESLiveMicStateConnected){
               DDLogInfo(@"正在连麦中  不支持取消申请鉴定");
                  return;
            }
            if (connector.state==NTESLiveMicStateWait){
                
                if ([self.delegate respondsToSelector:@selector(didUpdateConnectorStatus)]) {
                    [self.delegate didUpdateConnectorStatus];
                }
                if ([self.delegate respondsToSelector:@selector(stopTimer)]) {
                    [self.delegate stopTimer];
                }
                
                 [[UIApplication sharedApplication].keyWindow makeToast:@"用户没有接受连麦请求" duration:1.0 position:CSToastPositionCenter];
            }
           
            DDLogInfo(@"anchor: on receive notification NTESLiveCustomNotificationTypePopMic");
            [[NTESLiveManager sharedInstance] removeConnectors:from];
            
            if ([self.delegate respondsToSelector:@selector(didUpdateConnectors)]) {
                [self.delegate didUpdateConnectors];
            }
            if ([self.delegate respondsToSelector:@selector(reverseLinkUserCancel)]) {
                [self.delegate reverseLinkUserCancel];
            }
        }
            
            break;
            
            //鉴定用户进出房间
        case NTESLiveCustomNotificationTypeAudiencedEnterOrExitLiveRoom:
        {
             NTESMicConnector *connector= [[NTESLiveManager sharedInstance] findConnector:from];
            if (connector) {
                
                if ([[body jsonString:@"status"] isEqualToString:@"in"]) {
                    connector.onlineState  = NTESLiveMicOnlineStateEnterRoom;
                }
               else if ([[body jsonString:@"status"] isEqualToString:@"out"]){
                   connector.onlineState  = NTESLiveMicOnlineStateExitRoom;
                }
            }
        }
            break;
             //鉴定用户进入房间
            
        case NTESLiveCustomNotificationTypeRejectAgree:
            //这个只有主播会收到，是连麦者拒绝主播连麦，因连麦过期造成，非用户触发
            DDLogInfo(@"anchor: on receive notification NTESLiveCustomNotificationTypeRejectAgree");
            //[NTESLiveManager sharedInstance].connectorOnMic = nil;
            [[NTESLiveManager sharedInstance] delConnectorOnMicWithUid:from];
            [[NTESLiveManager sharedInstance] removeConnectors:notification.sender];
            if ([self.delegate respondsToSelector:@selector(didUpdateConnectors)]) {
                [self.delegate didUpdateConnectors];
            }
            break;
        default:
            break;
    }
}

- (void)dealWithNotificationMessage:(NIMMessage *)message {
    DDLogInfo(@"audience: on receive chatroom notification message");
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    switch (object.notificationType) {
        case NIMNotificationTypeChatroom:{
            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
            switch (content.eventType) {
                case NIMChatroomEventTypeEnter:{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameEnterUser object:message];

                    if (_delegate && [_delegate respondsToSelector:@selector(didUpdateChatroomMemebers:)]) {
                        [_delegate didUpdateChatroomMemebers:YES];
                    }
                    break;
                }
                case NIMChatroomEventTypeExit: {
                    if (_delegate && [_delegate respondsToSelector:@selector(didUpdateChatroomMemebers:)]) {
                        [_delegate didUpdateChatroomMemebers:NO];
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

                default:
                    DDLogError(@"audience: chatroom notification type is uncatch! type is %zd",content.eventType);
                    break;
            }
            
        }
            break;
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
    BOOL validRoom = [roomId isEqualToString:self.chatroom.roomId];
    return validRoom;
}


@end

