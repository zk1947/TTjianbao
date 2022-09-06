//
//  UIView+JHGradient.m
//  TTjianbao
//
//  Created by lihui on 2020/7/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UIView+JHGradient.h"

@implementation UIView (JHGradient)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

+ (UIView *)jh_gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIView *view = [[self alloc] init];
    [view jh_setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}

- (void)jh_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.jh_colors = [colorsM copy];
    self.jh_locations = locations;
    self.jh_startPoint = startPoint;
    self.jh_endPoint = endPoint;
}

#pragma mark- Getter&Setter

- (NSArray *)jh_colors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJh_colors:(NSArray *)colors {
    objc_setAssociatedObject(self, @selector(jh_colors), colors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.jh_colors];
    }
}

- (NSArray<NSNumber *> *)jh_locations {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJh_locations:(NSArray<NSNumber *> *)locations {
    objc_setAssociatedObject(self, @selector(jh_locations), locations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.jh_locations];
    }
}

- (CGPoint)jh_startPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setJh_startPoint:(CGPoint)startPoint {
    objc_setAssociatedObject(self, @selector(jh_startPoint), [NSValue valueWithCGPoint:startPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.jh_startPoint];
    }
}

- (CGPoint)jh_endPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setJh_endPoint:(CGPoint)endPoint {
    objc_setAssociatedObject(self, @selector(jh_endPoint), [NSValue valueWithCGPoint:endPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.jh_endPoint];
    }
}



@end

@implementation UILabel (JHGradient)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end
