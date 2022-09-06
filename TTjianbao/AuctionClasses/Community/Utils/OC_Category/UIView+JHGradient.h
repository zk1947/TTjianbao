//
//  UIView+JHGradient.h
//  TTjianbao
//
//  Created by lihui on 2020/7/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JHGradient)

@property(nullable, copy) NSArray *jh_colors;
@property(nullable, copy) NSArray<NSNumber *> *jh_locations;
@property CGPoint jh_startPoint;
@property CGPoint jh_endPoint;

+ (UIView *_Nullable)jh_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)jh_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end




NS_ASSUME_NONNULL_END
