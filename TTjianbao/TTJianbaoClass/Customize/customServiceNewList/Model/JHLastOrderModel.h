//
//  JHLastOrderModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLastOrderModel : NSObject
/**最后一条订单用*/
@property (copy, nonatomic)NSString * orderCode;//订单编号
@property (copy, nonatomic)NSString * orderStatus;//订单状态
@property (copy, nonatomic)NSString * orderStatusStr;//订单状态字符串
@property (copy, nonatomic)NSString * orderName;//订单名称
@property (copy, nonatomic)NSString * orderImg;//tupian
@property (copy, nonatomic)NSString * isShow;//是否显示
@property (copy, nonatomic)NSString * orderId;//
@end

NS_ASSUME_NONNULL_END
