//
//  UIViewController+YDAdd.h
//  LittleOrangeLamp
//
//  Created by WU on 2018/6/15.
//  Copyright © 2018年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YDAdd)

// 设置导航栏按钮
- (void)setLeftBarItemImage:(NSString *)imageName target:(id)target action:(SEL)action;
- (void)setRightBarItemImage:(NSString *)imageName target:(id)target action:(SEL)action;

- (void)setLeftBarItemTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setRightBarItemTitle:(NSString *)title target:(id)target action:(SEL)action;

- (UIBarButtonItem *)customNavButtonWithTitle:(NSString *)title imageName:(NSString *)imageName target:(id)targe action:(SEL)action;

@end
