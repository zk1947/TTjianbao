//
//  JHShopWindowLayout.h
//  TTjianbao
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHGoodsInfoMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHShopWindowLayout : NSObject

@property (nonatomic, strong) JHGoodsInfoMode *goodsInfo;

//所有布局参数
@property (nonatomic, assign) CGFloat cellHeight; //cell总高度

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat descHeight;
@property (nonatomic, assign) CGFloat curPriceWidth; //当前价格
@property (nonatomic, assign) CGFloat oriPriceWidth; //原价
@property (nonatomic, assign) CGFloat discountWidth; //折扣
@property (nonatomic, assign) CGFloat tagWidth; //标签
@property (nonatomic, assign) CGFloat imgTitleSpace; //间距
@property (nonatomic, assign) CGFloat titleDescSpace; //间距
@property (nonatomic, assign) CGFloat descPriceSpace; //间距
@property (nonatomic, assign) CGFloat space; //间距


- (instancetype)initWithModel:(JHGoodsInfoMode *)model;

@end

NS_ASSUME_NONNULL_END
