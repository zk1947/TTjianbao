//
//  UIView+Shadow.h
//  YDCategoryKit
//
//  Created by WU on 2019/6/26.
//  Copyright © 2019 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//阴影方向
typedef NS_ENUM(NSInteger, YDShadowSide) {
    YDShadowSideLeft = 0,
    YDShadowSideRight,
    YDShadowSideTop,
    YDShadowSideBottom,
    YDShadowSideNoTop,
    YDShadowSideAllSide
};

@interface UIView (Shadow)

/**
 * color    阴影颜色
 * opacity  阴影透明度，默认0
 * radius   阴影半径，默认3
 * side     阴影方向
 * width    阴影宽度
 */

- (void)yd_setShadowColor:(UIColor *)color
                  opacity:(CGFloat)opacity
                   radius:(CGFloat)radius
                    width:(CGFloat)width
                     side:(YDShadowSide)side;

@end

NS_ASSUME_NONNULL_END
