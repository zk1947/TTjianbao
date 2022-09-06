//
//  JHLastSaleGoodsReqModel.h
//  TTjianbao
//  Description:最近售出&待上架 请求模型
//  Created by Jesse on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsReqModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHLastSaleGoodsReqType)
{
    JHLastSaleGoodsReqTypeLastSale,
    JHLastSaleGoodsReqTypeWillSale,
    JHLastSaleGoodsReqTypeStoneSale,
    JHLastSaleGoodsReqTypeLastSaleFromUserCenter,//主播-个人中心-最近售出-列表
    JHLastSaleGoodsReqTypeWillSaleFromUserCenter//主播-个人中心-待上架-列表 
};

@interface JHLastSaleGoodsReqModel : JHGoodsReqModel

@property (nonatomic, assign) JHLastSaleGoodsReqType reqType;
@end

NS_ASSUME_NONNULL_END
