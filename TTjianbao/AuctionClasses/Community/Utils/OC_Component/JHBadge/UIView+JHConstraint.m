//
//  UIView+JHConstraint.m
//  TTjianbao
//
//  Created by wuyd on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UIView+JHConstraint.h"

@implementation UIView (JHConstraint)

- (NSLayoutConstraint *)widthConstraint {
    return [self constraint:self attribute:NSLayoutAttributeWidth];
}

- (NSLayoutConstraint *)heightConstraint {
    return [self constraint:self attribute:NSLayoutAttributeHeight];
}

- (NSLayoutConstraint *)topConstraintWithItem: (id)item {
    return [self constraint:item attribute:NSLayoutAttributeTop];
}

- (NSLayoutConstraint *)leadingConstraintWithItem: (id)item {
    return [self constraint:item attribute:NSLayoutAttributeLeading];
}

- (NSLayoutConstraint *)bottomConstraintWithItem:(id)item {
    return [self constraint:item attribute:NSLayoutAttributeBottom];
}

- (NSLayoutConstraint *)trailingConstraintWithItem:(id)item {
    return [self constraint:item attribute:NSLayoutAttributeTrailing];
}

- (NSLayoutConstraint *)centerXConstraintWithItem:(id)item {
    return [self constraint:item attribute:NSLayoutAttributeCenterX];
}

- (NSLayoutConstraint *)centerYConstraintWithItem:(id)item {
    return [self constraint:item attribute:NSLayoutAttributeCenterY];
}

- (NSLayoutConstraint *)constraint:(id)item attribute:(NSLayoutAttribute)layoutAttribute {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == item && constraint.firstAttribute == layoutAttribute) {
            return constraint;
        }
    }
    return nil;
}

@end
