//
//  UserFriendApiManager.h
//  TTjianbao
//
//  Created by wuyd on 2019/9/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CUserFriendModel;

NS_ASSUME_NONNULL_BEGIN

@interface UserFriendApiManager : NSObject

///请求关注或粉丝列表
+ (void)request_userFriendList:(CUserFriendModel *)model completeBlock:(HTTPCompleteBlock)block;

//关注 post
+ (void)followWithUserId:(NSInteger)userId fansCount:(NSInteger)fansCount completeBlock:(HTTPCompleteBlock)block;

//取消关注 delete
+ (void)cancelFollowWithUserId:(NSInteger)userId fansCount:(NSInteger)fansCount completeBlock:(HTTPCompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
