//
//  UILabel+LabelHeightAndWidth.h
//  TTjianbao
//
//  Created by YJ on 2021/1/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (LabelHeightAndWidth)

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
