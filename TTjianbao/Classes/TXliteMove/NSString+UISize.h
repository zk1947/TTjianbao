//
//  NSString+UISize.h
//  TXLiteAVDemo
//
//  Created by cui on 2018/12/17.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (UISize)

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font breakMode:(NSLineBreakMode)breakMode;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font breakMode:(NSLineBreakMode)breakMode align:(NSTextAlignment)alignment;

-(CGFloat)getStringHeight:(UIFont*)font width:(CGFloat)width size:(CGFloat)minSize;

-(CGFloat)getStringWidth:(UIFont*)font height:(CGFloat)height size:(CGFloat)minSize;

-(CGFloat)getStringHeight:(UIFont*)font width:(CGFloat)width maxLineCount:(int)lineCount;

/*
@param string 当前内容
@param font 当前字体
@param maxSize 当前最大宽高
@return 返回宽高
*/
+ (CGSize)getSpaceLabelHeight:(NSString *)string font:(UIFont*)font maxSize:(CGSize)maxSize withlineSpacing:(float)lineSpacing;

@end

NS_ASSUME_NONNULL_END
