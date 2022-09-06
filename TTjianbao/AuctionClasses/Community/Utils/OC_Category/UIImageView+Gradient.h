//
//  UIImageView+Gradient.h
//  TTjianbao
//
//  Created by wuyd on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//渐变颜色方向
typedef NS_ENUM(NSInteger, EGradientType) {
    EGradientType_Up_Down = 0,      //从上到下
    EGradientType_Left_Right,       //从左到右
    EGradientType_UpLeft_RightDown, //左上到右下
    EGradientType_UpRight_LeftDown  //右上到左下
};

@interface UIImageView (Gradient)

/*! 返回渐变色view */
+ (UIImageView *)gradientWithType:(EGradientType)type frame:(CGRect)rect colors:(NSArray<NSString *> *)colors;

/*! 返回渐变色的UIImage对象 */
- (UIImage *)imageFromGradientColors:(NSArray<NSString *> *)colors gradientType:(EGradientType)gradientType;

@end

NS_ASSUME_NONNULL_END
