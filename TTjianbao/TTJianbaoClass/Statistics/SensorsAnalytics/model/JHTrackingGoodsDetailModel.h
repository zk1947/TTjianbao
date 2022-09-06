//
//  JHTrackingGoodsDetailModel.h
//  TTjianbao
//
//  Created by apple on 2020/12/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHTrackingBaseModel.h"
NS_ASSUME_NONNULL_BEGIN
//商品埋点model
@interface JHTrackingGoodsDetailModel : JHTrackingBaseModel
@property (nonatomic, copy) NSString * page_position;    //来源页面
@property (nonatomic, copy) NSString * button_name;    //来源模块
@property (nonatomic, copy) NSString * source_page;    //来源页面
@property (nonatomic, copy) NSString * source_module;    //来源模块
@property (nonatomic, copy) NSString * commodity_id;    //商品id
@property (nonatomic, copy) NSString * commodity_name;    //商品名称
@property (nonatomic, copy) NSNumber * original_price;    //商品原价
@property (nonatomic, copy) NSNumber * present_price;    //商品现价
@property (nonatomic, copy) NSString * commodity_section_name;    //商品版块名称
@property (nonatomic, copy) NSString * first_commodity;    //商品一级分类
@property (nonatomic, copy) NSString * second_commodity;    //商品二级分类
@property (nonatomic, copy) NSString * third_commodity;    //商品三级分类
@property (nonatomic, copy) NSString * topic_id;    //专题id
@property (nonatomic, copy) NSString * activity_name;    //活动名称
@property (nonatomic, copy) NSString * store_seller_id;    //店铺/卖家id
@property (nonatomic, copy) NSString * store_seller_name;    //店铺/卖家名称

@end

NS_ASSUME_NONNULL_END
