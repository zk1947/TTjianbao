//
//  UIButton+BackColor.m
//  TTjianbao
//
//  Created by yaoyao on 2019/7/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UIButton+BackColor.h"
#import "UIImage+NTESColor.h"

@implementation UIButton (BackColor)
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    UIImage *image = [UIImage imageWithColor:color];
    [self setBackgroundImage:image forState:state];
}
@end
