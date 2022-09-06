//
//  UIView+JHDesignableView.m
//  TTjianbao
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UIView+JHDesignableView.h"
#import <objc/runtime.h>

@implementation UIView (JHDesignableView)
-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}
-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}
-(CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}
-(CGFloat)borderWidth{
    return self.layer.borderWidth;
}
-(UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
@end
