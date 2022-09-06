//
//  JHDiscoverChannelViewModel.h
//  TTjianbao
//
//  Created by mac on 2019/5/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RequestModel;

@interface JHDiscoverChannelViewModel : NSObject

/**
 获取频道列表 用于冷启动页
 
 @param deviceId iPhone设备唯一标志
 @param success success description
 @param failure failure description
 */
+ (void)getChannelListWithSuccess:(void (^)(RequestModel *request))success
                          failure:(void (^)(RequestModel *request))failure;


/**
 提交选择频道： 用于更新发现页的channel 和更新本地保存的channel数据
 
 @param channelIds 频道id拼接串
 @param success success description
 @param failure failure description
 */
+ (void)submitChannelWithIds:(NSString *)channelIds
                     success:(void (^)(RequestModel *request))success
                     failure:(void (^)(RequestModel *request))failure;


/**
 获取已选频道列表 专门用来发现页面的viewdidLoad方法中 和更新本地保存的channel数据
 
 @param success success description
 @param failure failure description
 */
+ (void)getSelectedChannelListWithSuccess:(void (^)(RequestModel *request))success
                                  failure:(void (^)(RequestModel *request))failure;


/**
 
 获取频道分类列表
 
 @param channelId 频道分类id
 @param success success description
 @param failure failure description
 */
+ (void)getChannelCateListWithChannel_id:(NSInteger)channelId
                               direction:(NSString *)direction
                                 last_id:(NSString *)last_id
                                    page:(NSInteger)page
                                 success:(void (^)(RequestModel *request))success
                                 failure:(void (^)(RequestModel *request))failure;


/**
 不喜欢推荐用户（首页的关注栏的推荐宝友）或者发现首页（不感兴趣）
 
 @param user_id user_id 用户id
 @param success success description
 @param failure failure description
 */
+ (void)deleteRecommentUserWithItem_type:(NSInteger)item_type
                                 item_id:(NSString *)item_id
                              entry_type:(NSInteger)entry_type
                                entry_id:(NSString *)entry_id
                                 success:(void (^)(RequestModel *request))success
                                 failure:(void (^)(RequestModel *request))failure;


/**
 关注用户
 
 @param user_id 用户id
 @param success success description
 @param failure failure description
 */
+ (void)focusRecommentUserWithUserId:(NSString *)user_id
                          fans_count:(NSInteger)fans_count
                             success:(void (^)(RequestModel *request))success
                             failure:(void (^)(RequestModel *request))failure;


/**
 取消关注

 @param user_id user_id description
 @param success success description
 @param failure failure description
 */
+ (void)cancleFocusRecommentUserWithUserId:(NSString *)user_id
                                fans_count:(NSInteger)fans_count
                                   success:(void (^)(RequestModel *request))success
                                   failure:(void (^)(RequestModel *request))failure;


/**
 点赞

 @param item_id item_id description
 @param item_type item_type description
 @param item_like_count item_like_count description
 @param success success description
 @param failure failure description
 */
+ (void)likeItemWithItemid:(NSString *)item_id
                 item_type:(NSInteger)item_type
             itemLikeCount:(NSInteger)item_like_count
                   success:(void (^)(RequestModel *request))success
                   failure:(void (^)(RequestModel *request))failure;


/**
  取消点赞

 @param item_id item_id description
 @param item_type item_type description
 @param item_like_count item_like_count description
 @param success success description
 @param failure failure description
 */
+ (void)cancleLikeItemWithItemid:(NSString *)item_id
                 item_type:(NSInteger)item_type
             itemLikeCount:(NSInteger)item_like_count
                   success:(void (^)(RequestModel *request))success
                   failure:(void (^)(RequestModel *request))failure;


/**
 删除帖子
 
 @param item_id item_id
 @param item_type item_type
 */
+ (void)deleteContentWithItemId:(NSString *)item_id
                       itemType:(NSInteger)item_type
                        success:(void (^)(RequestModel *request))success
                        failure:(void (^)(RequestModel *request))failure;

+ (void)getHotTopicList:(succeedBlock)success failure:(failureBlock)failure;

/**
获取关注状态

@param success
@param failure
*/
+ (void)getFollowStatus:(void (^)(RequestModel *request))success failure:(void (^)(RequestModel *request))failure;

@end

NS_ASSUME_NONNULL_END
