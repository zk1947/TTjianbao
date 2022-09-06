//
//  NTESLiveAnchorHandler.h
//  TTjianbao
//  Description:主播端消息解析、统一分发(预处理)
//  Created by chris on 16/8/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESMicConnector.h"
#import "NIMSDK/NIMSDK.h"

@protocol NTESLiveAnchorHandlerDelegate <NSObject>

@optional
- (void)didUpdateConnectors;

- (void)didUpdateConnectorStatus;

- (void)didUpdateChatroomMemebers:(BOOL)isAdd;

- (void)stopTimer;

- (void)didUserBeMute:(BOOL)ismute message:(NIMMessage *)message;

-(void)connecterLeft:(NSString *)uid;

- (void)reverseLinkUserCancel;
@end

@interface NTESLiveAnchorHandler : NSObject

@property (nonatomic,weak) id<NTESLiveAnchorHandlerDelegate> delegate;

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;

- (void)dealWithNotificationMessage:(NIMMessage *)message;

- (void)dealWithBypassCustomNotification:(NIMCustomSystemNotification *)notification;

@end
