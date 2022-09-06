//
//  JHPersonalResellModel.h
//  TTjianbao
//  Description:个人转售model
//  Created by jesee on 20/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGoodsRespModel.h"
#import "JHGoodsReqModel.h"

@class JHPersonalResellListModel, JHPersonalResellSalePriceWrapperModel;

typedef NS_ENUM(NSUInteger, JHPersonalResellSubPageType) {
    JHPersonalResellSubPageTypeWaitShelve, //待上架
    JHPersonalResellSubPageTypeShelve, //在售
    JHPersonalResellSubPageTypeSold //已售
};

NS_ASSUME_NONNULL_BEGIN

@interface JHPersonalResellModel : JHRespModel

@property (nonatomic, strong) NSArray *list;// Array[JHPersonalResellListModel]: 列表 ,
@property (nonatomic, copy) NSString *total; // 总条目数
@end

@interface JHPersonalResellListModel : JHGoodsRespModel

@property (nonatomic, copy) NSString *buyerImg;// (string, optional): 买家头像 ,
@property (nonatomic, copy) NSString *buyerName;// (string, optional): 买家名称 ,
@property (nonatomic, copy) NSString *orderId;// (integer, optional): 订单ID ,
@property (nonatomic, copy) NSString *orderStatus;// (string, optional): 订单状态 ,
@property (nonatomic, copy) NSString* workorderDesc;//refunding 退货退款中 refunded 退货完成 ,这两种状态时，转成此字段
@property (nonatomic, copy) NSString *salePrice;// (number, optional): 交易价格 ,
@property (nonatomic, copy) NSString *stoneResaleId;// (string, optional): 个人转售单ID
@property (nonatomic, strong) JHPersonalResellSalePriceWrapperModel *salePriceWrapper;// (PriceWrapper, optional): 交易价格包装类
@property (nonatomic, assign) NSInteger showVideo;// 个人转售是否显示视频播放按钮：0-不显示、1-显示
@end

@interface JHPersonalResellSalePriceWrapperModel : NSObject

@property (nonatomic, copy) NSString *priceFraction;// (string, optional),
@property (nonatomic, copy) NSString *pricePart;// (string, optional),
@property (nonatomic, copy) NSString *priceSign;// (string, optional)
@end

///原石转售-个人中心-列表基类
@interface JHPersonalResellReqModel : JHGoodsReqModel

@property (nonatomic, copy) NSString *lastId;//最后一条原石Id
@end

///原石转售-个人中心-在售（已上架）列表
@interface JHPersonalResellShelveListReqModel : JHPersonalResellReqModel

@end

///原石转售-个人中心-已售列表
@interface JHPersonalResellSoldReqModel : JHPersonalResellReqModel

@end

///原石转售-个人中心-待上架列表
@interface JHPersonalResellWaitshelveReqModel : JHPersonalResellReqModel

@end

///原石转售-个人中心-list item
@interface JHPersonalResellListItemReqModel : JHReqModel

@property (nonatomic, copy) NSString *stoneResaleId;//原石Id
@end

///原石转售-上架-操作
@interface JHPersonalResellShelveReqModel : JHReqModel

@property (nonatomic, copy) NSString *stoneResaleId;//原石Id
@end

///原石转售-下架-操作
@interface JHPersonalResellUnshelveReqModel : JHReqModel

@property (nonatomic, copy) NSString *stoneResaleId;//原石Id
@end

///原石转售-个人中心-删除
@interface JHPersonalResellDeleteReqModel : JHReqModel

@property (nonatomic, copy) NSString *stoneResaleId;//原石Id
@end

NS_ASSUME_NONNULL_END
