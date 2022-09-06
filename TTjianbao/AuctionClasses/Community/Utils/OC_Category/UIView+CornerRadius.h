//
//  UIView+CornerRadius.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/22.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark - UIView (CornerRadius)

@interface UIView (CornerRadius)

///使用此方法
- (void)yd_setCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners;


#pragma mark -
#pragma mark - 以下方法 如果背景不是纯色值，圆角会有颜色
/**
 * 设置一个四角圆角
 *
 * @param radius 圆角半径
 * @param color  圆角背景色
 */
- (void)yd_setCornerRadius:(CGFloat)radius color:(UIColor *)color;

/**
 * 设置一个普通圆角
 *
 * @param radius  圆角半径
 * @param color   圆角背景色
 * @param corners 圆角位置
 */
- (void)yd_setCornerRadius:(CGFloat)radius color:(UIColor *)color corners:(UIRectCorner)corners;

/**
 * 设置一个带边框的圆角
 *
 * @param cornerRadii 圆角半径cornerRadii
 * @param color       圆角背景色
 * @param corners     圆角位置
 * @param borderColor 边框颜色
 * @param borderWidth 边框线宽
 */
- (void)yd_setCornerRadii:(CGSize)cornerRadii color:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end


#pragma mark -
#pragma mark - CAlayer (CornerRadius)

@interface CALayer (CornerRadius)

@property (nonatomic, strong) UIImage *contentImage; //contents的便捷设置

/** 对应UIView的相应API */
- (void)yd_setCornerRadius:(CGFloat)radius color:(UIColor *)color;

- (void)yd_setCornerRadius:(CGFloat)radius color:(UIColor *)color corners:(UIRectCorner)corners;

- (void)yd_setCornerRadii:(CGSize)cornerRadii
                    color:(UIColor *)color
                  corners:(UIRectCorner)corners
              borderColor:(nullable UIColor *)borderColor
              borderWidth:(CGFloat)borderWidth;

@end

NS_ASSUME_NONNULL_END
