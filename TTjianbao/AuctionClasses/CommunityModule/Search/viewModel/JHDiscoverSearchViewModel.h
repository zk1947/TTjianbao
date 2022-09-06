//
//  JHDiscoverSearchViewModel.h
//  TTjianbao
//
//  Created by mac on 2019/5/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHDiscoverSearchViewModel : NSObject

/**
 社区热门话题

 @param channelId channelId description
 @param success success description
 @param failure failure description 
 */
+ (void)getSearchKeyWordWithChannel_id:(NSInteger)channelId
                               success:(void (^)(RequestModel *request))success
                               failure:(void (^)(RequestModel *request))failure;


/// 社区热搜词接口
/// @param block 请求成功| 失败的回调
+ (void)getHotKeyHordData:(HTTPCompleteBlock)block;
///获取直播热搜词
+ (void)getLiveHotKeyHordData:(HTTPCompleteBlock)block;
///获取商城热搜词
+ (void)getStoreHotKeyHordData:(HTTPCompleteBlock)block;
///获取C2C热搜词
+ (void)getC2CHotKeyHordData:(HTTPCompleteBlock)block;

/**
  搜索

 @param channel_id channel_id description
 @param q q description
 @param type 0:全部 1:求鉴定 2:可售
 @param page page description
 @param success success description
 @param failure failure description
 */

//未用到
//+ (void)searchInfoWithChannelId:(NSInteger)channel_id
//                              q:(NSString *)q
//                           type:(NSString *)type
//                           page:(NSInteger)page
//                        success:(void (^)(RequestModel *request))success
//                        failure:(void (^)(RequestModel *request))failure;
@end

NS_ASSUME_NONNULL_END
