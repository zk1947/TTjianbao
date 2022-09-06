//
//  UIImageView+Gradient.m
//  TTjianbao
//
//  Created by wuyd on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "UIImageView+Gradient.h"
#import "YYKit.h"

@implementation UIImageView (Gradient)

/*! 返回渐变色view */
+ (UIImageView *)gradientWithType:(EGradientType)type frame:(CGRect)rect colors:(NSArray<NSString *> *)colors {
    UIImageView *imgView = [UIImageView new];
    imgView.frame = rect;
    
    if (!colors) { return imgView; }
    
    UIImage *normalImg = [imgView imageFromGradientColors:colors gradientType:type];
    imgView.image = normalImg;
    return imgView;
}

- (UIImage *)imageFromGradientColors:(NSArray<NSString *> *)colors gradientType:(EGradientType)gradientType {
    NSMutableArray *colorRefArr = [NSMutableArray array];
    for(NSString *colorStr in colors) {
        [colorRefArr addObject:(UIColor *)[UIColor colorWithHexString:colorStr].CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[UIColor colorWithHexString:[colors lastObject]] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colorRefArr, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0: {
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        }
        case 1: {
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, 0.0);
            break;
        }
        case 2: {
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, self.frame.size.height);
            break;
        }
        case 3: {
            start = CGPointMake(self.frame.size.width, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        }
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
