//
//  JHRecycleOrderBusinessCheck.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleOrderBusinessModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^detailInfoBlock)(JHRecycleOrderBusinessModel * _Nullable respondObject);


@interface JHRecycleOrderBusinessCheck : NSObject

/// 获取回收商验证信息
/// orderId : 订单ID
+ (void)getBusinessInfoWithOrderId : (NSString *)orderId
                    successBlock:(detailInfoBlock) success
                    failureBlock:(failureBlock)failure;

@end

NS_ASSUME_NONNULL_END
