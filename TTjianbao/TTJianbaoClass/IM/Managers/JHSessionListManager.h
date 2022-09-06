//
//  JHSessionListManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "JHChatUserManager.h"
#import "JHSessionModel.h"
#import "JHChatGoodsInfoModel.h"
#import "JHChatOrderInfoModel.h"
#import "JHIMLoginManager.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^SessionHandler)(JHSessionModel * model);

@interface JHSessionListManager : NSObject
@property (nonatomic, strong) NSMutableArray<JHSessionModel *> *sessionList;
@property (nonatomic, strong) RACReplaySubject *reloadDataSubject;
@property (nonatomic, strong) RACReplaySubject<JHSessionModel *> *insertDataSubject;
@property (nonatomic, strong) RACReplaySubject<JHSessionModel *> *reloadSessionData;
+ (instancetype)sharedManager;
/// 获取所有未读消息数
- (NSInteger)getAllUnreadCount;
- (void)getSessionList;
/// 删除最近会话
- (void)deleteSession : (JHSessionModel *)session;
@end
NS_ASSUME_NONNULL_END
