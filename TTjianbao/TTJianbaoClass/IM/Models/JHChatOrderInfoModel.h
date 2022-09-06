//
//  JHChatOrderInfoModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHIMHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class JHChatOrderInfoModel;

@interface JHChatCustomOrderModel : NSObject<NIMCustomAttachment>
@property (nonatomic, assign) JHChatCustomType type;
@property (nonatomic, strong) JHChatOrderInfoModel *body;
@end

@interface JHChatOrderInfoListModel : NSObject
@property (nonatomic, strong) NSArray<JHChatOrderInfoModel *> *orderInfos;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger total;
@end

#pragma mark - order
@interface JHChatOrderInfoModel : NSObject
///// 订单类型- 0: C2C订单 1：B2C订单
//@property (nonatomic, assign) NSInteger orderPlatformType;
/// C2C订单类型  1我买的 2我卖的
@property (nonatomic, assign) NSUInteger marketOrderType;
/// 商品图片
@property (nonatomic, copy) NSString *iconUrl;
/// 商品名称
@property (nonatomic, copy) NSString *title;
/// 商品金额
@property (nonatomic, copy) NSString *price;
/// 订单ID
@property (nonatomic, copy) NSString *orderId;
/// 订单Code
@property (nonatomic, copy) NSString *orderCode;
/// 订单状态，直接赋值 状态字符串
@property (nonatomic, copy) NSString *orderState;
/// 订单状态，直接赋值 状态字符串
@property (nonatomic, copy) NSString *orderStatus;
/// 订单时间
@property (nonatomic, copy) NSString *orderDate;
/// 买家ID
@property (nonatomic, copy) NSString *customerId;
/// 卖家ID
@property (nonatomic, copy) NSString *sellerCustomerId;
/// 订单详情落地页分类 - normal: 卖场订单归类 customize: 定制订单归类 market: 集市订单归类 recycle: 回收订单归类 appraise: 鉴定订单归类
@property (nonatomic, copy) NSString *orderLoadingCategory;

@property (nonatomic, copy) NSString *goodsUrl;
@property (nonatomic, copy) NSString *goodsTitle;
@property (nonatomic, copy) NSString *orderAmount;

@property (nonatomic, copy) NSString *orderStatusDesc;
@property (nonatomic, copy) NSString *payTime;
/// 买家订单状态文案
@property (nonatomic, copy) NSString *orderStatusDescBuyer;
/// 卖家订单状态文案
@property (nonatomic, copy) NSString *orderStatusDescSeller;

@end

NS_ASSUME_NONNULL_END
