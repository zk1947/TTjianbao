//
//  JHGoodsRespModel.h
//  TTjianbao
//  Description:跟商品相关~ 返回基类字段
//  Created by Jesse on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface JHGoodsRespModel : JHResponseModel

@property (nonatomic, strong) NSString* goodsCode; // (string, optional): 原石编号
@property (nonatomic, strong) NSString* goodsTitle; // (string, optional): 原石名称
@property (nonatomic, strong) NSString* goodsUrl; //(string, optional): 图片
@property (nonatomic, strong) NSString* orderCode; //(string, optional): 订单id

@end

@interface JHGoodsExtModel : JHGoodsRespModel

@property (nonatomic, strong) NSString* dealSequence;// (integer, optional): 第几次交易 ,
@property (nonatomic, strong) NSString* offerCount;// (integer, optional): 出价人数 ,
@property (nonatomic, strong) NSString* seekCount;// (integer, optional): 求看人数 ,
@property (nonatomic, strong) NSArray<NSString*>* seekCustomerImgList;// (Array[string], optional): 求看人图片列表 ,
@property (nonatomic, strong) NSString* stoneRestoreId;// (integer, optional): 回血原石ID
@property (nonatomic, strong) NSString* salePrice;

@end

NS_ASSUME_NONNULL_END
