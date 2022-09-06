//
//  JHMyCenterDotModel.h
//  TTjianbao
//
//  Created by apple on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESLiveViewDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterDotModel : NSObject

/// 待上架数
@property (nonatomic, assign) NSInteger shelveCount;

/// 待付款数（主播、助理查看客户待付款数）
@property (nonatomic, assign) NSInteger waitPayCount;

/// 待付款数（买家
@property (nonatomic, assign) NSInteger buyerWaitPayCount;

/// 待鉴定（买家）
@property (nonatomic, assign) NSInteger waitAppraisalCount;

/// 待收货（买家）
@property (nonatomic, assign) NSInteger waitReceivedCount;

/// 待评价（买家）
@property (nonatomic, assign) NSInteger waitEvaluateCount;

/// 待发货数（商家）
@property (nonatomic, assign) NSInteger waitSendCount;

/// 退款售后数（商家）
@property (nonatomic, assign) NSInteger serviceAfterRefundCount;

/// 我的出价（买家）
@property (nonatomic, assign) NSInteger myOfferCount;

/// 有人出价（买家）
@property (nonatomic, assign) NSInteger offerCount;


/// 代付款  公用
@property (nonatomic, assign) NSInteger customRedPointWaitPayCount;
//定制服务用户
/// 全部订单
@property (nonatomic, assign) NSInteger customRedPointAllCount;
/// 进行中
@property (nonatomic, assign) NSInteger customRedPointInProcessCount;
/// 待收货
@property (nonatomic, assign) NSInteger customRedPointWaitReceiveCount;
/// 已完成
@property (nonatomic, assign) NSInteger CustomRedPointFinishCount;

//定制服务主播
/// 定制待收货  waitCustomizerReceive
@property (nonatomic, assign) NSInteger customNumPointwaitCustomizerReceive;
/// 定制中  customizing
@property (nonatomic, assign) NSInteger customNumPointcustomizing;
/// 定制方案中  customizerPlaning
@property (nonatomic, assign) NSInteger customNumPointcustomizerPlaning;
/// 定制待发货  weitSendCount
@property (nonatomic, assign) NSInteger CustomNumPointweitSendCount;

///回收相关  ---- TODO lihui 21.04.10
///待付款
@property (nonatomic, assign) NSInteger recycleRedPointWillPayCount;
///待发货
@property (nonatomic, assign) NSInteger recycleRedPointWillSendCount;
///待收货
@property (nonatomic, assign) NSInteger recycleRedPointDidSendCount;
///待确认价格
@property (nonatomic, assign) NSInteger recycleRedPointWillConfirmPrice;
///回收订单的红点集合
@property (nonatomic, copy) NSDictionary *recycleOrderCount;

@property (nonatomic, assign) NSInteger recycleMyPublishCount; /// 回收-我发布的(买家)
@property (nonatomic, assign) NSInteger recycleMySoldCount; /// 回收-我卖出的(买家)
@property (nonatomic, assign) NSInteger recyclePoolCount; /// 回收池红点(卖家)


///////// 商城的
/// 昨日成交 金额  单位：元
@property (nonatomic,   copy) NSString *shopAllDealStr;
/// 昨日成交 金额  单位：分
@property (nonatomic, assign) NSInteger shopAllDeal;
/// 本月总成交 数目或者金额  单位：元
@property (nonatomic,   copy) NSString *shopMonthAllDeal;
/// 较昨日比率 示例 120%
@property (nonatomic,   copy) NSString *shopComparedYesterdayRate;


/////// 直播间的
/// 昨日成交 金额  单位：元
@property (nonatomic,   copy) NSString *liveAllDealStr;
/// 昨日成交 金额  单位：分
@property (nonatomic, assign) NSInteger liveAllDeal;
/// 本月总成交 数目或者金额  单位：元
@property (nonatomic,   copy) NSString *liveMonthAllDeal;
/// 较昨日比率 示例 120%
@property (nonatomic,   copy) NSString *liveComparedYesterdayRate;

@property (nonatomic, assign) NSInteger imageTextAppraiserSwitch;//图文鉴定师接单状态 0关闭 1开启
@property (nonatomic, assign) NSInteger waitAppraisalNum;//图文鉴定师待鉴定数量

@property (nonatomic, assign) NSInteger fundWaitManageCount;//资金待管理数"

@property (nonatomic, copy) dispatch_block_t block;

+ (instancetype)shareInstance;

+ (void)requestDataWithType:(NSNumber *)type block:(dispatch_block_t)block;
///区分业务线的方法
+ (void)requestDataWithType:(NSNumber *)type contentType:(NSInteger)bussId block:(dispatch_block_t)block;
+ (void)requestCustomizeDataWithType:(NSNumber *)type block:(dispatch_block_t)block;
/// 电商订单消息改变
+ (void)changeOrderMessageCount:(NSDictionary *)sender;

/// 直播间出价
+ (void)changeBidMessageCount:(NSDictionary *)sender type:(NTESLiveCustomNotificationType)type;


/// 店铺数据
/**
 字段名称            字段说明    类型    必填（是 Y、否 N）    备注
 sellerCustomerId    商家id    Long       Y
 businessType        类型       Integer    N              0 所有 1 直播间 2 商城
 statisticsDays      筛选近天数    Integer    N            如：1 昨天 7 近七天 30 近30天
 statisticsType      检索页面类型    Integer    Y          1 成交金额 2成交单数 3成交人数 4客单价
 */
+ (void)shopDataRequest:(NSString *)sellerCustomerId
           businessType:(NSString *)businessType
         statisticsDays:(NSString *)statisticsDays
         statisticsType:(NSString *)statisticsType
                  block:(dispatch_block_t)block;

@end

@interface JHMyCenterOrderDotModel : NSObject
/// 待支付订单 +1 0 -1
@property (nonatomic, assign) NSInteger customerWaitPay;

/// 用户待鉴定订单 +1 0 -1
@property (nonatomic, assign) NSInteger customerWaitAppraise;

/// 用户待收货订单 +1 0 -1
@property (nonatomic, assign) NSInteger customerWaitReceive;

/// 用户待评价订单 +1 0 -1
@property (nonatomic, assign) NSInteger customerWaitEval;

/// 商家待支付订单 +1 0 -1
@property (nonatomic, assign) NSInteger sellerWaitCustomerPay;

///商家待发货订单 +1 0 -1
@property (nonatomic, assign) NSInteger sellerWaitSent;

///商家退款售后订单 +1 0 -1
@property (nonatomic, assign) NSInteger sellerRefunding;

@end



@interface JHMyCenterShopDataModel : NSObject
/// 昨日成交 金额  单位：元
@property (nonatomic,   copy) NSString *allDealStr;
/// 昨日成交 金额  单位：分
@property (nonatomic, assign) NSInteger allDeal;
/// 本月总成交 数目或者金额  单位：元
@property (nonatomic,   copy) NSString *monthAllDeal;
/// 较昨日比率 示例 120%
@property (nonatomic,   copy) NSString *comparedYesterdayRate;
@end



   
    



NS_ASSUME_NONNULL_END
