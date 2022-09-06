//
//  JHSessionListManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSessionListManager.h"
#import "NTESLoginManager.h"
#import "JHChatCouponInfoModel.h"
#import "JHChatCustomTipModel.h"

@interface JHSessionListManager()<NIMConversationManagerDelegate>
@property (nonatomic, copy) NSString *myAccount;
@end
@implementation JHSessionListManager
+ (instancetype)sharedManager
{
    static JHSessionListManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHSessionListManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.myAccount = [JHChatUserManager sharedManager].userAccId;
        [self setupManager];
    }
    return self;
}
-(void)dealloc {
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}
#pragma mark - Public
- (void)getSessionList {
    [self.sessionList removeAllObjects];
    NSArray *list = [[NIMSDK sharedSDK].conversationManager allRecentSessions];
    for (NIMRecentSession *session in list) {
        
        if ([session.session.sessionId isEqualToString:self.myAccount]) continue;
        
        @weakify(self)
        [self getSessionModel:session handler:^(JHSessionModel * _Nonnull model) {
            @strongify(self)
            [self.sessionList appendObject:model];
        }];
        
        // 更新用户信息
        [[JHChatUserManager sharedManager] requestUserInfo:session.lastMessage.session.sessionId handler:^(JHChatUserInfo * _Nonnull userInfo) {
            
        }];
    }
    [self.reloadDataSubject sendNext:nil];
}
/// 获取所有未读消息数
- (NSInteger)getAllUnreadCount {
    return [NIMSDK sharedSDK].conversationManager.allUnreadCount;
}
/// 删除最近会话
- (void)deleteSession : (JHSessionModel *)session {
    [self.sessionList removeObject:session];
    [[NIMSDK sharedSDK].conversationManager deleteRecentSession:session.session];
}
#pragma mark - Private
- (void)getSessionModel : (NIMRecentSession *)session handler : (SessionHandler)handler{
    NIMMessage *message = session.lastMessage;
    
    [JHChatUserManager getUserInfoWithID:session.session.sessionId handler:^(JHChatUserInfo * _Nonnull userInfo) {
        JHSessionModel *model = [[JHSessionModel alloc] init];
        model.nikeName = userInfo.nickName;
        model.iconUrl = userInfo.vatarUrl;
        
        model.session = session;
        model.unreadCount = session.unreadCount;
        model.receiveAccount = session.session.sessionId;
        model.dateText = [self getDateStringWithTime:message.timestamp];
        model.lastMessage = [self getLastMessage: message];
        
        if (handler) {
            handler(model);
        }
    }];
    
    
    
}
- (NSString *)getLastMessage : (NIMMessage *)message {
    NSString *lastMessage = @"";
    switch (message.messageType) {
        case NIMMessageTypeText:
            lastMessage = message.text;
            break;
        case NIMMessageTypeAudio:
            lastMessage = @"[语音]";
            break;
        case NIMMessageTypeImage:
            lastMessage = @"[图片]";
            break;
        case NIMMessageTypeVideo:
            lastMessage = @"[视频]";
            break;
        case NIMMessageTypeCustom:
            lastMessage = [self getCustomLastMessage:message];
            break;
        case NIMMessageTypeTip:
            lastMessage = [self getTipLastMessage: message];
            break;
        default:
            break;
    }
    return lastMessage;
}
- (NSString *)getCustomLastMessage : (NIMMessage *)message {
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    if ([object.attachment isKindOfClass:[JHChatCustomOrderModel class]]) {
        return @"[订单]";
    }else if ([object.attachment isKindOfClass:[JHChatCustomGoodsModel class]]) {
        return @"[商品]";
    }else if ([object.attachment isKindOfClass:[JHChatCustomTipModel class]]) {
        return @"[服务评价]";
    }else if ([object.attachment isKindOfClass:[JHChatCustomCouponModel class]]) {
        return @"[优惠券]";
    }
    return @"";
}
- (NSString *)getTipLastMessage : (NIMMessage *)message {
    NSDictionary *dic = message.localExt;
    if (dic == nil) return @"";
    NSString *type = dic[@"type"];
    if ([type isEqualToString:@"revoke"]) {
        return [self getRevokeLastMessage:message];;
    }else if ([type isEqualToString:@"Tip"]) {
        return [ self getTipCustomLastMessage:message];
    }
    return @"";
}
- (NSString *)getRevokeLastMessage : (NIMMessage *)message {
    NSDictionary *dic = message.localExt;
    if (dic == nil) return @"";
    if (dic[@"text"]) {
        return dic[@"text"];
    }
    return @"";
}
- (NSString *)getTipCustomLastMessage : (NIMMessage *)message {
    NSDictionary *dic = message.localExt;
    if (dic == nil) return @"";
    
    return @"";
}
/// 时间戳获取时间
- (NSString *)getDateStringWithTime : (NSTimeInterval)time {
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
- (JHSessionModel *)getSessionWithID : (NSString *)account {
    NSArray *arr = [self.sessionList jh_filter:^BOOL(JHSessionModel * _Nonnull obj, NSUInteger idx) {
        return [obj.receiveAccount isEqualToString:account];
    }];
    if (arr.count == 0) return nil;
    return arr.lastObject;
}
- (void)deleteSessionFromListWithId : (NSString *)account {
    JHSessionModel *model = [self getSessionWithID:account];
    [self.sessionList removeObject:model];
}
#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount {
    if ([recentSession.session.sessionId isEqualToString:self.myAccount]) return;
    @weakify(self)
    [self getSessionModel:recentSession handler:^(JHSessionModel * _Nonnull model) {
        @strongify(self)
        [self.sessionList insertObject:model atIndex:0];
        [self.reloadDataSubject sendNext:nil];
        [self.insertDataSubject sendNext:model];
    }];
    
}
- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount {
    JHSessionModel *model = [self getSessionWithID:recentSession.session.sessionId];
    model.dateText = [self getDateStringWithTime:recentSession.lastMessage.timestamp];
    model.unreadCount = recentSession.unreadCount;
    model.lastMessage = [self getLastMessage:recentSession.lastMessage];
    [self.reloadSessionData sendNext:model];
}
- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount {
    
}
#pragma mark - init
- (void)setupManager {
    [[JHIMLoginManager sharedManager] imLogin];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
}
#pragma mark - LAZY
- (NSMutableArray<JHSessionModel *> *)sessionList {
    if (!_sessionList) {
        _sessionList = [NSMutableArray array];
    }
    return _sessionList;
}
- (RACReplaySubject *)reloadDataSubject {
    if (!_reloadDataSubject) {
        _reloadDataSubject = [RACReplaySubject subject];
    }
    return _reloadDataSubject;
}
- (RACReplaySubject<JHSessionModel *> *)insertDataSubject {
    if (!_insertDataSubject) {
        _insertDataSubject = [RACReplaySubject subject];
    }
    return _insertDataSubject;
}
- (RACReplaySubject<JHSessionModel *> *)reloadSessionData {
    if (!_reloadSessionData) {
        _reloadSessionData = [RACReplaySubject subject];
    }
    return _reloadSessionData;
}
@end
