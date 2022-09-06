//
//  CSQOrderModel.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/9.
//  Copyright © 2019 Netease. All rights reserved.
//  社区-获取订单id
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSQOrderModel : NSObject

@property (nonatomic, copy) NSString *orderCode; //order_code
@property (nonatomic, copy) NSString *orderId; //ttjb_order_id

@end

NS_ASSUME_NONNULL_END
