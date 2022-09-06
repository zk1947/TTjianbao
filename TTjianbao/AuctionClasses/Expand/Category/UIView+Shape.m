//
//  UIView+Shape.m
//  XZBAppTest
//
//  Created by xzb on 2016/11/9.
//  Copyright © 2016年 xzb. All rights reserved.
//

#import "UIView+Shape.h"

@implementation UIView (Shape)

- (void)setShape:(CGPathRef)shape
{
    if (shape == nil)
    {
        self.layer.mask = nil;
    }

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = shape;
    self.layer.mask = maskLayer;
}

@end
