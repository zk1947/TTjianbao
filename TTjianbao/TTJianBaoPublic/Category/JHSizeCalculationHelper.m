//
//  JHSizeCalculationHelper.m
//  TTjianbao
//
//  Created by user on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSizeCalculationHelper.h"

@implementation JHSizeCalculationHelper
+ (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{
                                        NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                        NSFontAttributeName:font
                                    } context:nil].size;
    return size;
}

@end
