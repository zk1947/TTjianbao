//
//  UIView+JHShadow.h
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, JHShadowPathType) {
    JHShadowPathTop,
    JHShadowPathBottom,
    JHShadowPathLeft,
    JHShadowPathRight,
    JHShadowPathCommon,
    JHShadowPathAround,
};

@interface UIView (JHShadow)


- (void)viewShadowPathWithColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowPathType:(JHShadowPathType)shadowPathType shadowPathWidth:(CGFloat)shadowPathWidth;


+ (void)addShadow:(UIView *)shadowView Offset:(CGSize)offset Opacity:(CGFloat)opacity ShadowRadius:(CGFloat)shadowRadius ShadowColor:(UIColor *)shadowColor CornerRadius:(CGFloat)cornerRadius BorderColor:(UIColor *)borderColor BorderWidth:(CGFloat)borderWidth;

- (void)addDottedLineFromImageView:(UIView *)superView;


@end

NS_ASSUME_NONNULL_END
