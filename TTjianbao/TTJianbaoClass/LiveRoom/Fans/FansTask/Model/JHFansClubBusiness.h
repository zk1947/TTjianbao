//
//  JHFansClubBusiness.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHFansClubModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHFansClubBusiness : NSObject
/// 上报粉丝任务
/// @param taskType taskType description
/// @param anchorId anchorId description
/// @param channelId channelId description
/// @param customerId customerId description
+ (void)FansTaskReport:(JHFansTaskType )taskType anchorId:(NSString*)anchorId  channelId:(NSString*)channelId customerId:(NSString*)customerId;

/// 获取任务列表数据
/// @param clubId clubId description
/// @param completion completion description
+ (void)getFansClubInfo:(NSString *)clubId completion:(JHApiRequestHandler)completion;

/// 获取粉丝列表头部数据
/// @param anchorId anchorId description
/// @param completion completion description
+ (void)getFansClubTitle:(NSString *)anchorId completion:(JHApiRequestHandler)completion;

/// 获取粉丝列表
/// @param anchorId anchorId description
/// @param pageNo pageNo description
/// @param pageSize pageSize description
/// @param completion completion description
+ (void)getFansList:(NSString *)anchorId  pageNo:(NSInteger)pageNo  pageSize:(NSInteger)pageSize  completion: (JHApiRequestHandler)completion;

+ (void)checkAndSendReward:(NSString *)anchorId completion:(JHApiRequestHandler)completion;
@end

NS_ASSUME_NONNULL_END
