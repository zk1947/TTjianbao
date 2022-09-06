//
//  UIView+CornerRadius.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/22.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "UIView+CornerRadius.h"
#import <objc/runtime.h>

#pragma mark -
#pragma mark - NSObject (_YDAdd)

@implementation NSObject (_YDAdd)

+ (void)yd_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return;
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)yd_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)yd_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)yd_removeAssociateWithKey:(void *)key {
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_ASSIGN);
}

@end


#pragma mark -
#pragma mark - UIImage (CornerRadius)

@implementation UIImage (CornerRadius)

+ (UIImage *)yd_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock {
    if (!drawBlock) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)yd_maskCornerRadiusWithImageColor:(UIColor *)color cornerRadii:(CGSize)cornerRadii size:(CGSize)size corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    return [UIImage yd_imageWithSize:size drawBlock:^(CGContextRef  _Nonnull context) {
        CGContextSetLineWidth(context, 0);
        [color set];
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectInset(rect, -0.3, -0.3)];
        UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 0.3, 0.3) byRoundingCorners:corners cornerRadii:cornerRadii];
        [rectPath appendPath:roundPath];
        CGContextAddPath(context, rectPath.CGPath);
        CGContextEOFillPath(context);
        if (!borderColor || !borderWidth) return;
        [borderColor set];
        UIBezierPath *borderOutterPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
        UIBezierPath *borderInnerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:cornerRadii];
        [borderOutterPath appendPath:borderInnerPath];
        CGContextAddPath(context, borderOutterPath.CGPath);
        CGContextEOFillPath(context);
    }];
}

@end


#pragma mark -
#pragma mark - CALayer (CornerRadius)

static void * const _YDMaskCornerRadiusLayerKey = "_YDMaskCornerRadiusLayerKey";
static NSMutableSet <UIImage *> *maskCornerRaidusImageSet;

@implementation CALayer (CornerRadius)

//+ (void)load {
//    [CALayer yd_swizzleInstanceMethod:@selector(layoutSublayers) with:@selector(_yd_layoutSublayers)];
//}

- (UIImage *)contentImage {
    return [UIImage imageWithCGImage:(__bridge CGImageRef)self.contents];
}

- (void)setContentImage:(UIImage *)contentImage {
    self.contents = (__bridge id)contentImage.CGImage;
}

- (void)yd_setCornerRadius:(CGFloat)radius color:(UIColor *)color {
    [self yd_setCornerRadius:radius color:color corners:UIRectCornerAllCorners];
}

- (void)yd_setCornerRadius:(CGFloat)radius color:(UIColor *)color corners:(UIRectCorner)corners {
    [self yd_setCornerRadii:CGSizeMake(radius, radius) color:color corners:corners borderColor:nil borderWidth:0];
}

- (void)yd_setCornerRadii:(CGSize)cornerRadii
                    color:(UIColor *)color
                  corners:(UIRectCorner)corners
              borderColor:(nullable UIColor *)borderColor
              borderWidth:(CGFloat)borderWidth
{
    if (!color) return;
    CALayer *cornerRadiusLayer = [self yd_getAssociatedValueForKey:_YDMaskCornerRadiusLayerKey];
    if (!cornerRadiusLayer) {
        cornerRadiusLayer = [CALayer new];
        cornerRadiusLayer.opaque = YES;
        [self yd_setAssociateValue:cornerRadiusLayer withKey:_YDMaskCornerRadiusLayerKey];
    }
    if (color) {
        [cornerRadiusLayer yd_setAssociateValue:color withKey:"_yd_cornerRadiusImageColor"];
    } else {
        [cornerRadiusLayer yd_removeAssociateWithKey:"_yd_cornerRadiusImageColor"];
    }
    [cornerRadiusLayer yd_setAssociateValue:[NSValue valueWithCGSize:cornerRadii] withKey:"_yd_cornerRadiusImageRadius"];
    [cornerRadiusLayer yd_setAssociateValue:@(corners) withKey:"_yd_cornerRadiusImageCorners"];
    if (borderColor) {
        [cornerRadiusLayer yd_setAssociateValue:borderColor withKey:"_yd_cornerRadiusImageBorderColor"];
    } else {
        [cornerRadiusLayer yd_removeAssociateWithKey:"_yd_cornerRadiusImageBorderColor"];
    }
    [cornerRadiusLayer yd_setAssociateValue:@(borderWidth) withKey:"_yd_cornerRadiusImageBorderWidth"];
    UIImage *image = [self _mr_getCornerRadiusImageFromSet];
    if (image) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cornerRadiusLayer.contentImage = image;
        [CATransaction commit];
    }
}

- (UIImage *)_mr_getCornerRadiusImageFromSet {
    if (!self.bounds.size.width || !self.bounds.size.height) return nil;
    CALayer *cornerRadiusLayer = [self yd_getAssociatedValueForKey:_YDMaskCornerRadiusLayerKey];
    UIColor *color = [cornerRadiusLayer yd_getAssociatedValueForKey:"_yd_cornerRadiusImageColor"];
    if (!color) return nil;
    CGSize radius = [[cornerRadiusLayer yd_getAssociatedValueForKey:"_yd_cornerRadiusImageRadius"] CGSizeValue];
    NSUInteger corners = [[cornerRadiusLayer yd_getAssociatedValueForKey:"_yd_cornerRadiusImageCorners"] unsignedIntegerValue];
    CGFloat borderWidth = [[cornerRadiusLayer yd_getAssociatedValueForKey:"_yd_cornerRadiusImageBorderWidth"] floatValue];
    UIColor *borderColor = [cornerRadiusLayer yd_getAssociatedValueForKey:"_yd_cornerRadiusImageBorderColor"];
    if (!maskCornerRaidusImageSet) {
        maskCornerRaidusImageSet = [NSMutableSet new];
    }
    __block UIImage *image = nil;
    [maskCornerRaidusImageSet enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, BOOL * _Nonnull stop) {
        CGSize imageSize = [[obj yd_getAssociatedValueForKey:"_yd_cornerRadiusImageSize"] CGSizeValue];
        UIColor *imageColor = [obj yd_getAssociatedValueForKey:"_yd_cornerRadiusImageColor"];
        CGSize imageRadius = [[obj yd_getAssociatedValueForKey:"_yd_cornerRadiusImageRadius"] CGSizeValue];
        NSUInteger imageCorners = [[obj yd_getAssociatedValueForKey:"_yd_cornerRadiusImageCorners"] unsignedIntegerValue];
        CGFloat imageBorderWidth = [[obj yd_getAssociatedValueForKey:"_yd_cornerRadiusImageBorderWidth"] floatValue];
        UIColor *imageBorderColor = [obj yd_getAssociatedValueForKey:"_yd_cornerRadiusImageBorderColor"];
        BOOL isBorderSame = (CGColorEqualToColor(borderColor.CGColor, imageBorderColor.CGColor) && borderWidth == imageBorderWidth) || (!borderColor && !imageBorderColor) || (!borderWidth && !imageBorderWidth);
        BOOL canReuse = CGSizeEqualToSize(self.bounds.size, imageSize) && CGColorEqualToColor(imageColor.CGColor, color.CGColor) && imageCorners == corners && CGSizeEqualToSize(radius, imageRadius) && isBorderSame;
        if (canReuse) {
            image = obj;
            *stop = YES;
        }
    }];
    if (!image) {
        image = [UIImage yd_maskCornerRadiusWithImageColor:color cornerRadii:radius size:self.bounds.size corners:corners borderColor:borderColor borderWidth:borderWidth];
        [image yd_setAssociateValue:[NSValue valueWithCGSize:self.bounds.size] withKey:"_yd_cornerRadiusImageSize"];
        [image yd_setAssociateValue:color withKey:"_yd_cornerRadiusImageColor"];
        [image yd_setAssociateValue:[NSValue valueWithCGSize:radius] withKey:"_yd_cornerRadiusImageRadius"];
        [image yd_setAssociateValue:@(corners) withKey:"_yd_cornerRadiusImageCorners"];
        if (borderColor) {
            [image yd_setAssociateValue:color withKey:"_yd_cornerRadiusImageBorderColor"];
        }
        [image yd_setAssociateValue:@(borderWidth) withKey:"_yd_cornerRadiusImageBorderWidth"];
        [maskCornerRaidusImageSet addObject:image];
    }
    return image;
}

#pragma mark - exchage Methods

- (void)_yd_layoutSublayers {
    [self _yd_layoutSublayers];
    CALayer *cornerRadiusLayer = [self yd_getAssociatedValueForKey:_YDMaskCornerRadiusLayerKey];
    if (cornerRadiusLayer) {
        UIImage *aImage = [self _mr_getCornerRadiusImageFromSet];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cornerRadiusLayer.contentImage = aImage;
        cornerRadiusLayer.frame = self.bounds;
        [CATransaction commit];
        [self addSublayer:cornerRadiusLayer];
    }
}

@end


#pragma mark -
#pragma mark - UIView (CornerRadius)

@implementation UIView (CornerRadius)

- (void)yd_setCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners {
    if (@available(iOS 11.0, *)) {
        self.layer.cornerRadius = radius;
        self.layer.maskedCorners = (CACornerMask)corners;
    } else {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}

- (void)yd_setCornerRadius:(CGFloat)radius color:(UIColor *)color {
    [self.layer yd_setCornerRadius:radius color:color];
}

- (void)yd_setCornerRadius:(CGFloat)radius color:(UIColor *)color corners:(UIRectCorner)corners {
    [self.layer yd_setCornerRadius:radius color:color corners:corners];
}

- (void)yd_setCornerRadii:(CGSize)cornerRadii color:(UIColor *)color corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    [self.layer yd_setCornerRadii:cornerRadii color:color corners:corners borderColor:borderColor borderWidth:borderWidth];
}

@end
