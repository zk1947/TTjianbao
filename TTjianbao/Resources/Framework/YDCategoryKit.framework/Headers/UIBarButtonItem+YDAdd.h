//
//  UIBarButtonItem+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 16/4/15.
//  Copyright © 2016年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YDAdd)

+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title target:(id)obj action:(SEL)selector;

+ (UIBarButtonItem *)itemWithIcon:(NSString*)iconName showBadge:(BOOL)showbadge target:(id)obj action:(SEL)selector;

@end
