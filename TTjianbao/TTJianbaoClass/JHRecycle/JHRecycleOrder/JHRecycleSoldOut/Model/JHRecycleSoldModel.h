//
//  JHRecycleSoldModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleHeader.h"


NS_ASSUME_NONNULL_BEGIN
// 按钮展示专用Model
@interface JHRecycleButtonsModel : NSObject
/** 关闭订单*/
@property (nonatomic, assign) BOOL closeOrderBtnFlag;
/** 取消订单*/
@property (nonatomic, assign) BOOL cancelOrderBtnFlag;
/** 订单追踪*/
@property (nonatomic, assign) BOOL traceOrderBtnFlag;
/** 预约上门取件*/
@property (nonatomic, assign) BOOL callDoorBtnFlag;
/** 查看取件预约*/
@property (nonatomic, assign) BOOL seeCallDoorBtnFlag;
/** 查看物流*/
@property (nonatomic, assign) BOOL seeExpressBtnFlag;
/** 确认交易*/
@property (nonatomic, assign) BOOL confirmDealBtnFlag;
/** 申请退回*/
@property (nonatomic, assign) BOOL applyRefundBtnFlag;
/** 申请仲裁*/
@property (nonatomic, assign) BOOL applyArbitrationBtnFlag;
/** 申请销毁*/
@property (nonatomic, assign) BOOL applyDestroyBtnFlag;
/** 查看仲裁*/
@property (nonatomic, assign) BOOL seeArbitrationBtnFlag;
/** 删除订单*/
@property (nonatomic, assign) BOOL deleteOrderBtnFlag;
/** 确认收货*/
@property (nonatomic, assign) BOOL confirmRecieptBtnFlag;

@end

@interface JHRecycleAvatarModel : NSObject
/** 小图*/
@property(nonatomic, copy) NSString *small;
/** 中图*/
@property(nonatomic, copy) NSString *medium;
/** 大图*/
@property(nonatomic, copy) NSString *big;

@end

@interface JHRecycleGoodsUrlModel : NSObject
/** 小图*/
@property(nonatomic, copy) NSString *small;
/** 中图*/
@property(nonatomic, copy) NSString *medium;
/** 大图*/
@property(nonatomic, copy) NSString *big;

@end

@interface JHRecycleSoldModel : NSObject

/** 过期时间戳*/
@property(nonatomic, copy) NSString *expiredTime;
/** 时间差*/
@property (nonatomic, assign) NSInteger timeDuring;
/** 订单ID*/
@property(nonatomic, copy) NSString *orderId;
/** 订单状态*/
@property(nonatomic, copy) NSString *orderStatus;
/** 订单状态code*/
@property(nonatomic, copy) NSString *orderStatusCode;
/** 回收商名称*/
@property(nonatomic, copy) NSString *sellerCustomerName;
/** 回收商品主图*/
@property(nonatomic, strong) JHRecycleGoodsUrlModel *goodsUrl;
/** 回收商品分类*/
@property(nonatomic, copy) NSString *goodsCateName;
/** 回收商品名称*/
@property(nonatomic, copy) NSString *goodsName;
/** 回收商品描述*/
@property(nonatomic, copy) NSString *goodsDesc;
/** 回收商头像*/
@property(nonatomic, strong) JHRecycleAvatarModel *avatar;
/** 展示按钮*/
@property(nonatomic, strong) JHRecycleButtonsModel *buttonsVo;
/** 订单编号*/
@property(nonatomic, copy) NSString *orderCode;
/** 商品三级分类*/
@property(nonatomic, copy) NSString *goodsTypeId;
/** 商品二级分类*/
@property(nonatomic, copy) NSString *goodsCateId;
/** 价格*/
@property(nonatomic, copy) NSString *orderPrice;
/** 交易价格*/
@property(nonatomic, copy) NSString *dealPrice;
/** */
@property(nonatomic, copy) NSString *goodsId;
@end

NS_ASSUME_NONNULL_END
