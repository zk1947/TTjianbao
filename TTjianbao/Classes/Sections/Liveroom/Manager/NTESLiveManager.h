//
//  NTESChatroomManager.h
//  NIM
//
//  Created by chris on 16/1/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESService.h"
#import "NTESLiveViewDefine.h"
#import <NIMSDK/NIMSDK.h>

@class NTESPresent;
@class NTESPresentItem;
@class NTESMicConnector;

typedef NS_ENUM(NSUInteger, JHRoomRole) {
    JHRoomRoleAndience = 0,
    JHRoomRoleAssistant = 1, /// 助理
    JHRoomRoleAnchor = 2,
};

@interface NTESLiveManager : NTESService

//直播中的角色
@property (nonatomic, assign) NTESLiveRole role;

//目前直播间的类型
@property (nonatomic, assign) NTESLiveType type;

//目前直播间直播画面质量，仅视频直播有效
@property (nonatomic, assign) NTESLiveQuality liveQuality;

//请求直播方向
@property (nonatomic, assign) NIMVideoOrientation requestOrientation;

//目前直播方向
@property (nonatomic, assign) NIMVideoOrientation orientation;

//连麦用户
@property (nonatomic, strong) NSMutableArray <NTESMicConnector *> *connectorsOnMic;
//连麦队列
@property (nonatomic, strong) NSMutableArray<NTESMicConnector *> *connectors;

//查询所有上麦用户uid
- (NSMutableArray <NSString *> *)uidsOfConnectorsOnMic;

//查询上麦用户
- (NTESMicConnector *)connectorOnMicWithUid:(NSString *)uid;

//是否可以添加上麦用户
- (BOOL)canAddConnectorOnMic;

//插入上麦用户
- (void)insertConnectorOnMic:(NTESMicConnector *)connectorOnMic atIndex:(NSInteger)index;

//添加上麦用户
- (void)addConnectorOnMic:(NTESMicConnector *)connectorOnMic;

//移除上麦用户
- (void)delConnectorOnMicWithUid:(NSString *)uid;

//移除所有上麦用户
- (void)delAllConnectorsOnMic;

//最早的上麦用户
- (NTESMicConnector *)earliestConnectorOnMic;

//@property (nonatomic, strong) NTESMicConnector *connectorOnMic;

//目前互动直播的类型，为连麦者本身的属性
@property (nonatomic, assign) NIMNetCallMediaType bypassType;

//聊天室信息
- (NIMChatroom *)roomInfo:(NSString *)roomId;

//我在聊天室内的信息
- (NIMChatroomMember *)myInfo:(NSString *)roomId;

//聊天室的主播信息
- (void)anchorInfo:(NSString *)roomId handler:(void(^)(NSError *,NIMChatroomMember *))handler;

//缓存我的聊天室个人信息
- (void)cacheMyInfo:(NIMChatroomMember *)info roomId:(NSString *)roomId;

//缓存聊天室信息
- (void)cacheChatroom:(NIMChatroom *)chatroom;

//礼物信息
@property (nonatomic, strong) NSMutableDictionary *presents;
@property (nonatomic, strong) NSMutableArray *presentArray;

//- (NSMutableDictionary *)presents;

//我收到的礼物
- (NSArray<NTESPresentItem *> *)myPresentBox;


//-----------------以下接口只对主播有效------------------//
//更新连麦者
- (void)updateConnectors:(NTESMicConnector *)connector;
- (void)insertConnector:(NTESMicConnector *)connector atIndex:(NSInteger)index;
//移除连麦者
- (void)removeConnectors:(NSString *)uid;

//移除所有连麦者
- (void)removeAllConnectors;

//获取连麦者
- (NTESMicConnector *)findConnector:(NSString *)uid;

//获取某一状态下的连麦者
- (NSArray<NTESMicConnector *> *)connectors:(NTESLiveMicState)state;


- (void)requestPresentList;

@end
