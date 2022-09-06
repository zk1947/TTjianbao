//
//  SGHelperTool.m
//  TTjianbao
//
//  Created by YJ on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "SGHelperTool.h"

@implementation SGHelperTool

//计算字符串宽度
+ (CGFloat)SG_widthWithString:(NSString *)string font:(UIFont *)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}


@end

