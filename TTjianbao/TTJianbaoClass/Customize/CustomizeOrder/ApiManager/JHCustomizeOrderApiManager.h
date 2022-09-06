//
//  JHCustomizeOrderApiManager.h
//  TTjianbao
//
//  Created by jiangchao on 2020/11/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCustomizeOrderModel.h"
#import "JHCustomizeLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeOrderApiManager : NSObject

//定制订单详情接口
+ (void)requestCustomizeOrderDetail:(NSString *)orderId isSeller:(BOOL)isSeller Completion:(void(^)(NSError *error, JHCustomizeOrderModel* orderModel))completion;



/// 物流信息
+ (void)requestCustomizeLogistics:(NSString *)orderId
                         userType:(NSString *)userType
                       Completion:(void(^)(NSError *_Nullable error, NSArray<JHCustomizeLogisticsFinalModel *>* _Nullable models))completion;


@end

NS_ASSUME_NONNULL_END
