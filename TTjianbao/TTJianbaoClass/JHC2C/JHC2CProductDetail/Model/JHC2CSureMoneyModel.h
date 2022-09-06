//
//  JHC2CSureMoneyModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSureMoneyModel : NSObject

@property (nonatomic, copy) NSString* orderId;

@property (nonatomic, copy) NSString* orderCode;

@property (nonatomic, copy) NSString* orderStatus;

@property (nonatomic, copy) NSString* goodsName;

@property (nonatomic, copy) NSString* payExpireTime;


@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface JHC2CAuctionRefershModel : NSObject

/// 结束时间  auctionEndTime = "2021-07-01T18:43:00";
@property (nonatomic, copy) NSString* auctionEndTime;

/// 序列号
@property (nonatomic, copy) NSString* auctionSn;

/// 0-上架 1-下架 2违规禁售  3预告中  4已售出  5流拍  6交易取消
@property (nonatomic, copy) NSString* productStatus;

/// 当前用户拍卖状态（0无状态 1 失效 2出局 3领先 4中拍）
@property (nonatomic, copy) NSString* auctionStatus;

/// 拍卖订单状态 1 待确认 2 待付款 3 支付中 4 待发货 5 已预约 6 待收货 7 已完成 8 退货退款中 9 已退款 10 已关闭 11 待鉴定 12 已鉴定
@property (nonatomic, assign) NSUInteger orderStatus;

/// 拍卖状态（0 待拍 1竞拍中 2 已结束 ）
@property (nonatomic, copy) NSString* flowStatus;

/// 加价幅度
@property (nonatomic, copy) NSString* bidIncrement;

/// 最高出价买家id
@property (nonatomic, copy) NSString* buyerId;

/// 当前最高出价
@property (nonatomic, copy) NSString* buyerPrice;

/// 当前用户是否设置过代理 0:否 1:是
@property (nonatomic) BOOL isAgent;

/// 已出价次数
@property (nonatomic, copy) NSString* number;

/// 起拍价
@property (nonatomic, copy) NSString* startPrice;

/// 当前用户代理价(分)
@property (nonatomic, copy) NSString* expectedPrice;

/// 订单ID
@property (nonatomic, copy) NSString* orderId;

/// 开始时间  秒
@property (nonatomic) NSInteger startTime;
/// 结束时间 秒
@property (nonatomic) NSInteger endTime;

/// 1:下架      以下状态都表示为上架 因为是基于上架状态使用的      10:待拍 11:已预约拍卖      20:开拍该用户无动作 21：领先 22：出局      30:表示拍卖结束 无出价 31:拍卖结束有中拍 32:中拍待支付 33 中拍支付中 （根据这两个值区分提单页面还是支付页面）35:支付完成",
@property(nonatomic) NSInteger  productDetailStatus;

@end

NS_ASSUME_NONNULL_END

