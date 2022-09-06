//
//  PayMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/2/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "TTjianbaoUtil.h"
#import "WXPayDataMode.h"

@interface PayWayMode : NSObject
@property (strong,nonatomic)NSString * icon;
@property (assign,nonatomic)int Id;
@property (assign,nonatomic)BOOL isDefault;
@property (strong,nonatomic)NSString * name;
@property (assign,nonatomic)int sort;
@property (strong,nonatomic)NSString * remarks;


@end

@interface JHOrderConfirmReqModel : NSObject

@property (nonatomic, strong) NSString *orderDesc;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *onlyGoodsId;
@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *sellerCouponId;
@property (nonatomic, strong) NSString *discountCouponId;
@property (nonatomic, strong) NSString *useMounty;
@property (nonatomic, strong) NSString *bountyAmount;
@property (nonatomic, strong) NSString *orderCategory;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, assign)   NSInteger goodsCount;///商品数量
@property (nonatomic, strong) NSString *showId;//专场id
@property (nonatomic, strong) NSString *needPayMoney;//抵扣完需要支付的金额
/// 0是其他，1是闪购
@property (nonatomic, assign) NSInteger buyType;

//原石所属的订单id,个人转售时候用
@property(copy,nonatomic) NSString *parentOrderId;
@end


@interface JHGoodsOrderDetailReqModel : NSObject
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString *orderCategory;
@property (nonatomic, assign) NSInteger goodsCount;///商品数量
@property (nonatomic,   copy) NSString *source;   ///页面来源
@property (nonatomic, assign) NSInteger buyType;
@end

//商城改版
@interface JHNewStoreOrderDetailReqModel : NSObject
@property (nonatomic, strong) NSString *showId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, assign) NSInteger productCount;///商品数量
@property (nonatomic, strong) NSString *orderCategory;
@end

@interface JHPrepayReqModel : NSObject
@property (nonatomic, strong) NSString *payId;
@property (nonatomic, strong) NSString *portalEnum;
@property (nonatomic, strong) NSString *payMoney;
//商机资金支付id
@property (nonatomic, strong) NSString *shopRecordId;
//订单支付id
@property (nonatomic, strong) NSString *orderId;

@end

@interface JHRedPacketPrepayReqModel : NSObject
@property (nonatomic, assign) int remainUsed;
@property (nonatomic, strong) NSString *payWay;
@property (nonatomic, strong) NSString *redPacketId;
@property (nonatomic, strong) NSString *portalEnum;

@end

@interface JHRedPacketPrepayRespModel : NSObject
@property (nonatomic, strong) NSString *outTradeNo;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *relevanceId;
@property (nonatomic, strong) NSString *payWay;
@end

@interface JHIntentionReqModel : NSObject
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *goodsCode;
@end

@interface PayMode : NSObject

/// 请求订单支付方式
/// @param orderId orderId description
/// @param completion completion description
+ (void)requestOrderPayWays:(NSString *)orderId  completion:(JHApiRequestHandler)completion;

/// 订单微信预支付
/// @param reqMode reqMode description
/// @param completion completion description
+ (void)WXOrderPrepay:(JHPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion;

/// 订单支付宝预支付
/// @param reqMode reqMode description
/// @param completion completion description
+ (void)ALiOrderPrepay:(JHPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion;

/// 订单查询结果
/// @param outTradeNo outTradeNo description
/// @param completion completion description
+ (void)requestOrderPayStatus:(NSString *)outTradeNo  completion:(JHApiRequestHandler)completion;
+ (void)requestRecycleOrderPayStatus:(NSString *)outTradeNo  completion:(JHApiRequestHandler)completion;
/// 微信支付
/// @param pay pay description
+(void)WXPay:(WXPayDataMode*)pay;

/// 支付宝支付
/// @param orderString orderString description
+(void)AliPay:(NSString*)orderString callback:(JHActionBlock)completionBlock;

/// 支付方式排序
/// @param array array description
+(NSArray *)sortbyPay:(NSArray *)array;


/// 红包预支付
/// @param reqMode reqMode description
/// @param completion completion description
+ (void)redPacketPrepay:(JHRedPacketPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion;

/// 红包支付结果查询
/// @param outTradeNo outTradeNo description
/// @param completion completion description
+ (void)requestPacketPayStatus:(NSString *)outTradeNo  completion:(JHApiRequestHandler)completion;


/// 调起银联支付
/// @param type 支付类型 参看JHPayType
/// @param data 数据
/// @param block 回调
+ (void)unionPayWithType:(JHPayType)type
                    data:(id)data
            completBlock:(JHActionBlock)block;


//商机资金微信预支付
+ (void)WXShopPrepay:(JHPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion;

//商机资金支付宝预支付
+ (void)ALiShopPrepay:(JHPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion;
@end

