//
//  NSString+AttributedString.h
//    
//
//  Created by yaoyao on 2017/9/30.
//  Copyright © 2017年 yaoyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributedString)
- (NSMutableAttributedString *)attributedSubString:(NSString *)subString font:(UIFont *)font color:(UIColor *)color allColor:(UIColor *)allColor allfont:(UIFont *)allFont;

- (NSMutableAttributedString *)attributedFontSize:(CGFloat)fontSize color:(UIColor *)color;

- (NSMutableAttributedString *)attributedFont:(UIFont*)font color:(UIColor *)color range:(NSRange)range;

- (NSMutableAttributedString *)attributedFontSize:(CGFloat)fontSize color:(UIColor *)color lineSpace:(NSInteger)space;

- (NSMutableAttributedString *)attributedTailFontSize:(CGFloat)fontSize color:(UIColor *)color;

- (NSMutableAttributedString *)attributedFontSize:(CGFloat)fontSize color:(UIColor *)color firstLineHeadIndent:(CGFloat)indent;

- (NSMutableAttributedString *)formatePriceFontSize:(CGFloat)fontSize color:(UIColor *)color;

- (NSMutableAttributedString *)attributedSubString:(NSString *)subString subString:(NSString *)subs font:(UIFont *)font color:(UIColor *)color  sfont:(UIFont *)sfont scolor:(UIColor *)scolor allColor:(UIColor *)allColor allfont:(UIFont *)allFont;

- (NSMutableAttributedString *)attributedShadow;

+ (NSMutableAttributedString *)mergeStrings:(NSMutableArray *)items;

@end
