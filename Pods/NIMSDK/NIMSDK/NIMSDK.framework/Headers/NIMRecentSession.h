//
//  NIMRecentSession.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NIMMessage;
@class NIMSession;

/**
 *  最近会话
 */
@interface NIMRecentSession : NSObject

/**
 *  当前会话
 */
@property (nullable,nonatomic,readonly,copy)   NIMSession  *session;

/**
 *  最后一条消息
 */
@property (nullable,nonatomic,readonly,strong)   NIMMessage  *lastMessage;

/**
 *  未读消息数
 */
@property (nonatomic,readonly,assign)   NSInteger   unreadCount;

/**
 *  本地扩展
 */
@property (nullable,nonatomic,readonly,copy) NSDictionary *localExt;

@end


/**
 *  检索最近会话选项
 */
@interface NIMRecentSessionOption : NSObject

/**
 *  最后一条消息过滤
 *  @discusssion 最近会话里lastMessage为非过滤类型里的最后一条。例：@[@(NIMMessageTypeNotification)],
 *  表示返回的最近会话里lastMessage是最后一条非NIMMessageTypeNotification类型的消息。
 */
@property (nonatomic, strong) NSArray<NSNumber *> *filterLastMessageTypes;

@end

NS_ASSUME_NONNULL_END
