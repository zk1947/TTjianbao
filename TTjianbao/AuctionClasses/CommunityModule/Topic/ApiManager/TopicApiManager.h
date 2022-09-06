//
//  TopicApiManager.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/1.
//  Copyright © 2019 Netease. All rights reserved.
//  话题Api
//

#import <Foundation/Foundation.h>
@class CTopicModel;
@class CTopicDetailModel;
@class CSaleListModel;

NS_ASSUME_NONNULL_BEGIN

//typedef void (^HTTPCompleteBlock)(id _Nullable respObj, BOOL hasError);

@interface TopicApiManager : NSObject

///全部话题列表页 - 获取全部话题列表（分页）
+ (void)request_topicList:(CTopicModel *)model completeBlock:(HTTPCompleteBlock)block;

///全部话题列表页 - 搜索（分页）
+ (void)request_searchAllTopicList:(CTopicModel *)model keyword:(nullable NSString *)keyword completeBlock:(HTTPCompleteBlock)block;

/**
 发帖 -> 话题选择页 -> 搜索话题列表
 keyword为空 表示搜索全部
 */
+ (void)request_topicListWithKeyword:(nullable NSString *)keyword completeBlock:(HTTPCompleteBlock)block;

///获取话题首页（详情）数据
+ (void)request_topicDetail:(CTopicDetailModel *)model completeBlock:(HTTPCompleteBlock)block;
///话题首页（详情）刷新/加载更多 推荐列表
+ (void)request_topicDetailRefresh:(CTopicDetailModel *)model completeBlock:(HTTPCompleteBlock)block;

///获取特卖列表
+ (void)request_saleList:(CSaleListModel *)model completeBlock:(HTTPCompleteBlock)block;

/**
 * 请求订单id <ttjb_order_id>
 * @param itemId 特卖信息中的itemId
 */
+ (void)request_orderID:(NSString *)itemId completeBlock:(HTTPCompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
