//
//  NTESSessionMsgHelper.m
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionMsgConverter.h"
#import "NSString+NTES.h"
#import "NTESPresentAttachment.h"
#import "NTESLikeAttachment.h"
#import "NTESPresent.h"
#import "NSDictionary+NTESJson.h"
#import "NTESLiveViewDefine.h"
#import "NTESLiveManager.h"
#import "NTESMicConnector.h"
#import "NTESMicAttachment.h"
#import "CommHelp.h"

@implementation NTESSessionMsgConverter


+ (NIMMessage*)msgWithText:(NSString*)text
{
    NIMMessage *textMessage = [[NIMMessage alloc] init];
    textMessage.text        = text;
    return textMessage;
}

+ (NIMMessage *)msgWithTip:(NSString *)tip
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMTipObject *tipObject    = [[NIMTipObject alloc] init];
    message.messageObject      = tipObject;
    message.text               = tip;
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = NO;
    message.setting            = setting;
    return message;
}

+ (NIMMessage *)msgWithPresent:(NTESPresent *)present
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMCustomObject *object    = [[NIMCustomObject alloc] init];
    NTESPresentAttachment *attachment = [[NTESPresentAttachment alloc] init];
    attachment.presentType     = present.type;
    attachment.count           = 1;
    object.attachment          = attachment;
    message.messageObject      = object;
    return message;
}

+ (NIMMessage *)msgWithLike
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMCustomObject *object    = [[NIMCustomObject alloc] init];
    JHSystemMsgAttachment *attachment = [[JHSystemMsgAttachment alloc] init];
    attachment.type = JHSystemMsgType666;
    object.attachment          = attachment;
    message.messageObject      = object;
    return message;
}

+ (NIMMessage *)msgWithConnectedMic:(NTESMicConnector *)connector
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMCustomObject *object    = [[NIMCustomObject alloc] init];
    NTESMicConnectedAttachment *attachment = [[NTESMicConnectedAttachment alloc] init];
    attachment.type            = connector.type;
    attachment.nick            = connector.nick;
    attachment.avatar          = connector.avatar;
    attachment.connectorId     = connector.uid;
    object.attachment          = attachment;
    message.messageObject      = object;
    return message;
}

+ (NIMMessage *)msgWithDisconnectedMic:(NTESMicConnector *)connector
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMCustomObject *object    = [[NIMCustomObject alloc] init];
    NTESDisConnectedAttachment *attachment = [[NTESDisConnectedAttachment alloc] init];
    attachment.connectorId     = connector.uid;
    object.attachment          = attachment;
    message.messageObject      = object;
    return message;
}

+ (NIMMessage *)msgWithSystemMsg:(JHSystemMsg *)msg
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMCustomObject *object    = [[NIMCustomObject alloc] init];
    JHSystemMsgAttachment *attachment = [[JHSystemMsgAttachment alloc] init];
    attachment.type     = msg.type;
    attachment.avatar           = msg.avatar;
    attachment.content           = msg.content;
    attachment.nick           = msg.nick;

    object.attachment          = attachment;
    message.messageObject      = object;
    return message;
}


@end



@implementation NTESSessionCustomNotificationConverter

+ (NIMCustomSystemNotification *)notificationWithPushMic:(NSString *)roomId style:(NIMNetCallMediaType)style
{
    NIMChatroomMember *member = [[NTESLiveManager sharedInstance] myInfo:roomId];
    if (member) {
        
        NSLog(@"member.roomNickname=%@",member.roomNickname);
        NSString *content = [ @{
                                @"command"   : @(NTESLiveCustomNotificationTypePushMic),
                                @"roomid" : roomId,
                                @"style"  : @(style),
                                @"info"   : @{
                                                @"nick"   : @"fg",
                                                @"avatar" : member.roomAvatar.length? member.roomAvatar : @"avatar_default"
                                            }
                                } jsonBody];
        NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
        notification.sendToOnlineUsersOnly = YES;
        return notification;
    }
    return nil;
}


+ (NIMCustomSystemNotification *)notificationWithPopMic:(NSString *)roomId
{
    NSString *content = [@{@"command":@(NTESLiveCustomNotificationTypePopMic),@"roomid" : roomId} jsonBody];
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = YES;
    return notification;
}

+ (NIMCustomSystemNotification *)notificationWithAgreeMic:(NSString *)roomId
                                                    style:(NIMNetCallMediaType)style
{
//    NSString *content = [@{@"command":@(NTESLiveCustomNotificationTypeAgreeConnectMic),@"roomid" : roomId, @"style":@(style)} jsonBody];
    
        NSDate * nowTime=[CommHelp getCurrentTrueDate];
        nowTime=[nowTime dateByAddingTimeInterval:20];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[nowTime timeIntervalSince1970]*1000];
     //   NSString * endTime=[CommHelp timeChange:timeSp];;
     //   DDLogInfo(@"endTime=%@",endTime);
    
    NSString *content = [@{
                            @"body":@{@"roomId" : roomId, @"style":@(style),@"waitTime":@(20),@"expireTime":timeSp},
                            @"type":@(NTESLiveCustomNotificationTypeAgreeConnectMic),
                            } jsonBody];
    
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = YES;
    return notification;
}

+ (NIMCustomSystemNotification *)notificationBeMuteSendAnchorMsg:(NSString *)roomId
                                                          avatar:(NSString *)avatar
                                                            nick:(NSString *)nick
                                                             msg:(NSString *)msg
                                                
{



    NSString *content = [@{
                           @"body":@{@"roomId" : roomId, @"avatar":avatar,@"nick":nick, @"msg":msg},
                           @"type":@(NTESLiveCustomNotificationTypeBeMuteUserSendToAnchorMsg),
                           } jsonBody];
    
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = YES;
    return notification;
}

+ (NIMCustomSystemNotification *)notificationWithRejectAgree:(NSString *)roomId
{
    NSString *content = [@{@"command":@(NTESLiveCustomNotificationTypeRejectAgree),@"roomid" : roomId} jsonBody];
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = YES;
    return notification;
}


+ (NIMCustomSystemNotification *)notificationWithForceDisconnect:(NSString *)roomId uid:(NSString *)uid
{
    NSString *content = [@{@"command":@(NTESLiveCustomNotificationTypeForceDisconnect),@"roomid" : roomId, @"uid":uid} jsonBody];
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = NO;
    return notification;
}

@end
