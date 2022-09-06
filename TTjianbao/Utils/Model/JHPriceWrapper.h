//
//  JHPriceWrapper.h
//  TTjianbao
//  Description:价格与人民币符号调整
//  Created by jesee on 16/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHPriceShowStyle) {
    JHPriceShowStyleDefault,
    JHPriceShowStyleList = JHPriceShowStyleDefault,
    JHPriceShowStyleDetail,
};

NS_ASSUME_NONNULL_BEGIN

/*
 *小数点后两位，如果有小数前端显示，如果没有小数，前端显示整数。例：￥3.21  ￥3  ￥21万
 *人民币符号和价格字体大小：
 *1)列表样式符号11pt，价格17pt，小数11pt.
 *2) 详情符号符号18pt，价格24pt，小数18pt
 */

@interface JHPriceWrapper : NSObject
/**
 * 实际显示部分为：priceSign+pricePart+priceFraction
 * 比如1000.1， priceSign为￥，pricePart为1000，priceFraction为.1
 * 比如100000，priceSign为￥，pricePart为10万，priceFraction为空（""）
 * 比如103000，priceSign为￥，pricePart为10.3万，priceFraction为空（""）
 */

//* 价格符号，例如￥
@property (nonatomic, copy) NSString *priceSign;
//* 价格部分
@property (nonatomic, copy) NSString *pricePart;
//* 小数部分
@property (nonatomic, copy) NSString *priceFraction;
/**
 *本地字段展示时,需要设置的显示类型
 *默认list样式可以不设置
 */
@property (nonatomic, assign) JHPriceShowStyle showStyle;

//转成富文本string
- (NSMutableAttributedString*)showPrice;

@end

NS_ASSUME_NONNULL_END
