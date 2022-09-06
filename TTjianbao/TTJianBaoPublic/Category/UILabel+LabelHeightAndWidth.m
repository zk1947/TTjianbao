//
//  UILabel+LabelHeightAndWidth.m
//  TTjianbao
//
//  Created by YJ on 2021/1/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UILabel+LabelHeightAndWidth.h"

@implementation UILabel (LabelHeightAndWidth)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

@end
