//
//  UIView+JHConstraint.h
//  TTjianbao
//
//  Created by wuyd on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JHConstraint)

- (NSLayoutConstraint *)widthConstraint;
- (NSLayoutConstraint *)heightConstraint;
- (NSLayoutConstraint *)topConstraintWithItem:(id)item;
- (NSLayoutConstraint *)leadingConstraintWithItem:(id)item;
- (NSLayoutConstraint *)bottomConstraintWithItem:(id)item;
- (NSLayoutConstraint *)trailingConstraintWithItem:(id)item;
- (NSLayoutConstraint *)centerXConstraintWithItem:(id)item;
- (NSLayoutConstraint *)centerYConstraintWithItem:(id)item;

@end

NS_ASSUME_NONNULL_END
