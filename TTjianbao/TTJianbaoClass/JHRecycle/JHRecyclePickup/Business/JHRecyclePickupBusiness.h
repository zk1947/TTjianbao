//
//  JHRecyclePickupBusiness.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecyclePickupBusiness : NSObject
//未预约-预约取件信息
+ (void)requestRecyclePickupGoToAppointmentWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

//提交预约取件
+ (void)requestRecyclePickupAppointmentSubmitWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

//已预约-上门取件内容
+ (void)requestRecyclePickupAppointmentSuccessWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
