//
//  JHLuckyBagBusiniss.h
//  TTjianbao
//
//  Created by zk on 2021/11/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHLuckyBagShowModel.h"
#import "JHLuckyBagRewardModel.h"
#import "JHLuckyBagModel.h"
#import "JHLuckyBagTaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLuckyBagBusiniss : NSObject

///福袋一览
+ (void)loadShowListData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, NSArray *_Nullable resourceArr))completion;

///奖励列表
+ (void)loadRewardData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, NSArray *_Nullable resourceArr))completion;

///商家福袋信息
+ (void)loadLuckyBagMsgData:(void(^)(NSError *_Nullable error, JHLuckyBagModel *_Nullable model))completion;

///发放福袋
+ (void)sendLuckyBagData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, BOOL success, NSString *_Nullable message))completion;

///下架福袋
+ (void)downLuckyBagData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, NSString *_Nullable message))completion;

///用户福袋任务信息
+ (void)loadBagTaskData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, JHLuckyBagTaskModel *_Nullable model))completion;

///发布福袋评论任务
+ (void)sendBagMsgData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, NSString *_Nullable message))completion;

///用户福袋入口信息
+ (void)loadBagEntranceData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, CustomerBagTagModel *_Nullable model))completion;

@end

NS_ASSUME_NONNULL_END
