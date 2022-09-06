//
//  UIView+JHShadow.m
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UIView+JHShadow.h"

@implementation UIView (JHShadow)

- (void)viewShadowPathWithColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowPathType:(JHShadowPathType)shadowPathType shadowPathWidth:(CGFloat)shadowPathWidth{
    
    self.layer.masksToBounds = NO;//必须要等于NO否则会把阴影切割隐藏掉
    self.layer.shadowColor = shadowColor.CGColor;// 阴影颜色
    self.layer.shadowOpacity = shadowOpacity;// 阴影透明度，默认0
    self.layer.shadowOffset = CGSizeZero;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowRadius = shadowRadius;//阴影半径，默认3
    CGRect shadowRect = CGRectZero;
    CGFloat originX,originY,sizeWith,sizeHeight;
    originX = 0;
    originY = 0;
    sizeWith = self.bounds.size.width;
    sizeHeight = self.bounds.size.height;
    
    if (shadowPathType == JHShadowPathTop) {
        shadowRect = CGRectMake(originX, originY-shadowPathWidth/2, sizeWith, shadowPathWidth);
    }else if (shadowPathType == JHShadowPathBottom){
        shadowRect = CGRectMake(originY, sizeHeight-shadowPathWidth/2, sizeWith, shadowPathWidth);
    }else if (shadowPathType == JHShadowPathLeft){
        shadowRect = CGRectMake(originX-shadowPathWidth/2, originY, shadowPathWidth, sizeHeight);
    }else if (shadowPathType == JHShadowPathRight){
        shadowRect = CGRectMake(sizeWith-shadowPathWidth/2, originY, shadowPathWidth, sizeHeight);
    }else if (shadowPathType == JHShadowPathCommon){
        shadowRect = CGRectMake(originX-shadowPathWidth/2, 2, sizeWith+shadowPathWidth, sizeHeight+shadowPathWidth/2);
    }else if (shadowPathType == JHShadowPathAround){
        shadowRect = CGRectMake(originX-shadowPathWidth/2, originY-shadowPathWidth/2, sizeWith+shadowPathWidth, sizeHeight+shadowPathWidth);
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:shadowRect];
    self.layer.shadowPath = bezierPath.CGPath;//阴影路径
}

///添加阴影
+ (void)addShadow:(UIView *)shadowView Offset:(CGSize)offset Opacity:(CGFloat)opacity ShadowRadius:(CGFloat)shadowRadius ShadowColor:(UIColor *)shadowColor CornerRadius:(CGFloat)cornerRadius BorderColor:(UIColor *)borderColor BorderWidth:(CGFloat)borderWidth {
    shadowView.layer.masksToBounds = NO;
    shadowView.layer.shadowOffset = offset;
    shadowView.layer.shadowOpacity = opacity;
    shadowView.layer.shadowRadius = shadowRadius;
    shadowView.layer.shadowColor = shadowColor.CGColor;
    shadowView.layer.cornerRadius = cornerRadius;
    shadowView.layer.borderWidth = borderWidth;
    shadowView.layer.borderColor = borderColor.CGColor;
}

/**
 * 此方法作用:给一个矩形视图增加四条矩形虚线边框
 * parma:superView:需要加载的父视图
 */

#define padding 10

- (void)addDottedLineFromImageView:(UIView *)superView{
    CGFloat w = superView.frame.size.width;
    CGFloat h = superView.frame.size.height;
    //创建四个imageView作边框
    for (NSInteger i = 0; i < 4; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        if (i == 0) {
            imageView.frame = CGRectMake(0, 0, w, padding);
        }else if (i == 1){
            imageView.frame = CGRectMake(0, 0, padding, h);
        }else if (i == 2){
            imageView.frame = CGRectMake(0, h - padding, w, padding);
        }else if (i == 3){
            imageView.frame = CGRectMake(w - padding, 0, padding, h);
        }
        [superView addSubview:imageView];
        UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
        [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
        CGFloat lengths[] = {10,5};
        CGContextRef line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, [UIColor blackColor].CGColor);
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0, 0);    //开始画线
        if (i == 0) {
            CGContextAddLineToPoint(line, w - padding, 0);
        }else if (i == 1){
            CGContextAddLineToPoint(line, 0, w);
        }else if (i == 2){
            CGContextMoveToPoint(line, 0, padding);
            CGContextAddLineToPoint(line, w, padding);
        }else if (i == 3){
            CGContextMoveToPoint(line, padding, 0);
            CGContextAddLineToPoint(line, padding, w);
        }
        CGContextStrokePath(line);
        imageView.image = UIGraphicsGetImageFromCurrentImageContext();

    }

}




@end
