//
//  UIBarButtonItem+JHBadge.m
//  TTjianbao
//
//  Created by wuyd on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UIBarButtonItem+JHBadge.h"
#import "UIView+JHBadge.h"

@implementation UIBarButtonItem (JHBadge)

- (JHBadgeControl *)badgeView {
    return [self parentView].badgeView;
}

- (void)jh_addBadgeText:(NSString *)text {
    [[self parentView] jh_addBadgeText:text];
}

- (void)jh_addBadgeNumber:(NSInteger)number {
    [[self parentView] jh_addBadgeNumber:number];
}

- (void)jh_addDotBadge {
    [[self parentView] jh_addDotWithColor:kBadgeColorDefault];
}

- (void)jh_addDotWithColor:(UIColor *)color {
    [[self parentView] jh_addDotWithColor:color];
}

- (void)jh_setBadgeHeight:(CGFloat)height {
    [[self parentView] jh_setBadgeHeight:height];
}

- (void)jh_setBadgeFlexMode:(JHBadgeFlexMode)flexMode {
    [[self parentView] jh_setBadgeFlexMode:flexMode];
}

- (void)jh_moveBadgeWithX:(CGFloat)x Y:(CGFloat)y {
    [[self parentView] jh_moveBadgeWithX:x Y:y];
}

- (void)jh_showBadge {
    [[self parentView] jh_showBadge];
}

- (void)jh_hideBadge {
    [[self parentView] jh_hideBadge];
}

- (void)jh_plusBadge {
    [[self parentView] jh_plusBadge];
}

- (void)jh_plusBadgeBy:(NSInteger)number {
    [[self parentView] jh_plusBadgeBy:number];
}

- (void)jh_minusBadge {
    [[self parentView] jh_minusBadge];
}

- (void)jh_minusBadgeBy:(NSInteger)number {
    [[self parentView] jh_minusBadgeBy:number];
}


#pragma mark -
#pragma mark - 获取Badge父视图
- (UIView *)parentView {
    //找到UIBarButtonItem的Badge所在父视图为：UIImageView
    UIView *navigationButton = [self valueForKey:@"_view"];
    double version = [UIDevice currentDevice].systemVersion.doubleValue;
    NSString *controlName = (version < 11 ? @"UIImageView" : @"UIButton" );
    for (UIView *subView in navigationButton.subviews) {
        if ([subView isKindOfClass:NSClassFromString(controlName)]) {
            subView.layer.masksToBounds = NO;
            return subView;
        }
    }
    return navigationButton;
}

@end
