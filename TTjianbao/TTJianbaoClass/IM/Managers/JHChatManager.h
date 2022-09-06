//
//  JHChatManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHIMHeader.h"
#import "JHMessage.h"
#import <Photos/Photos.h>
#import "JHChatGoodsInfoModel.h"
#import <NIMSDK/NIMSDK.h>
#import "JHChatUserManager.h"
#import "JHChatUserInfo.h"
#import "JHChatCustomTipModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSInteger const RevokeTime = 3 * 60;
static NSInteger const DateInterval = 5 * 60;

typedef void (^MesssageCountHandler)(NSInteger count);
typedef void (^JHMesssageHandler)(NSArray<JHMessage *> *list);

@protocol JHChatManagerDelegate <NSObject>

- (void)insertManagerWithIndex : (NSInteger) index;
- (void)chatManagerReloadAllDatas;
- (void)chatManagerReloadDatasWithScrollIndex : (NSInteger)index;
- (void)audioDidStartPlay;
- (void)audioDidPlayCompleted;
- (void)reloadMessageWithIndex : (NSUInteger)index;
@end

@interface JHChatManager : NSObject
@property (nonatomic, copy) NSString *toastText;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *receiveAccount;
@property (nonatomic, weak) id<JHChatManagerDelegate> delegate;
/// 用户管理
@property (nonatomic, strong) JHChatUserManager *userManager;
@property (nonatomic, strong) NSMutableArray<JHMessage *> *messageList;
/// 未读消息数
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, assign) NSInteger unreadIndex;

/// 操作消息
@property (nonatomic, strong) RACReplaySubject<JHChatCustomTipInfo *> *eventSubject;
//@property (nonatomic, strong) JHChatUserInfo *userInfo;
//@property (nonatomic, strong) JHChatUserInfo *otherInfo;
- (void)loadMoreLocalMessage;
/// 加载更早的历史记录
- (void)loadLocalMessage : (MesssageCountHandler)handler;
/// 重新发送
- (void)resendMessage : (JHMessage *)message;
/// 发送消息
- (void)sendMessage : (JHMessage *)message account : (NSString *)account;
/// 发送图片消息
- (void)sendMessageWithImage : (UIImage *)image thumImage : (UIImage *)thumImage account : (NSString *)account;
/// 发送视频消息
- (void)sendMessageWithVideo : (NSString *)url thumImage : (UIImage *)thumImage account : (NSString *)account;
/// 发送自定义消息
- (void)sendCustomMessage : (JHMessage *)message account : (NSString *)account;
/// 搜索消息
- (void)searchMessageWithStartTime : (NSTimeInterval)startTime
                           endTime : (NSTimeInterval)endTime
                       messageType : (JHMessageType)messageType
                           handler : (JHMesssageHandler) handler;
/// 发送已读回执
- (void)sendMessageReceipt;
/// 插入欢迎消息
- (void)insertWelcomeMessage : (NSString *)text;
/// 插入tip  消息
- (void)insertTipMessageWithText : (NSString *)text;
/// 删除消息
- (void)delegateMessage : (JHMessage *)message;
- (void)delegateAllLocalMessage;
- (void)clearUnreadCount;
/// 更新消息
- (void)updateMessage : (JHMessage *)message;
/// 撤回消息
- (void)revokeMessage : (JHMessage *)message;
/// 开始录音
- (void)startRecordAudio;
/// 停止录音
- (void)stopRecordAudio;
/// 取消录音
- (void)cancelRecordAudio;
/// 播放音频
- (void)startPlayAudio : (NSString *)url;
/// 停止播放音频
- (void)stopPlayAudio;
@end

NS_ASSUME_NONNULL_END
