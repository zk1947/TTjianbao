//
//  NTESSessionMsgConverter.h
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import "JHSystemMsgAttachment.h"

@class NTESPresent;
@class NTESMicConnector;

@interface NTESSessionMsgConverter : NSObject

+ (NIMMessage *)msgWithText:(NSString*)text;

+ (NIMMessage *)msgWithTip:(NSString *)tip;

+ (NIMMessage *)msgWithPresent:(NTESPresent *)present;

+ (NIMMessage *)msgWithLike;

+ (NIMMessage *)msgWithConnectedMic:(NTESMicConnector *)connector;

+ (NIMMessage *)msgWithDisconnectedMic:(NTESMicConnector *)connector;

+ (NIMMessage *)msgWithSystemMsg:(JHSystemMsg *)msg;

@end


@interface NTESSessionCustomNotificationConverter : NSObject

+ (NIMCustomSystemNotification *)notificationWithPushMic:(NSString *)roomId style:(NIMNetCallMediaType)style;

+ (NIMCustomSystemNotification *)notificationWithPopMic:(NSString *)roomId;

+ (NIMCustomSystemNotification *)notificationWithAgreeMic:(NSString *)roomId
                                                    style:(NIMNetCallMediaType)style;

+ (NIMCustomSystemNotification *)notificationWithRejectAgree:(NSString *)roomId;

+ (NIMCustomSystemNotification *)notificationWithForceDisconnect:(NSString *)roomId uid:(NSString *)uid;

+ (NIMCustomSystemNotification *)notificationBeMuteSendAnchorMsg:(NSString *)roomId
                                                          avatar:(NSString *)avatar
                                                            nick:(NSString *)nick
                                                             msg:(NSString *)msg;

@end
