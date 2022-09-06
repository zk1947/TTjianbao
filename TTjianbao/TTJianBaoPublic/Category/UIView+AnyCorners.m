//
//  UIView+AnyCorners.m
//  TTjianbao
//
//  Created by YJ on 2021/1/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UIView+AnyCorners.h"

@implementation UIView (AnyCorners)

- (void)setBorderWithCornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
                             type:(UIRectCorner)corners
{
    CGRect rect = CGRectMake(borderWidth/2.0, borderWidth/2.0,
                             CGRectGetWidth(self.frame)-borderWidth, CGRectGetHeight(self.frame)-borderWidth);
    CGSize radii = CGSizeMake(cornerRadius, borderWidth);
     
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
     
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = borderColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
     
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
     
    [self.layer addSublayer:shapeLayer];
     
    CGRect clipRect = CGRectMake(0, 0,
                                 CGRectGetWidth(self.frame)-1, CGRectGetHeight(self.frame)-1);
    CGSize clipRadii = CGSizeMake(cornerRadius, borderWidth);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:clipRect byRoundingCorners:corners cornerRadii:clipRadii];
     
    CAShapeLayer *clipLayer = [CAShapeLayer layer];
    clipLayer.strokeColor = borderColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
 
    clipLayer.lineWidth = 1;
    clipLayer.lineJoin = kCALineJoinRound;
    clipLayer.lineCap = kCALineCapRound;
    clipLayer.path = clipPath.CGPath;
 
    self.layer.mask = clipLayer;
}


@end
