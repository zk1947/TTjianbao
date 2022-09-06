//
//  JHChatManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatManager.h"
#import "JHIMLoginManager.h"
#import "JHChatBusiness.h"

typedef void (^MesssageHandler)(NSArray<NIMMessage *> *list);


@interface JHChatManager()<NIMChatManagerDelegate, NIMMediaManagerDelegate ,NIMConversationManagerDelegate>
@property (nonatomic, assign)  NSInteger audioDuration;
@property (nonatomic, strong) NSMutableArray *reloadIndexs;
/// 欢迎文本
@property (nonatomic, copy) NSString *welcomeText;

@property (nonatomic, strong) NIMSession *session;
@end

@implementation JHChatManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupManager];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"IM释放 - ChatManager - ViewController-%@ 释放", [self class]);
    [[[NIMSDK sharedSDK] chatManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] mediaManager] removeDelegate:self];
}
#pragma mark - 发送消息
- (void)sendP2PMessage : (JHMessage *)message account : (NSString *)account{
    if (account == nil) return;
    [self setupMessageApnsPayload:message.message];
    @weakify(self)
    [self.userManager getUserInfoWithID:self.account handler:^(JHChatUserInfo * _Nonnull userInfo) {
        @strongify(self)
        message.userInfo = userInfo;
        
       
        NSError *error = nil;
        [[[NIMSDK sharedSDK] chatManager] sendMessage:message.message toSession:self.session error:&error];
        // 发送失败
        if (error) {
            self.toastText = @"发送失败，请重试";
        }else {
            message.sendState = JHMessageSendStateSending;
            
            if (message.messageType == JHMessageTypeCustomTip && message.customTipInfo.type != JHChatCustomTipTypeNormal) {
                return;
            }
            
            [self.messageList appendObject:message];
            
            if (self.delegate == nil) return;
            NSInteger index = self.messageList.count > 0 ? self.messageList.count - 1 : 0;
            [self.delegate insertManagerWithIndex:index];
            
            if (message.messageType == JHMessageTypeUnknown ||
                message.messageType == JHMessageTypeDate ||
                message.messageType == JHMessageTypeTip ||
                message.messageType == JHMessageTypeCustomTip ||
                message.messageType == JHMessageTypeRevoke) return;
            
            BOOL isBusiness = [JHChatUserManager sharedManager].userIsBusiness;
            NSString *type = isBusiness ? @"0" : @"1";
            [JHChatBusiness startSessionWithAccount:self.account receiveAccount:self.receiveAccount type : type];
        }
    }];
    
}
- (void)sendMessage : (JHMessage *)message account : (NSString *)account{
    if (account == nil) return;
    if ( message.customTipInfo.type != JHChatCustomTipTypeEvaluate) {
        [self sendMessageDate];
    }
    
    [self sendP2PMessage:message account:account];
}
- (void)resendMessage : (JHMessage *)message {
    NSError *error = nil;
    [[[NIMSDK sharedSDK] chatManager] resendMessage:message.message error:&error];
    // 发送失败
    if (error) {
        self.toastText = @"发送失败，请重试";
    }else {
        message.sendState = JHMessageSendStateSending;
    }
}
/// 发送图片消息
- (void)sendMessageWithImage : (UIImage *)image thumImage : (UIImage *)thumImage account : (NSString *)account {
    JHMessage *msg = [[JHMessage alloc] initWithImage:image thumImage:thumImage];
    msg.senderType = JHMessageSenderTypeMe;
    [self sendMessage:msg account:account];
}
/// 发送视频消息
- (void)sendMessageWithVideo : (NSString *)url thumImage : (UIImage *)thumImage account : (NSString *)account {
    JHMessage *msg = [[JHMessage alloc] initWithVideo:url thumImage:thumImage];
    msg.senderType = JHMessageSenderTypeMe;
    [self sendMessage:msg account:account];
}
- (void)sendMessageWithAudioUrl : (NSString *)url account : (NSString *)account {
    JHMessage *msg = [[JHMessage alloc] initWithAudioUrl:url duration:self.audioDuration];
    msg.senderType = JHMessageSenderTypeMe;
    [self sendMessage:msg account:account];
    self.audioDuration = 0;
}
/// 发送自定义消息
- (void)sendCustomMessage : (JHMessage *) message account : (NSString *)account {
    message.senderType = JHMessageSenderTypeMe;
    [self sendMessage:message account:account];
}
/// 发送日期扩展消息
- (void)sendMessageDate {
    JHMessage *message = self.messageList.lastObject;
    
    NSTimeInterval timeSp = [self getNowDateInterval];
    NSTimeInterval timeInterval = timeSp - message.message.timestamp;
    if (timeInterval <= DateInterval) return;
    
    NSDate *datenow = [NSDate date];//现在时间
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSString *dateStr = [formatter stringFromDate:datenow];
    
    JHMessage *msg = [[JHMessage alloc] initWithDate:dateStr];
    msg.senderType = JHMessageSenderTypeMe;
    [self sendP2PMessage:msg account:self.receiveAccount];
}
/// 插入欢迎消息
- (void)insertWelcomeMessage : (NSString *)text {
    self.welcomeText = text;
}
- (void)insertTipMessageWithText : (NSString *)text {
    
    JHMessage *msg = [[JHMessage alloc] initTipMessage:text senderType:JHMessageSenderTypeOther];
    msg.senderType = JHMessageSenderTypeOther;
    if (msg.senderType == JHMessageSenderTypeOther) {
        [self.userManager getUserInfoWithID:self.receiveAccount handler:^(JHChatUserInfo * _Nonnull userInfo) {
            msg.userInfo = userInfo;
        }];
        
    }else {
        [self.userManager getUserInfoWithID:self.account handler:^(JHChatUserInfo * _Nonnull userInfo) {
            msg.userInfo = userInfo;
        }];
    }
    
    [self.messageList appendObject:msg];
    [self saveLocalMessage:msg];
    if (self.delegate == nil) return;
    [self.delegate insertManagerWithIndex:self.messageList.count - 1];
    
}
#pragma mark - 发送-已读回执
- (void)sendMessageReceipt {
    JHMessage *message = self.messageList.lastObject;
    [self sendMessageReceipt:message];
}
- (void)sendMessageReceipt : (JHMessage *)message {
    NIMMessageReceipt *receipt = [[NIMMessageReceipt alloc] initWithMessage:message.message];
    [[[NIMSDK sharedSDK] chatManager] sendMessageReceipt:receipt
                                              completion:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark - 删除消息
- (void)delegateMessage : (JHMessage *)message {
    [self.messageList removeObject:message];
    [[[NIMSDK sharedSDK] conversationManager] deleteMessage:message.message];
}
- (void)delegateAllLocalMessage {
    [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:self.session option:nil];
}
- (void)clearUnreadCount {
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
}
/// 更新消息
- (void)updateMessage : (JHMessage *)message {
    [[NIMSDK sharedSDK].conversationManager updateMessage:message.message forSession:self.session completion:^(NSError * _Nullable error) {
            
    }];
}
#pragma mark - 撤回消息
- (void)revokeMessage : (JHMessage *)message {
    NSTimeInterval timeInterval = [self getNowDateInterval];
    if (timeInterval - message.message.timestamp > RevokeTime) return;
    BOOL isEdit = false;
    NSString *msgText = @"";
    if (message.messageType == JHMessageTypeText) {
        isEdit = true;
        msgText = message.message.text;
    }
    @weakify(self)
    [[[NIMSDK sharedSDK] chatManager] revokeMessage:message.message completion:^(NSError * _Nullable error) {
        @strongify(self)
        JHMessage *msg = [[JHMessage alloc] initRevokeMessage:message.message.text text:@"您撤回一条消息" isEdit:isEdit];
        msg.message.timestamp = message.message.timestamp;
        NSUInteger index = [self.messageList indexOfObject:message];
        [self.messageList replaceObjectAtIndex:index withObject:msg];
        [self.delegate reloadMessageWithIndex:index];
        [self saveLocalMessage:msg];
    }];
}
#pragma mark - 保存本地消息
- (void)saveLocalMessage : (JHMessage *)message {
    [[NIMSDK sharedSDK].conversationManager saveMessage:message.message forSession:self.session completion:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark - 录音
/// 开始录音
- (void)startRecordAudio {
    if ([[NIMSDK sharedSDK] mediaManager].isPlaying) {
        [[[NIMSDK sharedSDK] mediaManager] stopPlay];
    }
    [[[NIMSDK sharedSDK] mediaManager] record:NIMAudioTypeAAC duration:audioRecordMaxDuration];
}
/// 停止录音
- (void)stopRecordAudio {
    [[[NIMSDK sharedSDK] mediaManager] stopRecord];
}
/// 取消录音
- (void)cancelRecordAudio {
    [[[NIMSDK sharedSDK] mediaManager] cancelRecord];
}
#pragma mark - 播放录音
- (void)startPlayAudio : (NSString *)url {
    if ([[NIMSDK sharedSDK] mediaManager].isPlaying) return;
    [[[NIMSDK sharedSDK] mediaManager] play:url];
}
- (void)stopPlayAudio {
    [[[NIMSDK sharedSDK] mediaManager] stopPlay];
}
#pragma mark - 加载本地消息
- (void)loadMoreLocalMessage {
    [self loadLocalMessages:^(NSInteger count) {
        if (self.delegate == nil) return;
        
        NSInteger index = count - 1;
        if (index < 0) {
            index = 0;
        }
        
        [self.delegate chatManagerReloadDatasWithScrollIndex:index];
    }];
}
- (void)loadLocalMessage : (MesssageCountHandler)handler{
    
    [self loadLocalMessages : handler];
    if (self.delegate == nil) return;
    [self.delegate chatManagerReloadAllDatas];
}
- (void)loadLocalMessages : (MesssageCountHandler)handler {
    NIMMessage *message;
    if (self.messageList.count > 0) {
        message = self.messageList.firstObject.message;
    }
    NSInteger unreadCount = self.unreadCount;
    NSInteger limit = 20;
    
    if (unreadCount > limit) {
        limit = unreadCount;
    }
    
    self.unreadIndex = limit - unreadCount;
    
    limit = limit <= 100 ? limit : 100;
    
    if (self.messageList.count >= 100) {
        @weakify(self)
        [self getHistoryMessages:message limit : limit handler:^(NSArray<NIMMessage *> *list) {
            @strongify(self)
            NSArray *arr = [self getJHMessages:list];
            [self.messageList insertObjects:arr atIndex:0];
            if (handler) {
                handler(arr.count);
            }
        }];
    }else {
        NSArray *list = [self getLocalMessages:limit message:message];
        
        NSArray *arr = [self getJHMessages:list];
        [self.messageList insertObjects:arr atIndex:0];
        if (handler) {
            handler(arr.count);
        }
    }
    
}
- (NSArray *)getLocalMessages : (NSInteger)limit message : (NIMMessage *)message;{
    NSArray *list = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:self.session message:message limit:limit];
    
    return list;
}
#pragma mark - 加载云端消息
- (void)getHistoryMessages : (NIMMessage *)message limit : (NSInteger)limit handler : (MesssageHandler) handler {
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
    option.endTime = message.timestamp;
    option.limit = limit;
    option.sync = true;
    option.currentMessage = message;
    option.order = NIMMessageSearchOrderDesc;
    
    [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:self.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        
        handler(messages.reverseObjectEnumerator.allObjects);
    }];
}
- (NSArray *)getJHMessages : (NSArray<NIMMessage *> *)list {
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NIMMessage *msg in list) {
        JHMessage *message = [[JHMessage alloc] initWithMessage:msg];
//        if (message.customTipInfo.type == JHChatCustomTipTypeEvaluate) {
//            [evaluates appendObject:message];
//            continue;
//        }
        if (message.senderType == JHMessageSenderTypeOther) {
            [self.userManager getUserInfoWithID:self.receiveAccount handler:^(JHChatUserInfo * _Nonnull userInfo) {
                message.userInfo = userInfo;
            }];
        }else {
            [self.userManager getUserInfoWithID:self.account handler:^(JHChatUserInfo * _Nonnull userInfo) {
                message.userInfo = userInfo;
            }];
        }
        
        [arr appendObject:message];
    }
    
//    if (evaluates.count > 0) {
//        // 服务评价
//        JHMessage *model = evaluates.lastObject;
//        BOOL isShow = [model.message.localExt[IsShowEvaluate] boolValue];
//
//        if (isShow == false) {
//            [self.eventSubject sendNext:model.customTipInfo];
//            model.message.localExt = @{IsShowEvaluate : @(true)};
//        }
//
//    }

    return arr;
}
/// 搜索消息
- (void)searchMessageWithStartTime : (NSTimeInterval)startTime
                           endTime : (NSTimeInterval)endTime
                       messageType : (JHMessageType)messageType
                           handler : (JHMesssageHandler) handler{
    
    
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc] init];
    option.startTime = startTime;
    option.endTime = endTime;
    option.limit = 100;
    option.order = NIMMessageSearchOrderDesc;
    option.allMessageTypes = true;
    [[[NIMSDK sharedSDK] conversationManager] searchMessages:self.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        NSArray *arr = [self getJHMessages:messages.reverseObjectEnumerator.allObjects];
        
        NSArray *list = [arr jh_filter:^BOOL(JHMessage * _Nonnull obj, NSUInteger idx) {
            return obj.messageType == messageType;
        }];
        
        if (handler) {
            handler(list);
        }
    }];
}
#pragma mark - SetManager
- (void)setupManager {
    
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
//    [[[NIMSDK sharedSDK] chatManager] addDelegate:self];
    [[[NIMSDK sharedSDK] mediaManager] addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    
}
// 设置apns  payload 用于点击通知栏，跳转对应会话页面
- (void)setupMessageApnsPayload : (NIMMessage *)message {
    if (message == nil) return;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue: @"1" forKey:@"nimCusType"];
    [dict setValue:self.account forKey:@"sessionId"];
    message.apnsPayload = dict;
}
#pragma mark - NIM Message Delegate
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    BOOL isTip = false;
    for (NIMMessage *message in messages) {
        if (![message.session.sessionId isEqualToString:self.session.sessionId]) return;
        
        if (message.messageType == NIMMessageTypeTip) {
            isTip = true;
            break;
        }
        
        JHMessage *messageModel = [[JHMessage alloc] initWithMessage:message];
        messageModel.senderType = JHMessageSenderTypeOther;
        [self.userManager getUserInfoWithID:self.receiveAccount handler:^(JHChatUserInfo * _Nonnull userInfo) {
            messageModel.userInfo = userInfo;
        }];
        
        if (messageModel.messageType == JHMessageTypeCustomTip && messageModel.customTipInfo.type != JHChatCustomTipTypeNormal) {
            [self.eventSubject sendNext:messageModel.customTipInfo];
            messageModel.message.localExt = @{IsShowEvaluate : @(true)};
            return;
        }
        [self.messageList appendObject:messageModel];
        [self sendMessageReceipt:messageModel];
        if (self.delegate == nil) return;
        [self.delegate insertManagerWithIndex:self.messageList.count - 1];
    }
    if (isTip) return;
    double msgTime = messages.lastObject.timestamp;
    [self setMessageReceiptsWithTime :msgTime];
}

- (void)onRecvMessageReceipts:(NSArray<NIMMessageReceipt *> *)receipts {
    NIMMessageReceipt *receipt = receipts.lastObject;
    double msgTime = receipt.timestamp;
    [self setMessageReceiptsWithTime :msgTime];
}
- (void)onRecvRevokeMessageNotification:(NIMRevokeMessageNotification *)notification {
    JHMessage *message = [self getMessage:notification.message];
    if ([notification.message.session.sessionId isEqualToString:self.session.sessionId]) return;
    @weakify(self)
    [self.userManager getUserInfoWithID:self.receiveAccount handler:^(JHChatUserInfo * _Nonnull userInfo) {
        @strongify(self)
        NSString *text = [NSString stringWithFormat:@"\"%@\" 撤回一条消息", userInfo.nickName];
        JHMessage *msg = [[JHMessage alloc] initRevokeMessage:message.message.text text:text isEdit:false];
        msg.message.timestamp = notification.timestamp;
        if (message == nil) return;
        
        NSUInteger index = [self.messageList indexOfObject:message];
        if (index >= self.messageList.count) return;
        [self.messageList replaceObjectAtIndex:index withObject:msg];
        [self.delegate reloadMessageWithIndex:index];
        [self saveLocalMessage:msg];
    }];
}

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error {
    
    JHMessage *msg = [self getMessage:message];
    if (error) {
        if (error.code == 7101) { // 已被拉黑
            self.toastText = @"对方拒收了您的消息";
            msg.sendState = JHMessageSendStateBlack;
        }else {
            self.toastText = @"发送失败，请重试";
            msg.sendState = JHMessageSendStateFail;
        }
    }else {
        msg.sendState = JHMessageSendStateSuccess;
    }
    if (self.welcomeText.length > 0 && msg.messageType != JHMessageTypeDate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            usleep(500000);
            [self insertTipMessageWithText:self.welcomeText];
            self.welcomeText = nil;
        });
    }
}

#pragma mark - NIM Record Audio Delegate
// 录音结束
- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error {
    if (error) return ;
    if (self.audioDuration < 1000) {
        self.toastText = @"少于1秒";
        return;
    }
    [self sendMessageWithAudioUrl:filePath account:self.receiveAccount];
}

- (void)recordAudioProgress:(NSTimeInterval)currentTime {
    self.audioDuration = currentTime * 1000;
}
// 取消
- (void)recordAudioDidCancelled {
    
}
#pragma mark - Private
// 这是已读回执 消息状态
- (void)setMessageReceiptsWithTime: (double)time {
    NSArray *list = [self getMessageWithTime:time];
    
    for (JHMessage *message in list) {
        message.isRemoteRead = true;
    }
}
- (JHMessage *)getMessage : (NIMMessage *)message {
    NSArray *list = [self.messageList jh_filter:^BOOL(JHMessage * _Nonnull obj, NSUInteger idx) {
        return [obj.message.messageId isEqualToString: message.messageId];
    }];
    if (list.count == 0) return nil;
    return list.lastObject;
}
- (JHMessage *)getMessageWithId : (NSString *)messageId {
    NSArray *list = [self.messageList jh_filter:^BOOL(JHMessage * _Nonnull obj, NSUInteger idx) {
        return [obj.message.messageId isEqualToString: messageId];
    }];
    if (list.count == 0) return nil;
    return list.lastObject;
}
- (NSArray<JHMessage *> *)getMessageWithTime : (double )time {
    NSArray *list = [self.messageList jh_filter:^BOOL(JHMessage * _Nonnull obj, NSUInteger idx) {
        return obj.messageType != JHMessageTypeTip && obj.messageType != JHMessageTypeDate && obj.message.timestamp <= time && obj.senderType == JHMessageSenderTypeMe && obj.isRemoteRead == false;
    }];
    
    return list;
}
- (JHMessage *)getupMessage : (JHMessage *)message {
    NSInteger index = [self.messageList indexOfObject:message];
    if (index - 1 >= 0) {
        return self.messageList[index - 1];
    }
    return nil;
}
- (JHMessage *)getNextMessage : (JHMessage *)message {
    NSInteger index = [self.messageList indexOfObject:message];
    if (index + 1 < self.messageList.count) {
        return self.messageList[index + 1];
    }
    return nil;
}
- (NSTimeInterval)getNowDateInterval {
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeInterval timeSp = [datenow timeIntervalSince1970];
    return timeSp;
}

#pragma mark - NIM Play Audio Delegate
- (void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
    if (error) {
        self.toastText = @"播放失败，请重试!";
        return;
    }
    if (self.delegate == nil) return;
    [self.delegate audioDidStartPlay];
}
- (void)playAudio:(NSString *)filePath didCompletedWithError:(NSError *)error {
    if (self.delegate == nil) return;
    [self.delegate audioDidPlayCompleted];
}
#pragma mark - Lazy
- (void)setReceiveAccount:(NSString *)receiveAccount {
    _receiveAccount = receiveAccount;
    ////    self.userManager.receiveAccount = receiveAccount;
    //    [self loadLocalMessage];
    self.session = [NIMSession session:receiveAccount type:NIMSessionTypeP2P];
}
- (NSMutableArray<JHMessage *> *)messageList {
    if (!_messageList) {
        _messageList = [NSMutableArray array];
    }
    return _messageList;
}
- (NSMutableArray *)reloadIndexs {
    if (_reloadIndexs) {
        _reloadIndexs = [NSMutableArray array];
    }
    return _reloadIndexs;
}
- (JHChatUserManager *)userManager {
    if (!_userManager) {
        _userManager = [JHChatUserManager sharedManager];
    }
    return _userManager;
}
- (NSInteger)unreadCount {
    return [[NIMSDK sharedSDK].conversationManager recentSessionBySession:self.session].unreadCount;
}
- (RACReplaySubject<JHChatCustomTipInfo *> *)eventSubject {
    if (!_eventSubject) {
        _eventSubject = [RACReplaySubject subject];
    }
    return _eventSubject;
}
@end
