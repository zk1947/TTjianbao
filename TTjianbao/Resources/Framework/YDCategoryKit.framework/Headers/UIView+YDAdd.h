//
//  UIView+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 14-8-6.
//  Copyright (c) 2015年 hetang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class EaseLoadingView;

typedef NS_ENUM(NSInteger, BadgePositionType) {
    
    BadgePositionTypeDefault = 0,
    BadgePositionTypeMiddle
};


#pragma mark -
#pragma mark - UIView (YDAdd)
@interface UIView (YDAdd)

- (void)doCircleFrame;
- (void)doNotCircleFrame;
- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

- (CGFloat)maxXOfFrame;

- (void)setSubScrollsToTop:(BOOL)scrollsToTop;

- (void)addGradientLayerWithColors:(NSArray *)cgColorArray;
- (void)addGradientLayerWithColors:(NSArray *)cgColorArray
                         locations:(NSArray *)floatNumArray
                        startPoint:(CGPoint )aPoint
                          endPoint:(CGPoint)endPoint;

- (void)removeViewWithTag:(NSInteger)tag;

- (UIView*)subViewOfClassName:(NSString*)className;

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;

- (void)outputSubviewTree;//输出子视图的目录树
+ (void)outputTreeInView:(UIView *)view withSeparatorCount:(NSInteger)count;//输出某个View的subview目录

#pragma mark - LoadingView
@property (nonatomic, strong) EaseLoadingView *loadingView;
- (void)beginLoading;
- (void)endLoading;

@end


#pragma mark -
#pragma mark - EaseLoadingView
@interface EaseLoadingView : UIView
@property (nonatomic, strong) UIImageView *loopView, *iconView;
@property (nonatomic, assign, readonly) BOOL isLoading;
- (void)startAnimating;
- (void)stopAnimating;
@end
