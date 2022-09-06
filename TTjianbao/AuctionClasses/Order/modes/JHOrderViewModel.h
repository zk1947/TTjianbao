//
//  JHOrderViewMode.h
//  TTjianbao
//
//  Created by jiang on 2019/8/9.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdressMode.h"
#import "JHStoneOfferModel.h"
#import "PayMode.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^JHOrderPayCheckoutHandler)( RequestModel *respondObject ,  NSError *error);
@interface JHOrderViewModel : NSObject

/**
校验订单是否已被购买
 @param order_id order_id description
 @param completion completion description
 */
+ (void)OrderPayCheckWithOrderId:(NSString *)order_id
                                     completion:(JHOrderPayCheckoutHandler)completion;

/**
校验订单是否已被购买 给确认订单和订单详情用
 @param order_id order_id description
 @param completion completion description
 */

+ (void)OrderPayCheckTest2WithOrderId:(NSString *)order_id
                           completion:(JHOrderPayCheckoutHandler)completion;

/**
 获取导出订单PDF 地址
 @param startTime startTime description
 @param endTime endTime description
 @param completion completion description
 */
+ (void)getOrderExportInfoByStartTime:(NSString *)startTime endTime:(NSString*)endTime
completion:(JHApiRequestHandler)completion;



/**
 修改订单地址
 @param orderId orderId description
 @param addresId addresId description
 @param completion completion description
 */
+ (void)alterOrderAddressByOrderId:(NSString *)orderId andAddressId:(NSString*)addresId
                           completion:(JHApiRequestHandler)completion;



/// 订单确认页请求已支付意向金信息
/// @param orderId orderId description
/// @param completion completion description
+ (void)requestOrderIntentionByOrderId:(JHIntentionReqModel *)reqMode completion:(JHApiRequestHandler)completion;
/**
 检验地址信息是否合法
 @param address address description
 @param completion completion description
 */
+ (void)checkOrderAddress:( AdressMode*)address completion:(JHApiRequestHandler)completion;


/// 请求订单详情数据
/// @param orderId 订单id
/// @param completion completion description
+ (void)requestOrderDetail:(NSString *)orderId isSeller:(BOOL)isSeller completion:(JHApiRequestHandler)completion;

/// 请求石头订单详情数据
/// @param orderId 订单id
/// @param completion completion description
//+ (void)requestStoneOrderDetail:(NSString *)orderId isSeller:(BOOL)isSeller completion:(JHApiRequestHandler)completion;
+ (void)requestStoneOrderDetail:(NSString *)orderId isSeller:(BOOL)isSeller stoneId:(NSString *)stoneId completion:(JHApiRequestHandler)completion;

/// 获取订单确认信息
/// @param orderId orderId description
/// @param completion completion description
+ (void)requestOrderConfirmDetail:(NSString *)orderId completion:(JHApiRequestHandler)completion;
/// 确认订单
/// @param reqMode reqMode description
/// @param completion completion description
+ (void)ConfirmOrder:(JHOrderConfirmReqModel *)reqMode  completion:(JHApiRequestHandler)completion;


/// 获取天天特卖商品确认详情
/// @param goodsId goodsId description
/// @param completion completion description
+ (void)requestGoodsConfirmDetail:(JHGoodsOrderDetailReqModel *)reqMode  completion:(JHApiRequestHandler)completion;
/// 生成特卖订单
/// @param reqMode reqMode description
/// @param completion completion description
+ (void)ConfirmGoodsOrder:(JHOrderConfirmReqModel *)reqMode  completion:(JHApiRequestHandler)completion;


/// 提醒发货
/// @param orderId orderId description
/// @param completion completion description
+ (void)remindOrderSend:(NSString *)orderId  completion:(JHApiRequestHandler)completion;


/// 精品商城获取订单数据
/// @param reqMode reqMode description
/// @param completion completion description
+ (void)requestNewStoreConfirmDetail:(JHNewStoreOrderDetailReqModel *)reqMode  completion:(JHApiRequestHandler)completion;

+ (void)requestNewStoreConfirmDetailC2C:(JHNewStoreOrderDetailReqModel *)reqMode  completion:(JHApiRequestHandler)completion;

/// 精品商城创建订单
/// @param reqMode reqMode description
/// @param completion completion description
+ (void)ConfirmNewStoreOrder:(JHOrderConfirmReqModel *)reqMode  completion:(JHApiRequestHandler)completion;

+ (void)buildOrderC2cOrder:(JHOrderConfirmReqModel *)reqMode  completion:(JHApiRequestHandler)completion;
/// c2c 确认订单
+ (void)mekeOrderC2cOrder:(NSDictionary *)dict  completion:(JHApiRequestHandler)completion;
@end

NS_ASSUME_NONNULL_END
