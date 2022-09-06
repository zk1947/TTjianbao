//
//
//  UIView+JHBadge.m
//  TTjianbao
//
//  Created by wuyd on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UIView+JHBadge.h"
#import "JHBadgeControl.h"
#import <objc/runtime.h>

static NSString *const kBadgeViewKey = @"JHBadgeViewKey";

@interface UIView ()

@end

@implementation UIView (JHBadge)

- (void)jh_addBadgeText:(NSString *)text {
    [self jh_showBadge];
    self.badgeView.text = text;
    [self jh_setBadgeFlexMode:self.badgeView.flexMode];
    if (text) {
        if (self.badgeView.widthConstraint && self.badgeView.widthConstraint.relation == NSLayoutRelationGreaterThanOrEqual) {
            return;
        }
        self.badgeView.widthConstraint.active = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.badgeView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        [self.badgeView addConstraint:constraint];
        
    } else {
        if (self.badgeView.widthConstraint && self.badgeView.widthConstraint.relation == NSLayoutRelationEqual) {
            return;
        }
        self.badgeView.widthConstraint.active = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.badgeView attribute:(NSLayoutAttributeHeight) multiplier:1.0 constant:0];
        [self.badgeView addConstraint:constraint];
    }
}

- (void)jh_addBadgeNumber:(NSInteger)number {
    if (number <= 0) {
        [self jh_addBadgeText:@"0"];
        [self jh_hideBadge];
        return;
    }
    [self jh_addBadgeText:[NSString stringWithFormat:@"%ld", number]];
}

- (void)jh_addDotBadge {
    [self jh_addDotWithColor:kBadgeColorDefault];
}

- (void)jh_addDotWithColor:(UIColor *)color {
    [self jh_addBadgeText:nil];
    [self jh_setBadgeHeight:kBadgeDotHeight];
    self.badgeView.backgroundColor = color;
}

- (void)jh_moveBadgeWithX:(CGFloat)x Y:(CGFloat)y {
    self.badgeView.offset = CGPointMake(x, y);
    [self centerYConstraintWithItem:self.badgeView].constant = y;
    
    CGFloat badgeHeight = self.badgeView.heightConstraint.constant;
    switch (self.badgeView.flexMode) {
        case JHBadgeFlexModeLeft: // 1.向左伸缩 <==●
        {
            [self centerXConstraintWithItem:self.badgeView].active = NO;
            [self leadingConstraintWithItem:self.badgeView].active = NO;
            if ([self trailingConstraintWithItem:self.badgeView]) {
                [self trailingConstraintWithItem:self.badgeView].constant = x + badgeHeight*0.5;
                return;
            }
            NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeTrailing relatedBy:(NSLayoutRelationEqual) toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:(x + badgeHeight*0.5)];
            [self addConstraint:trailingConstraint];
            break;
        }
        case JHBadgeFlexModeRight: // 2.右伸缩 ●==>
        {
            [self centerXConstraintWithItem:self.badgeView].active = NO;
            [self trailingConstraintWithItem:self.badgeView].active = NO;
            if ([self leadingConstraintWithItem:self.badgeView]) {
                [self leadingConstraintWithItem:self.badgeView].constant = x - badgeHeight*0.5;
                return;
            }
            NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:(x - badgeHeight*0.5)];
            [self addConstraint:leadingConstraint];
            break;
        }
        case JHBadgeFlexModeMiddle: // 3.左右伸缩 <=●=>
        {
            [self leadingConstraintWithItem:self.badgeView].active = NO;
            [self trailingConstraintWithItem:self.badgeView].active = NO;
            if ([self centerXConstraintWithItem:self.badgeView]) {
                [self centerXConstraintWithItem:self.badgeView].constant = x;
                return;
            }
            NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:x];
            [self addConstraint:centerXConstraint];
            break;
        }
    }
}

- (void)jh_setBadgeFlexMode:(JHBadgeFlexMode)flexMode {
    self.badgeView.flexMode = flexMode;
    [self jh_moveBadgeWithX:self.badgeView.offset.x Y:self.badgeView.offset.y];
}

- (void)jh_setBadgeHeight:(CGFloat)height {
    self.badgeView.layer.cornerRadius = height * 0.5;
    self.badgeView.heightConstraint.constant = height;
    [self jh_moveBadgeWithX:self.badgeView.offset.x Y:self.badgeView.offset.y];
}

- (void)jh_showBadge {
    self.badgeView.hidden = NO;
}

- (void)jh_hideBadge {
    self.badgeView.hidden = YES;
}

- (void)jh_plusBadge {
    [self jh_plusBadgeBy:1];
}

- (void)jh_plusBadgeBy:(NSInteger)number {
    NSInteger result = self.badgeView.text.integerValue + number;
    if (result > 0) {
        [self jh_showBadge];
    }
    self.badgeView.text = [NSString stringWithFormat:@"%ld", result];
}

- (void)jh_minusBadge {
    [self jh_minusBadgeBy:1];
}

- (void)jh_minusBadgeBy:(NSInteger)number {
    NSInteger result = self.badgeView.text.integerValue - number;
    if (result <= 0) {
        [self jh_hideBadge];
        self.badgeView.text = @"0";
        return;
    }
    self.badgeView.text = [NSString stringWithFormat:@"%ld", result];
}

- (void)addBadgeViewLayoutConstraint {
    [self.badgeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.badgeView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kBadgeHeightDefault];
    
    [self addConstraints:@[centerXConstraint, centerYConstraint]];
    [self.badgeView addConstraints:@[widthConstraint, heightConstraint]];
}


#pragma mark -
#pragma mark - setter/getter

- (JHBadgeControl *)badgeView {
    JHBadgeControl *badgeView = objc_getAssociatedObject(self, &kBadgeViewKey);
    if (!badgeView) {
        badgeView = [JHBadgeControl defaultBadge];
        [self addSubview:badgeView];
        [self bringSubviewToFront:badgeView];
        [self setBadgeView:badgeView];
        [self addBadgeViewLayoutConstraint];
    }
    return badgeView;
}

- (void)setBadgeView:(JHBadgeControl *)badgeView {
    objc_setAssociatedObject(self, &kBadgeViewKey, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
