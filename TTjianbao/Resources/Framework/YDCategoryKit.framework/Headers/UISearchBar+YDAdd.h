//
//  UISearchBar+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 16/4/15.
//  Copyright © 2016年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (YDAdd)

- (UITextField *)searchTextField;

- (void)setSearchIcon:(UIImage *)image;
- (void)setPlaceholderColor:(UIColor *)color;

//设置输入内容样式
- (void)setTextFont:(UIFont *)font;
- (void)setTextColor:(UIColor *)textColor;

//设置取消按钮样式
- (void)setCancelButtonFont:(UIFont *)font;
- (void)setCancelButtonTitle:(NSString *)title;
- (void)setCancelButtonEnabled:(BOOL)enabled;

@end
