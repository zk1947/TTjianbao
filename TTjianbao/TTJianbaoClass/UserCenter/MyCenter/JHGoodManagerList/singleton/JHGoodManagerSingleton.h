//
//  JHGoodManagerSingleton.h
//  TTjianbao
//
//  Created by user on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHGoodManagerNormalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodManagerSingleton : NSObject
/// 商品状态   0上架   1下架   2违规禁售   3预告中  4已售出  5流拍  6交易取消
@property (nonatomic, copy) NSString *productStatus;
/// 商品名称/分类名称
@property (nonatomic, copy) NSString *searchName;
/// 最低价
@property (nonatomic, copy) NSString *minPrice;
/// 最高价
@property (nonatomic, copy) NSString *maxPrice;
/// 发布开始时间
@property (nonatomic, copy) NSString *publishStartTime;
/// 发布结束时间
@property (nonatomic, copy) NSString *publishEndTime;
/// 分类一级id
@property (nonatomic, copy) NSString *firstCategoryId;
/// 分类二级id
@property (nonatomic, copy) NSString *secondCategoryId;
/// 分类三级id
@property (nonatomic, copy) NSString *thirdCategoryId;




/// 上架使用
/// 起拍价
@property (nonatomic, copy) NSString *startAuctionPrice;
/// 加价幅度
@property (nonatomic, copy) NSString *addAuctionPrice;
/// 保证金
@property (nonatomic, copy) NSString *sureMoney;
/// 商品发布类型 (立即上架/指定时间)
@property (nonatomic, copy) NSString *putOnType;
/// 持续时间
@property (nonatomic, copy) NSString *auctionDuration;
/// 开始时间
@property (nonatomic, copy) NSString *auctionStartTime;


/// 导航条当前状态
@property (nonatomic, assign) JHGoodManagerListRequestProductStatus navProductStatus;

+ (JHGoodManagerSingleton *)shared;

@end

NS_ASSUME_NONNULL_END
