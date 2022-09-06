//
//  JHRecycleOrderPurseViewModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleOrderPursueModel.h"
#import "JHRecycleLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderPurseViewModel : NSObject

///订单流转数据
+ (void)getOrderPursueList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSArray<JHRecycleOrderPursueModel *> *_Nullable array))completion;

/// 回收物流信息查询
+ (void)getRecycleLogisticsList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, JHRecycleLogisticsModel *_Nullable logisticsModel))completion;

/// 直发物流信息查询
+ (void)getZhifaLogisticsList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, JHRecycleLogisticsModel *_Nullable logisticsModel))completion;
@end

NS_ASSUME_NONNULL_END
