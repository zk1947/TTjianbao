//
//  UIImage+JHColor.m
//  TTjianbao
//
//  Created by yaoyao on 2020/5/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UIImage+JHColor.h"


@implementation UIImage (JHColor)

+ (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(JHGradientType)gradientType imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case JHGradientFromTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case JHGradientFromLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case JHGradientFromLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case JHGradientFromLeftBottomToRightTop:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }


    
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
 
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(JHGradientType)gradientType imgSize:(CGSize)imgSize string:(NSString *)text radius:(CGFloat)radius {
    
    UIImage *image = [self gradientColorImageFromColors:colors gradientType:gradientType imgSize:imgSize];
    return [image drawCircleImageWithRadius:radius string:text];
    
}

- (UIImage *)drawCircleImageWithRadius:(CGFloat)radius string:(NSString *)text {
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [[UIColor clearColor] setFill];
    UIRectFill(rect);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [path addClip];
    [self drawInRect:rect];
    [text drawInRect:CGRectMake(5, 2, size.width-10, size.height-2) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:kFontNormal size:10]}];

    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

- (UIImage *)drawCircleImageWithRadius:(CGFloat)radius {
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [[UIColor clearColor] setFill];
    UIRectFill(rect);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [path addClip];
    [self drawInRect:rect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

+ (UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(JHGradientType)gradientType imgSize:(CGSize)imgSize radius:(CGFloat)radius {
    UIImage *image = [self gradientColorImageFromColors:colors gradientType:gradientType imgSize:imgSize];
    return [image drawCircleImageWithRadius:radius];
    
}

+ (UIImage *)gradientThemeImageSize:(CGSize)imgSize radius:(CGFloat)radius {
    return [UIImage gradientColorImageFromColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] gradientType:JHGradientFromLeftToRight imgSize:imgSize radius:radius];
}

+ (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius {
    
    UIImage *image = [self createImageColor:color size:size];

    return [image drawCircleImageWithRadius:radius];
    
}
@end
