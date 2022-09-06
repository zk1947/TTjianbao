//
//  JHRecycleOrderDetailModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-Model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JHRecycleOrderInfo;
@class JHRecycleOrderButtonInfo;
@class JHRecycleOrderNodeInfo;

@interface JHRecycleOrderDetailModel : NSObject
@property (nonatomic, strong) JHRecycleOrderNodeInfo *recycleNodeLine;
@property (nonatomic, strong) JHRecycleOrderInfo *order;
@property (nonatomic, strong) JHRecycleOrderButtonInfo *buttonsVo;
@end

#pragma mark - 订单节点
@interface JHRecycleOrderNodeInfo : NSObject
@property (nonatomic, strong) NSArray<NSString *> *recycleNodes;
@property (nonatomic, strong) NSArray<NSString *> *recycleNodesStr;
@property (nonatomic, assign) NSInteger selectedNode;
@end

#pragma mark - 订单信息
@interface JHRecycleOrderInfo : NSObject
/// 收货国家
@property (nonatomic, copy) NSString *shippingCountry;
/// 收货省份
@property (nonatomic, copy) NSString *shippingProvince;
/// 收货市
@property (nonatomic, copy) NSString *shippingCity;
/// 收货区/县
@property (nonatomic, copy) NSString *shippingCounty;
/// 收货详细地址
@property (nonatomic, copy) NSString *shippingAddress;
/// 收货人名
@property (nonatomic, copy) NSString *shippingPerson;
/// 收货人电话
@property (nonatomic, copy) NSString *shippingMobile;
/// 订单状态 1 待付款2 支付中3 待发货4 待收货5 待确认价格6 交易完成7 退款退货中8 退款完成9 订单关闭10 订单取消
@property (nonatomic, assign) NSInteger recycleOrderStatus;
/// 根据的订单状态展示文本 - 第二个显示框展示文本 显示小灰字
@property (nonatomic, copy) NSString *recycleOrderStatusText;
/// 买家id
@property (nonatomic, copy) NSString *customerId;
/// 买家昵称
@property (nonatomic, copy) NSString *customerNickname;
/// 商家id
@property (nonatomic, copy) NSString *sellerCustomerId;
/// 商家名称
@property (nonatomic, copy) NSString *sellerCustomerName;
/// 商品图片url
@property (nonatomic, copy) NSString *goodsUrl;
/// 商品id
@property (nonatomic, copy) NSString *onlyGoodsId;
/// 商品名称
@property (nonatomic, copy) NSString *goodsTitle;
@property (nonatomic, copy) NSString *orderDesc;
/// 订单编码
@property (nonatomic, copy) NSString *orderCode;
/// 订单金额
@property (nonatomic, copy) NSString *orderPrice;
/// 最终价格
@property (nonatomic, copy) NSString *finalPrice;
/// 订单创建时间
@property (nonatomic, copy) NSString *orderCreateTime;
/// 商品分类ID
@property (nonatomic, copy) NSString *goodsTypeId;
/// 商品分类id
@property (nonatomic, copy) NSString *goodsCate;
/// 商品分类名称
@property (nonatomic, copy) NSString *goodsCateName;
/// 过期时间戳
@property (nonatomic, assign) NSInteger payExpireTimeStr;
/// 商家首次出价金额 单位：元
@property (nonatomic, copy) NSString *offerPrice;
/// 宝贝报价 单位：元
@property (nonatomic, copy) NSString *dealPrice;

/// 出价状态 - 确认价格状态，0：未确认，1：原价确认，2：降价确认，3：确认拒绝回收； 默认为0
@property (nonatomic, assign) NSInteger confirmStatus;
/// 预付总价金额（验收价格）
@property (nonatomic, copy) NSString *preOrderPrice;
/// 仲裁状态 - 0 未申请仲裁 ；1 已申请仲裁 ；2 已处理仲裁；3、达成交易 ；默认为0
@property (nonatomic, assign) NSInteger appealStatus;
/// 仲裁结果文本
@property (nonatomic, copy) NSString *abrResult;
/// 仲裁id
@property (nonatomic, copy) NSString *arbId;
/// 确认交易剩余时间
@property (nonatomic, assign) NSInteger remaingTime;
/// 取消理由
@property (nonatomic, copy) NSString *cancelReason;
/// 仲裁结果
@property (nonatomic, copy) NSString *remark;
/// 商家验收说明
@property (nonatomic, copy) NSString *signRemark;
///// 达成交易价格
//@property (nonatomic, copy) NSString *diffPrice;
///
@property (nonatomic, assign) NSInteger diffRefundType;

@end

#pragma mark - 按钮
@interface JHRecycleOrderButtonInfo : NSObject
/// 取消订单 1 显示，0 不显示
@property (nonatomic, assign) BOOL cancelOrderBtnFlag;
/// 订单追踪
@property (nonatomic, assign) BOOL traceOrderBtnFlag;
/// 预约上门取件
@property (nonatomic, assign) BOOL callDoorBtnFlag;
/// 查看取件预约
@property (nonatomic, assign) BOOL seeCallDoorBtnFlag;
/// 查看物流
@property (nonatomic, assign) BOOL seeExpressBtnFlag;
/// 确认交易
@property (nonatomic, assign) BOOL confirmDealBtnFlag;
/// 申请退回
@property (nonatomic, assign) BOOL applyRefundBtnFlag;
/// 申请仲裁
@property (nonatomic, assign) BOOL applyArbitrationBtnFlag;
/// 申请销毁
@property (nonatomic, assign) BOOL applyDestroyBtnFlag;
/// 查看仲裁
@property (nonatomic, assign) BOOL seeArbitrationBtnFlag;
/// 删除订单
@property (nonatomic, assign) BOOL deleteOrderBtnFlag;
/// 确认收货
@property (nonatomic, assign) BOOL confirmRecieptBtnFlag;
/// 关闭交易
@property (nonatomic, assign) BOOL closeOrderBtnFlag;

@end

#pragma mark - 取消理由model
@interface JHRecycleCancelModel : NSObject
/// 取消理由类型
@property (nonatomic, copy) NSString *reasonType;
/// 取消理由
@property (nonatomic, copy) NSString *reasonTypeDesc;
/// 取消理由类型
@property (nonatomic, copy) NSString *code;
/// 取消理由
@property (nonatomic, copy) NSString *msg;

@end


NS_ASSUME_NONNULL_END
