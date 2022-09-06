//
//  JHLastSaleGoodsModel.h
//  TTjianbao
//  Description:最近售出&待上架
//  Created by Jesse on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLastSaleGoodsModel : JHGoodsRespModel

@property (nonatomic, copy) NSString *dealPrice;// (number, optional): 交易价格 ~ 最近售出
@property (nonatomic, copy) NSString *salePrice; //(number, optional): 交易价格 ~ 待上架
@property (nonatomic, copy) NSString *purchasePrice;//最近售出原石 原石主播
@property (nonatomic, copy) NSString* depositoryLocationCode; //(string, optional): 货架号 ,
@property (nonatomic, assign) NSInteger processButton; //加工按钮(0-不显示，1-显示可点击，2-显示不可点击)
@property (nonatomic, assign) NSInteger saleButton; //寄售按钮 (0-不显示，1-显示可点击，2-显示不可点击),
@property (nonatomic, assign) NSInteger sendButton; //寄回按钮 (0-不显示，1-显示可点击，2-显示不可点击),
@property (nonatomic, assign) NSInteger splitButton; //拆单按钮 (0-不显示，1-显示可点击，2-显示不可点击),
@property (nonatomic, assign) NSInteger printButton;// 打印按钮：0-不显示、1-显示 ,
@property (nonatomic, assign) NSInteger shelfState; //上架状态,【不是服务端返回数据,需要本地查询】
@property (nonatomic, copy) NSString *stoneRestoreId; //(integer, optional): 原石回血ID
@property (nonatomic, copy) NSString *stoneId; //(integer, optional): 原石ID
@property (nonatomic, copy) NSString *purchaseCustomerId; //订单对应用户(买家)Id
@property (nonatomic, copy) NSString *signCustomerId; //添加签约用户ID
@end

@interface JHLastSaleGoodsRespModel : RequestModel

@end

NS_ASSUME_NONNULL_END
