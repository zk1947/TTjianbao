//
//  JHLiveRoomApiManger.h
//  TTjianbao
//
//  Created by lihui on 2020/7/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRoomApiManger : NSObject

#pragma mark -
#pragma mark -  直播间介绍相关

/// 获取直播间信息
/// @param channelLocalId 直播间id
/// @param block 网络请求回调
+ (void)getLiveRoomInfo:(NSString *)channelLocalId
          completeBlock:(HTTPCompleteBlock)block;

/// 删除直播间信息
/// @param channelLocalId 直播间id
/// @param block 网络请求回调
+ (void)deleteLiveRoomInfo:(NSString *)channelLocalId
             completeBlock:(HTTPCompleteBlock)block;

/// 删除直播间主播信息
/// @param broadId 主播id
/// @param block 网络请求回调
+ (void)deleteAnchorInfo:(NSString *)broadId
           completeBlock:(HTTPCompleteBlock)block;


/// 直播间介绍页关注/取消关注用户
/// @param anchorId 直播间id
/// @param status 当前关注状态
/// @param block 网络请求回调
+ (void)follow:(NSString *)anchorId
 currentStatus:(NSInteger)status
 completeBlock:(HTTPCompleteBlock)block;

/// 修改主播的直播状态
/// @param broadId 主播id
/// @param liveState 主播直播状态
/// @param block 网络请求回调
+ (void)modifyLivingState:(NSString *)broadId
                liveState:(NSString *)liveState
            completeBlock:(HTTPCompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
