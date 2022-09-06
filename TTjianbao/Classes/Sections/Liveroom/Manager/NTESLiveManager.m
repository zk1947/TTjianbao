//
//  NTESChatroomManager.m
//  NIM
//
//  Created by chris on 16/1/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveManager.h"
#import "NSDictionary+NTESJson.h"
#import "NTESPresent.h"
#import "NTESFileLocationHelper.h"
#import "NTESPresentAttachment.h"
#import "NTESPresentItem.h"
#import "NTESMicConnector.h"
#import "UserInfoRequestManager.h"


@interface NTESLiveManager()<NIMChatManagerDelegate>

@property (nonatomic,strong) NSMutableDictionary *chatrooms;

@property (nonatomic,strong) NSMutableDictionary *myInfo;

@property (nonatomic,strong) NSMutableDictionary *anchorInfo;

@property (nonatomic,strong) NSMutableArray<NTESPresentItem *> *presentBox; //收到的礼物信息



@end

@implementation NTESLiveManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _chatrooms = [[NSMutableDictionary alloc] init];
        _myInfo = [[NSMutableDictionary alloc] init];
        _anchorInfo = [[NSMutableDictionary alloc] init];
        _connectors = [[NSMutableArray alloc] init];
        [self unarchivePresentBox];
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
    }
    return self;
}

-(void)setRole:(NTESLiveRole)role{
    
       NSLog(@"qian_role=============%ld",(long)_role);
       _role=role;
        NSLog(@"hou_role=============%ld",(long)_role);
}
- (void)dealloc
{
    [self archivePresentBox];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

- (NIMChatroomMember *)myInfo:(NSString *)roomId
{
    NIMChatroomMember *member = _myInfo[roomId];
    return member;
}

- (void)anchorInfo:(NSString *)roomId handler:(void(^)(NSError *,NIMChatroomMember *))handler
{
    if (!handler) {
        return;
    }
    NIMChatroomMember *member = _anchorInfo[roomId];
    if (member) {
        handler(nil,member);
        return;
    }
    NIMChatroom *chatroom = self.chatrooms[roomId];
    if (chatroom) {
        NIMChatroomMembersByIdsRequest *requst = [[NIMChatroomMembersByIdsRequest alloc] init];
        requst.roomId = roomId;
        
        NSLog(@"chatroom.creator======%@",chatroom.creator);
        requst.userIds = @[chatroom.creator];
        [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:requst completion:^(NSError *error, NSArray *members) {
            handler(error,members.firstObject);
        }];
    }
}

- (void)cacheMyInfo:(NIMChatroomMember *)info roomId:(NSString *)roomId
{
    [_myInfo setObject:info forKey:roomId];
}

- (void)cacheChatroom:(NIMChatroom *)chatroom{
    [_chatrooms setObject:chatroom forKey:chatroom.roomId];
}

- (NIMChatroom *)roomInfo:(NSString *)roomId
{
    return _chatrooms[roomId];
}

- (NSArray<NTESPresentItem *> *)myPresentBox
{
    return self.presentBox;
}

- (void)savePresent:(NSInteger)presentType
              count:(NSInteger)count
{
    NTESPresentItem *presentItem;
    for (NTESPresentItem *item in self.presentBox) {
        if (item.type == presentType) {
            presentItem = item;
            break;
        }
    }
    if (!presentItem) {
        presentItem = [[NTESPresentItem alloc] init];
        presentItem.type  = presentType;
        [self.presentBox addObject:presentItem];
    }
    presentItem.count++;
}

- (void)unarchivePresentBox
{
    NSString *filepath = self.presentBoxDataPath;
    NSArray *array= @[];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
        array = [object isKindOfClass:[NSArray class]] ? object : @[];
    }
    self.presentBox = [array mutableCopy];
}

- (void)archivePresentBox
{
    NSData *data = [NSData data];
    if (self.presentBox)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:self.presentBox];
    }
    [data writeToFile:[self presentBoxDataPath] atomically:YES];
}

- (NSString *)presentBoxDataPath
{
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    NSString *path = [OBJ_TO_STRING([NTESFileLocationHelper getAppDocumentPath]) stringByAppendingPathComponent:[@"present_box_data_" stringByAppendingString:OBJ_TO_STRING(currentUserId)]];
    return path;
}
//
//- (NSDictionary *)presents
//{
//    static NSMutableDictionary *presents;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        presents = [[NSMutableDictionary alloc] init];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"Presents" ofType:@"plist"];
//        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
//        for (NSString *key in dict) {
//            NSDictionary *p = dict[key];
//            NTESPresent *present = [[NTESPresent alloc] init];
//            present.type = key.integerValue;
//            present.name = p[@"name"];
//            present.icon = p[@"icon"];
//            [presents setObject:present forKey:key];
//        }
//    });
//    return presents;
//}

- (void)onEnterBackground
{
    [self archivePresentBox];
}
- (void)onAppWillTerminate
{
    [self archivePresentBox];
}
- (void)insertConnector:(NTESMicConnector *)connector atIndex:(NSInteger)index {
    NTESMicConnector *localCon = [self findConnector:connector.uid];
    if (!localCon)
    {
        [self.connectors insertObject:connector atIndex:0];
    }
    else
    {
        localCon.state = connector.state;
    }
}
- (void)updateConnectors:(NTESMicConnector *)connector
{
    NTESMicConnector *localCon = [self findConnector:connector.uid];
    if (!localCon)
    {
        [self.connectors addObject:connector];
    }
    else
    {
        localCon.state = connector.state;
    }
}

- (void)removeConnectors:(NSString *)uid
{
    NTESMicConnector *connector = [self findConnector:uid];
    if (connector) {
        [self.connectors removeObject:connector];
    }
}

- (void)removeAllConnectors
{
    [self.connectors removeAllObjects];
}

- (NTESMicConnector *)findConnector:(NSString *)uid
{
    for (NTESMicConnector *connector in self.connectors) {
        if ([connector.uid isEqualToString:uid]) {
            return connector;
        }
    }
    return nil;
}

- (NSArray<NTESMicConnector *> *)connectors:(NTESLiveMicState)state
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NTESMicConnector *connector in self.connectors) {
        if (connector.state == state) {
            [result addObject:connector];
        }
    }
    return [NSArray arrayWithArray:result];
}

#pragma mark - NIMChatManagerDelegate
- (void)onRecvMessages:(NSArray *)messages
{
    for (NIMMessage *message in messages) {
        NSString *room = message.session.sessionId;
        NIMChatroomMember *member = [self myInfo:room];
        NIMCustomObject *object = message.messageObject;
        if (member.type == NIMChatroomMemberTypeCreator && [object isKindOfClass:[NIMCustomObject class]] && [object.attachment isKindOfClass:[NTESPresentAttachment class]]) {
            NTESPresentAttachment *attach = object.attachment;
            [self savePresent:attach.presentType count:attach.count];
        }
    }
}


#pragma mark - Private
//- (void)setConnectorOnMic:(NTESMicConnector *)connectorOnMic
//{
//    if (![_connectorOnMic.uid isEqualToString:connectorOnMic.uid]) {
//        DDLogInfo(@"connector on mic changed %@ -> %@",_connectorOnMic.uid,connectorOnMic.uid);
//    }
//    _connectorOnMic = connectorOnMic;
//}

#define MAX_CONNECTOR_ONMAC_COUNT (1)
- (NSMutableArray <NSString *> *)uidsOfConnectorsOnMic {
    NSMutableArray *ret = [NSMutableArray array];
    [_connectorsOnMic enumerateObjectsUsingBlock:^(NTESMicConnector * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ret addObject:obj.uid];
    }];
    return ret;
}

- (BOOL)canAddConnectorOnMic {
    BOOL ret = YES;
    if (_connectorsOnMic.count >= MAX_CONNECTOR_ONMAC_COUNT) {
        DDLogInfo(@"connector on mic beyond max count %d", MAX_CONNECTOR_ONMAC_COUNT);
        ret = NO;
    }
    return ret;
}

- (void)delRepeatConnectorOnMic:(NTESMicConnector *)connectorOnMic {
    __block NSInteger isDelIndex = -1;

    if (!_connectorsOnMic) {
        _connectorsOnMic = [NSMutableArray array];
    }
    
    [_connectorsOnMic enumerateObjectsUsingBlock:^(NTESMicConnector * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uid isEqualToString:connectorOnMic.uid]) {
            DDLogInfo(@"connector on mic changed %@ -> %@",obj.uid,connectorOnMic.uid);
            isDelIndex = idx;
            *stop = YES;
        }
    }];
    
    if (isDelIndex >= 0 && isDelIndex < _connectorsOnMic.count) {
        [_connectorsOnMic removeObjectAtIndex:isDelIndex];
    }
}

- (void)insertConnectorOnMic:(NTESMicConnector *)connectorOnMic atIndex:(NSInteger)index {
    if (connectorOnMic) {
        [self delRepeatConnectorOnMic:connectorOnMic];
        [_connectorsOnMic insertObject:connectorOnMic atIndex:index];
    }

}

- (void)addConnectorOnMic:(NTESMicConnector *)connectorOnMic {
    if (connectorOnMic) {
        [self delRepeatConnectorOnMic:connectorOnMic];
        [_connectorsOnMic addObject:connectorOnMic];
    }
}

- (NTESMicConnector *)connectorOnMicWithUid:(NSString *)uid {
    if (!uid) {
        return nil;
    }
    __block NTESMicConnector *ret = nil;
    [_connectorsOnMic enumerateObjectsUsingBlock:^(NTESMicConnector * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uid isEqualToString:uid]) {
            ret = obj;
            *stop = YES;
        }
    }];
    return ret;
}

- (void)delConnectorOnMicWithUid:(NSString *)uid {
    if (!uid) {
        return;
    }
    
    __block NSInteger delIndex = -1;
    [_connectorsOnMic enumerateObjectsUsingBlock:^(NTESMicConnector * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uid isEqualToString:uid]) {
            delIndex = idx;
            *stop = YES;
        }
    }];
    if (delIndex >= 0) {
        [_connectorsOnMic removeObjectAtIndex:delIndex];
    }
}

- (void)delAllConnectorsOnMic {
    [_connectorsOnMic removeAllObjects];
}

- (NTESMicConnector *)earliestConnectorOnMic {
    if (_connectorsOnMic.count > 0) {
        return [_connectorsOnMic firstObject];
    } else {
        return nil;
    }
}


- (void)requestPresentList {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/gift/auth") Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        [UserInfoRequestManager sharedInstance].user.balance = [NSString stringWithFormat:@"%@",respondObject.data[@"balance"]];// [((NSNumber *)respondObject.data[@"balance"]) stringValue];

        self.presents = [NSMutableDictionary dictionary];
        self.presentArray = [NSMutableArray array];
        
        NSArray *present = [NTESPresent mj_objectArrayWithKeyValuesArray:respondObject.data[@"gifts"]];
        for (NTESPresent *p in present) {
            [self.presents setObject:p forKey:p.Id];
            [self.presentArray addObject:p];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

@end
