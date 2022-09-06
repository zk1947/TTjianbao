//
//  JHShanGouModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/10/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHShanGouModel : NSObject

//必须商品编码
@property(nonatomic, strong) NSString * Id;


//必须商品编码
@property(nonatomic, strong) NSString * productCode;

//商品标题
@property(nonatomic, strong) NSString * productTitle;

//商品图片
@property(nonatomic, strong) NSString * productImg;

//商品分类名称
@property(nonatomic, strong) NSString * secondCategory;

//新二级分类id
@property(nonatomic) NSInteger newSecondCategoryId;

//旧二级分类id
@property(nonatomic) NSInteger oldSecondCategoryId;

//商品单价
@property(nonatomic, strong) NSString * price;

//材料费
@property(nonatomic, strong) NSString * materialCost;

//手工费
@property(nonatomic, strong) NSString * manualCost;

//合计
@property(nonatomic, strong) NSString * totalPrice;

//商品库存
@property(nonatomic) NSInteger store;

//商品剩余库存
@property(nonatomic) NSInteger usableStore;

//发布者Id
@property(nonatomic) NSInteger publisherId;

//商品类型 normal-常规 processingOrder-加工 giftOrder-福利单
@property(nonatomic, strong) NSString * productType;

//商品状态 0-上架 1-下架 2-已售罄
@property(nonatomic) NSInteger productStatus;

//创建时间
@property(nonatomic, strong) NSString * createTime;

//更新时间
@property(nonatomic, strong) NSString * updateTime;

@end

NS_ASSUME_NONNULL_END
