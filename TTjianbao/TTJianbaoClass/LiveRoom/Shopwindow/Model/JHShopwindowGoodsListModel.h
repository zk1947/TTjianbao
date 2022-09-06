//
//  JHShopwindowGoodsListModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHPriceWrapper.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHShopwindowGoodsListModel : NSObject
///商品code
@property (nonatomic, copy) NSString *code;

///商品品类
@property (nonatomic, copy) NSString *goodsCateId;

///商品品类名称
@property (nonatomic, copy) NSString *goodsCateIdName;

///商品状态(1：等待购买；2:待支付；3:已售)' ,
@property (nonatomic, assign) NSInteger goodsStatus;

///商品id
@property (nonatomic, copy) NSString *Id;

///图片
@property (nonatomic, copy) NSString *listImage;

///在线标志(1:上架；2下架) ,
@property (nonatomic, assign) NSInteger onlineFlag;

/// 价格
@property (nonatomic, copy) NSString *price;

///商品序号
@property (nonatomic, copy) NSString *sort;

///商品名称
@property (nonatomic, copy) NSString *title;

/// 价格包装类
@property (nonatomic, strong) JHPriceWrapper *priceWrapper;

@end

NS_ASSUME_NONNULL_END
