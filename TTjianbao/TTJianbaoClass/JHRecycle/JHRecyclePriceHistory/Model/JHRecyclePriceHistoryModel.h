//
//  JHRecyclePriceModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 图片模型,大中小图
@interface JHRecyclePriceImageModel : NSObject
/** 小图*/
@property(nonatomic, strong) NSString *small;
/** 中图*/
@property(nonatomic, strong) NSString *medium;
/** 大图*/
@property(nonatomic, strong) NSString *big;
@end

@interface JHRecyclePriceHistoryModel : NSObject

/** 出价ID*/
@property (nonatomic, copy) NSString *bidId;
/** 我的出价 单位为元*/
@property (nonatomic, copy) NSString *bidPriceYuan;
/** 详细状态：0 待用户确认出价 3 中标 6 用户超24小时未确认出价 9 用户删除商品 12 用户下架商品 15 商品已被别人成交 18 商品已被平台下架 21 超时未支付*/
@property (nonatomic, assign) NSInteger bidStatus;
/** 失效状态：6 用户主动下架 7 商品已被平台下架 12 用户超时未确认报价 15 回收商超时未支付 50 商品已被别人成交*/
@property (nonatomic, copy) NSString *invalidStatus;
/** 分类名称*/
@property (nonatomic, copy) NSString *categoryName;
/** 商品描述*/
@property (nonatomic, copy) NSString *productDesc;
/** 商品id*/
@property (nonatomic, copy) NSString *productId;
/** 商品图片*/
@property (nonatomic, strong) JHRecyclePriceImageModel *productImage;
/** 商品成交价*/
@property (nonatomic, copy) NSString *productPrice;
/** 小贴士*/
@property (nonatomic, copy) NSString *tipDesc;
/** 订单*/
@property (nonatomic, copy) NSString *orderId;
@end

NS_ASSUME_NONNULL_END
