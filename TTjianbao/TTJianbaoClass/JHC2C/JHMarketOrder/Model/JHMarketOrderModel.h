//
//  JHMarketOrderModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 按钮展示专用Model
@interface JHMarketOrderButtonsModel : NSObject
/** 联系卖家*/
@property (nonatomic, assign) BOOL contactSellerBtnFlag;
/** 取消订单*/
@property (nonatomic, assign) BOOL cancelOrderBtnFlag;
/** 立即支付*/
@property (nonatomic, assign) BOOL payBtnFlag;
/** 提醒发货*/
@property (nonatomic, assign) BOOL remindShipBtnFlag;
/** 我要评价*/
@property (nonatomic, assign) BOOL commentBtnFlag;
/** 查看物流*/
@property (nonatomic, assign) BOOL seeExpressBtnFlag;
/** 确认收货*/
@property (nonatomic, assign) BOOL confirmDealBtnFlag;
/** 申请退款*/
@property (nonatomic, assign) BOOL applyRefundBtnFlag;
/** 查看退款详情*/
@property (nonatomic, assign) BOOL seeRefundBtnFlag;
/** 删除*/
@property (nonatomic, assign) BOOL deleteBtnFlag;
/** 联系买家*/
@property (nonatomic, assign) BOOL contactBuyerBtnFlag;
/** 关闭交易*/
@property (nonatomic, assign) BOOL closeOrderBtnFlag;
/** 预约发货*/
@property (nonatomic, assign) BOOL reserveShipBtnFlag;
/** 填写物流订单*/
@property (nonatomic, assign) BOOL addExpressNoBtnFlag;
/** 提醒发货*/
@property (nonatomic, assign) BOOL remindReceiptBtnFlag;
/** 修改价格*/
@property (nonatomic, assign) BOOL modifyPriceBtnFlag;
/** 平台介入结果*/
@property (nonatomic, assign) BOOL platformInBtnFlag;
@end

@interface JHMarketOrderAvatarModel : NSObject
/** 小图*/
@property(nonatomic, copy) NSString *small;
/** 中图*/
@property(nonatomic, copy) NSString *medium;
/** 大图*/
@property(nonatomic, copy) NSString *big;

@end

@interface JHMarketOrderGoodsUrlModel : NSObject
/** 小图*/
@property(nonatomic, copy) NSString *small;
/** 中图*/
@property(nonatomic, copy) NSString *medium;
/** 大图*/
@property(nonatomic, copy) NSString *big;

@end

@interface JHMarketOrderModel : NSObject

/** 集市订单品类*/
@property(nonatomic, copy) NSString *marketOrderCategory;
/** 名称*/
@property(nonatomic, copy) NSString *customerName;
/** 对方id*/
@property(nonatomic, copy) NSString *customerId;
/** 头像*/
@property(nonatomic, strong) JHMarketOrderAvatarModel *customerImg;
/** 订单ID*/
@property(nonatomic, copy) NSString *orderId;
/** 订单编号*/
@property(nonatomic, copy) NSString *orderCode;
/** 订单状态code  1 待确认 2 待付款 3 支付中 4 待发货 5 已预约 6 待收货 7 已完成 8 退货退款中 9 已退款 10 已关闭 11 待鉴定 12 已鉴定*/
@property(nonatomic, copy) NSString *orderStatus;
/** 订单状态文字*/
@property(nonatomic, copy) NSString *orderStatusText;
/** 订单状态描述*/
@property(nonatomic, copy) NSString *orderText;
/** 订单价格 实付价格*/
@property(nonatomic, copy) NSString *orderPrice;
/** 原始价格*/
@property(nonatomic, copy) NSString *originOrderPrice;
/** 下单时间*/
@property(nonatomic, copy) NSString *orderCreateTime;
/** 商品ID*/
@property(nonatomic, copy) NSString *goodsId;
/** 商品编号*/
@property(nonatomic, copy) NSString *goodsCode;
/** 商品图片*/
@property(nonatomic, strong) JHMarketOrderGoodsUrlModel *goodsUrl;
/** 商品名称*/
@property(nonatomic, copy) NSString *goodsName;
/** 展示按钮*/
@property(nonatomic, strong) JHMarketOrderButtonsModel *buttonsVo;
/** 收货国家*/
@property(nonatomic, copy) NSString *shippingCounty;
/** 收货省*/
@property(nonatomic, copy) NSString *shippingCity;
/** 收货市*/
@property(nonatomic, copy) NSString *shippingProvince;
/** 收货县*/
@property(nonatomic, copy) NSString *shippingCountry;
/** 收货详细地址*/
@property(nonatomic, copy) NSString *shippingAddress;
/** 收货人*/
@property(nonatomic, copy) NSString *shippingPerson;
/** 收货电话*/
@property(nonatomic, copy) NSString *shippingPhone;
/** 过期时间*/
@property(nonatomic, copy) NSString *expireTime;
/** 时间差*/
@property (nonatomic, assign) NSInteger timeDuring;
/** 津贴*/
@property(nonatomic, copy) NSString *bountyAmount;
/** 运费*/
@property(nonatomic, copy) NSString *freight;
/** 鉴定id*/
@property(nonatomic, copy) NSString *appraisalId;
/** 鉴定结果*/
@property(nonatomic, copy) NSString *appraisalResult;
/** 网易云accId（对方的）*/
@property(nonatomic, copy) NSString *accId;
/** 是否已评价 0 未评价 1 已评价*/
@property(nonatomic, copy) NSString *commentStatus;

/** 钱币受物流管制，发货较慢*/
@property(nonatomic, copy) NSString *remindText;

@end

NS_ASSUME_NONNULL_END
