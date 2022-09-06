//
//  JHSessionModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface JHSessionModel : NSObject
/// 头像
@property (nonatomic, copy) NSString *iconUrl;
/// 名称
@property (nonatomic, copy) NSString *nikeName;
/// 最后一条消息
@property (nonatomic, copy) NSString *lastMessage;
/// 时间
@property (nonatomic, copy) NSString *dateText;
/// 未读消息树
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, copy) NSString *receiveAccount;
@property (nonatomic, strong) NIMRecentSession *session;
@end

NS_ASSUME_NONNULL_END
