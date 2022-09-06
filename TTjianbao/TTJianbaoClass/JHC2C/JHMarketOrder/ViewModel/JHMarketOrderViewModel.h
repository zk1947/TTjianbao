//
//  JHMarketOrderViewModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMarketOrderModel.h"
#import "JHMarketPublishModel.h"
#import "JHMarketProductAuthModel.h"
#import "JHIssueGoodsEditModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketOrderViewModel : NSObject
///获取卖出的列表的接口
+ (void)getOrderList:(NSMutableDictionary *)params isBuyer:(BOOL)isBuyer Completion:(void (^)(NSError * _Nullable error, NSArray<JHMarketOrderModel *> *_Nullable array))completion;

///订单详情
+ (void)orderDetail:(NSMutableDictionary *)params isBuyer:(BOOL)isBuyer Completion:(void (^)(NSError * _Nullable error, JHMarketOrderModel *_Nullable orderModel))completion;

///取消订单接口
+ (void)cancelOrder:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///修改价格接口
+ (void)updatePrice:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///提醒发货
+ (void)remindShip:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///确认收货
+ (void)signOrder:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///删除订单
+ (void)deleteOrder:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;
/// 删除商品-我发布的
+ (void)deletePublishGoods : (NSString *)productId Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;
///提醒收货
+ (void)remindReceipt:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///申请退款页面
+ (void)refundDetailRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///申请退款
+ (void)refundRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///评价订单
+ (void)commentRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///关闭交易
+ (void)closeOrder:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///获取退款页面数据
+ (void)getRefundDetailData:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;



///获取发布的列表的接口
+ (void)getPublishList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSArray<JHMarketPublishModel *> *_Nullable array, NSInteger exposureNum, BOOL polished))completion;

///查询单条信息
+ (void)getSinglePublishList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSArray<JHMarketPublishModel *> *_Nullable array))completion;

///擦亮接口
+ (void)highlightPublishList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///上下架商品
+ (void)updateGoodsStatus:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///修改商品价格
+ (void)updateProductPrice:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;


///鉴定订单确认详情
+ (void)confirmAppriaseOrderDetail:(NSDictionary *)params completion:(JHApiRequestHandler)completion;


///鉴定订单预支付
+ (void)appriaseOrderPreparePay:(NSDictionary *)params completion:(JHApiRequestHandler)completion;

///一键鉴定下单
+ (void)appriaseProductAuth:(NSDictionary *)params Completion:(void (^)(NSError * _Nullable error, JHMarketProductAuthModel *_Nullable model))completion;

+ (void)getEditGoodsData:(NSDictionary *)params Completion:(void (^)(NSError * _Nullable error, JHIssueGoodsEditModel *_Nullable model))completion;

@end

NS_ASSUME_NONNULL_END
