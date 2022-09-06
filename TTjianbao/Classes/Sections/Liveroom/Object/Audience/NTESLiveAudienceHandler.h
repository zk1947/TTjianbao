//
//  NTESLiveAudienceHandler.h
//  TTjianbao
//  Description:观众端消息解析、统一分发(预处理)
//  Created by chris on 16/8/17.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESLiveViewDefine.h"
#import "NIMSDK/NIMSDK.h"

typedef void(^NTESPlayerShutdownCompletion)(void);
@class ChannelMode;
@protocol NTESLiveAudienceHandlerDelegate <NSObject>

@optional

- (void)didUpdateConnectors;

- (void)didUpdateUserOnMicWithUid:(NSString *)uid;

- (void)joinMeetingError:(NSError *)error;

- (void)didStartByPassingWithUid:(NSString *)uid;

- (void)didStopByPassingWithUid:(NSString *)uid;

- (void)didUpdateLiveType:(NTESLiveType)type;

- (void)didUpdateLiveStatus;

- (void)didUpdateLiveOrientation:(NIMVideoOrientation)orientation;

- (void)didUpdateChatroomMemebers:(BOOL)isAdd userId:(NSString *)userId;

- (void)didcancleConnectMic;

//主播断开连麦
- (void)didForceDisConnectMic;
//主播拒绝鉴定
- (void)didRefuseConnectMic;

- (void)didUserBeMute:(BOOL)ismute message:(NIMMessage *)message;

- (void)didAddBlackMessage:(NIMMessage *)message;

@end

@protocol NTESLiveAudienceHandlerDatasource <NSObject>

@required


@end

@interface NTESLiveAudienceHandler : NSObject

@property (nonatomic,weak) id<NTESLiveAudienceHandlerDelegate> delegate;

@property (nonatomic,weak) id<NTESLiveAudienceHandlerDatasource> datasource;

@property (nonatomic,assign) BOOL isWaitingForAgreeConnect;

@property (nonatomic,assign) NSInteger timeCount;

@property (nonatomic,strong) NIMNetCallMeeting *currentMeeting;

@property (nonatomic,strong) ChannelMode *channel;

- (instancetype)initWithChatroom:(NIMChatroom *)room;

- (void)dealWithBypassMessage:(NIMMessage *)message;

- (void)dealWithNotificationMessage:(NIMMessage *)message;

- (void)dealWithBypassCustomNotification:(NIMCustomSystemNotification *)notification;

- (void)switchCamera;

@end
