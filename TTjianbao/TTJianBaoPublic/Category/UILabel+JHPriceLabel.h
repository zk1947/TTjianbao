//
//  UILabel+JHPriceLabel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (JHPriceLabel)
/**
 设置价格标签
 
 @param price 价格
 @param prefixFont ￥的字体
 @param labelFont ￥400.23（400.23的字体）
 @param textColor 字体颜色
 */
- (void)setPrice:(NSString *)price
      prefixFont:(UIFont *)prefixFont
       labelFont:(UIFont *)labelFont
       textColor:(UIColor *)textColor;

/**
 设置价格标签（小数字体不同）
 
 @param price 价格
 @param prefixFont ￥的字体
 @param labelFont ￥400.23（400字体）
 @param suffixFont ￥400.23 （23字体）
 @param textColor 字体颜色
 */
- (void)setPrice:(NSString *)price
      prefixFont:(UIFont *)prefixFont
       labelFont:(UIFont *)labelFont
      suffixFont:(UIFont *)suffixFont
       textColor:(UIColor *)textColor;

@end

NS_ASSUME_NONNULL_END
