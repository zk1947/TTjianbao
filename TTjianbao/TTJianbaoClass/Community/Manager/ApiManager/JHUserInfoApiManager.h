//
//  JHUserInfoApiManager.h
//  TTjianbao
//
//  Created by lihui on 2020/6/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHPersonalInfoType) {
    ///评论过
    JHPersonalInfoTypeComment = 1,
    ///发布过
    JHPersonalInfoTypePublish = 2,
    ///赞过
    JHPersonalInfoTypeLike = 3,
};

@interface JHUserInfoApiManager : NSObject

/// 获取用户信息
/// @param user_id 用户id
/// @param success 成功的block回调
/// @param failure 失败的block回调
+ (void)homePageWithUserId:(NSString *)user_id
success:(void (^)(RequestModel *request))success
                   failure:(void (^)(RequestModel *request))failure;


/// 取消关注用户
/// @param userId 用户id
/// @param fansCount 用户粉丝数量
/// @param block 网络请求回调
+ (void)cancelFollowUserAction:(NSString *)userId
                     fansCount:(NSInteger)fansCount
                 completeBlock:(HTTPCompleteBlock)block;

/// 关注用户
/// @param userId 用户id
/// @param fansCount 粉丝数量
/// @param block 网络请求回调
+ (void)followUserAction:(NSString *)userId
               fansCount:(NSInteger)fansCount
           completeBlock:(HTTPCompleteBlock)block;


/// 获取个人中心足迹统计信息
/// @param userId 用户id
/// @param block 网络请求回调
+ (void)getUserHistoryStasticsWithUserId:(NSString *)userId
                           CompleteBlock:(HTTPCompleteBlock)block;


/// 获取个人中心足迹（评过发过/赞过）
/// @param type 足迹烈性
/// @param userId 用户id
/// @param page 页数
/// @param lastId 最后一个帖子的id
/// @param block 网络请求回调
+ (void)getUserHistory:(JHPersonalInfoType)type
                UserId:(NSString *)userId
                  Page:(NSInteger)page
                LastId:(NSString *)lastId
         CompleteBlock:(HTTPCompleteBlock)block;


/// 评过列表点赞
/// @param itemType 帖子类型
/// @param itemId 帖子id
/// @param likeNum 点赞数量
/// @param block 网络请求回调
+ (void)sendCommentLikeRequest:(NSInteger)itemType
                        itemId:(NSString *)itemId
                       likeNum:(NSInteger)likeNum
                         block:(HTTPCompleteBlock)block;

/// 评过列表取消点赞
/// @param itemType 帖子类型
/// @param itemId 帖子id
/// @param likeNum 点赞数量
/// @param block 网络请求回调
+ (void)sendCommentUnLikeRequest:(NSInteger)itemType
                          itemId:(NSString *)itemId
                         likeNum:(NSInteger)likeNum
                           block:(HTTPCompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
