//
//  UIImage+JHColor.h
//  TTjianbao
//
//  Created by yaoyao on 2020/5/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHGradientType) {
    JHGradientFromTopToBottom,
    JHGradientFromLeftToRight,
    JHGradientFromLeftTopToRightBottom,
    JHGradientFromLeftBottomToRightTop,

};


@interface UIImage (JHColor)


/// 生成一张纯色图片
+ (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size;

/// 创建一张渐变色图片
+ (UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(JHGradientType)gradientType imgSize:(CGSize)imgSize;
/// 创建一张渐变色的图片 绘制文字和圆角
+ (UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(JHGradientType)gradientType imgSize:(CGSize)imgSize string:(NSString *)text radius:(CGFloat)radius;

/// 创建一张渐变色图片 圆角
+ (UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(JHGradientType)gradientType imgSize:(CGSize)imgSize radius:(CGFloat)radius;

/// 创建主题按钮图片
+ (UIImage *)gradientThemeImageSize:(CGSize)imgSize radius:(CGFloat)radius;

+ (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
