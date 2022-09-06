//
//  UILabel+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 16/4/15.
//  Copyright © 2016年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (YDAdd)

+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor;

- (void)setLongString:(NSString *)str withFitWidth:(CGFloat)width;
- (void)setLongString:(NSString *)str withFitWidth:(CGFloat)width maxHeight:(CGFloat)maxHeight;
- (void)setLongString:(NSString *)str withVariableWidth:(CGFloat)maxWidth;

@end
