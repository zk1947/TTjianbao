//
//  JHServiceManageBusiness.h
//  TTjianbao
//
//  Created by zk on 2021/7/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHServiceManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHServiceManageBusiness : NSObject

///获取自动回复列表
+ (void)getServiceList:(NSString *)anchorId Completion:(void(^)(NSError *_Nullable error, JHServiceManageModel *_Nullable model))completion;

///店铺快捷回复添加
+ (void)addServiceData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, BOOL isSuccess))completion;

///店铺快捷回复编辑
+ (void)editServiceData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, BOOL isSuccess))completion;

+(void)logProperty:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
