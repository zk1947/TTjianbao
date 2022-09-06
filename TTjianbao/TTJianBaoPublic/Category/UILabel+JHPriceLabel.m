//
//  UILabel+JHPriceLabel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UILabel+JHPriceLabel.h"

@implementation UILabel (JHPriceLabel)
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
       textColor:(UIColor *)textColor{
    if ([price isNotBlank]) {
        NSString *prefixString = [price substringToIndex:1];
        if ([prefixString isEqualToString:@"¥"]) {
            price = [price substringFromIndex:1];
        }
        price = [@"¥ " stringByAppendingString:price];
        NSString *prefixStr = [price substringToIndex:1];
        NSString *labelStr = [price substringFromIndex:1];
        
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:price];
        //¥
        [attributedStr addAttribute:NSFontAttributeName
                              value:prefixFont
                              range:NSMakeRange(0, prefixStr.length)];
        //¥后面的
        [attributedStr addAttribute:NSFontAttributeName
                              value:labelFont
                              range:NSMakeRange(prefixStr.length, labelStr.length)];
        //字符串的颜色
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:textColor
                              range:NSMakeRange(0, price.length)];
        
        self.attributedText = attributedStr;
        
    }
}


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
       textColor:(UIColor *)textColor{
    
    if ([price isNotBlank]) {
        NSString *prefixString = [price substringToIndex:1];
        if ([prefixString isEqualToString:@"¥"]) {
            price = [price substringFromIndex:1];
        }
        price = [@"¥" stringByAppendingString:price];

        //分隔字符串
        NSString *prefixStr;//¥符号
        NSString *labelStr;//¥后的字符 ￥400.23（400.23）
        NSString *suffixStr;//￥400.23（23）
        NSString *integerStr;//￥400.23（400）
        
        prefixStr = [price substringToIndex:1];
        labelStr = [price substringFromIndex:1];
        
        
        if ([labelStr containsString:@"."]) {
            NSRange range = [labelStr rangeOfString:@"."];
            suffixStr = [labelStr substringFromIndex:range.location];
            integerStr = [labelStr substringToIndex:range.location];
        }
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:price];

        //￥
        [attributedStr addAttribute:NSFontAttributeName
                              value:prefixFont
                              range:NSMakeRange(0, prefixStr.length)];

        //小数点前面的字体大小
        [attributedStr addAttribute:NSFontAttributeName
                              value:labelFont
                              range:NSMakeRange(prefixStr.length , integerStr.length)];
        
        //小数点后面的字体大小
        [attributedStr addAttribute:NSFontAttributeName
                              value:suffixFont
                              range:NSMakeRange(prefixStr.length + integerStr.length, suffixStr.length)];
        //字符串的颜色
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:textColor
                              range:NSMakeRange(0, price.length)];
        
        self.attributedText = attributedStr;

    }

}

@end
