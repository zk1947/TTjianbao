//
//  UITabBarItem+JHBadge.m
//  TTjianbao
//
//  Created by wuyd on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UITabBarItem+JHBadge.h"
#import "UIView+JHBadge.h"

@implementation UITabBarItem (JHBadge)

- (JHBadgeControl *)badgeView {
    return [self parentView].badgeView;
}

- (void)jh_addBadgeText:(NSString *)text {
    [[self parentView] jh_addBadgeText:text];
    [[self parentView] jh_moveBadgeWithX:4 Y:3]; // 默认为系统badge所在的位置
}

- (void)jh_addBadgeNumber:(NSInteger)number {
    [[self parentView] jh_addBadgeNumber:number];
    [[self parentView] jh_moveBadgeWithX:4 Y:3];
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
#pragma mark - 获取Badge的父视图
- (UIView *)parentView {
    // 通过Xcode视图调试工具找到UITabBarItem原生Badge所在父视图
    UIView *tabBarButton = [self valueForKey:@"_view"];
    for (UIView *subView in tabBarButton.subviews) {
        if (subView.superclass == NSClassFromString(@"UIImageView")) {
            return subView;
        }
    }
    return tabBarButton;
}

@end
