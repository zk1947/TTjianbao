//
//  JHC2CUploadProductModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHC2CUploadProductModel : NSObject

/// 后台一级分类id
@property(nonatomic, copy) NSString * firstCategoryId;

/// 后台二级分类id
@property(nonatomic, copy) NSString * secondCategoryId;

/// 后台三级分类id
@property(nonatomic, copy) NSString * thirdCategoryId;

/// 商品描述
@property(nonatomic, copy) NSString * productDesc;

/// 商品类型 0一口价  1拍卖
@property(nonatomic, assign) NSInteger productType;

/// 是否图文鉴定 0:否 1:是
@property(nonatomic, assign) NSInteger identify;

/// 必传图片
@property(nonatomic, strong) NSArray* mainImageUrlArr;

///可选图片
@property(nonatomic, strong) NSArray * detailImagesArr;

///商品选择属性
@property(nonatomic, strong) NSDictionary * attrsDic;

/// 拍卖信息 startPrice  bidIncrement   earnestMoney   auctionStartTime   auctionEndTime
@property(nonatomic, strong) NSDictionary * auctionDic;

/// 一口价信息 price  originPrice   freight    needFreight 0  1
@property(nonatomic, strong) NSDictionary * priceDic;

@property (nonatomic, assign) int productId;

- (NSDictionary*)changePar;

@end
